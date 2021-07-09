# Functions for manipulating expressions
module Expressions

using DataFrames
using StatsBase
using FunctionWrappers: FunctionWrapper
using Espresso # Espresso actually implements some of the features
# we already have here, but I think my implementation is faster.
# It does seem much better for simplification, though. 

export replace!, replace, count_subexpressions, enumerate_expr, truth_table, compile_expression


function Base.replace!(e::Expr, p::Pair; all=true)
    old, new = p
    oldpred = old isa Function ? old : x -> typeof(x) == typeof(old) && x == old
    mknew = new isa Function ? new : _ -> deepcopy(new)
    if oldpred(e)
        oldpred(e)
        return mknew(deepcopy(e))
    end
    for i in eachindex(e.args)
        if oldpred(e.args[i])
            e.args[i], oldpred(e.args[i])
            e.args[i] = mknew(e.args[i])
            all || return e
        elseif e.args[i] isa Expr
            Base.replace!(e.args[i], oldpred=>mknew, all=all)
        end
    end
    return e
end


function Base.replace(e::Expr, p::Pair; all=true)
    Base.replace!(deepcopy(e), p, all=all)
end


count_subexpressions(x) = 0

function count_subexpressions(e::Expr)
    1 + mapreduce(count_subexpressions, +, e.args)
end


depth(x) = 0

function depth(e::Expr)
    1 + mapreduce(depth, max, e.args)
end



function enumerate_expr!(table, path, expr::Expr; startat = 2)
    if !isterminal(expr)
        for (i, a) in enumerate(expr.args[startat:end])
            if !isterminal(a)
                p = [path..., (i + startat - 1)]
                table[p] = a
                enumerate_expr!(table, p, a, startat = startat)
            end
        end
    end
    table
end


function enumerate_expr(expr::Expr; startat = 2)
    table = Dict()
    path = []
    table[[]] = expr
    enumerate_expr!(table, path, expr, startat = startat)
    table
end

function validate_path!(path::Vector, table::Dict)
    if length(path) > 0 && isterminal(table[path])
        pop!(path)
        validate_path!(path, table)
    else
        path
    end
end


function random_subexpr(e::Expr; maxdepth=8)
    table = filter(x -> length(x) <= maxdepth, enumerate_expr(e))
    if isempty(table)
        return [], e
    end
    path = validate_path!(rand(keys(table)), table)
    if isempty(path)
        [], e
    end
    path, table[path]
end


function prune!(e::Expr, depth, terminals)
    isterminal(e) && return
    if depth <= 1
        for i in 2:length(e.args)
            if e.args[i] isa Expr
                e.args[i] = rand(terminals).first
            end
        end
    else
        for arg in e.args[2:end]
            prune!(arg, depth-1, terminals)
        end
    end
end


prune!(e, depth, terminals) = nothing




# Rewriting rules


@simple_rule ~~x              x
@simple_rule (false & x)      false
@simple_rule (true | x)       true
@simple_rule (false | x)      x
@simple_rule (true & x)       x
@simple_rule ~(x & y)         (~x | ~y)
@simple_rule ~(x | y)         (~x & ~y)
@simple_rule (x | x)          x
@simple_rule (x & x)          x



simplify(e) = Espresso.simplify(e)

function evalwith(g, input)
    input = Bool.(input)
    eval(quote
         let D = $input
         return $g
         end
         end)
end



function generate_input_variables(num)
    [:(D[$i]) for i = 1:num]
end

function generate_terminals(num)
    input = generate_input_variables(num)
    terminals = [t => 0 for t in [input..., true, false]]
    return terminals
end


function bits(n, num_bits)
    n = UInt128(n)
    [(n & UInt128(1) << i != 0) for i = 0:(num_bits-1)]
end



function variables_used!(acc, expr::Expr)
    if expr.head === :ref
        push!(acc, expr)
    else
        for x in expr.args[2:end]
            variables_used!(acc, x)
        end
    end
end

variables_used!(acc, literal::Bool) = nothing

function variables_used(expr)
    acc = []
    variables_used!(acc, expr)
    sort!(acc, by = s -> s.args[2])
    unique!(acc)
    acc
end


function safeeval(e)
    try
        eval(e)
    catch exception
        @error exception
        println("The expression was: $(e)")
        false
    end
end

function compile_expression(expr::Expr)
    :(D -> $(expr)) |> eval |> FunctionWrapper{Bool,Tuple{Vector{Bool}}}
end


function variables_used_upper_bound(expr)
    [a.args[2] for a in variables_used(expr)] |> maximum
end


