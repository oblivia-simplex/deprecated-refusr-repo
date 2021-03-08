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

function nodelist(terminals=TERMINALS)
    vcat(
        NONTERMINALS,
        [(()->t, 0) for t in terminals]
    )
end

function grow(depth, max_depth; num_var=length(INPUT))
    terminals = [INPUT[1:num_var]..., true, false]
    nodes = nodelist(terminals)
    if depth == max_depth
        return rand(terminals)
    else
        (node, arity) = (depth > 0 && rand() > 0.5) ? rand(nodes) : rand(NONTERMINALS)
        args = [grow(depth+1, max_depth, num_var=num_var) for _ in 1:arity]
        return node(args...)
    end
end


grow(max_depth; num_var=length(INPUT)) = grow(0, max_depth, num_var=num_var)

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


function evaluate_with_input(expr; variables=INPUT, values::Vector{Bool})
    @assert length(variables) == length(values)
    assignments = [I ← i for (I, i) in zip(variables, values)]
    Let(assignments, expr) |> toexpr |> eval
end


function variables_used!(terminal::Bool, acc)
    return
end

function variables_used!(terminal::SymbolicUtils.Sym, acc)
    push!(acc, terminal)
    return
end

function variables_used!(expr::SymbolicUtils.Term, acc)
    for x in expr.arguments
        variables_used!(x, acc)
    end
    return
end

function variables_used(expr)
    acc = []
    variables_used!(expr, acc)
    sort!(acc, by = s -> parse(Int, String(s.name)[3:end]))
    unique!(acc)
    return acc
end


using DataFrames

function bits(n, num_bits)
    [(n & 1 << i != 0) for i in 0:(num_bits-1)]
end

function truth_table(expr; width=6)
    variables = INPUT[1:width]
    table = DataFrame([[repr(i) => 0 for i in variables]..., "OUT" => 0])
    for i in 0:(2^width - 1)
        values = bits(i, width)
        output = evaluate_with_input(expr, variables=variables, values=values)
        row = [values..., output]
        if i == 0
            table[1,:] = row
        else
            push!(table, row)
        end
    end
    table
end

function check_for_juntas(table; expr=nothing)
    (_, ncols) = size(table)
    nvars = ncols - 1
    variables = INPUT[1:nvars]
    used = expr === nothing ? variables : variables_used(expr)
    used = [v.name for v in used]
    if Bool.(table.OUT) |> all
        println("[*] This function is a tautology!")
        return variables
    elseif Bool.(table.OUT) |> any |> !
        println("[x] This function is an absurdity!")
        return variables
    end
    irrelevant = []
    for var in variables
        if !(var.name in used)
            println("[-] $(var.name) does not occur")
            push!(irrelevant, var.name)
            continue
        end
        col = var.name
        T = select(filter(r -> r[col] == true, table), Not(col))
        F = select(filter(r -> r[col] == false, table), Not(col))
        if T == F
            println("[-] $col is irrelevant")
            push!(irrelevant, col)
        end
    end
    relevant = [v for v in variables if !(v.name in irrelevant)]
    if !isempty(irrelevant)
        n = length(variables) - length(irrelevant)
        println("[+] This function is a $(n)-junta.")
        println("[+] Relevant variables: $(relevant)")
    end
    return relevant
end


function test_junta_checker()
    w = 10
    @show e = grow(5, num_var=w)
    @show table = truth_table(e, width=w)
    check_for_juntas(table, expr=e)
    println(e)
end



