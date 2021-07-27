include("base.jl")

using Distributed
__precompile__(false) # Precompilation is causing the system to OOM!

#Base.Experimental.@optlevel 3
 
@show CORES = "REFUSR_PROCS" ∈ keys(ENV) ? parse(Int, ENV["REFUSR_PROCS"]) : 1
 
EXEFLAGS = "--project=$(Base.active_project())"
 
if CORES > nprocs()
    addprocs(CORES, topology=:master_worker, exeflags = EXEFLAGS)
end


@everywhere begin
    @info "Preparing environment on core $(myid()) of $(nprocs())..."
    if myid() != 1
        include("$(@__DIR__)/base.jl")
    end
    @info "Environment ready on core $(myid())."
end



UI = dash()

function initialize_server(config) # initialize UI
    global UI
    UI.layout = html_div() do
        html_h1("REFUSR UI"),
        html_div("Waiting for data...")
    end
    Dash.set_title!(UI, "REFUSR UI")
    @info "Starting Dash server..."
    run_server(UI, config.dashboard.server, config.dashboard.port, debug=true)
    @warn "Dash server no longer running"
end



function check_server(config)
    server = config.dashboard.server
    port = config.dashboard.port
    for i in 1:3
        try
            run(`nc -z $(server) $(port)`)
            @info "Server is listening"
            server_running = true
            break
        catch _
            sleep(1)
            continue
        end
    end
end



function ui_callback(L::Cockatrice.Logging.Logger)::Nothing
    global UI
    begin # TODO restore async macro
       
        e = nrow(L.table)
        j = e <= 10 ? 1 : e - 10

        msg = "$(L.table[j:e,:])"

        #body!(UI, msg)
        UI.layout = html_div() do 
            html_h1("REFUSR UI"),
            html_div("$(msg)") 
        end # end html_div block
    end # end async block
    return nothing
end 

# TODO: Replace this electron UI with a Dash UI, or something similar.
# Stream images, etc. to it. 


function launch(config_path)
    config = prep_config(config_path)
    @async initialize_server(config)
    check_server(config)

    fitness_function = FF.fit #Meta.parse("FF.$(config.selection.fitness_function)") |> eval
    #@assert fitness_function isa Function

    WORKERS = workers()
    
    params = [:config => config,
              :fitness => fitness_function,
              :creature_type => LinearGenotype.Creature,
              :crossover => LinearGenotype.crossover,
              :mutate => LinearGenotype.mutate!,
              :tracers => TRACERS,
              :loggers => LOGGERS,
              :stopping_condition => stopping_condition,
              :objective_performance => objective_performance,
              :WORKERS => WORKERS,
              :callback => ui_callback,
              ]
    world, logger = Cosmos.run(;params...)
    Distributed.rmprocs(WORKERS...)
    elites = [w.elites[1] for w in world]
    champion = sort(elites, by=objective_performance)[end]
    @info "Preparing summary of champion $(champion.name) and simplifying expression..."
    champion_html = Analysis.summarize(logger, champion)
    @info "Saved report to file://$(champion_html)"
    return (world=world, logger=logger, champion=champion)
end
