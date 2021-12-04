module ParityTables

using ..Bits
using DataFrames
using CSV
using StatsBase

function n_parity(n; save=false, path=nothing, mode=:odd)

    f(D) = mode === :odd ? sum(D) % 2 == 1 : sum(D) % 2 == 0

    cols = [["D[$i]" for i in 1:n]; "OUT"]
    df = DataFrame([[] for _ in cols], cols)

    for i in 1:(2^n)
        args = bits(i-1, n)
        row = [args; f(args)]
        push!(df, row)
    end

    if save && path === nothing
        path = "$(@__DIR__)/../samples/$(n)-bit-$(mode)-parity.csv"
    end

    if path !== nothing
        CSV.write(path, df)
        @info "Wrote truth table for $(n)-bit $(mode)-parity to $(path)
"
    end

    return df
end


function k_dropout_n_parity(n, k;
                            dropout=:ALL,
                            save=false,
                            path=nothing,
                            mode=:odd)

    @assert k < n

    f(D) = mode === :odd ? sum(D) % 2 == 1 : sum(D) % 2 == 0
    cols = [["D[$i]" for i in 1:n]; "OUT"]
    df = DataFrame([[] for _ in cols], cols)

    keep = n - k

    dropout_rows = dropout === :ALL ? (1:(2^n)) : sample(1:(2^n), dropout, replace=false)

    for i in 1:(2^n)
        args = bits(i-1, n)
        active_bits = i ∈ dropout_rows ? sample(1:n, keep, replace=false) : 1:n
        row = [args; f(args[active_bits])]
        push!(df, row)
    end

    if save && path === nothing
        path = "$(@__DIR__)/../samples/$(n)-bit-$(mode)-parity-$(k)-dropout.csv"
    end

    if path !== nothing
        CSV.write(path, df)
        @info "Wrote truth table for $(n)-bit $(mode)-parity with $(k)-dropout to $(path)"
    end

    return df
end


end # module
