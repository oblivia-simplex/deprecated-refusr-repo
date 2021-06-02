module TreeGenotype
using DataFrames
using StatsBase
using FunctionWrappers: FunctionWrapper
using Cockatrice

using ..FF
using ..Names
using ..StructuredTextTemplate
using ..Expressions



Base.@kwdef mutable struct Creature
    chromosome::Expr
    program = nothing
    fitness::Any
    generation::Any
    phenotype = nothing
    name::Any
    parents = nothing
    likeness = nothing
end


isterminal(e) = false

isterminal(b::Bool) = true

isterminal(e::Expr) = e.head === :ref


function generate_input_variables(num)
    [:(D[$i]) for i = 1:num]
end

function generate_terminals(num)
    input = generate_input_variables(num)
    terminals = [t => 0 for t in [input..., true, false]]
    return terminals
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

function compile_chromosome(expr::Expr)
    :(D -> $(expr)) |> safeeval |> FunctionWrapper{Bool,Tuple{Vector{Bool}}}
end


function Creature(config::NamedTuple)
    terminals = generate_terminals(config.genotype.inputs_n)
    chromosome = grow(config.genotype.max_depth, terminals = terminals)
    fitness = fill(-Inf, config.selection.d_fitness)
    name = Names.rand_name(4)
    Creature(
        chromosome = chromosome,
        phenotype = nothing,
        program = nothing,
        fitness = fitness,
        generation = 0,
        name = name,
    )
end

"The material implication operator."
(⊃)(a, b) = (!a) | b

NONTERMINALS = [:& => 2, :| => 2, :⊻ => 2, :! => 1]

ST_TRANS = [:& => "AND", :xor => "XOR", :| => "OR", :! => "NOT"] |> Dict


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
    inputsize = config.genotype.inputs_n
    st = expr |> structured_text_expr |> e -> StructuredTextTemplate.wrap(e, inputsize)
    if length(comment) > 0
        return "(*\n$(comment)\n*)\n\n$(st)"
    else
        return st
    end
end

function grow(depth, max_depth, terminals, nonterminals, bushiness)
    nodes = [terminals; nonterminals]
    if depth == max_depth
        return first(rand(terminals))
    end
    node, arity = depth > 0 && rand() > bushiness ? rand(nodes) : rand(nonterminals)
    if iszero(arity)
        return node
    end
    args = [grow(depth + 1, max_depth, terminals, nonterminals, bushiness) for _ = 1:arity]
    return Expr(:call, node, args...)
end


function grow(
    max_depth;
    terminals = [],
    nonterminals = NONTERMINALS,
    bushiness = 0.8,
)
    grow(0, max_depth, terminals, nonterminals, bushiness)
end

function evalwith(g, input)
    input = Bool.(input)
    eval(quote
        let D = $input
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

variables_used!(acc, literal::Bool) = nothing

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


function truth_table(expr; width = nothing, samplesize::Union{Symbol,Int} = :ALL)
    # Sampling without replacement fails when the sample ranges over integers larger
    # than 64 bits in width
    if isnothing(width)
        used = [a.args[2] for a in variables_used(expr)] |> maximum
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
        @assert !isterminal(e)
        e = e.args[i]
    end
    return e
end


function expr_set!(expr::Expr, val, indices...)
    if isempty(indices)
        return val
    end
    e = expr
    for i in indices[1:end-1]
        e = e.args[i]
        @assert e.head === :call
    end
    e.args[indices[end]] = val
    expr
end

# TODO: implement size-fair and/or homologous crossover
# a la Langdon
# TODO: how much of this can be done with immutables?
function crossover(a::Expr, b::Expr)
    child_a = deepcopy(a)
    child_b = deepcopy(b)
    key_a, sub_a = random_subexpr(child_a)
    key_b, sub_b = random_subexpr(child_b)
    child_a = expr_set!(child_a, sub_b, key_a...)
    child_a = expr_set!(child_b, sub_a, key_b...)
    [child_a, child_b]
end

function crossover(a::Creature, b::Creature; config = nothing)
    chromosomes = crossover(a.chromosome, b.chromosome)
    terminals = generate_terminals(config.genotype.inputs_n)
    for g in chromosomes
        prune!(g, config.genotype.max_depth, terminals)
    end
    generation = max(a.generation, b.generation) + 1
    name = Names.rand_name(4)
    fitness = fill(-Inf, length(a.fitness))
    child1 = Creature(
        chromosome = chromosomes[1],
        generation = generation,
        name = Names.rand_name(4),
        fitness = deepcopy(fitness),
    )
    child2 = Creature(
        chromosome = chromosomes[2],
        generation = generation,
        name = Names.rand_name(4),
        fitness = fitness,
    )
    [child1, child2]
end

function mutate(a::Expr; config=nothing)
    terminals = generate_terminals(config.genotype.inputs_n)
    crossover(a, grow(depth, terminals=terminals), config=config)
end


function mutate!(a::Expr; config=nothing)
    depth = 3
    terminals = generate_terminals(config.genotype.inputs_n)
    b = grow(depth, terminals = terminals)
    key, _ = random_subexpr(a)
    _, sub = random_subexpr(b)
    expr_set!(a, sub, key...)
    a
end


function mutate!(a::Creature; config = nothing)
    mutate!(a.chromosome, config=config)
    a
end


function FF.evaluate(g::Creature; data::Vector)
    if g.program === nothing
        g.program = compile_chromosome(g.chromosome)
    end
    g.program(data)
end


function FF.parsimony(g::Creature)
    d = depth(g.chromosome)
    iszero(d) ? 1.0 : 1.0 / d
end


end # end module Genotype
