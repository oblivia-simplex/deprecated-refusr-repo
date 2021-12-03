module Bits

export bits, random_walk

function bits(n, dim)
    n = UInt128(n)
    [(n & UInt128(1) << i != 0) for i = 0:(dim-1)] |> BitVector
end



function random_walk(dim, len; set=false)
    bv = bits(rand(0:(2^dim)-1), dim)
    walk = set ? Set() : []
    while length(walk) < len
        push!(walk, copy(bv))
        bv[rand(1:dim)] ⊻= true
    end
    return set ? collect(walk) : walk
end

end # module
