module FF

#import ..TreeGenotype: evaluate, parsimony
#import ..LinearGenotype: evaluate, parsimony
using FunctionWrappers: FunctionWrapper
using Statistics, CSV, DataFrames, InformationMeasures, StatsBase
using Memoize


### Interface for FF-required functions
parsimony(g) = error("unimplemented")
evaluate(g; data, kwargs...) = error("unimplemented")
###

DATA = nothing

function _set_data(data::String; samplesize=1000)
    global DATA
    data = CSV.read(data, DataFrame)
    rows = sample(1:size(data,1), samplesize, replace=false)
    DATA = data[rows, :]
end

function _set_data(data::DataFrame)
    global DATA
    DATA = data
end


@memoize Dict mutualinfo(a, b) = get_mutual_information(a,b) / get_entropy(a)

function get_accuracy(answers, result)
    1.0 - (answers .⊻ result|> sum) / length(answers)
end

function fit(g; config = nothing)
    global DATA
    if DATA === nothing
        _set_data(config.selection.data)
    end
    p = parsimony(g)
    if g.phenotype === nothing
        g.phenotype = [evaluate(g, data=collect(Bool, r[1:end-1])) for r in eachrow(DATA)]
    end
    answers = [r[end] for r in eachrow(DATA)]
    mutinfo = mutualinfo(answers, g.phenotype)
    accuracy = get_accuracy(answers, g.phenotype) 
    g.fitness = [mutinfo, accuracy,  p]
    return g.fitness
end


## TODO
# partial evaluation:
# - evaluate random subexpressions and measure mutual information to goal,
#   to incentivize partial solutions.

end # end module FF

