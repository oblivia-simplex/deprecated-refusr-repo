module FF

#using ..TreeGenotype: evaluate, parsimony
using ..LinearGenotype: evaluate, parsimony
using FunctionWrappers: FunctionWrapper
using Statistics, CSV, DataFrames, InformationMeasures

DATA = nothing
TRUE_REWARD, FALSE_REWARD = Inf, Inf

function _set_data(data::String)
    global DATA, TRUE_REWARD, FALSE_REWARD
    DATA = CSV.read(data, DataFrame)
    FALSE_REWARD = (DATA[:, end] |> mean) * 2.0
    TRUE_REWARD = 2.0 - FALSE_REWARD
    TRUE_REWARD, FALSE_REWARD
end



function fit(g; config = nothing)
    global DATA
    if DATA === nothing
        _set_data(config.selection.data)
    end
    if g.phenotype === nothing
        g.phenotype = [evaluate(g, data=collect(Bool, r[1:end-1])) for r in eachrow(DATA)]
    end
    answers = [r[end] for r in eachrow(DATA)]
    score = get_mutual_information(answers, g.phenotype)
    accuracy = 1.0 - (answers .⊻ g.phenotype |> sum) / length(answers)
    g.fitness = [accuracy, score, parsimony(g)]
    return g.fitness
end


## TODO
# partial evaluation:
# - evaluate random subexpressions and measure mutual information to goal,
#   to incentivize partial solutions.

end # end module FF

