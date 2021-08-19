module Sensitivity

using ..Expressions
using LightGraphs
using MetaGraphs
using Statistics
using GraphRecipes
using Plots
using Images
using SparseArrays
using FunctionWrappers: FunctionWrapper


function hypercube(dim)
    bits = [Expressions.bits(i, dim) |> BitVector
         for i in 0:(2^dim-1)]

    adj = spzeros(Bool, 2^dim, 2^dim)
    for i in 1:2^dim
        for j in 1:2^dim
            if bits[i] .⊻ bits[j] |> sum |> isone
                adj[i,j] = true
            end
        end
    end

    G = LightGraphs.SimpleGraph(adj) |> MetaGraph

    for (v, b) in zip(vertices(G), bits)
        set_prop!(G, v, :bits, b)
        set_prop!(G, v, :label, join(string.(Int.(b)), ""))
    end

    G
end


function eval_at_vertex(expr, G, v)
    Expressions.evalwith(expr, D=get_prop(G, v, :bits))
end


function evaluated_hypercube(expr)
    f = Expressions.compile_expression(expr)
    dim = Expressions.variables_used_upper_bound(expr)
    evaluated_hypercube(f, dim)
end


function evaluated_hypercube(f, dim::Integer)
    Q = hypercube(dim)
    for v in vertices(Q)
        set_prop!(Q, v, :value, f(get_prop(Q, v, :bits)))
    end
    Q
end


to_Z(b) = b ? 1 : -1


function ∇(Q, v)
    f(x) = get_prop(Q, x, :value) |> to_Z
    value = f(v)
    neighbourhood = f.(all_neighbors(Q, v))
    (((neighbourhood .- value) ./ 2.0) .^ 2) |> mean
end


function energized_hypercube(expr)
    Q = evaluated_hypercube(expr)
    for v in vertices(Q)
        energy = ∇(Q, v)
        set_prop!(Q, v, :energy, energy)
    end
    Q
end


function energize_hypercube!(Q)
    for v in vertices(Q)
        energy = ∇(Q, v)
        set_prop!(Q, v, :energy, energy)
    end
    Q
end


function dirichlet_energy(expr::Expr)
    Q = energized_hypercube(expr)
    [get_prop(Q, v, :energy) for v in vertices(Q)] |> mean
end


function dirichlet_energy(Q)
    [get_prop(Q, v, :energy) for v in vertices(Q)] |> mean
end



function plotcube(Q)
    color = colorsigned()
    graphplot(
        Q,
        names = [get_prop(Q, v, :label) for v in vertices(Q)],
        nodeshape = [get_prop(Q, v, :value) ? :circle : :rect
                     for v in vertices(Q)],
        nodecolor = [get_prop(Q, v, :energy) |> color
                     for v in vertices(Q)],
    )
end



end # module
