using Distributed


if nprocs() == 1
    addprocs(4, topology=:master_worker, exeflags="--project=$(Base.active_project())")
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
    const Genotype = LinearGenotype
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
                  crossover=Genotype.crossover,
                  mutate=Genotype.mutate!,
                  creature_type=Genotype.Creature,
                  tracers=tracers)
end


function launch(config_path)
    config = Config.parse(config_path)
    fitness_function = Meta.parse("FF.$(config.selection.fitness_function)") |> eval
    @assert fitness_function isa Function
    E, table = Cosmos.δ_run(config=config,
                            fitness=fitness_function,
                            creature_type=Genotype.Creature,
                            crossover=Genotype.crossover,
                            mutate=Genotype.mutate!,
                            tracers=TRACERS,
                            loggers=LOGGERS,
                            )
    ## TODO: Actually log that table. 
end


if !isinteractive()
    config = length(ARGS) > 0 ? ARGS[1] : "./config.yaml"
    launch(config)
end

