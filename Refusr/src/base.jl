using Pkg
Pkg.activate("$(@__DIR__)/..")
Pkg.instantiate()


using Blink
using CSV
using Cockatrice
using Cockatrice.Config
using Cockatrice.Cosmos
using Cockatrice.Evo: Tracer
using Dash
using DashCoreComponents
using DashHtmlComponents
using DataFrames
using Dates
using DistributedArrays
using FunctionWrappers: FunctionWrapper
using InformationMeasures
using PlotlyBase
using ProgressMeter
using Setfield
using Statistics
using Printf

include("Ops.jl")
include("BitEntropy.jl")
include("StructuredTextTemplate.jl")
include("Expressions.jl")
include("Names.jl")
include("FF.jl")
include("TreeGenotype.jl")
include("LinearGenotype.jl")
include("step.jl")
include("Z3Bridge.jl")
include("Analysis.jl")

meanfinite(s) = mean(filter(isfinite, s))
stdfinite(s) = std(filter(isfinite, s))

function get_likeness(g)
    isempty(g.likeness) ? -Inf : maximum(g.likeness)
end

DEFAULT_CONFIG_FIELDS = [
    ["dashboard", "enable"] => true,
    ["dashboard", "port"] => 9124,
    ["dashboard", "server"] => "0.0.0.0",
    ["step_duration"] => 1,
    ["preserve_population"] => false,
    ["experiment"] => Names.rand_name(2),
    ["selection", "t_size"] => 6,
    ["selection", "lexical"] => true,
    ["logging", "dir"] => "$(ENV["HOME"])/logs/refusr/",
    ["genotype", "weight_crossover_points"] => true,
    ["genotype", "ops"] => [:|, :&, :~, :mov],
]

function prep_config(path)
    proj_dir = abspath("$(@__DIR__)/../")
    config = Cockatrice.Config.parse(path, DEFAULT_CONFIG_FIELDS)
    if !isabspath(config.selection.data)
        full_path = "$(proj_dir)/$(config.selection.data)"
        @assert isfile(full_path) "config.selection.data must be either an absolute path, or a relative path from the project directory"
        config = @set config.selection.data = "$(proj_dir)/$(config.selection.data)"
    end
    data = CSV.read(config.selection.data, DataFrame)
    data_n = ncol(data) - 1
    if data_n != config.genotype.data_n
        @warn "data_n mismatch, setting to confirm to actual data" config.genotype.data_n ncol(data)-1
        config = @set config.genotype.data_n = data_n
    end
    config = @set config.genotype.ops = Symbol.(split(config.genotype.ops))
    n = now()
    config = @set config.experiment =
        (@sprintf "%s.%02d-%02d-%02d" config.experiment hour(n) minute(n) second(n))
    config = @set config.logging.dir = Cockatrice.Logging.make_log_dir(config.experiment)
    
    config
end

function objective_performance(g)
    if g.phenotype === nothing
        return -Inf
    end
    if g.performance !== nothing
        return g.performance
    end

    correct = (!).(g.phenotype.results .⊻ FF.get_answers(FF.DATA))
    g.performance = mean(correct)
    return g.performance
end

stopping_condition(evo) =
    !isempty(evo.elites) && (objective_performance.(evo.elites) |> maximum) == 1.0

# TODO: why not just trace stats at end of step_for_duration?!
# The logger never sees anything else.

TRACERS = [
    (key = "objective", callback = objective_performance, rate = 1.00),
    (key = "fitness_1", callback = g -> g.fitness[1], rate = 0.01),
    (key = "fitness_2", callback = g -> g.fitness[2], rate = 0.01),
    (key = "fitness_3", callback = g -> g.fitness[3], rate = 1.0),
    (key = "chromosome_len", callback = g -> length(g.chromosome), rate = 0.01),
    (
        key = "effective_len",
        callback = g -> isnothing(g.effective_code) ? -Inf : length(g.effective_code),
        rate = 0.01,
    ),
    (key = "num_offspring", callback = g -> g.num_offspring, rate = 0.01),
    (key = "generation", callback = g -> g.generation, rate = 0.01),
    (key = "likeness", callback = get_likeness, rate = 0.01),
]



LOGGERS = [
    (key = "objective", reducer = maximum),
    (key = "objective", reducer = meanfinite),
    (key = "fitness_1", reducer = maximum),
    (key = "fitness_1", reducer = meanfinite),
    (key = "fitness_1", reducer = std),
    (key = "fitness_2", reducer = maximum),
    (key = "fitness_2", reducer = meanfinite),
    (key = "fitness_2", reducer = std),
    (key = "fitness_3", reducer = meanfinite),
    (key = "fitness_3", reducer = maximum),
    (key = "fitness_3", reducer = std),
    (key = "chromosome_len", reducer = Statistics.maximum),
    (key = "chromosome_len", reducer = Statistics.mean),
    (key = "effective_len", reducer = Statistics.maximum),
    (key = "effective_len", reducer = Statistics.mean),
    (key = "num_offspring", reducer = maximum),
    (key = "num_offspring", reducer = Statistics.mean),
    (key = "generation", reducer = Statistics.mean),
    (key = "likeness", reducer = meanfinite),
]

pipinstall(package) = run(`$(PyCall.python) -m pip install $(package)`)


# Debugging tools

## To facilitate debugging and testing
function mkevo(config = "./config.yaml")
    config = prep_config(config)
    FF._set_data(config.selection.data)
    Cockatrice.Evo.Evolution(
        config,
        creature_type = LinearGenotype.Creature,
        fitness = FF.fit,
        tracers = TRACERS,
        mutate = LinearGenotype.mutate!,
        crossover = LinearGenotype.crossover,
        objective_performance = objective_performance,
    )
end



function stuff_logger!(L, rows = 100)
    ac = 0
    for i = 1:rows
        stats = rand(ncol(L.table) - 1)
        ac += i * rand() * 1000
        r = [ac, stats...]
        push!(L.table, r)
    end
end # end module


function stuff_im_log!(L, num = 100, isles = 8)
    p = 10 * 10
    c = 64
    for i = 1:num
        ims = [rand(Bool, c, p) |> BitArray for _ = 1:isles]
        push!(L.im_log, ims)
    end
end


function fake_logger()
    config = prep_config("./config/config-2MUX-sharing.yaml")
    L = Cockatrice.Logging.Logger(LOGGERS, config)
    stuff_logger!(L)
    stuff_im_log!(L)
    evoL = mkevo()
    @showprogress for i = 1:100
        Cockatrice.Evo.step!(evoL)
    end
    for i = 1:100
        Cockatrice.Logging.add_specimen(L, rand(evoL.geo.deme))
    end
    return L, evoL
end

# TODO: what if you cached abstract expressions, modulo renaming of variables?
