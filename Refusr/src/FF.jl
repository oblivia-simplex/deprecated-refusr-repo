module FF

#using ..TreeGenotype: evaluate, parsimony
using ..LinearGenotype: evaluate, parsimony
using FunctionWrappers: FunctionWrapper
using Statistics, CSV, DataFrames, InformationMeasures, StatsBase

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

mutualinfo(a, b) = a == b ? 1.0 : get_mutual_information(a, b)

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
    mutinfo = round(mutualinfo(answers, g.phenotype), digits=4)
    accuracy = 1.0 - (answers .⊻ g.phenotype |> sum) / length(answers)
    g.fitness = [mutinfo, accuracy, p]
    return g.fitness
end


## TODO
# partial evaluation:
# - evaluate random subexpressions and measure mutual information to goal,
#   to incentivize partial solutions.

end # end module FF

