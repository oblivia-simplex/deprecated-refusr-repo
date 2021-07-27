using Cockatrice

using CSV, DataFrames
using ProgressMeter
using Setfield
using InformationMeasures
using Statistics

include("BitEntropy.jl")
include("StructuredTextTemplate.jl")
include("Expressions.jl")
include("Names.jl")
include("FF.jl")
include("TreeGenotype.jl")
include("LinearGenotype.jl")
include("step.jl")
include("Z3Bridge.jl")
include("Analysis.jl")

meanfinite(s) = mean(filter(isfinite, s))
stdfinite(s) = std(filter(isfinite, s))

function get_likeness(g)
    isnothing(g.likeness) ? -Inf : maximum(g.likeness)
end


function prep_config(path)
    config = Cockatrice.Config.parse(path)
    data = CSV.read(config.selection.data, DataFrame)
    data_n = ncol(data) - 1
    #config = @set config.genotype.data_n = data_n
    config
end

function objective_performance(g)
    if g.phenotype === nothing
        return -Inf
    end
    if g.performance !== nothing
        return g.performance
    end

    correct = (!).(g.phenotype.results .⊻ FF.get_answers(FF.DATA))
    g.performance = mean(correct)
    return g.performance
end

stopping_condition(evo) = !isempty(evo.elites) && (objective_performance.(evo.elites) |> maximum) == 1.0

TRACERS = [
    (key="objective", callback=objective_performance, rate=0.01),
    (key="fitness_1", callback=g->g.fitness[1], rate=0.01),
    (key="fitness_2", callback=g->g.fitness[2], rate=0.01),
    #(key="fitness_3", callback=g->g.fitness[3], rate=1.0),
    (key="chromosome_len", callback=g->length(g.chromosome), rate=0.01),
    (key="effective_len", callback=g->isnothing(g.effective_code) ? -Inf : length(g.effective_code), rate=0.01),
    (key="num_offspring", callback=g->g.num_offspring, rate=0.01),
    (key="generation", callback=g->g.generation, rate=0.01),
    #(key="likeness", callback=get_likeness, rate=0.01),
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
    #(key="likeness", reducer=meanfinite),
]


## To facilitate debugging
function mkevo(config="./config.yaml")
    config = prep_config(config)
    FF._set_data(config.selection.data)
    Cockatrice.Evo.Evolution(config, creature_type=LinearGenotype.Creature, fitness=FF.fit, tracers=TRACERS, mutate=LinearGenotype.mutate!, crossover=LinearGenotype.crossover, objective_performance=objective_performance)
end

