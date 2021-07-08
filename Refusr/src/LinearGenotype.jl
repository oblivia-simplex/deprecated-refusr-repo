module LinearGenotype

using Printf
import JSON
import Base.isequal

using ..FF
using ..Names
using ..StructuredTextTemplate
using ..Cockatrice.Evo
using ..Expressions


NUM_REGS = 8
function _set_NUM_REGS(n)
    global NUM_REGS
    NUM_REGS = n
end

RegType = Bool

struct Inst
    op::Function
    arity::Int
    # let's use the convention that negative indices refer to input
    dst::Int
    src::Int
end


Base.isequal(a::Inst, b::Inst) = (a.op == b.op
                                  && a.arity == b.arity
                                  && a.dst == b.dst
                                  && a.src == b.src)


function Inst(d::Dict)
    op = d["op"] isa Number ? constant(d["op"]) : eval(Symbol(d["op"]))
    Inst(op, d["arity"], d["dst"], d["src"])
end




function serialize_op(inst::Inst)
    if inst.arity == 0
        inst.op()
    else
        nameof(inst.op)
    end
end

function JSON.lower(inst::Inst)
    (op = serialize_op(inst),
     arity = inst.arity,
     dst = inst.dst,
     src = inst.src)
end





function to_expr(inst::Inst)
    op = nameof(inst.op)
    dst = :(R[$(inst.dst)])
    src_t = inst.src < 0 ? :D : :R
    src_i = abs(inst.src)
    src = :($(src_t)[$(src_i)])
    if inst.arity == 2
        :($dst = $op($dst, $src))
    elseif inst.arity == 1
        :($dst = $op($src))
    else # inst.arity == 0
        :($dst = $(inst.op()))
    end
end

DEFAULT_EXPR = :(R[1] = false)

function to_expr(code::Vector{Inst})
    code = strip_introns(code, [1])
    isempty(code) && return DEFAULT_EXPR
    expr = pop!(code) |> to_expr
    @assert expr.head == :(=)
    LHS, RHS = expr.args
    while !isempty(code)
        e = pop!(code) |> to_expr
        @assert e.head == :(=)
        lhs, rhs = e.args
        Expressions.replace!(RHS, lhs=>rhs)
    end
    expr
end
        

Base.@kwdef mutable struct Creature
    chromosome::Vector{Inst}
    effective_code::Union{Nothing, Vector{Inst}}
    phenotype
    fitness::Vector{Float64}
    name::String
    generation::Int
    num_offspring::Int = 0
    parents = nothing
    likeness = nothing
    performance = nothing
end


function summarize(g::Creature)
    symbolic_str = to_expr(g.chromosome) |> string
    chrom_str = join(map(string, g.chromosome), "\n")
    effec_str = isnothing(g.effective_code) ? "" : join(map(string, g.effective_code), "\n")

    pheno_str = isnothing(g.phenotype) ? "" : """
Phenotype.Results:

$(g.phenotype.results)

Phenotype.Trace:

$(g.phenotype.trace)
"""

"""
Name: $(g.name)

Symbolic Expression: $(symbolic_str)

Chromosome:
$(chrom_str)

Effective Code:
$(effec_str)

$(pheno_str)

Parents: $(g.parents)

Fitness: $(g.fitness)

Performance: $(g.performance)
"""
end


function random_program(n; ops=OPS, num_data=NUM_REGS, num_regs=NUM_REGS)
    [rand_inst(ops=ops, num_data=num_data, num_regs=num_regs) for _ in 1:n]
end
    


function Creature(config::NamedTuple)
    len = rand(config.genotype.min_len:config.genotype.max_len)
    chromosome = [rand_inst(ops=OPS, num_data=config.genotype.inputs_n, num_regs=NUM_REGS) for _ in 1:len]
    fitness = Evo.init_fitness(config)
    Creature(chromosome=chromosome,
             effective_code=nothing,
             phenotype=nothing,
             fitness=fitness,
             name=Names.rand_name(4),
             generation=0)
end


function Creature(d::Dict)

    Creature(
        chromosome = Inst.(d["chromosome"]),
        effective_code = isnothing(d["effective_code"]) ? nothing : Inst.(d["effective_code"]),
        phenotype = isnothing(d["phenotype"]) ? nothing : (results = Vector{Bool}(d["phenotype"]["results"]), trace = BitArray(d["phenotype"]["trace"])),
        fitness = Vector{Float64}([isnothing(x) ? -Inf : x for x in d["fitness"]]),
        name = d["name"],
        generation = d["generation"],
        num_offspring = d["num_offspring"],
        parents = d["parents"],
        likeness = d["likeness"],
        performance = d["performance"],
    )

end


function serialize_creature(g::Creature)
    JSON.json(g)
end

function deserialize_creature(s::String)
    JSON.parse(s) |> Creature
end


function Base.show(io::IO, inst::Inst)
    op_str = inst.op |> nameof |> String
    regtype(x) = x < 0 ? 'D' : 'R'
    if inst.arity == 2
        @printf(io, "%c[%02d] ← %c[%02d] %s %c[%02d]",
                regtype(inst.dst), inst.dst,
                regtype(inst.dst), inst.dst,
                op_str,
                regtype(inst.src), abs(inst.src))
    elseif inst.arity == 1
        @printf(io, "%c[%02d] ← %s %c[%02d]",
                regtype(inst.dst), inst.dst,
                op_str,
                regtype(inst.src), abs(inst.src))
    else # inst.arity == 0
        @printf(io, "%c[%02d] ← %s",
                regtype(inst.dst), inst.dst,
                inst.op())
    end
end

