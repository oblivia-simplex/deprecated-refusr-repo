module Fingerprint

export fingerprint, printdiff, printcompare

using BitTools, ..Properties, ..JuntaSearch

function fingerprint(t :: Vector{Tuple{BitVector, Integer, Bool}},
    codesize = nothing)

    logloglen = log(2, length(t))
    occtarget = 2
    if codesize == nothing
        codesize = max(64, Int(ceil(logloglen)))
    end
    return mapreduce(o -> hypercode(o, occtarget, codesize), hypersum, t)
end

@inline printdiff(a, b) = distance(a, b)

function crosstest(f :: Function,
    t1 :: PointwisePropertyTest, t2 :: PointwisePropertyTest)
    # Test f with t1's test on the points in t2 and collect new log;
    # return log with new results
    log = Vector{Tuple{BitVector, Integer, Bool}}()

    for pointresult in t2.log
        point = pointresult[1]
        diffbit = pointresult[2]
        t1result = t1.test(f,
            point, setindex!(copy(point), !point[diffbit], diffbit))
        push!(log, (point, diffbit, t1result))
    end

    return log
end

function printcompare(
    f1 :: Function, f2 :: Function,
    t1 :: PointwisePropertyTest, t2 :: PointwisePropertyTest,
    codesize = nothing
    )

    fullt1log = vcat(
        t1.log,
        crosstest(f1, t1, t2))
    fullt2log = vcat(
        t2.log,
        crosstest(f2, t2, t1)
    )

    return printdiff(
        fingerprint(fullt1log, codesize),
        fingerprint(fullt2log, codesize)
    )
end

end # module
