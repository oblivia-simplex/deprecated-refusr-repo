module JuntaSearch

export junta_size_adaptive_simple, check_for_juntas_adaptive_simple

using BitTools
using ..Properties
using Random
using Combinatorics
using Memoize
using Distributed

RNG_DEFAULT = Random.GLOBAL_RNG
PARBLOCK_DEFAULT = 256*Sys.CPU_THREADS

function junta_binary_search(f :: Function, x :: BitVector, y :: BitVector,
    testspec :: Union{PointwisePropertyTest, Nothing})
    # http://www.cs.columbia.edu/~rocco/Public/stoc18.pdf
    # Input: Query access to f : {0, 1}^n → {0, 1},
    # and two bit vectors x, y ∈ {0, 1}^n with f(x) ,f(y).
    # Output: Two bit vectors x′, y′ ∈ {0, 1}^n,
    # with f(x′), f(y′) and x′ = y′^(i) for some i ∈ diff(x, y).
    # x^(i) denotes bit vector x with bit(s) at position(s) i (or vector I) flipped.
    # (1) Let B ⊆ [n] be the set such that x = y^(B).
    # (2) If |B| = 1, return x and y.
    # (3) Partition (arbitrarily) B into B1 and B2 of size ⌊|B|/2⌋ and ⌈|B|/2⌉,
    #     respectively.
    # (4) Query f(x^(B1)).
    # (5) If f(x) ≠ f(x^(B1)), return BinarySearch(f, x, x^(B1)).
    # (6) Otherwise, return BinarySearch(f, x^(B1), y).

    @debug "x: $x, y: $y"
    @debug "fx ≠ fy: $(f(x) ≠ f(y))" # Strangely, this is not always true
    # Even though this is called from within a conditional on this condition
    # Used to be an assert which caught it
    # Happens when the junta includes the last position as in
    # f = (x::BitVector) -> reduce(xor, x[3:4]) for a 4-dimensional test.
    # Still apparently works in that case though.

    B = findall(x .⊻ y)

    if length(B) == 1
        if testspec !== nothing
            propertyholds = testspec.test(f, x, y)
            lock(testspec.log_lock) do
                push!(testspec.log, (x, B[1], propertyholds))
            end
        end
        return (x, y)
    end

    Bpartlen = div(length(B), 2)
    B1 = shuffle!(B)[1:Bpartlen]

    xB1 = invert_at_indices(x, B1)

    if f(xB1) ≠ f(x)
        return junta_binary_search(f, x, xB1, testspec)
    else
        return junta_binary_search(f, xB1, y, testspec)
    end
end

# lock concurrent access to this function to keep memoization safe
powerset_lock = ReentrantLock()
@memoize function powersetdifference(dim, s)
    return collect(powerset(setdiff(1:dim, s)))
end

