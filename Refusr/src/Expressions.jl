# Functions for manipulating expressions
module Expressions

using PyCall
using Dates
using Graphs
using Memoize
using LRUCache
using TikzPictures
using TreeView
using DataFrames
using StatsBase
using FunctionWrappers: FunctionWrapper
using Espresso # Espresso actually implements some of the features
# we already have here, but I think my implementation is faster.
# It does seem much better for simplification, though. 

export replace!, replace, count_subexpressions, enumerate_expr, truth_table, compile_expression, nand, ⊃


sympy = pyimport("sympy")

function __init__()
    copy!(sympy, pyimport("sympy"))
end


nand(a,b) = ~(a & b)

(⊃)(a, b) = (~a) | b

function Base.replace!(e::Expr, p::Pair; all=true)
    old, new = p
    oldpred = old isa Function ? old : x -> typeof(x) == typeof(old) && x == old
    mknew = new isa Function ? new : _ -> deepcopy(new)
    if oldpred(e)
        return mknew(e)
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

function replace_atom(e, p::Pair; all=true)
    old, new = p
    oldpred = old isa Function ? old : x -> typeof(x) == typeof(old) && x == old
    mknew = new isa Function ? new : _ -> deepcopy(new)
    if oldpred(e)
        return mknew(e)
    else
        return e
    end
end


Base.replace(s::Symbol, p::Pair; all=true) = replace_atom(s, p, all=all)
Base.replace(s::Bool, p::Pair; all=true) = replace_atom(s, p, all=all)




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


@simple_rule identity(x)      x
@simple_rule ~~x              x
@simple_rule (false & x)      false
@simple_rule (x & false)      false
@simple_rule (true | x)       true
@simple_rule (x | true)       true
@simple_rule (false | x)      x
@simple_rule (x | false)      x
@simple_rule (true & x)       x
@simple_rule (x & true)       x
@simple_rule ~(x & y)         (~x | ~y)
@simple_rule ~(x | y)         (~x & ~y)
@simple_rule (x | x)          x
@simple_rule (x & x)          x
@simple_rule (x ⊻ x)          false
@simple_rule ((x ⊻ y) ⊻ x)    y



_simplify(e) = Espresso.simplify(e)

function symbols(v::Vector{String})
    if isempty(v)
        PyObject[]
    elseif length(v) == 1
        [sympy.symbols(v[1])]
    else
        sympy.symbols(join(v, " ")) |> collect
    end
end

function demangle(s::Symbol)
    if s == :True
        return true
    elseif s == :False
        return false
    end
    st = string(s)
    if st[1] ∈ "RD"
        letter = Symbol(st[1])
        number = parse(Int, st[2:end])
        :($(letter)[$(number)])
    else
        s
    end
end


function mangle(e)
    Symbol("$(e.args[1])$(e.args[2])")
end


function mangle_expr(e)
    replace(e, (x -> x isa Expr && x.head === :ref) => mangle)
end

demangle_helper(s::Symbol) = demangle(s)
demangle_helper(s::Expr) = replace(s, (x -> x isa Symbol) => demangle)
demangle_helper(s) = s

simplify(b::Bool) = b
simplify(s::Symbol) = s

Cache() = LRU{Expr, Union{Bool, Expr, Symbol}}(maxsize=2^30, by=Base.summarysize)

USE_CACHE = true

function _use_cache(b::Bool)
    global USE_CACHE
    USE_CACHE = b
end


 

const __simplify = let CACHE = Cache(),
    hits = 0,
    queries = 0,
    cache_time = 0
function simplify_(e::Expr)::Union{Bool, Expr, Symbol}

    function check_cache(e)
        if USE_CACHE
            start_at = now()
            queries > 0 && @debug "Cache stats" hits queries (hits / queries) CACHE.currentsize (CACHE.currentsize / CACHE.maxsize) ((1000 * cache_time / queries) |> ceil |> Nanosecond)
            try
                result = CACHE[e]
                hits += 1
                cache_time += (now() - start_at).value
                return result
            catch KeyError
                queries += 1
                cache_time += (now() - start_at).value
                return nothing
            end
        end
    end

    function cache(e, result)
        if USE_CACHE
            start_at = now()
            CACHE[e] = result
            cache_time += (now() - start_at).value
        end
    end

    res = check_cache(e)
    !isnothing(res) && return res


    Rn = variables_used_upper_bound(e, :R)
    Dn = variables_used_upper_bound(e, :D)
    
    str(v) = "$(v.args[1])$(v.args[2])"
    D = ["D$(i)" for i in 1:Dn] |> symbols
    R = ["R$(i)" for i in 1:Rn] |> symbols
    x = evalwith(e, D=D, R=R)
    p = sympy.simplify(x)
    s = Meta.parse(p.__repr__())
    simple = demangle_helper(s)
    if simple isa Expr
        replace!(simple, :^ => :⊻)
    end
    @debug "Simplified\n$(e)\nwith $(count_subexpressions(e)) subexpressions, to:\n$(simple)\nwith $(count_subexpressions(simple))..."
    cache(e, simple)

    return simple
end
end # end closure

simplify(e::Expr) = __simplify(e)


flush_cache!() = empty!(__simplify.CACHE)


function evalwith(g; D, R=[])
    eval(quote
         let D = $D
         let R = $R
         return $g
         end
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

@inline function variables_used(expr)
#    acc = []
#    variables_used!(acc, expr)
#    sort!(acc, by = s -> s.args[2])
#    unique!(acc)
#    acc
    Espresso.find_vars(expr)
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


function variables_used_upper_bound(expr, letter=:D)
    v = [a.args[2] for a in variables_used(expr) if a.args[1] == letter]
    isempty(v) ? 0 : maximum(v)
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
        inputsize = config.genotype.data_n
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

subscript(ref::Expr) = "$(ref.args[1])_{$(ref.args[2])}"

function save_diagram(e::Expr, path; tree=true)
    s = replace(e, (x -> x isa Expr && x.head == :ref) => (x -> Symbol(string(x))))
    if s isa Expr && s.head == :call
        Expressions.replace!(s, :~ => :NOT)
        Expressions.replace!(s, :& => :AND)
        Expressions.replace!(s, :| => :OR)
    end
    graph = tree ? TreeView.walk_tree(s) : TreeView.make_dag(s)
    tikz = TreeView.tikz_representation(graph)
    if endswith(path, "svg")
        save(SVG(path), tikz)
    elseif endswith(path, "png")
        svg_path = replace(path, "png" => "svg")
        save(SVG(svg_path), tikz)
        run(`inkscape --export-png=$(path) $(svg_path)`)
    elseif endswith(path, "tex")
        save(TEX(path), tikz)
    elseif endswith(path, "pdf")
        save(PDF(path), tikz)
    end
    return path
end


function diagram(e::Expr; tree=true, format=:svg)
    tmp = read(`mktemp /tmp/XXXXX.$(format)`, String) |> strip
    Base.rm(tmp) # to suppress warnings
    save_diagram(e, tmp, tree=tree)
    dia = read(tmp, String)
    Base.rm(tmp)
    return dia
end


function diagram(sym::Symbol; tree=true, format=:svg)
    diagram(Expr(sym), tree=tree, format=format)
end


function diagram(val; tree=true, format=:svg)
    diagram(Expr(Symbol(val)), tree=tree, format=format)
end


function to_constraints(e::Expr, model)
    @assert e.head == :(=) "This method expects assignment expressions."
    # TODO might be a fun exercise to translate assignment instructions
    # to order-theoretic JuMP constraints. But not the thing i need to do now.
end

function expression_graph(e::Expr)

end

end # module Expressions
