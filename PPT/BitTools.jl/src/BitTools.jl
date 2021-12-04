module BitTools

export rbitvec, invert_at_indices

using RandomNumbers
using Random
using Distributions

rng = Xorshifts.Xoshiro128Plus(0xdeadbeef)

@inline function rbitvec(len :: Integer, occ :: Integer, rng = rng)
    # Returns a random bit vector of length len
    # with occ one bits and len-occ zero bits
    return BitVector(shuffle!(rng, [zeros(Bool, len - occ); ones(Bool, occ)]))
end

using Distributions: Beta
beta = Beta(5, 5)

@inline function rbitvec(len :: Integer)
    # Returns a random bit vector of length len
    # and occupancy Beta(5,5) between 1 and len
    return rbitvec(len, Int(floor(len * rand(rng, beta)) + 1))
end

@inline function invert_at_indices(x::BitVector, inds)
    # returns copy of x with bits flipped at positions given in inds
    out = copy(x)
    map!(!, view(out, inds), x[inds])
    return out
end

using Clustering
import StatsBase: sample, Weights
using Distributions

export findClustering, sample, sampleWeights, unimodalDist, sampleBernoulli

function hammingDistances(data :: BitMatrix)
    (dim, len) = size(data)
    r = zeros(UInt16, len, len)
    for i in 1:len
        for j in 1:i
            r[i,j] = r[j,i] = sum(data[:,i] .!= data[:,j])
        end
    end
    return r
end

@inline score(a, b) = vmeasure(a, b)

function tryNewClustering(k :: Int, oldClustering :: KmeansResult, data :: BitMatrix)
    (dim, oldK) = size(oldClustering.centers)
    if k == oldK
        return oldClustering
    end
    c = copy(oldClustering.centers)

    if k < oldK
        c = c[:, 1:k]
    elseif k > oldK
        c = hcat(c, rand(dim, k - oldK))
    end

    return kmeans!(data, c, maxiter = 32)
end

function findClustering(data :: BitMatrix, initialGuess :: Union{KmeansResult,Nothing} = nothing)
    (dim, len) = size(data)
    initialK = 1
    initialGuess = initialGuess != nothing ? initialGuess :
     kmeans(data, initialK, maxiter = 64, display = :iter)

    bestGuess = initialGuess
    bestGuessScore = score(initialGuess, initialGuess)

    for k in initialK : Int(floor(1.5 * sqrt(len)))
        newGuess = tryNewClustering(k, bestGuess, data)
        newGuessScore = score(newGuess, bestGuess)

        if(newGuessScore > bestGuessScore)
            bestGuess = newGuess
            bestGuessScore = newGuessScore
        end
    end

    return bestGuess
end

function sampleWeights(c :: KmeansResult, numInSamples = 16)
    idxs = collect(1:size(c.centers)[2])
    points = sum(c.counts)
    cols = sample(idxs, Weights(c.counts ./ points), numInSamples)
    len = length(cols)
    return sum(c.centers[:, cols], dims = 2) ./ len
end

function sample(c :: KmeansResult, numInSamples = 16, numOutSamples = 1)
    weights = sampleWeights(c, numInSamples)
    out = BitMatrix(undef, length(weights), numOutSamples)
    for i in 1: length(weights)
        for j in 1:numOutSamples
            out[i, j] = rand(Bernoulli(weights[i]))
        end
    end
    return out
end

@inline function bound(x, low, high)
    return min(max(x, low), high)
end

function unimodalDist(data :: BitMatrix, smooth = 0)
    counts = bound.(sum(data, dims = 2) ./ Float16(size(data)[2]), smooth, 1 - smooth)
    return counts
end

import Distributions.Bernoulli

function sampleBernoulli(p :: AbstractMatrix, numSamples = 1)
    out = BitMatrix(undef, size(p)[1], numSamples)
    for i in 1:size(p)[1]
        for j in 1:numSamples
            out[i, j] = rand(Bernoulli(p[i]))
        end
    end
    return out
end

export hypercode, hypersum, hyperdiff, hyperprod, hyperquot, distance

function hypercode(o, setbits = 16, length = 4096)
    localrng = Xorshifts.Xorshift64(hash(o))
    return rbitvec(length, setbits, localrng)
end

@inline function hypersum(a, b)
    # this will only perform as expected for sparse codes, up to capacity
    return a .⊻ b
end

@inline function hyperdiff(a, b)
    return a .& .!b
end

@inline function hyperprod(a, b)
    # permutation version is better for many uses
    return a .⊻ b
end

@inline function hyperquot(a, b)
    # permutation version is better for many uses
    return a .⊻ b
end

@inline function distance(a, b)
    return sum(a .⊻ b)
end

end # module
