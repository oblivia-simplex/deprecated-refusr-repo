using Cockatrice

using InformationMeasures
using Statistics

include("Names.jl")
include("StructuredTextTemplate.jl")
include("FF.jl")
include("Expressions.jl")
include("TreeGenotype.jl")
include("LinearGenotype.jl")
include("step.jl")

meanfinite(s) = mean(filter(isfinite, s))
stdfinite(s) = std(filter(isfinite, s))

function get_likeness(g)
    isnothing(g.likeness) ? -Inf : maximum(g.likeness)
end

TRACERS = [
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
    (key="fitness_1", reducer=meanfinite),
    (key="fitness_1", reducer=std),
    (key="fitness_1", reducer=maximum),
    (key="fitness_2", reducer=meanfinite),
    (key="fitness_2", reducer=std),
    (key="fitness_2", reducer=maximum),
    (key="fitness_3", reducer=meanfinite),
    (key="fitness_3", reducer=std),
    (key="fitness_3", reducer=maximum),
    (key="chromosome_len", reducer=Statistics.mean),
    (key="chromosome_len", reducer=Statistics.std),
    (key="chromosome_len", reducer=Statistics.maximum),
    (key="effective_len", reducer=Statistics.mean),
    (key="effective_len", reducer=Statistics.std),
    (key="effective_len", reducer=Statistics.maximum),
    (key="num_offspring", reducer=maximum),
    (key="num_offspring", reducer=Statistics.mean),
    (key="generation", reducer=Statistics.mean),
    (key="likeness", reducer=meanfinite),
]

