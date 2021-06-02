using Cockatrice

using InformationMeasures
using Statistics

include("Names.jl")
include("StructuredTextTemplate.jl")
include("FF.jl")
include("expressions.jl")
include("TreeGenotype.jl")
include("LinearGenotype.jl")
include("step.jl")

m(s) = mean(filter(isfinite, s))

function get_likeness(g)
    isnothing(g.likeness) ? -Inf : maximum(g.likeness)
end

TRACERS = [
    (key="fitness_1", callback=g->g.fitness[1], rate=1.0),
    (key="fitness_2", callback=g->g.fitness[2], rate=1.0),
    (key="fitness_3", callback=g->g.fitness[3], rate=1.0),
    (key="likeness", callback=get_likeness, rate=1.0),
]
