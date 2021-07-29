module LinearGenotype

using Printf
using Distributed
import JSON
import Base.isequal

using ..FF
using ..Names
using ..StructuredTextTemplate
using ..Cockatrice.Evo
using ..Expressions



const RegType = Bool

const mov = identity


const OPS = [
    #(⊻, 2),
    #(⊃, 2),
    #(nand, 2),
    (|, 2),
    (&, 2),
    (~, 1),
    (mov, 1),
    #    (truth, 0),
    #    (falsity, 0), 
]


struct Inst
    op::Function
    arity::Int
    # let's use the convention that negative indices refer to input
    dst::Int
    src::Int
end

## How many possible Insts are there, for N inputs?
## Where there are N inputs, there are 2N possible src values and N possible dst
## arity is fixed with op, so there are 4 possible op values
number_of_possible_insts(n_input, n_reg; ops=OPS) = n_input * (n_input + n_reg) * length(ops)


function number_of_possible_programs(n_input, n_reg, max_length) 
    [number_of_possible_insts(n_input, n_reg)^BigFloat(i) for i in 1:max_length] |> sum
end

function number_of_possible_programs(config::NamedTuple)
    number_of_possible_programs(config.genotype.data_n, config.genotype.registers_n, config.genotype.max_length)
end



@inline function semantic_intron(inst::Inst)::Bool
    inst.op ∈ (&, |, mov) && (inst.src == inst.dst)
end


function strip_introns(code, out_regs)
    active_regs = copy(out_regs)
    active_insts = []
    for inst in reverse(code)
        semantic_intron(inst) && continue
        if inst.dst ∈ active_regs
            push!(active_insts, inst)
            filter!(r -> r != inst.dst, active_regs)
            inst.arity == 2 && push!(active_regs, inst.dst)
            inst.arity >= 1 && push!(active_regs, inst.src)
        end
    end
    reverse(active_insts)
end


function byte_encoding(inst)

    src = UInt8(abs(inst.src))
    if inst.src < 0
        src = (~src) + 0x01 # Two's Complement
    end
    [
        UInt8(findfirst(x->x==(inst.op, inst.arity), OPS)),
        UInt8(inst.dst),
        src
    ]
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


function to_expr(code::Vector{Inst}; intron_free=true, incremental_simplify=true)
    DEFAULT_EXPR = false
    code = intron_free ? copy(code) : strip_introns(code, [1])
    if isempty(code)
        return DEFAULT_EXPR
    end
    expr = pop!(code) |> to_expr
    LHS, RHS = expr.args
    while !isempty(code)
        e = pop!(code) |> to_expr
        lhs, rhs = e.args
        RHS = Expressions.replace(RHS, lhs=>rhs)
        if incremental_simplify
            RHS = Expressions.simplify(RHS)
        end
    end
    # Since we initialize the R registers to `false`, any remaining R references
    # can be replaced with `false`.
    RHS = Expressions.replace(RHS, (e -> e isa Expr && e.args[1] == :R) => false)
    if incremental_simplify
        return Expressions.simplify(RHS)
    else
        return RHS
    end
end
 

Base.@kwdef mutable struct Creature
    chromosome::Vector{Inst}
    effective_code::Union{Nothing, Vector{Inst}}
    phenotype
    fitness::Vector{Float64}
    name::String
    generation::Int
    num_offspring::Int = 0
    parents = []
    likeness = []
    performance = nothing
    symbolic = nothing
    native_island = myid() == 1 ? 1 : myid() - 1
end


function decompile(g::Creature; assign=true, incremental_simplify=true)
    if !isnothing(g.symbolic) && assign
        return g.symbolic
    end
    @debug "Decompiling $(g.name)'s chromosome..."
    if isnothing(g.effective_code)
        g.effective_code = strip_introns(g.chromosome, [1])
    end
    symbolic = to_expr(g.effective_code,
                       intron_free=true,
                       incremental_simplify=incremental_simplify)
    if assign
        g.symbolic = symbolic
    end
    return symbolic
end


function random_program(n; ops=OPS, num_data=1, num_regs=1)
    [rand_inst(ops=ops, num_data=num_data, num_regs=num_regs) for _ in 1:n]
end
    


function Creature(config::NamedTuple)
    len = rand(config.genotype.min_len:config.genotype.max_len)
    chromosome = [rand_inst(ops=OPS, num_data=config.genotype.data_n, num_regs=config.genotype.registers_n) for _ in 1:len]
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


function crop(seq, len)
    length(seq) > len ? seq[1:len] : seq
end

