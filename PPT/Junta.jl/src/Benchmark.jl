module Benchmark

using BenchmarkTools
using ..JuntaSearch

function bench(testdims = [16,18,20,22,23])
    times = []

    for dim in testdims
        print("Benchmarking $(dim) input dimension: ")
        testindices = [1,4,5,7,8]
        testfn = (x::BitVector) -> reduce(xor, x[testindices])
        ϵ = 1e-3
        error_prob = 1e-5

        if dim < 23
            evals = 5
        else
            evals = 1
        end

        push!(times, @benchmark junta_size_adaptive_simple(
            $(testfn), $(ϵ), $(dim), $(error_prob)) evals = evals)
        println("Completed in $(median(times[end])).")
        GC.gc()
    end

    return times
end

end # module