function truth_table(expr; width = nothing, samplesize::Union{Symbol,Int} = :ALL)
    # Sampling without replacement fails when the sample ranges over integers larger
    # than 64 bits in width
    program = compile_expression(expr)
    if isnothing(width)
        used = variables_used_upper_bound(expr)
        variables = generate_input_variables(used)
        width = length(variables)
    else
        variables = generate_input_variables(width)
    end
    width = UInt128(width)
    use_replacement = (width > 60)
    range = UInt128(0):(UInt128(2)^width-1)
    if samplesize === :ALL || samplesize == 1.0
        samplesize = length(range) |> Int128
        sampling = range
    else
        if samplesize isa Float64 && samplesize < 1.0
            samplesize = (samplesize * length(range)) |> UInt128
        end
        sampling = sample(range, samplesize, replace = use_replacement) |> sort
    end
    threadrows = []
    for i = 1:Threads.nthreads()
        push!(threadrows, [])
    end
    Threads.@threads for i in sampling
        values = bits(i, width)
        output = program(values)
        row = [values..., output]
        push!(threadrows[Threads.threadid()], row)
        binstr = [x ? '1' : '0' for x in row] |> String
    end
    rows = vcat(threadrows...)
    table = DataFrame([[string(i) => 0 for i in variables]..., "OUT" => 0])
    table[1, :] = rows[1]
    for row in rows[2:end]
        push!(table, row)
    end
    table
end


module MUX


using ..Expressions: bits


function mux(ctrl_bits; vars = nothing, shuffle = true)
    num_inputs = 2^ctrl_bits
    needed = num_inputs + ctrl_bits
    vars = isnothing(vars) ? [:(D[$i]) for i in 1:needed] : vars
    @assert length(vars) ≥ needed "At least $(needed) vars are needed"
    wires = shuffle ? sort(vars, by = _ -> rand()) : vars
    controls = wires[1:ctrl_bits]
    input = wires[(ctrl_bits+1):end]
    m = foldl(
        (a, b) -> :($a & $b),
        map(0:(num_inputs-1)) do i
        switches = bits(i, ctrl_bits)
        antecedent = foldl((a, b) -> :($a & $b), map(zip(switches, controls)) do (s, c)
                           s == 0 ? :(~ $c) : c
                           end)
        consequent = input[i+1]
        :(~($antecedent) | $consequent) # Material Conditional
        end,
    )
    return m, controls, input
end



end

module ST

using CSV
using ..Expressions: variables_used_upper_bound, MUX, truth_table
include("StructuredTextTemplate.jl")
include("Names.jl")

ST_TRANS = [:& => "AND", :| => "OR", :~ => "NOT"] |> Dict


function structured_text_expr(expr::Expr)
    if expr.head === :ref
        return string(expr)
    elseif expr.head === :call
        op = ST_TRANS[expr.args[1]]
        args = expr.args[2:end]
        if length(args) == 2
            a, b = structured_text_expr.(args)
            return "($(a) $(op) $(b))"
        else
            a = structured_text_expr(args[1])
            return "($(op) $(a))"
        end
    end
end


function structured_text_expr(terminal::Bool)
    repr(terminal) |> uppercase
end


function structured_text(expr; config=nothing, comment = "")
    if isnothing(config)
        inputsize = variables_used_upper_bound(expr)
    else
        inputsize = config.genotype.inputs_n
    end
    st = expr |> structured_text_expr |> e -> StructuredTextTemplate.wrap(e, inputsize)
    if length(comment) > 0
        return "(*\n$(comment)\n*)\n\n$(st)"
    else
        return st
    end
end



function generate_files(
    sexp;
    name = nothing,
    comment = "",
    dir = ".",
    samplesize = 10000,
)

    if isnothing(name)
        name = "RND-EXPR_" * Names.rand_name(3)
    end

    st = structured_text(sexp, comment = comment)

    println(st)

    table = truth_table(sexp, samplesize = samplesize)

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



function generate_mux_code_and_sample(ctrl_bits; dir = ".", samplesize = 10000)
    name = "$(ctrl_bits)-MUX_" * Names.rand_name(3)

    @show m, c, i = MUX.mux(ctrl_bits, shuffle = true)
    dataname(s) = "Data[$(s.args[2])]"
    comment = """This code implements a shuffled multiplexer with $(ctrl_bits) control bits.
    The control bits are: $(join(dataname.(c), ", "))
    The input bits are: $(join(dataname.(i), ", "))

    The symbolic expression is:\n$(m)
    """

    return generate_files(
        m,
        name = name,
        comment = comment,
        dir = dir,
        samplesize = samplesize,
    )
end




end


end # module Expressions
