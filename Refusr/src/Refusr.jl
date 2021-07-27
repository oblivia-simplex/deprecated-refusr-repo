using Distributed
__precompile__(false) # Precompilation is causing the system to OOM!

Base.Experimental.@optlevel 3

CORES = "REFUSR_PROCS" ∈ keys(ENV) ? parse(Int, ENV["REFUSR_PROCS"]) : 1

if CORES > 1
    addprocs(CORES, topology=:master_worker, exeflags="--project=$(Base.active_project())")
end

@everywhere begin
    @info "Preparing environment on core $(myid()) of $(nworkers())..."
    using Pkg
    Pkg.instantiate()

    using DistributedArrays
    using CSV, DataFrames
    using Statistics
    using Cockatrice.Config
    using Cockatrice.Evo: Tracer
    using Dates

    include("$(@__DIR__)/base.jl")
    @info "Environment ready on core $(myid())."
end


using Cockatrice.Cosmos

function log_to_terminal(L::Cockatrice.Logging.Logger)
    @info "in callback"
    println(L.table[end,:])
end

function launch(config_path)
    config = prep_config(config_path)
 
    fitness_function = Meta.parse("FF.$(config.selection.fitness_function)") |> eval
    @assert fitness_function isa Function

    params = [:config => config,
              :fitness => fitness_function,
              :creature_type => LinearGenotype.Creature,
              :crossover => LinearGenotype.crossover,
              :mutate => LinearGenotype.mutate!,
              :tracers => TRACERS,
              :loggers => LOGGERS,
              :stopping_condition => stopping_condition,
              :objective_performance => objective_performance,
              :cores => CORES,
              :callback => log_to_terminal,
              ]
    world, logger = Cosmos.run(;params...)
    # FIXME # Base.kill(Distributed.workers())
    elites = [w.elites[1] for w in world]
    champion = sort(elites, by=objective_performance)[end]
    @info "Preparing summary of champion $(champion.name) and simplifying expression..."
    champion_html = Analysis.summarize(logger, champion)
    @info "Saved report to file://$(champion_html)"
    return (world=world, logger=logger, champion=champion)
end
