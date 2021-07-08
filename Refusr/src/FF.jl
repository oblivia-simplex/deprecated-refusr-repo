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
    if DataFrames.nrow(data) <= samplesize
        DATA = data
    else
        rows = sample(1:size(data,1), samplesize, replace=false)
        DATA = data[rows, :]
    end
end

function _set_data(data::DataFrame)
    global DATA
    DATA = data
end


mutualinfo(a, b) = get_mutual_information(a,b) / get_entropy(a)


get_difficulty_scores(IM) = 1.0 .- map(mean, eachrow(IM))

function get_hamming(answers, result; IM=nothing)
    correct = (!).(answers .⊻ result)
    if isnothing(IM)
        mean(correct)
    else
        correct = (!).(answers .⊻ result)
        adjusted = correct .* get_difficulty_scores(IM)
        mean(adjusted)
    end
end

unzip(a) = map(x->getfield.(a, x), fieldnames(eltype(a)))


# Only defined for Linear Genotypes for now
# returns a 2d array of intermediate results
intermediate_results(trace) = vcat([transpose(tr[1,:]) for tr in trace]...)

intermediate_hamming(answers, trace) = map(c->get_hamming(answers, c), eachcol(intermediate_results(trace)))


get_answers(data) = Bool.(data[:, end])

# to keep things working smoothly, we'll consider an absent phenotype to have passed
# all tests, just for the sake of difficulty calculation. The idea here is that a
# virgin interaction matrix shouldn't alter the hamming score at all -- which is what
# will happen when the score is multiplied by 1.
# FIXME try rand() instead of ones(), so that it alters it in an "expected" or "average"
# way, instead.
passes(e) = isnothing(e.phenotype) ? BitArray(rand(Bool, nrow(DATA))) : (~).(e.phenotype.results .⊻ get_answers(DATA))

## TODO maintain this as a field of the Geo object, and update it in a piecemeal
## way, as needed. No need to reevaluate every row, every step.
function build_interaction_matrix(geo)
	  hcat(passes.(reshape(geo.deme, prod(size(geo.deme))))...)
end

function get_difficulty(interaction_matrix, row_index)
    interaction_matrix[row_index,:] |> mean
end


function fit(geo, g)
    global DATA
    config = geo.config
    if DATA === nothing
        _set_data(config.selection.data)
    end
    # FIXME: refactor so that the interaction matrix is held as a field of Geo
    # and is updated only as needed, IF that turns out to be faster. It might not
    # be, as julia is really rather quick with its array and matrix operations.
    interaction_matrix = (geo.config.selection.fitness_sharing ?
                          build_interaction_matrix(geo)
                          : nothing)
    if g.phenotype === nothing
        results, trace = [evaluate(g, data=collect(Bool, r[1:end-1])) for r in eachrow(DATA)] |> unzip
        g.phenotype = (results = results, trace = trace)
    end
    # We could scan the trace here, and see if the program solved the problem
    # at some intermediary stage.

    answers = get_answers(DATA)
    mutinfo = mutualinfo(answers, g.phenotype.results)
    hamming = get_hamming(answers, g.phenotype.results, IM=interaction_matrix) 
    # Variety measures how different the program behaves with respect to input
    # variety = length(unique(g.phenotype.trace)) / length(g.phenotype.trace)
    g.fitness = [hamming, mutinfo, parsimony(g)]
    return g.fitness
end



## TODO
# partial evaluation:
# - evaluate random subexpressions and measure mutual information to goal,
#   to incentivize partial solutions.

end # end module FF

