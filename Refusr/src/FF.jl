module FF

#import ..TreeGenotype: evaluate, parsimony
#import ..LinearGenotype: evaluate, parsimony
using FunctionWrappers: FunctionWrapper
using Statistics, CSV, DataFrames, InformationMeasures, StatsBase
using ..BitEntropy
using Cockatrice.Geo


### Interface for FF-required functions
parsimony(g) = error("unimplemented")
evaluate(g; data, kwargs...) = error("unimplemented")
###

DATA = nothing
INPUT = nothing

function graydecode(n::Integer)
    r = n
    while (n >>= 1) != 0
        r ⊻= n
    end
    return r
end

grayencode(n::Integer) = n ⊻ (n >> 1)

pack(row) = sum([row[i] << (i - 1) for i = 1:length(row)])

graydecode_row(row) = pack(row) |> graydecode


function _set_data(data::String; samplesize = :ALL)
    global DATA, INPUT
    data = CSV.read(data, DataFrame)
    data = sort(eachrow(data), by = r -> graydecode_row(r[1:end-1])) |> DataFrame
    if samplesize === :ALL || DataFrames.nrow(data) <= samplesize
        DATA = data
    else
        rows = sample(1:size(data, 1), samplesize, replace = false)
        DATA = data[rows, :]
    end
    INPUT = Array{Bool}(DATA[:, 1:end-1]) |> BitArray
end

function _set_data(data::DataFrame)
    global DATA
    DATA = data
    INPUT = Array{Bool}(DATA[:, 1:end-1]) |> BitArray
end


hamming(a, b) = (!).(a .⊻ b)

mutualinfo(a, b) = get_mutual_information(a, b) / get_entropy(a)


get_difficulty_scores(IM) = 1.0 .- map(mean, eachrow(IM))

function get_hamming(answers, result; IM = nothing, sharing = (!isnothing(IM)))
    correct = (!).(answers .⊻ result)
    if sharing
        correct = (!).(answers .⊻ result)
        adjusted = correct .* get_difficulty_scores(IM)
        mean(adjusted)
    else
        mean(correct)
    end
end

unzip(a) = map(x -> getfield.(a, x), fieldnames(eltype(a)))


# Only defined for Linear Genotypes for now
# returns a 2d array of intermediate results
intermediate_results(trace) = vcat([transpose(tr[1, :]) for tr in trace]...)

intermediate_hamming(answers, trace) =
    map(c -> get_hamming(answers, c), eachcol(intermediate_results(trace)))


get_answers(data = DATA) = Bool.(data[:, end]) |> BitArray

# to keep things working smoothly, we'll consider an absent phenotype to have passed
# all tests, just for the sake of difficulty calculation. The idea here is that a
# virgin interaction matrix shouldn't alter the hamming score at all -- which is what
# will happen when the score is multiplied by 1.
# FIXME try rand() instead of ones(), so that it alters it in an "expected" or "average"
# way, instead.
passes(e) =
    isnothing(e.phenotype) ? BitArray(rand(Bool, nrow(DATA))) :
    (~).(e.phenotype.results .⊻ get_answers(DATA))

## TODO maintain this as a field of the Geo object, and update it in a piecemeal
## way, as needed. No need to reevaluate every row, every step.
function build_interaction_matrix(geo)
    if !isnothing(geo.interaction_matrix)
        geo.interaction_matrix
    else
        geo.interaction_matrix = hcat(passes.(reshape(geo.deme, prod(size(geo.deme))))...)
    end
end

# Some trace accessors for convenience. Check to make sure these aren't obsolete.

function trace_accessor(trace; reg = :, step = :, case = :)
    trace[reg, step, case]
end


function add_data_to_trace(trace, input = INPUT)
    n_steps = size(trace, 2)
    x = repeat(INPUT, 1, 1, n_steps)
    p = permutedims(x, [2, 3, 1])
    cat(p, trace, dims = (1,))
end


## See Krawiec, chapter 6

