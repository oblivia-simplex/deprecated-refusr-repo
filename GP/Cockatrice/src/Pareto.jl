module Pareto

export nonDominatedSorting

dominates(x, y) =
    all(i -> x[i] >= y[i], eachindex(x)) && any(i -> x[i] > y[i], eachindex(x))

function nonDominatedSorting(arr; by = identity, n_fronts = 0)
    fronts::Array{Array,1} = Array[]
    ind::Array{Int64,1} = collect(1:size(arr, 1))
    while !isempty(arr)
        s = size(arr, 1)
        red = dropdims(
            sum([dominates(by(arr[i]), by(arr[j])) for i = 1:s, j = 1:s], dims = 1) .== 0,
            dims = 1,
        )
        a = 1:s
        sel::Array{Int64,1} = a[red]
        push!(fronts, ind[sel])
        if n_fronts > 0 && length(fronts) >= n_fronts
            break
        end
        da::Array{Int64,1} = deleteat!(collect(1:s), sel)
        ind = deleteat!(ind, sel)
        arr = arr[da, :]
    end
    return fronts
end

end # module
