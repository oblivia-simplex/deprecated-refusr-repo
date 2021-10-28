### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ bdf54e0e-426a-4a13-a253-832d367b2ea6
begin
	using Pkg
	Pkg.activate("$(@__DIR__)/..")
	include("$(@__DIR__)/../src/base.jl")
	using BenchmarkTools, BenchmarkPlots, StatsPlots
	plotly()
	#include("./test/bench.jl")
end

# ╔═╡ 971d7f76-f6d0-11eb-34f0-9ffa21a07d7b
md"# Benchmark Plots"

# ╔═╡ 5eeb15ea-64c0-421a-a4bc-47bca8594a4a
md"## Benchmarking the Decompiler"

# ╔═╡ cb63e4bd-a6a8-47f2-8836-df7c87d801dd
DURATION=300

# ╔═╡ 34cd69e6-55fb-4420-bee7-9d3e0beb0ac8
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


# ╔═╡ 04271198-e449-459b-8fb6-31424132905d

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



# ╔═╡ 6595a749-799f-44a8-b7ac-a8e3e5187278

function decompile_without_cache(g; incremental_simplify=false)
    Expressions._use_cache!(false)
    LinearGenotype.decompile(g; assign=false, simplify=true, incremental_simplify)
    Expressions._use_cache!(true)
end



# ╔═╡ e1a387e2-8e39-471f-a163-640718b65681
snapshots = evolve_snapshots([100, 1000, 10_000, 100_000, 200_000])

# ╔═╡ 466fa482-3d1c-45d3-b90c-30ca6003f6e7
begin
	suite = BenchmarkGroup(["decompiler"])
	for evo in snapshots
		k = "T$(evo.iteration)"
		suite[k] = decompiler_benchmarks(evo)
		suite[k]["inc 0 cache 0"] = @benchmarkable decompile_without_cache(g, incremental_simplify=false) setup=(g=rand($(evo.geo.deme))) seconds=DURATION
		suite[k]["inc 1 cache 0"] = @benchmarkable decompile_without_cache(g, incremental_simplify=true) setup=(g=rand($(evo.geo.deme))) seconds=DURATION
	end

	@info "Tuning the suite"
	tune!(suite)
end

# ╔═╡ eac0e098-0778-4e13-9174-9d8ffb5d2565
# BenchmarkTools.tune!(suite)

# ╔═╡ e043f264-8657-48e7-bf0b-a783db533d86
function run_and_plot_suite(suite)
	trial = run(suite)
	plot(t)
end

# ╔═╡ e76004e9-740c-4048-a8e6-d962f3b3d7ef
keys(suite)

# ╔═╡ abd8e37d-bac7-4767-87f7-e309dcd15bed
T0 = run(suite["T0"])

# ╔═╡ c48a536f-b6c2-4763-bcc5-470d475cc53d
T0plot = plot(T0, title="After Initialization")

# ╔═╡ 76b5e402-5e31-4021-b6f6-e2156954438a


# ╔═╡ 7a03cc9b-5347-4b31-a68e-d7c1f678839d
T100 = run(suite["T100"])

# ╔═╡ 0406589d-3da4-427e-a8d6-3fbfb9ff40cd
T100plot = plot(T100, title="After 100 Tournaments")

# ╔═╡ ec4a3b3a-8737-4dbf-81d1-9c008a3c5dbd
T1000 = run(suite["T1000"])

# ╔═╡ d6c8ffc7-9281-49d0-a295-a4edb5411a89
T1000plot = plot(T1000, title="After 1000 Tournaments")

# ╔═╡ 37cc3c6d-1f7b-4dc4-9eb9-1444206d354f


# ╔═╡ 3b7f6dbc-fdb4-4b1e-bbb1-fd7743e4becf
T10_000 = run(suite["T10000"])

# ╔═╡ edb27237-90af-4cd9-ba9e-4d161c3662c9
T10_000plot = plot(T10_000, title="After 10,000 Tournaments")

# ╔═╡ 74753aab-53d9-47ac-b74d-437b2e869285
T100_000 = run(suite["T100000"])

# ╔═╡ dd5acd81-893a-424b-9c7d-91bb1785f31f
T100_000plot = plot(T100_000, title="After 100,000 Tournaments")

# ╔═╡ 09a5185b-edb6-42d5-afef-bc1782d03d3b
T200_000 = run(suite["T200000"])

# ╔═╡ 2a44b393-8d91-4c57-aa36-eba3b8ae314c
T200_000plot = plot(T200_000, title="After 200,000 Tournaments")

# ╔═╡ df869b45-94e8-4f77-b7e8-cb05338d7790


# ╔═╡ Cell order:
# ╠═971d7f76-f6d0-11eb-34f0-9ffa21a07d7b
# ╠═5eeb15ea-64c0-421a-a4bc-47bca8594a4a
# ╠═cb63e4bd-a6a8-47f2-8836-df7c87d801dd
# ╠═bdf54e0e-426a-4a13-a253-832d367b2ea6
# ╠═34cd69e6-55fb-4420-bee7-9d3e0beb0ac8
# ╠═04271198-e449-459b-8fb6-31424132905d
# ╠═6595a749-799f-44a8-b7ac-a8e3e5187278
# ╠═e1a387e2-8e39-471f-a163-640718b65681
# ╠═466fa482-3d1c-45d3-b90c-30ca6003f6e7
# ╠═eac0e098-0778-4e13-9174-9d8ffb5d2565
# ╠═e043f264-8657-48e7-bf0b-a783db533d86
# ╠═e76004e9-740c-4048-a8e6-d962f3b3d7ef
# ╠═abd8e37d-bac7-4767-87f7-e309dcd15bed
# ╠═c48a536f-b6c2-4763-bcc5-470d475cc53d
# ╠═76b5e402-5e31-4021-b6f6-e2156954438a
# ╠═7a03cc9b-5347-4b31-a68e-d7c1f678839d
# ╠═0406589d-3da4-427e-a8d6-3fbfb9ff40cd
# ╠═ec4a3b3a-8737-4dbf-81d1-9c008a3c5dbd
# ╠═d6c8ffc7-9281-49d0-a295-a4edb5411a89
# ╠═37cc3c6d-1f7b-4dc4-9eb9-1444206d354f
# ╠═3b7f6dbc-fdb4-4b1e-bbb1-fd7743e4becf
# ╠═edb27237-90af-4cd9-ba9e-4d161c3662c9
# ╠═74753aab-53d9-47ac-b74d-437b2e869285
# ╠═dd5acd81-893a-424b-9c7d-91bb1785f31f
# ╠═09a5185b-edb6-42d5-afef-bc1782d03d3b
# ╠═2a44b393-8d91-4c57-aa36-eba3b8ae314c
# ╠═df869b45-94e8-4f77-b7e8-cb05338d7790
