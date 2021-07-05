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

NONTERMINALS = [:& => 2, :| => 2, :~ => 1]


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
        g.program = compile_expression(g.chromosome)
    end
    g.program(data)
end


function FF.parsimony(g::Creature)
    d = depth(g.chromosome)
    iszero(d) ? 1.0 : 1.0 / d
end


end # end module Genotype
