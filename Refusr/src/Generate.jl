using SymbolicUtils
using SymbolicUtils.Code

include("StructuredTextTemplate.jl")

ARITY = 1024

"The material implication operator."
(⊃)(a, b) = (!a) | b

INPUT = [
    SymbolicUtils.Sym{Bool}(Symbol("IN$(i)"))
    for i in 1:ARITY
]

TERMINALS = [(()->t, 0) for t in [INPUT..., true, false]]

NONTERMINALS = [
    (!, 1),
    (&, 2),
    (|, 2),
    (⊻, 3),
]

## Rewrite rules

## Definition of XOR
R_XOR_DEF = @acrule ~ϕ ⊻ ~ψ => (~ϕ & !~ψ) | (!~ϕ & ~ψ)
R_XOR_DEFr = @acrule (~ϕ & !~ψ) | (!~ϕ & ~ψ) => ~ϕ ⊻ ~ψ
R_XOR1 = @acrule ~ϕ ⊻ ~ϕ => false
R_XOR2 = @acrule ~ϕ ⊻ true => !~ϕ
R_XOR3 = @acrule ~ϕ ⊻ false => ~ϕ

## Idempotence
R_IDEM_AND = @acrule ~ϕ & ~ϕ => ~ϕ
R_IDEM_OR  = @acrule ~ϕ | ~ϕ => ~ϕ

# Double negation
R_DN = @rule !(!~ϕ) => ~ϕ

# Negation
R_NEG_AND = @acrule ~ϕ & (!~ϕ) => false
R_NEG_OR = @acrule ~ϕ | (!~ϕ) => true
R_ABSORB_AND = @acrule ~ϕ & false => false
R_ABSORB_OR = @acrule ~ϕ | true => true
R_IDENT_AND = @acrule ~ϕ & true => ~ϕ
R_IDENT_OR = @acrule ~ϕ | false => ~ϕ
R_NEG_TRUE = @rule !true => false
R_NEG_FALSE = @rule !false => true

# Distribution
R_DIST  = @acrule ~ϕ | (~ψ & ~ρ) => (~ϕ & ~ψ) | (~ϕ & ~ρ)
R_DISTr = @acrule (~ϕ & ~ψ) | (~ϕ & ~ρ) => ~ϕ | (~ψ & ~ρ)

# De Morgan's
R_DeMORGAN1 = @acrule !(~ϕ & ~ψ) => (!~ϕ) | (!~ψ)
R_DeMORGAN2 = @acrule !(~ϕ | ~ψ) => (!~ϕ) & (!~ψ)


RULES = SymbolicUtils.Rewriters.RestartedChain([
    R_XOR_DEF,
    R_XOR_DEFr,
    R_XOR1,
    R_XOR2,
    R_XOR3,
    R_IDEM_AND,
    R_DN,
    R_NEG_AND,
    R_NEG_OR,
    R_ABSORB_AND,
    R_ABSORB_OR,
    R_IDENT_AND,
    R_IDENT_OR,
    R_NEG_TRUE,
    R_NEG_FALSE,
    R_DIST,
    R_DISTr,
    R_DeMORGAN1,
    R_DeMORGAN2,
]) |> Rewriters.Postwalk




function grow(depth, max_depth, terminals=TERMINALS, nonterminals=NONTERMINALS, bushiness=0.5)
    nodes = vcat(terminals, nonterminals)
    if depth == max_depth
        return first(rand(terminals))()
    else
        (node, arity) = (depth > 0 && rand() > bushiness) ? rand(nodes) : rand(nonterminals)
        args = [grow(depth+1, max_depth, terminals, nonterminals, bushiness) for _ in 1:arity]
        return node(args...)
    end
end


function grow(max_depth; terminals=TERMINALS, nonterminals=NONTERMINALS, bushiness=0.5)
    grow(0, max_depth, terminals, nonterminals, bushiness)
end


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

bits(n) = bits(n, log(2, n) |> ceil |> Int)

function truth_table(expr; width=6)
    variables = INPUT[1:width]
    table = DataFrame([[repr(i) => 0 for i in variables]..., "OUT" => 0])
    rows = [[] for _ in 1:(2^width)]
    Threads.@threads for i in 0:(2^width - 1)
        values = bits(i, width)
        output = evaluate_with_input(expr, variables=variables, values=values)
        row = [values..., output]
        rows[i+1] = row
    end
    table[1,:] = rows[1]
    for row in rows[2:end]
        push!(table, row)
    end
    table
end

function check_for_juntas(table; expr=nothing)
    #expr = simplify(expr, rewriter = RULES, threaded=true)
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
        names = [String(x.name) for x in relevant]
        names = join(names, ", ")
        println("[+] Relevant variables: $names")
    end
    return irrelevant
end


function test_junta_checker(w=10)
    @show e = grow(5, num_var=w)
    @show table = truth_table(e, width=w)
    check_for_juntas(table, expr=e)
    println(e)
end


###
# Designing some canonical boolean functions
##

function mux(ctrl_bits; vars=nothing, shuffle=true)
    num_inputs = 2^ctrl_bits
    if vars === nothing
        vars = INPUT[1:num_inputs + ctrl_bits]
    end
    num_inputs + ctrl_bits <= length(vars)
    wires = shuffle ? sort(vars, by = _ -> rand()) : vars
    @show controls = wires[1:ctrl_bits]
    @show input = wires[(ctrl_bits+1):(ctrl_bits+num_inputs)]
    # the trick to this is normal form
    m = foldl(&, map(0:(num_inputs-1)) do i
          bs = bits(i, ctrl_bits)
          antecedent = foldl(&, map(zip(bs, controls)) do (b, ctrl)
                             b == 0 ? !ctrl : ctrl
                             end)
          consequent = input[i+1]
          antecedent ⊃ consequent
          end)
    return m, controls, input
end


