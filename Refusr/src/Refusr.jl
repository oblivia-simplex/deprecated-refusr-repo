include("base.jl")
include("Dashboard.jl")

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



# UI = dash()
# 
# function initialize_server(config) # initialize UI
#     global UI
#     UI.layout = html_div() do
#         html_h1("REFUSR UI"),
#         html_div("Waiting for data...")
#     end
#     enable_dev_tools!(UI, dev_tools_hot_reload=false)
#     Dash.set_title!(UI, "REFUSR UI")
#     @info "Starting Dash server..."
#     run_server(UI, config.dashboard.server, config.dashboard.port, debug=true)
#     @warn "Dash server no longer running"
# end
# 
# 
# 
# function check_server(config)
#     server = config.dashboard.server
#     port = config.dashboard.port
#     for i in 1:3
#         try
#             run(`nc -z $(server) $(port)`)
#             @info "Server is listening"
#             server_running = true
#             break
#         catch _
#             sleep(1)
#             continue
#         end
#     end
# end
# 
# 
# function generate_table(D::DataFrame, max_rows = 10)
#     html_table([
#         html_thead(html_tr([html_th(col) for col in names(D)])),
#         html_tbody([
#             html_tr([html_td(D[r, c]) for c in names(D)]) for r in max(1, nrow(D)-max_rows):nrow(D)
#         ]),
#     ])
# end
# 
# 
# function plot_stat(D::DataFrame;
#                    cols::Vector{Symbol},
#                    names=nothing,
#                    id="REFUSR-plot",
#                    title="REFUSR Plot")
#     X = D.iteration_mean
#     if names === nothing
#         names = [replace(n, "_" => " ") for n in string.(cols)]
#     end
#     data = [(x = X, y = D[!,Y], name = N) for (Y,N) in zip(cols, names)]
#     dcc_graph(
#         id = id,
#         figure = (
#             data = data,
#             layout = (title = title,)
#         )
#     )
# end
# 
# function ui_callback(L::Cockatrice.Logging.Logger, report=nothing)::Nothing
#     global UI
#     begin # TODO restore async macro
#         e = nrow(L.table)
#         j = e <= 10 ? 1 : e - 10
# 
#         X = L.table.iteration_mean
#         D = L.table
# 
#         if isnothing(report)
#             champion_report = html_div()
#         else
#             champion_report = read(report, String) |> dcc_markdown
#         end
# 
#         UI.layout = html_div() do
#             html_h1("REFUSR UI"),
#             plot_stat(D,
#                       cols=[:objective_meanfinite, :objective_maximum],
#                       names=["mean performance", "best performance"],
#                       title="Performance",
#                       id="REFUSR-performance-plot"),
#             generate_table(D, 10),
#             champion_report
#         end # end html_div block
#     end # end async block
#     return nothing
# end 

# TODO: Replace this electron UI with a Dash UI, or something similar.
# Stream images, etc. to it. 


function launch(config_path)
    config = prep_config(config_path)
    server_task = @async Dashboard.initialize_server(config)
    Dashboard.check_server(config)

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
              :callback => Dashboard.ui_callback,
              ]
    started_at = now()
    world, logger = Cosmos.run(;params...)
    finished_at = now()
    @info "Time spent in main GP loop, including initialization: $(finished_at - started_at)"
    #Distributed.rmprocs(WORKERS...)
    if CORES > 1
        try
            Distributed.rmprocs(WORKERS...)
        catch er
            @warn "Failed to remove worker processes: $(er)"
        end
    end
    elites = [w.elites[1] for w in world]
    champion = sort(elites, by=objective_performance)[end]
    push!(logger.specimens, champion)
    @info "Sending data on champion to dashboard" Dashboard.check_server(config)
    Dashboard.ui_callback(logger, final=true) #, champion_md)
    wait(server_task)
    return (world=world, logger=logger, champion=champion)
end
