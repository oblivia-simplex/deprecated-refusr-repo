### A Pluto.jl notebook ###
# v0.17.0

using Markdown
using InteractiveUtils

# ╔═╡ d1381e9d-8487-4591-90a7-346f4d84be3f
begin
	using Pkg
	REFUSR_URL="https://github.com/oblivia-simplex/refusr"
	COCKATRICE_URL="https://github.com/oblivia-simplex/Cockatrice.jl"
	DIR="$(ENV["HOME"])/src/refusr"
	cd(DIR)
	Pkg.activate(DIR)
	#Pkg.add(url=COCKATRICE_URL) ; using Cockatrice
	#Pkg.add(url=REFUSR_URL); using Refusr: Sensitivity, FF, LinearGenotypes, Expressions, Cockatrice
	#Refusr = ingredients("src/Refusr.jl")
#import .Refusr: LinearGenotypes, Expressions, Sensitivity
	include("src/base.jl")
	include("src/RandomFunctions.jl")
	using Cockatrice
	using Distributions
	using FunctionWrappers: FunctionWrapper
	using Statistics
	using DataFrames
	using StatsPlots
	using PGFPlotsX
	using Plots
	Plots.plotly()
end

# ╔═╡ 6e8003e3-cf8f-4926-bbca-c09387e88671
using Memoize

# ╔═╡ c6706c67-4046-4897-b31b-1f68717024cc
include("src/RandomFunctions.jl")

# ╔═╡ 3ff7dfe8-3cfd-11ec-0557-85eeb1f87838
md"# Approximate Dirichlet Energy Measures on the Hypercube"

# ╔═╡ fef6f72a-5819-420f-8ae9-3a653430be2e
function rndfunc(dim)
	RandomFunctions.bfunc_by_rnd_vec(dim)
end

# ╔═╡ b7e27cff-25d8-4ec8-8ee8-bd9d291ea1a6


# ╔═╡ efd1d858-abbe-4efd-afe0-cf614eaf66e3
DIM = 10

# ╔═╡ ae25d145-4799-4cd6-a7a1-972eee5c55cf
function getstats(res)
	(mean = mean(res.guess),
	std = std(res.guess),
	median = median(res.guess),
	max = maximum(res.guess),
	min = minimum(res.guess),
	error = abs(mean(res.guess) - res.truth),
	errors = abs.(res.guess .- res.truth),
	truth = res.truth,
	sample = res.sample,
	)
end

# ╔═╡ 59decbdd-a4f2-4934-9da5-99ff351d32f8
function guess_energy(f; dim=DIM, trials=100, sample=0.1)
	if sample === :RANDOM
		sample = rand() * 2
	end
	if f === :RANDOM
		f = rndfunc(dim)
	end
	(
		guess = [Sensitivity.approximate_dirichlet_energy(f, dim, sample) |> Float64 for _ in 1:trials], 
		truth = Sensitivity.dirichlet_energy(f, dim) |> Float64,
		sample = sample,
	) |> getstats
end

# ╔═╡ 365f7dc6-2392-4acb-8866-f325ea66b64d
SAMPLE_RANGE = LinRange(0.01, 2, 20)

# ╔═╡ 0805cca3-b72c-4c6e-adbe-4fb4084dcbc3
df = sort((guess_energy(:RANDOM, sample=:RANDOM) for _ in 1:200) |> DataFrame, [:sample])

# ╔═╡ f588da39-70bc-42d2-8dc6-7d53e38abb53
unpacked = vcat([[(sample = r.sample, error = e, std = r.std, mean = r.error) for e in r.errors] for r in eachrow(df) if r.sample > 0.01]...) |> DataFrame

# ╔═╡ b0973fcf-61dc-42b6-9452-8936b74c3447
begin 
	@df unpacked qqplot(:sample, [:error], xlabel="ratio of |V(G)| visited", ylabel="mean error (over 100 trials)", qqline=:fit)

	
end

# ╔═╡ bd35f672-cd41-4439-969d-6a79dd7281f1
md"TODO add error bars or std shading"

# ╔═╡ Cell order:
# ╠═3ff7dfe8-3cfd-11ec-0557-85eeb1f87838
# ╠═d1381e9d-8487-4591-90a7-346f4d84be3f
# ╠═c6706c67-4046-4897-b31b-1f68717024cc
# ╠═6e8003e3-cf8f-4926-bbca-c09387e88671
# ╠═fef6f72a-5819-420f-8ae9-3a653430be2e
# ╠═b7e27cff-25d8-4ec8-8ee8-bd9d291ea1a6
# ╠═efd1d858-abbe-4efd-afe0-cf614eaf66e3
# ╠═ae25d145-4799-4cd6-a7a1-972eee5c55cf
# ╠═59decbdd-a4f2-4934-9da5-99ff351d32f8
# ╠═365f7dc6-2392-4acb-8866-f325ea66b64d
# ╠═0805cca3-b72c-4c6e-adbe-4fb4084dcbc3
# ╠═f588da39-70bc-42d2-8dc6-7d53e38abb53
# ╠═b0973fcf-61dc-42b6-9452-8936b74c3447
# ╠═bd35f672-cd41-4439-969d-6a79dd7281f1