function check_for_juntas_adaptive_simple(
    f :: Function, D :: Function, k :: Integer, ϵ :: Real, dim :: Integer,
    initial_I :: Set{Integer} = Set{Integer}(),
    testspec :: Union{PointwisePropertyTest, Nothing} = nothing,
    rng = RNG_DEFAULT,
    parblocksize :: Integer = PARBLOCK_DEFAULT
    )
    # http://www.cs.columbia.edu/~rocco/Public/stoc18.pdf
    # Input: Oracle access to a Boolean function f : {0, 1}^n → {0, 1}
    #  and a probability distribution
    # D over {0, 1}^n, a positive integer k, and a distance parameter ϵ > 0.
    # dim, an annotation indicating the input dimension of f and output dim of D
    # Output: Either “accept” or “reject.”
    # (1) Set I = ∅. I ⊂ [n] is maintained such that a distinguishing pair
    #     has been found for each i ∈ I.
    # (2) Repeat 8(k + 1)/ϵ times:
    #     (3) Sample x ← D and a subset R of Icomplement uniformly at random.
    #         It's unclear if this means the elements of Icomplement should be
    #         sampled uniformly at random to form a subset or the subsets themselves.
    #         Set y = x^(R).
    #     (4) If f(x) ≠ f(y), then run the standard binary search on x, y to
    #         find a distinguishing pair for a new relevant variable i ∈ R ⊆ Ic.
    #         Set I = I ∪ {i}.
    #     (5) If |I| > k, then halt and output “reject.”
    # (6) Halt and output “accept.”
    #
    # SimpleDJunta makes O((k/ϵ) + k log n) queries and
    # always accepts when f is a k-junta.
    # It rejects with probability at least 2/3
    # if f is ϵ-far from k-juntas with respect to D.

    I = copy(initial_I)
    I_lock = ReentrantLock()

    totaltrials = Int(cld(8(k + 1), ϵ))
    blockiterations = max(16, div(totaltrials, parblocksize))

    for block in 1:blockiterations
        @sync @distributed for blockiteration = 1:blockiterations
            x = D()
            psdiff = Set()
            lock(powerset_lock) do
                psdiff = powersetdifference(dim, I)
            end
            R = rand(rng, psdiff)
            @debug "I: $I, R: $R"
            y = invert_at_indices(x, R)

            if f(x) ≠ f(y)
                @debug "doing binary search"
                xs, ys = junta_binary_search(f, x, y, testspec)
                i = findall(xs .⊻ ys)
                lock(I_lock) do
                    I = union(I, i)
                end
            end
        end
        if length(I) > k
            return (false, I)
        end
    end

    return (true, I)
end

function check_for_juntas_adaptive_simple(
    f :: Function, k :: Integer, ϵ :: Real, dim :: Integer,
    initial_I = Set{Integer}(),
    testspec :: Union{PointwisePropertyTest, Nothing} = nothing,
    rng = RNG_DEFAULT, parblocksize :: Integer = PARBLOCK_DEFAULT)
    return check_for_juntas_adaptive_simple(
        f, () -> rbitvec(dim), k, ϵ, dim, initial_I, testspec, rng, parblocksize
    )
end

@inline iterations_for_error_prob(x) = Int(cld(-log(x), (log(3))))
# alg rejects with prob 2/3 each time so 1/3 false neg rate so find (1/3)^y ≤ x
# to find number of iterations needed to get lower prob of false negative

function check_for_juntas_adaptive_simple(
    f :: Function, k :: Integer, ϵ :: Real, dim :: Integer, error_prob :: Real,
    initial_I :: Set{Integer} = Set{Integer}(),
    testspec :: Union{PointwisePropertyTest, Nothing} = nothing,
    rng = RNG_DEFAULT,
    parblocksize :: Integer = PARBLOCK_DEFAULT
    )

    accept = false
    indices = initial_I

    for i = 1:iterations_for_error_prob(error_prob)
        (accept, indices) = check_for_juntas_adaptive_simple(
            f, k, ϵ, dim, indices, testspec, rng, parblocksize
        )
        if !accept
            return (accept, indices)
        end
    end
    return (accept, indices)
end

function junta_size_adaptive_simple(
    f :: Function, # Function to test
    ϵ :: Real, # distance parameter for test sensitivity
    dim :: Integer, # dimension of input to test function
    error_prob :: Real, # error bound for testing
    testspec :: Union{PointwisePropertyTest, Nothing} = nothing, # property test
    num_points :: Integer = 1, # number of input points to accumulate at each index
    rng = RNG_DEFAULT, # rng to use
    parblocksize :: Integer = PARBLOCK_DEFAULT # number of tests to run parallel
    )
    # This variant steps up until it fails the junta test to determine junta size
    # It passes through the set of indices found so as not to lose the search state

    indices = Set{Integer}()
    found_k = 0

    for p in 1:num_points
        indices = Set{Integer}()
        for k in 1:dim
            (accept, indices) = check_for_juntas_adaptive_simple(
                f, k, ϵ, dim, error_prob / dim, indices, testspec, rng, parblocksize
            )
            if accept
                found_k = k
                break
            end
        end
    end

    return (found_k, sort(collect(indices)), testspec)
end

end # module JuntaSearch
