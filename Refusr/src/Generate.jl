using SymbolicUtils
using SymbolicUtils.Code

include("StructuredTextTemplate.jl")

ARITY = 5 * 10

INPUT = [
    SymbolicUtils.Sym{Bool}(Symbol("IN$(i)"))
    for i in 1:ARITY
]


TERMINALS = [INPUT..., true, false]

NONTERMINALS = [
    (!, 1),
    (&, 2),
    (|, 2),
    (⊻, 3),
]

NODES = [
    NONTERMINALS...,
    [(()->t,0) for t in TERMINALS]...,
]

function grow(depth, max_depth)
    if depth == max_depth
        return rand(TERMINALS)
    else
        node, arity = rand(NONTERMINALS) #depth > 0 ? rand(NODES) : rand(NONTERMINALS)
        args = [grow(depth+1, max_depth) for _ in 1:arity]
        return node(args...)
    end
end


grow(max_depth) = grow(0, max_depth)

function st_op(f)
    if f == xor
        "XOR"
    elseif f == &
        "AND"
    elseif f == |
        "OR"
    elseif f == !
        "NOT"
    end
end


function structured_text_expr(expr::SymbolicUtils.Term)
    op = st_op(expr.f)
    if length(expr.arguments) == 2
        a, b = structured_text_expr.(expr.arguments)
        return "($(a) $(op) $(b))"
    else
        a = structured_text_expr(expr.arguments[1])
        return "($(op) $(a))"
    end
end


function structured_text_expr(terminal::Bool)
    repr(terminal) |> uppercase
end


function structured_text_expr(terminal::SymbolicUtils.Sym)
    for i in 1:length(INPUT)
        if terminal ≡ INPUT[i]
            return "Data[$i]"
        end
    end
    error("Bad symbol: $terminal")
end



function structured_text(expr)
    expr |> structured_text_expr |> StructuredTextTemplate.wrap
end


function evaluate_with_input(expr, input::Vector{Bool})
    @assert length(input) == length(INPUT)
    TERMINALS = [INPUT..., true, false]
    assignments = [I ← i for (I, i) in zip(INPUT, input)]
    Let(assignments, expr) |> toexpr |> eval
end

using DataFrames

function bits(n, num_bits)
    [(n & 1 << i != 0) for i in 0:(num_bits-1)]
end

function truth_table(expr)
    table = DataFrame([[repr(i) => 0 for i in INPUT]..., "OUT" => 0])
    for i in 0b00000:0b11111
        input = bits(i, length(INPUT))
        output = evaluate_with_input(expr, input)
        row = [input..., output]
        if i == 0
            table[1,:] = row
        else
            push!(table, row)
        end
    end
    table
end

