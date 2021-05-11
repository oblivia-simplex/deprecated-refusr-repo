module Genotype
using DataFrames

include("StructuredTextTemplate.jl")
include("Names.jl")


Base.@kwdef mutable struct Creature
    chromosome::Expr
    fitness
    generation
    name
end


INPUT = [:(Data[$i]) for i in 1:64]
TERMINALS = [t => 0 for t in [INPUT..., true, false]]


function generate_terminals(num)
    input = [:(Data[$i]) for i in 1:num]
    terminals = [t => 0 for t in [input..., true, false]]
    return terminals
end


function Chromosome(config::NamedTuple)
    terminals = generate_terminals(config.genotype.inputs_n)
    chromosome = grow(config.genotype.max_depth)
    fitness = fill(-Inf, config.selection.d_fitness)
    name = Names.rand_name(4)
    Creature(chromosome=chromosome, fitness=fitness, generation=0, name=name)
end

"The material implication operator."
(⊃)(a, b) = (!a) | b

NONTERMINALS = [
    :& => 2,
    :| => 2,
    :⊻ => 2,
    :! => 1,
]

ST_TRANS = [
    :& => "AND",
    :⊻ => "XOR",
    :| => "OR",
    :! => "NOT",
] |> Dict


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


function structured_text(expr; inputsize = length(INPUT), comment = "")
    st = expr |> structured_text_expr |>
        e -> StructuredTextTemplate.wrap(e, inputsize)
    if length(comment) > 0
        return "(*\n$(comment)\n*)\n\n$(st)"
    else
        return st
    end
end

function grow(
    depth,
    max_depth,
    terminals,
    nonterminals,
    bushiness,
)
    nodes = [terminals; nonterminals]
    if depth == max_depth
        return first(rand(terminals))
    end
    node, arity = depth > 0 && rand() > bushiness ? rand(nodes) : rand(nonterminals)
    if iszero(arity)
        return node
    end
    args = [
        grow(depth + 1,
             max_depth,
             terminals,
             nonterminals,
             bushiness)
        for _ in 1:arity
    ]
    return Expr(:call, node, args...)
end


function grow(
    max_depth;
    terminals = TERMINALS,
    nonterminals = NONTERMINALS,
    bushiness = 0.8,
)
    grow(0, max_depth, terminals, nonterminals, bushiness)
end

function evalwith(g, input)
    eval(quote
         let Data = $input
         return $g
         end
         end)
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

variables_used!(literal::Bool, acc) = nothing

function variables_used(expr)
    acc = []
    variables_used!(acc, expr)
    sort!(acc, by = s -> s.args[2])
    unique!(acc)
    acc
end

function bits(n, num_bits)
    n = UInt128(n)
    [(n & UInt128(1) << i != 0) for i = 0:(num_bits-1)]
end


function truth_table(expr; width = 6, samplesize::Union{Symbol,Int} = :ALL)
    width = UInt128(width)
    # Sampling without replacement fails when the sample ranges over integers larger
    # than 64 bits in width
    used = [a.args[2] for a in variables_used(expr)] |> maximum
    variables = INPUT[1:used]
    width = length(variables)
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
    @show sampling
    threadrows = []
    for i = 1:Threads.nthreads()
        push!(threadrows, [])
    end
    Threads.@threads for i in sampling
        values = bits(i, width)
        output = evalwith(expr, values)
        row = [values..., output]
        push!(threadrows[Threads.threadid()], row)
        binstr = [x ? '1' : '0' for x in row] |> String
        println(binstr)
    end
    rows = vcat(threadrows...)
    table = DataFrame([[string(i) => 0 for i in variables]..., "OUT" => 0])
    table[1, :] = rows[1]
    for row in rows[2:end]
        push!(table, row)
    end
    table
end


function expr_index(expr::Expr, indices...)
    e = expr.args[indices[1]]
    for i in indices[2:end]
        @assert e.head === :call
        e = e.args[i]
    end
    return e
end


function expr_set!(expr::Expr, val, indices...)
    e = expr.args[indices[1]]
    for i in indices[2:end-1]
        e = e.args[i]
        @assert e.head === :call
    end
    e.args[indices[end]] = val
    expr
end


function enumerate_expr!(table, path, expr::Expr; startat=2)
    for (i, a) in enumerate(expr.args[startat:end])
        p = [path... (i + startat - 1)]
        table[p] = a
        if a isa Expr && a.head === :call
            enumerate_expr!(table, p, a, startat=startat)
        end
    end
    table
end


function enumerate_expr(expr::Expr; startat=2)
    table = Dict()
    path = []
    enumerate_expr!(table, path, expr, startat=startat)
    table
end




# TODO: implement size-fair and/or homologous crossover
# a la Langdon
function crossover(a::Expr, b::Expr)
    child = deepcopy(a)
    table_a = enumerate_expr(a)
    table_b = enumerate_expr(b)
    key, _ = deepcopy(rand(table_a))
    _, sub = deepcopy(rand(table_b))
    expr_set!(a, sub, key...)
    child
end


function crossover(a::Creature, b::Creature; config=nothing)
    chromosome = crossover(a.chromosome, b.chromosome)
    generation = max(a.generation, b.generation) + 1
    name = Names.rand_name(4)
    fitness = fill(-Inf, length(a.fitness))
    Creature(chromosome=chromosome, generation=generation, name=name, fitness=fitness)
end

function mutate(a::Expr; depth=4)
    crossover(a, grow(depth))
end


function mutate!(a::Expr)
    table_a = enumerate_expr(a)
    depth = length.(keys(table_a)) |> maximum
    b = grow(depth)
    table_b = enumerate_expr(b)
    key, _ = rand(table_a)
    _, sub = rand(table_b)
    expr_set!(a, sub, key...)
    a
end


function mutate!(a::Creature)
    mutate!(a.chromosome)
    a
end


end # end module Genotype
