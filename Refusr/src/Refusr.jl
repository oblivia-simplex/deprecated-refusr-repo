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
