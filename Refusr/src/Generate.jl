using SymbolicUtils
# using SymbolicUtils.Code
using StatsBase
using DataFrames
using CSV

include("Names.jl")

include("StructuredTextTemplate.jl")

ARITY = 4

"The material implication operator."
(⊃)(a, b) = (!a) | b

INPUT = [SymbolicUtils.Sym{Bool}(Symbol("IN$(i)")) for i = 1:ARITY]

TERMINALS = [(() -> t, 0) for t in [INPUT..., true, false]]


function ensure_input_variables!(num::Number)
    global INPUT, TERMINALS
    while length(INPUT) < num
        push!(INPUT, SymbolicUtils.Sym{Bool}(Symbol("IN$(length(INPUT)+1)")))
    end
    TERMINALS = [(() -> t, 0) for t in [INPUT..., true, false]]
end

function ensure_input_variables!(vars::Vector)
    global INPUT, TERMINALS
    INPUT = INPUT ∪ vars
    TERMINALS = [(() -> t, 0) for t in [INPUT..., true, false]]
end



NONTERMINALS = [(!, 1), (&, 2), (|, 2), (⊻, 3)]

## Rewrite rules

## Definition of XOR
R_XOR_DEF = @acrule ~ϕ ⊻ ~ψ => (~ϕ & ! ~ ψ) | (!~ϕ & ~ψ)
R_XOR_DEFr = @acrule (~ϕ & ! ~ ψ) | (!~ϕ & ~ψ) => ~ϕ ⊻ ~ψ
R_XOR1 = @acrule ~ϕ ⊻ ~ϕ => false
R_XOR2 = @acrule ~ϕ ⊻ true => !~ϕ
R_XOR3 = @acrule ~ϕ ⊻ false => ~ϕ

## Idempotence
R_IDEM_AND = @acrule ~ϕ & ~ϕ => ~ϕ
R_IDEM_OR = @acrule ~ϕ | ~ϕ => ~ϕ

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
R_DIST = @acrule ~ϕ | (~ψ & ~ρ) => (~ϕ & ~ψ) | (~ϕ & ~ρ)
R_DISTr = @acrule (~ϕ & ~ψ) | (~ϕ & ~ρ) => ~ϕ | (~ψ & ~ρ)

# De Morgan's
R_DeMORGAN1 = @acrule !(~ϕ & ~ψ) => (!~ϕ) | (!~ψ)
R_DeMORGAN2 = @acrule !(~ϕ | ~ψ) => (!~ϕ) & (!~ψ)


