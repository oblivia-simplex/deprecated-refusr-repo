using Cockatrice

using InformationMeasures
using Statistics

include("StructuredTextTemplate.jl")
include("Expressions.jl")
include("Names.jl")
include("FF.jl")
include("TreeGenotype.jl")
include("LinearGenotype.jl")
include("step.jl")

meanfinite(s) = mean(filter(isfinite, s))
stdfinite(s) = std(filter(isfinite, s))

function get_likeness(g)
    isnothing(g.likeness) ? -Inf : maximum(g.likeness)
end


function objective_performance(g)
    if g.phenotype === nothing
        return -Inf
    end
    correct = (!).(g.phenotype.results .⊻ FF.get_answers(FF.DATA))
    mean(correct)
end

TRACERS = [
    (key="objective", callback=objective_performance, rate=1.0),
    (key="fitness_1", callback=g->g.fitness[1], rate=1.0),
    (key="fitness_2", callback=g->g.fitness[2], rate=1.0),
    (key="fitness_3", callback=g->g.fitness[3], rate=1.0),
    (key="chromosome_len", callback=g->length(g.chromosome), rate=1.0),
    (key="effective_len", callback=g->isnothing(g.effective_code) ? -Inf : length(g.effective_code), rate=1.0),
    (key="num_offspring", callback=g->g.num_offspring, rate=1.0),
    (key="generation", callback=g->g.generation, rate=1.0),
    (key="likeness", callback=get_likeness, rate=1.0),
]



LOGGERS = [
    (key="objective", reducer=maximum),
    (key="objective", reducer=meanfinite),
    (key="fitness_1", reducer=maximum),
    (key="fitness_1", reducer=meanfinite),
    (key="fitness_1", reducer=std),
    (key="fitness_2", reducer=maximum),
    (key="fitness_2", reducer=meanfinite),
    (key="fitness_2", reducer=std),
    (key="chromosome_len", reducer=Statistics.maximum),
    (key="chromosome_len", reducer=Statistics.mean),
    (key="effective_len", reducer=Statistics.maximum),
    (key="effective_len", reducer=Statistics.mean),
    (key="num_offspring", reducer=maximum),
    (key="num_offspring", reducer=Statistics.mean),
    (key="generation", reducer=Statistics.mean),
    (key="likeness", reducer=meanfinite),
]


## To facilitate debugging
mkevo() = Cockatrice.Evo.Evolution(Cockatrice.Config.parse("./config.yaml"), creature_type=LinearGenotype.Creature, fitness=FF.fit, tracers=TRACERS, mutate=LinearGenotype.mutate!, crossover=LinearGenotype.crossover)


