include("$(@__DIR__)/../src/base.jl")
using BenchmarkTools
using BenchmarkPlots

DURATION=300

function decompiler_benchmarks(evo)
    format_tag(k) = "inc $(k.incremental_simplify |> Int) α $(k.alpha_cache |> Int)"
    toggles = [:incremental_simplify, :alpha_cache]
    # we don't want the genotypes to save a copy of their decompilation in a
    # struct field, since that would spoil the benchmark test. So,
    Expressions.flush_cache!()
    bmg = BenchmarkGroup()

    for vals in Iterators.product(repeat([[true, false]], length(toggles))...)
        kwargs = [k=>v for (k,v) in zip(toggles, vals)]
        b = @benchmarkable LinearGenotype.decompile(g; assign=false, $kwargs...) setup=(g=rand($(evo.geo.deme))) seconds=DURATION
        #push!(bs, (kwargs=deepcopy(kwargs), bench=b))
        k = format_tag(kwargs |> NamedTuple)
        bmg[k] = b
    end

    return bmg
end


function evolve_snapshots(periods)
    evoL = mkevo("$(@__DIR__)/../config/config-3MUX.yaml")
    snapshots = [deepcopy(evoL)]
    for period in periods
        steps = collect(evoL.iteration:period-1)
        @info "evolving to iteration $(period)"
        @showprogress for _ in steps
            Cockatrice.Evo.step!(evoL)
        end
        @info "evoL at iteration $(evoL.iteration)"
        push!(snapshots, deepcopy(evoL))
    end
    perf = [objective_performance.(evo.geo.deme) for evo in snapshots]
    @info "Objective performance in snapshots:"
    @show map(maximum, perf)
    @show map(mean, perf)
    @show map(median, perf)
    return snapshots
end


function decompile_without_cache(g; incremental_simplify=false)
    Expressions._use_cache!(false)
    LinearGenotype.decompile(g; assign=false, simplify=true, incremental_simplify)
    Expressions._use_cache!(true)
end






snapshots = evolve_snapshots([100, 1000, 10_000, 100_000, 200_000])

suite = BenchmarkGroup(["decompiler"])
for evo in snapshots
    k = "T$(evo.iteration)"
    suite[k] = decompiler_benchmarks(evo)
    suite[k]["inc 0 cache 0"] = @benchmarkable decompile_without_cache(g, incremental_simplify=false) setup=(g=rand($(evo.geo.deme))) seconds=DURATION
    suite[k]["inc 1 cache 0"] = @benchmarkable decompile_without_cache(g, incremental_simplify=true) setup=(g=rand($(evo.geo.deme))) seconds=DURATION
end

@info "Tuning the suite"
tune!(suite)

@info "Suite is ready"

suite


# for i in length(p)
#     @info "Benchmarking decompilation of population after $(p[i]) tournaments"
#     for item in B[i]
#         @info "Benchmarking decompile() with options: $(item.kwargs)"
#         run(item.bench)
#     end
# end




