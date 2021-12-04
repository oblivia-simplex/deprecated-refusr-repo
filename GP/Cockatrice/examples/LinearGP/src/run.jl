using Distributed

if nprocs() == 1
    addprocs(4, topology = :master_worker, exeflags = "--project=$(Base.active_project())")
end

@everywhere begin
    @info "Preparing environment..."
    using Pkg
    Pkg.instantiate()

    using DistributedArrays
    using Statistics
    using Cockatrice.Config
    using Cockatrice.Evo: Tracer
    using Dates

    include("$(@__DIR__)/LinearGP.jl")
    @info "Environment ready."

end

using Cockatrice.Cosmos


DEFAULT_CONFIG = "$(@__DIR__)/../configs/linear_gp.yaml"

DEFAULT_TRACE = [
    Tracer(key = "fitness_1", callback = (g -> g.fitness[1])),
    Tracer(key = "chromosome_len", callback = (g -> length(g.chromosome))),
    Tracer(key = "num_offspring", callback = (g -> g.num_offspring)),
    Tracer(key = "generation", callback = (g -> g.generation)),
]

DEFAULT_LOGGERS = [
    (key = "fitness_1", reducer = Statistics.mean),
    (key = "fitness_1", reducer = Base.maximum),
    (key = "fitness_1", reducer = Statistics.std),
    (key = "chromosome_len", reducer = Statistics.mean),
    (key = "num_offspring", reducer = Base.maximum),
]

# this one's mostly for REPL use
function init(;
    config_path = DEFAULT_CONFIG,
    fitness = LinearGP.FF.classify,
    tracers = DEFAULT_TRACE,
)
    if fitness === nothing
        fitness = get_fitness_function(config_path, FF)
    end
    Cosmos.δ_init(
        config = config_path,
        fitness = fitness,
        crossover = LinearGP.crossover,
        mutate = LinearGP.mutate!,
        creature_type = LinearGP.Creature,
        tracers = tracers,
    )
end


function launch(config_path)
    config = Config.parse(config_path)
    fitness_function = LinearGP.FF.classify
    @assert fitness_function isa Function
    Cosmos.δ_run(
        config = config,
        fitness = fitness_function,
        creature_type = LinearGP.Creature,
        crossover = LinearGP.crossover,
        mutate = LinearGP.mutate!,
        tracers = DEFAULT_TRACE,
        loggers = DEFAULT_LOGGERS,
    )
end


if !isinteractive()
    config = length(ARGS) > 0 ? ARGS[1] : DEFAULT_CONFIG
    launch(config)
end
