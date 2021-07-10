using Distributed
using CSV, DataFrames
using Setfield

if nprocs() == 1
    p = "REFUSR_PROCS" ∈ keys(ENV) ? parse(Int, ENV["REFUSR_PROCS"]) : 4
    addprocs(p, topology=:master_worker, exeflags="--project=$(Base.active_project())")
else
    @everywhere begin
        using Pkg
        Pkg.activate("$(@__DIR__)/..")
        Pkg.instantiate()
    end
end

@everywhere begin
    @info "Preparing environment..."
    using Pkg; Pkg.instantiate()

    using DistributedArrays
    using Statistics
    using Cockatrice.Config
    using Cockatrice.Evo: Tracer
    using Dates

    include("$(@__DIR__)/base.jl")
    @info "Environment ready."

end



using Cockatrice.Cosmos

# this one's mostly for REPL use
function init(;config_path="./config.yaml", fitness=nothing, tracers=TRACERS)
    config = Config.parse(config_path)
    if fitness === nothing
        fitness = get_fitness_function(config, FF)
    end
    Cosmos.δ_init(config=config,
                  fitness=fitness,
                  crossover=LinearGenotype.crossover,
                  mutate=LinearGenotype.mutate!,
                  creature_type=LinearGenotype.Creature,
                  tracers=tracers)
end


## FIXME: again, objective performance should be cached, probably
@everywhere stopping_condition(evo) = (objective_performance.(evo.geo.deme) |> maximum) == 1.0


function launch(config_path; single_process=false)
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
              ]
    if single_process
        Cosmos.run(;params...)
    else
        Cosmos.δ_run(;params...)
    end
end
