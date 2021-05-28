module LinearGenotype

using Printf

using ..FF
using ..Names
using ..StructuredTextTemplate
using ..Cockatrice.Evo


NUM_REGS = 20
RegType = Bool

struct Inst
    op::Function
    arity::Int
    # let's use the convention that negative indices refer to input
    dst::Int
    src::Int
end


Base.@kwdef mutable struct Creature
    chromosome::Vector{Inst}
    effective_code
    phenotype
    fitness::Vector{Float64}
    name::String
    generation::Int
    num_offspring::Int = 0
    parents = nothing
    likeness = nothing
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

constant(c) = () -> c

OPS = [
    (⊻, 2),
    (|, 2),
    (&, 2),
    (!, 1),
    (constant(true), 0),
    (constant(false), 0),
]


function rand_inst(;ops=OPS, num_data=NUM_REGS, num_regs=NUM_REGS)
    op, arity = rand(ops)
    dst = rand(1:num_regs)
    src = rand(Bool) ? rand(1:num_regs) : -1 * rand(1:num_data)
    Inst(op, arity, dst, src)
end


@inline I(ar,i) = ar[mod1(abs(i), length(ar))]

function evaluate_inst!(;regs::Vector, data::Vector, inst::Inst)
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

function FF.evaluate(g::Creature; data::Vector, trace=false)
    if g.effective_code === nothing
        g.effective_code = strip_introns(g.chromosome, OUTREGS)
    end
    regs = zeros(RegType, NUM_REGS)
    for inst in g.effective_code
        if trace
            println("$(inst)")
        end
        evaluate_inst!(regs=regs, data=data, inst=inst)
    end
    regs[OUTREGS][1] # KLUDGE
end


function FF.parsimony(g::Creature)
    len = length(g.chromosome)
    len == 0 ? -Inf : 1.0 / len
end

ST_TRANS = [:& => "AND", :xor => "XOR", :| => "OR", :! => "NOT"] |> Dict

function st_inst(inst::Inst)
    src = inst.src < 0 ? "Data[$(abs(inst.src))]" : "R[$(inst.src)]"
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