RULES =
    SymbolicUtils.Rewriters.RestartedChain([
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




function grow(
    depth,
    max_depth,
    terminals = TERMINALS,
    nonterminals = NONTERMINALS,
    bushiness = 0.5,
)
    nodes = vcat(terminals, nonterminals)
    if depth == max_depth
        return first(rand(terminals))()
    else
        (node, arity) = (depth > 0 && rand() > bushiness) ? rand(nodes) : rand(nonterminals)
        args =
            [grow(depth + 1, max_depth, terminals, nonterminals, bushiness) for _ = 1:arity]
        return node(args...)
    end
end


function grow(
    max_depth;
    terminals = TERMINALS,
    nonterminals = NONTERMINALS,
    bushiness = 0.8,
)
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
    for i = 1:length(INPUT)
        if terminal ≡ INPUT[i]
            return "Data[$i]"
        end
    end
    error("Bad symbol: $terminal")
end



function structured_text(expr; inputsize = length(INPUT), comment = "")
    variables_used(expr) |> ensure_input_variables!
    st = expr |> structured_text_expr |> e -> StructuredTextTemplate.wrap(e, inputsize)
    if length(comment) > 0
        return "(*\n$(comment)\n*)\n\n$(st)"
    else
        return st
    end
end


function evaluate_with_input(expr; variables = INPUT, values::Vector{Bool})
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


function bits(n, num_bits)
    n = UInt128(n)
    [(n & UInt128(1) << i != 0) for i = 0:(num_bits-1)]
end


bits(n) = bits(n, log(2, n) |> ceil |> Int)


function truth_table(expr; width = 6, samplesize::Union{Symbol,Int} = :ALL)
    width = UInt128(width)
    # Sampling without replacement fails when the sample ranges over integers larger
    # than 64 bits in width
    @show use_replacement = (width > 60)
    @show width
    variables = INPUT[1:width]
    @show range = UInt128(0):(UInt128(2)^width-1)
    if samplesize === :ALL || samplesize == 1.0
        samplesize = length(range) |> Int128
        sampling = range
    else
        if samplesize isa Float64 && samplesize < 1.0
            samplesize = (samplesize * length(range)) |> UInt128
        end
        sampling = sample(range, samplesize, replace = use_replacement) |> sort
    end
    @show sampling
    threadrows = []
    for i = 1:Threads.nthreads()
        push!(threadrows, [])
    end
    Threads.@threads for i in sampling
        values = bits(i, width)
        output = evaluate_with_input(expr, variables = variables, values = values)
        row = [values..., output]
        push!(threadrows[Threads.threadid()], row)
        binstr = [x ? '1' : '0' for x in row] |> String
        println(binstr)
    end
    rows = vcat(threadrows...)
    table = DataFrame([[repr(i) => 0 for i in variables]..., "OUT" => 0])
    table[1, :] = rows[1]
    for row in rows[2:end]
        push!(table, row)
    end
    table
end


function check_for_juntas(table; expr = nothing)
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


function test_junta_checker(w = 10)
    @show e = grow(5, num_var = w)
    @show table = truth_table(e, width = w)
    check_for_juntas(table, expr = e)
    println(e)
end


###
# Designing some canonical boolean functions
##

function mux(ctrl_bits; vars = nothing, shuffle = true)
    num_inputs = 2^ctrl_bits
    needed = num_inputs + ctrl_bits
    ensure_input_variables!(needed)
    vars = isnothing(vars) ? INPUT[1:needed] : vars
    @assert length(vars) ≥ needed "At least $(needed) vars are needed"
    wires = shuffle ? sort(vars, by = _ -> rand()) : vars
    controls = wires[1:ctrl_bits]
    input = wires[(ctrl_bits+1):end]
    m = foldl(&, map(0:(num_inputs-1)) do i
        switches = bits(i, ctrl_bits)
        antecedent = foldl(&, map(zip(switches, controls)) do (s, c)
            s == 0 ? !c : c
        end)
        consequent = input[i+1]
        antecedent ⊃ consequent
    end)
    return m, controls, input
end


function generate_mux_code_and_sample(ctrl_bits; dir = ".", samplesize = 10000)
    name = "$(ctrl_bits)-MUX_" * Names.rand_name(3)

    m, c, i = mux(ctrl_bits, shuffle = true)
    dataname(s) = "Data[$(String(s.name)[2:end])]"
    comment = """This code implements a shuffled multiplexer with $(ctrl_bits) control bits.
    The control bits are: $(join(dataname.(c), ", "))
    The input bits are: $(join(dataname.(i), ", "))

    The symbolic expression is:\n$(m)
    """

    tablewidth = UInt128(2)^ctrl_bits + ctrl_bits

    return generate_files(
        m,
        name = name,
        tablewidth = tablewidth,
        comment = comment,
        dir = dir,
        samplesize = samplesize,
    )
end


function generate_random_code_and_sample(
    depth;
    dir = ".",
    num_vars = 50,
    samplesize = 10000,
)
    ensure_input_variables!(num_vars)
    sexp = grow(depth, bushiness = 0.8)

    comment = """This code implements a randomly grown symbolic expression:\n\n$(sexp)\n"""

    return generate_files(
        sexp,
        tablewidth = num_vars,
        comment = comment,
        dir = dir,
        samplesize = samplesize,
    )
end


function generate_files(
    sexp;
    name = nothing,
    tablewidth = 50,
    comment = "",
    dir = ".",
    samplesize = 10000,
)

    if isnothing(name)
        name = "RND-EXPR_" * Names.rand_name(3)
    end

    st = structured_text(sexp, comment = comment, inputsize = tablewidth)

    println(st)

    table = truth_table(sexp, samplesize = samplesize, width = tablewidth)

    csv_path = "$(dir)/$(name)_$(samplesize).csv"
    st_path = "$(dir)/$(name).st"
    sexp_path = "$(dir)/$(name).sexp"

    println("[+] Saving symbolic expression to $sexp_path")
    write(sexp_path, repr(sexp))
    println("[+] Saving CSV to $csv_path")
    CSV.write(csv_path, table)
    println("[+] Saving ST code to $st_path")
    write(st_path, st)

    return sexp, table, st
end