function crossover(mother::Creature, father::Creature; config=nothing)::Vector{Creature}
    mother.num_offspring += 1
    father.num_offspring += 1
    mx = rand(1:length(mother.chromosome))
    fx = rand(1:length(father.chromosome))
    chrom1 = [mother.chromosome[1:mx]; father.chromosome[(fx+1):end]]
    chrom2 = [father.chromosome[1:fx]; mother.chromosome[(mx+1):end]]
    len = config.genotype.max_len
    children = Creature.([crop(chrom1, len), crop(chrom2, len)])
    generation = max(mother.generation, father.generation) + 1
    for child in children
        child.parents = [mother.name, father.name]
        child.generation = generation
        child.fitness = repeat([-Inf], config.selection.d_fitness)
    end
    children
end


function mutate!(creature::Creature; config=nothing)
    inds = keys(creature.chromosome)
    i = rand(inds)
    creature.chromosome[i] = rand_inst(ops=OPS, num_data=config.genotype.data_n, num_regs=config.genotype.registers_n) 
    return
end

constant(c) = c ? truth : falsity

truth() = true
falsity() = false



function rand_inst(;ops=OPS, num_data=1, num_regs=num_data)
    op, arity = rand(ops)
    dst = rand(1:num_regs)
    src = rand(Bool) ? rand(1:num_regs) : -1 * rand(1:num_data)
    Inst(op, arity, dst, src)
end


@inline I(ar,i) = ar[mod1(abs(i), length(ar))]
@inline IV(ar,i) = ar[mod1(abs(i), length(ar)), :]

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


## TODO: Optimize this. maybe even for CUDA.
# The indexing is slowing things down, I think.
# vectoralize it further.
function evaluate_inst_vec!(;R, D, inst)
    # Add a dimension to everything
    s_regs = inst.src < 0 ? D : R
    d_regs = R
    if inst.arity == 2
        args = [IV(d_regs, inst.dst), IV(s_regs, inst.src)]
    elseif inst.arity == 1
        args = [IV(s_regs, inst.src)]
    else
        args = []
    end
    d_regs[inst.dst, :] .= inst.op.(args...)

end


function execute(code, data; config, make_trace=true)::Tuple{RegType, BitArray}
    num_regs = config.genotype.registers_n
    max_steps = config.genotype.max_steps
    outreg = config.genotype.output_reg
    regs = zeros(RegType, num_regs)
    trace_len = max(1, min(length(code), max_steps)) # Assuming no loops
    trace = zeros(RegType, num_regs, trace_len) |> BitArray
    steps = 0
    for (pc, inst) in enumerate(code)
        if pc > max_steps break end
        evaluate_inst!(regs=regs, data=data, inst=inst)
        if make_trace
            trace[:, pc] .= regs
        end
        steps += 1
    end
    regs[outreg], trace
end


function execute_vec(code, INPUT; config, make_trace=true)
    D = INPUT'
    R = BitArray(zeros(Bool, (config.genotype.registers_n, size(D, 2))))
    max_steps = config.genotype.max_steps
    trace_len = max(1, min(length(code), max_steps))
    trace = zeros(Bool, size(R)..., trace_len) |> BitArray
    steps = 0
    for (pc, inst) in enumerate(code)
        if pc > max_steps break end
        evaluate_inst_vec!(R=R, D=D, inst=inst)
        if make_trace
            trace[:, :, pc] .= R
        end
        steps += 1
    end
    R[config.genotype.output_reg, :], trace
end


function evaluate_vectoral(code; INPUT::BitArray, config::NamedTuple, make_trace=true)
    execute_vec(code, INPUT, config=config, make_trace=make_trace)
end


unzip(a) = map(x->getfield.(a, x), fieldnames(eltype(a)))

function evaluate_sequential(code; INPUT::BitArray, config::NamedTuple, make_trace=true)
    res, tr = [execute(code, row, config=config, make_trace=make_trace) for row in eachrow(INPUT)] |> unzip
    (res, cat(tr..., dims=(3,)))
end

function FF.evaluate(g::Creature; INPUT::BitArray, config::NamedTuple, make_trace=true)
    if isnothing(g.effective_code)
        g.effective_code = strip_introns(g.chromosome, [config.genotype.output_reg])
    end
    evaluate_vectoral(g.effective_code, INPUT=INPUT, config=config, make_trace=make_trace)
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


FF.parsimony(g::Creature) = effective_parsimony(g)


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
    num_regs = config.genotype.registers_n
    reg_decl = """
VAR
    R : ARRAY[1..$(num_regs)] OF BOOL;
END_VAR

"""
    body = "    " * join(map(st_inst, prog), "\n    ")
    out = "\n    Out := R[1];\n"

    payload = reg_decl * body * out

    inputsize = config.genotype.data_n
    st = StructuredTextTemplate.wrap(payload, inputsize)
    if length(comment) > 0
        return "(*\n$(comment)\n*)\n\n$(st)"
    else
        return st
    end
end

end # end module