function trace_consistency(trace::BitArray, answers::BitArray)
    A = map(r -> BitEntropy.conditional_entropy(answers, r), eachslice(trace, dims = 2))
    B = map(r -> BitEntropy.conditional_entropy(r, answers), eachslice(trace, dims = 2))
    minimum(A .+ B)
end


OUTREG = 1

function trace_hamming(trace::BitArray, answers::BitArray)
    x = view(trace, OUTREG, :, :) .⊻ answers
    (1.0 .- map(mean, eachcol(x))) |> maximum
end


function trace_information(trace::BitArray; answers = get_answers())
    x = view(trace, OUTREG, :, :)
    map(x -> mutualinfo(answers, x), eachcol(x))
end

function active_trace_information(;
    code,
    trace,
    answers = get_answers(),
    measure = mutualinfo,
)
    slices = (view(trace, r, :, n) for (n, r) in enumerate(i.dst for i in code))
    [measure(answers, s) for s in slices]
end


## NOTE on translating coordinates:
# A[(i[2]-1)*(size(A,1))+i[1]] == A[i...]

function update_interaction_matrix!(geo, index, out_vec)
    if geo.interaction_matrix === nothing
        geo.interaction_matrix = build_interaction_matrix(geo)
    end
    flat_index = Geo.hilbert_index(geo, index)
    geo.interaction_matrix[:, flat_index] .= (!).(out_vec .⊻ get_answers(DATA))
end

function get_difficulty(interaction_matrix, row_index)
    interaction_matrix[row_index, :] |> mean
end


function fit(geo, i)
    global DATA
    g = geo.deme[i]
    config = geo.config
    if DATA === nothing
        _set_data(config.selection.data)
    end
    # FIXME: refactor so that the interaction matrix is held as a field of Geo
    # and is updated only as needed, IF that turns out to be faster. It might not
    # be, as julia is really rather quick with its array and matrix operations.
    interaction_matrix = build_interaction_matrix(geo)

    answers = get_answers()

    g.phenotype = if isnothing(g.phenotype)
        res, tr = evaluate(g, config = config, INPUT = INPUT, make_trace = true)

        hamming(a, b) = (~).(a .⊻ b) |> mean

        (
            results = res,
            trace = tr,
            # NOTE: we could actually reduce the trace to a vector, by tracking only
            # the dst registers. if needed, the full trace could easily be reconstituted.
            trace_info = active_trace_information(
                trace = tr,
                code = g.effective_code,
                measure = mutualinfo,
            ),
            trace_hamming = active_trace_information(
                trace = tr,
                code = g.effective_code,
                measure = hamming,
            ),
        )

    else
        g.phenotype
    end

    if isempty(g.effective_code)
        return [0, 0, 0]
    end

    @assert g.phenotype.results isa BitArray "g is $(g), g.phenotype.results is $(g.phenotype.results |> typeof)"
    @assert g.phenotype.trace isa BitArray "g is $(g) g.phenotype.trace is $(g.phenotype.trace |> typeof)"

    # We could scan the trace here, and see if the program solved the problem
    # at some intermediary stage. (max trace hamming)

    # NOTE trace_information should be minimized. Let's make it negative.
    #trace_con = -1.0 * trace_information(g.phenotype.trace, answers)

    hamming = get_hamming(
        answers,
        g.phenotype.results,
        sharing = config.selection.fitness_sharing,
        IM = interaction_matrix,
    )

    update_interaction_matrix!(geo, i, g.phenotype.results)
    # Variety measures how different the program behaves with respect to input
    # variety = length(unique(g.phenotype.trace)) / length(g.phenotype.trace)
    g.fitness = [hamming, maximum(g.phenotype.trace_info), parsimony(g)]
    return g.fitness
end



## TODO
# partial evaluation:
# - evaluate random subexpressions and measure mutual information to goal,
#   to incentivize partial solutions.

end # end module FF

# TODO: Implement Trace Consistency fitness metric
