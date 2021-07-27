module BitEntropy
using StatsBase

function Pr(bits, v)
    s = mean(bits)
    v ? s : 1.0 - s
end


# 98 ns vs InformationMeasures.get_entropy's 12 μs
function shannon_entropy(bits)
    ones = sum(bits)
    zeros = length(bits) - ones
    counts = [ones, zeros]
    s = sum(counts)
    l = (x -> x * log2(x)).(counts) |> sum
    log2(s) - l / s
end


function joint_entropy(Y, X)
    YX = vcat(reshape(Y, prod(size(Y))), reshape(X, prod(size(X))))
    shannon_entropy(YX)
end


function _conditional_entropy(Y, X)
    joint_entropy(Y, X) - shannon_entropy(X)
end

"H(Y|X)"
function conditional_entropy(Y, X)
    t = Pr(Y, true)  * log2(Pr(Y, true))
    f = Pr(Y, false) * log2(Pr(Y, false))
    -(t + f)
end



function mutual_information(Y, X)
    shannon_entropy(Y) - conditional_entropy(Y, X)
end

end
