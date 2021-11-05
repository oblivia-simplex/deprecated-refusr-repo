module Sensitivity

using ..Bits
using Graphs
using MetaGraphs
using Statistics
using GraphRecipes
using Plots
using Images
using SparseArrays
using FunctionWrappers: FunctionWrapper


const HyperCube = MetaGraph



function random_bitstring(dim)
    i = rand(0:(2^dim - 1))
    bits(i, dim)
end


function hypercube(dim)
    b = [bits(i, dim) |> BitVector for i = 0:(2^dim-1)]

    adj = spzeros(Bool, 2^dim, 2^dim)
    for i = 1:2^dim
        for j = 1:2^dim
            if b[i] .⊻ b[j] |> sum |> isone
                adj[i, j] = true
            end
        end
    end

    G = Graphs.SimpleGraph(adj) |> HyperCube

    for (v, bb) in zip(vertices(G), b)
        set_prop!(G, v, :bits, bb)
        set_prop!(G, v, :label, join(string.(Int.(bb)), ""))
    end

    G
end


function evaluated_hypercube(f::Function, dim::Integer)
    Q = hypercube(dim)
    evaluate_on_hypercube!(f, Q)
end


function evaluate_on_hypercube!(f, Q::HyperCube)
    for v in vertices(Q)
        set_prop!(Q, v, :value, f(get_prop(Q, v, :bits)))
    end
    Q
end


function local_energy(Q, v)::Rational
    f(x) = get_prop(Q, x, :value) |> Rational
    value = f(v)
    neighbourhood = f.(all_neighbors(Q, v))
    ((neighbourhood .- value) .^ 2) |> mean
end


function dirichlet_energy(f, dim; reducer=mean)
    Q = hypercube(dim)
    evaluate_on_hypercube!(f, Q)
    (local_energy(Q, v) for v in vertices(Q)) |> reducer
end


function approximate_dirichlet_energy(f, dim, sample)
    n = sample * 2^dim
    total = Rational(0)
    x = random_bitstring(dim)
    y = f(x) |> Rational
    x[rand(1:length(x))] ⊻= true
    for _ in 1:n
        v = f(x) |> Rational
        x[rand(1:length(x))] ⊻= true
        total += Rational((v - y)^2)
        y = v
    end
    return total / Rational(n)
end


function approximate_dirichlet_energy_by_walk(f, dim, walk)
    n = length(walk)
    total = Rational(0)
    x = walk[1]
    y = f(x) |> Rational
    for x in walk[2:end]
        v = f(x) |> Rational
        total += Rational((v - y)^2)
        y = v
    end
    return total / Rational(n)
end

function fast_dirichlet_energy(f, dim;
                               target,
                               initial_sample=0.1,
                               epsilon=0.05)
    approx = approximate_dirichlet_energy(f, dim, initial_sample)
    if abs(approx - target) < epsilon
        return dirichlet_energy(f, dim)
    else
        return approx
    end
end


function sensitivity(f, dim)
    dirichlet_energy(f, dim; reducer=maximum)
end


function energize_hypercube!(Q)
    for v in vertices(Q)
        energy = local_energy(Q, v)
        set_prop!(Q, v, :energy, energy)
    end
    Q
end

function plotcube(f, dim)
    Q = hypercube(dim)
    evaluate_on_hypercube!(f, Q)
    energize_hypercube!(Q)
    color = colorsigned()
    graphplot(
        Q,
        names = [get_prop(Q, v, :label) for v in vertices(Q)],
        nodeshape = [get_prop(Q, v, :value) ? :circle : :rect for v in vertices(Q)],
        nodecolor = [get_prop(Q, v, :energy) |> color for v in vertices(Q)],
    )
end

# TODO: write a function to estimate dirichlet energy from a partial sample
# pick random vertices, and then expand with a nonrepeating random walk from
# each vertex to grab random regions



end # module