function Creature(chromosome::Vector{Inst})
    Creature(chromosome=chromosome,
             effective_code=nothing,
             phenotype=nothing,
             fitness=[-Inf],
             name=Names.rand_name(4),
             generation=0)
end



function crossover(mother::Creature, father::Creature; config=nothing)::Vector{Creature}
    mother.num_offspring += 1
    father.num_offspring += 1
    mx = rand(1:length(mother.chromosome))
    fx = rand(1:length(father.chromosome))
    chrom1 = [mother.chromosome[1:mx]; father.chromosome[(fx+1):end]]
    chrom2 = [father.chromosome[1:fx]; mother.chromosome[(mx+1):end]]
    children = Creature.([chrom1, chrom2])
    generation = max(mother.generation, father.generation) + 1
    (c -> c.generation = generation).(children)
    (c -> c.fitness = Evo.init_fitness(mother.fitness)).(children)
    children
end


function mutate!(creature::Creature; config=nothing)
    inds = keys(creature.chromosome)
    i = rand(inds)
    creature.chromosome[i] = rand_inst(ops=OPS, num_data=config.genotype.inputs_n, num_regs=NUM_REGS) # FIXME hardcoded
    return
end

constant(c) = c ? truth : falsity

truth() = true
falsity() = false


OPS = [
#    (⊻, 2),
    (|, 2),
    (&, 2),
    (~, 1),
    (truth, 0),
    (falsity, 0),
]


function rand_inst(;ops=OPS, num_data=NUM_REGS, num_regs=NUM_REGS)
    op, arity = rand(ops)
    dst = rand(1:num_regs)
    src = rand(Bool) ? rand(1:num_regs) : -1 * rand(1:num_data)
    Inst(op, arity, dst, src)
end


@inline I(ar,i) = ar[mod1(abs(i), length(ar))]

function evaluate_inst!(;regs, data, inst)
    s_regs = inst.src < 0 ? data : regs
    d_regs = regs
    if inst.arity == 2
        args = [I(d_regs, inst.dst), I(s_regs, inst.src)]
    elseif inst.arity == 1
        args = [I(s_regs, inst.src)]
    else # inst.arity == 0
        args = []
    end
    d_regs[inst.dst] = inst.op(args...)
end


function strip_introns(code, out_regs)
    active_regs = copy(out_regs)
    active_insts = []
    for inst in reverse(code)
        if inst.dst ∈ active_regs 
            push!(active_insts, inst)
            filter!(r -> r != inst.dst, active_regs)
            if inst.arity == 2
                push!(active_regs, inst.dst)
            end
            if inst.arity ≥ 1
                push!(active_regs, inst.src)
            end
        end
    end
    reverse(active_insts)
end

OUTREGS = [1]

MAX_STEPS = 512

function execute(code, data; make_trace=true)
    regs = zeros(RegType, NUM_REGS)
    trace_len = min(length(code), MAX_STEPS) # Assuming no loops
    trace = zeros(RegType, NUM_REGS, trace_len) |> BitArray
    pc = 1
    steps = 0
    while steps <= MAX_STEPS && pc <= trace_len
        inst = code[pc]
        evaluate_inst!(regs=regs, data=data, inst=inst)
        if make_trace
            trace[:, pc] .= regs
        end
        pc += 1
        steps += 1
    end
    regs[OUTREGS][1], trace
end


function FF.evaluate(g::Creature; data::Vector, make_trace=true)
    if g.effective_code === nothing
        g.effective_code = strip_introns(g.chromosome, OUTREGS)
    end
    execute(g.effective_code, data, make_trace=make_trace)
end


# What if we define parsimony wrt the # of unnecessary instructions?

function _parsimony(g::Creature)
    len = length(g.chromosome)
    len == 0 ? -Inf : 1.0 / len
end


function effective_parsimony(g::Creature)
    if isnothing(g.effective_code)
        g.effective_code = strip_introns(g.chromosome, [1])
    end
    length(g.effective_code) / length(g.chromosome)
end


function stepped_parsimony(g::Creature, threshold::Int)
    len = length(g.chromosome)
    if len == 0
        -Inf
    elseif len < threshold
        1.0
    else
        1.0 / len
    end
end


FF.parsimony(g::Creature) = stepped_parsimony(g, 100)


ST_TRANS = [:& => "AND", :xor => "XOR", :| => "OR", :~ => "NOT"] |> Dict

function st_inst(inst::Inst)
    src = inst.src < 0 ? "D[$(abs(inst.src))]" : "R[$(inst.src)]"
    dst = "R[$(inst.dst)]"
    lhs = "$(dst) := "
    if inst.arity == 2
        op = ST_TRANS[nameof(inst.op)]
        rhs = "$(dst) $(op) $(src);"
    elseif inst.arity == 1
        op = ST_TRANS[nameof(inst.op)]
        rhs = "$(op) $(src);"
    else # inst.arity == 0
        op = string(inst.op()) |> uppercase
        rhs = "$(op);"
    end
    lhs * rhs
end

function structured_text(prog; config=nothing, comment="")
    prog = strip_introns(prog, [1])
    reg_decl = """
VAR
    R : ARRAY[1..$(NUM_REGS)] OF BOOL;
END_VAR

"""
    body = "    " * join(map(st_inst, prog), "\n    ")
    out = "\n    Out := R[1];\n"

    payload = reg_decl * body * out

    inputsize = config.genotype.inputs_n
    st = StructuredTextTemplate.wrap(payload, inputsize)
    if length(comment) > 0
        return "(*\n$(comment)\n*)\n\n$(st)"
    else
        return st
    end
end

end # end module
