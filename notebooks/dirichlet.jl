### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ d31dfd8f-2442-46cc-b788-3751a4f74308
begin
	#cd("$(ENV["HOME"])/src/refusr")
	using Pkg
	REFUSR_URL="https://github.com/oblivia-simplex/refusr"
	COCKATRICE_URL="file:///home/lucca/src/Cockatrice"
	Pkg.activate(mktempdir())
	Pkg.add(url=REFUSR_URL)
	Pkg.add("Distributions")
	using Distributions
	Pkg.add("FunctionWrappers")
	using FunctionWrappers
	Pkg.add("Statistics")
	using Statistics
	Pkg.add("DataFrames")
	using DataFrames
	Pkg.add("StatsPlots")
	using StatsPlots
	Pkg.add("PGFPlotsX")
	using PGFPlotsX
	using Refusr
	using Refusr: Cockatrice
end

# ╔═╡ 42e1aad9-6330-40e9-9aea-f7558edf4f1d
using Images

# ╔═╡ 0424a62a-3692-11ec-3d69-158cb1b525d0
md"# Dirichlet Energy of Boolean Functions on the Hypercube"

# ╔═╡ 0cba539b-f584-4ecc-8aba-271850962e61
md"What does the distribution of Dirichlet energy over the domain of n-dimensional Boolean functions look like? What does that distribution look like for some of our various ways of generating Boolean functions? That's what we're going to look at here."

# ╔═╡ dad07b34-0884-4f8d-970d-0b6ba744856e
function bitv_to_int(v,s=0) 
       b = 0
       for i in view(v, length(v):-1:1)
           s |= (i << b)
           b += 1
       end
       s
end

# ╔═╡ 6c7d69c4-15bd-4e3c-82d0-843a2502d152


# ╔═╡ a8291800-35c5-464f-bbf4-485cf5cfe6a6
function bfunc_by_rnd_vec(dim)
	len = 2^dim
	vector = rand(Bool, len) |> BitVector
	function (bv)
		i = bitv_to_int(bv)
		vector[i+1]
	end |> FunctionWrapper{Bool, Tuple{BitVector}}
end

# ╔═╡ 36e1a9e3-4b74-4dde-9892-cb15687522ec
function bfunc_by_prog(prog::Vector{LinearGenotype.Inst})
	function (bv)
		config = (genotype = (registers_n = dim - 1, 
				max_steps = len, output_reg = 1),) 
		out, _ = LinearGenotype.execute(prog, bv; 
			config=config, make_trace=false)
		return out
	end |> FunctionWrapper{Bool, Tuple{BitVector}}
end

# ╔═╡ fc9a3455-dc8e-4115-bab8-07648104affd
function bfunc_by_rnd_prog(dim, len=512, ops="& | ~ xor")
	len = len isa Integer ? len : rand(len)
	registers = max(1, dim ÷ 2)
	ops = Symbol.(split(ops))
	prog = LinearGenotype.random_program(len; ops)
	effective_indices = LinearGenotype.get_effective_indices(prog, [1])
	prog = prog[effective_indices]
	function (bv)
		config = (genotype=(registers_n=dim-1, max_steps=len, output_reg=1),) 
		out, _ = LinearGenotype.execute(prog, bv; config=config, make_trace=false)
		return out
	end |> FunctionWrapper{Bool, Tuple{BitVector}}
end


# ╔═╡ 7c042acb-9364-4f2a-b7bb-dab11241fa92
function bfunc_by_rnd_expr(dim, depth=8)
	e = Expressions.grow(depth, num_terminals=dim)
	Expressions.compile_expression(e)
end

# ╔═╡ e33a17dd-e519-45d5-836a-b2804390d399
md"## scratch examples"

# ╔═╡ 5262a2d0-e042-4cc1-90f7-28e98af93479
f1 = bfunc_by_rnd_vec(6)

# ╔═╡ fd1b7bdb-1332-49e7-a9be-86753e3aa8a1
f2 = bfunc_by_rnd_prog(6)

# ╔═╡ b3f5b9ae-2504-434e-8289-2248e91da60e
f3 = bfunc_by_rnd_expr(6)

# ╔═╡ 67e4629b-17ef-47dd-bd25-cd0d1661f65e
f2(BitVector([1,0,1,0,1,0]))

# ╔═╡ 824404db-2b5b-43b5-b997-18ba35c93a0e
Expressions.truth_table(f1, dim = 6)

# ╔═╡ 3d833fe9-86ff-47af-a091-a1ea1018cc37
Expressions.truth_table(f2, dim = 6)

# ╔═╡ feaf71eb-6eb8-4df4-a051-e7462613df47
Expressions.truth_table(f3, dim = 6)

# ╔═╡ aed154fa-cd6f-4b09-b43e-9029c990f51e
md"# Generating some Statistics"

# ╔═╡ d51112b5-55a2-42c9-a094-f0703f382827
GENERATORS = (
	vector = bfunc_by_rnd_vec,
	expression = bfunc_by_rnd_expr,
	program32 = dim -> bfunc_by_rnd_prog(dim, 32),
	program64 = dim -> bfunc_by_rnd_prog(dim, 64),
	program128 = dim -> bfunc_by_rnd_prog(dim, 128),
	program32xor = dim -> bfunc_by_rnd_prog(dim, 32, "xor"),
	program32notand = dim -> bfunc_by_rnd_prog(dim, 32, "~ &"),
	#program256 = dim -> bfunc_by_rnd_prog(dim, 256),
	#program512 = dim -> bfunc_by_rnd_prog(dim, 512),
	)

# ╔═╡ 2c5f16fc-f8a8-4991-b777-2b74cddfe1d7
n_samples = 1000

# ╔═╡ d42204e3-df2c-4a04-b2c3-e5b8aeba7c07
function distributions(dim, samples = n_samples)
	[k => [Sensitivity.dirichlet_energy(GENERATORS[k](dim), dim) for _ in 1:samples]
		for k in keys(GENERATORS)] |> DataFrame
end
	

# ╔═╡ 2ac91393-056d-462d-b4d1-347c3fa0f9d6
function sample_generator(gen, dim, samples = n_samples)
	[Sensitivity.dirichlet_energy(gen(dim), dim) for _ in 1:samples]
end

# ╔═╡ aab7b362-a668-405a-99f9-2c0f2ed8ae7c
x = range(0, 1, length = n_samples)

# ╔═╡ ab94bf4c-5e22-4859-b118-3eef6aa88c04
function plot_distribution(vec::Vector, name)
	#plot(fit(Normal, vec), lw=3)
	@pgf PGFPlotsX.Axis({ xlabel = name, ylabel = "pdf" },
          PGFPlotsX.Plot({thick, blue }, Table(x, pdf.(fit(Normal, vec), x))))
end

# ╔═╡ f9770acb-9104-4b08-ae18-d945ad17e5a4


# ╔═╡ a275d09c-f044-4e52-ba14-5cf5089b7102
function plot_distribution(D::DataFrame, name)
	plot_distribution(D[!, name], name)
	#@pgf Axis({ xlabel = name, ylabel = "pdf" },
    #      PGFPlotsX.Plot({thick, blue }, Table(x, pdf.(fit(Normal, D[!, name]), x))))
end

# ╔═╡ 07e4e2fc-00d7-41fc-bb7e-63aeefd73a5f
function plot_distributions(D)
	[plot_distribution(D, name) for name in names(D)]
end

# ╔═╡ f4bc4bef-a589-4297-a461-faeb8683914e
plot_distributions(distributions(3))

# ╔═╡ 28bf94c9-12d3-497b-917b-cfcece527e33
plot_distributions(distributions(4))

# ╔═╡ 708edd80-42ea-4033-b900-c27e7ba74eee
#plot_distributions(distributions(5))

# ╔═╡ edf9f31c-dc91-46d9-baef-eda4ce9a64db
#plot_distributions(distributions(6))

# ╔═╡ 7e63ddfb-6c9d-457a-b927-5c51b65d68f8
#plot_distributions(distributions(8))

# ╔═╡ f31072b1-e872-4a51-8a63-8df170165056
#plot_distributions(distributions(10))

# ╔═╡ f7e39a3b-14ba-4682-b386-a4b08525a955
D2 = distributions(2)

# ╔═╡ 9f651db0-3611-437a-a852-f3ba0c385c79
rows = collect(eachrow(D2))

# ╔═╡ 6f9e3071-8488-438b-b7fe-c779d767f780
u2 = unique(D2.vector)

# ╔═╡ b085a2e6-1193-4d3c-856d-da44ab6d9af2
u3 = (unique(sample_generator(GENERATORS.vector, 3, 100000))) |> sort

# ╔═╡ 0a8e8ef5-7558-4180-ab76-319d8db8f4a6


# ╔═╡ 137353ab-751e-4109-b301-87ac28ecff47
let dim = 3
	vectors = colorant"red" .* [Expressions.bits(I, 2^dim) for I in 0:2^(2^dim)-1]
end

# ╔═╡ 7750a86b-e502-4a45-9677-b000ef88fc94
numfuncs(dim) = 2^(2^dim)

# ╔═╡ a20e6356-afe2-4380-a076-2404b06f40b4
function allfuncs(dim)
	wrap = FunctionWrapper{Bool, Tuple{BitVector}}
	vectors = [Expressions.bits(I, 2^dim) |> BitVector for I in 0:2^(2^dim)-1]
	[wrap(bv -> vector[bitv_to_int(bv)+1]) for vector in vectors]
end

# ╔═╡ 0f09f58d-aff7-400a-ae78-5308b878e48a
bool_funcs_on_3cube = allfuncs(3)

# ╔═╡ 787b233a-5c90-4f9c-af4a-942ae8e26129
energies_on_3cube = [Sensitivity.dirichlet_energy(f, 3) for f in bool_funcs_on_3cube]

# ╔═╡ f6fee4e2-cff4-4814-99c3-b0ef7ca4d965
distinct_energies_on_3cube = energies_on_3cube |> unique |> sort

# ╔═╡ 8bf52a33-60ca-4203-938a-ab34ee8025b3


# ╔═╡ 2cf5c4c2-deee-4648-a0ec-7acf7a537736
Plots.histogram(range(0//12, 12//12, step=1//12), 
	energies_on_3cube, 
	xtick=[x for x in range(0//12, 12//12, step=1//4)], 
	bins=range(0, stop=1.000001, length=12))

# ╔═╡ ac1d8933-6e9d-441c-9a96-80397190431c
plot_distribution(energies_on_3cube, "energies on cube")

# ╔═╡ 3bb91cde-9c56-4e53-afae-8bbc20dff83e
D3 = distributions(3)

# ╔═╡ e6e51786-5d29-4177-bc15-f40b9e9d5409
md"might be nice to have the sensitivity analysis yield a rational number response, which could then be converted to float. TODO"

# ╔═╡ dfc9c722-bfe8-479b-91ed-9ca98558953f
#plot_distributions(distributions(12))

# ╔═╡ 8ecf4ede-f882-4bdb-b7e1-8098b07e6591
md"# Now, with Evolution"

# ╔═╡ d8ac5a80-30fd-43e2-a30b-e2339f3c212b


# ╔═╡ 4e8ec8ef-2152-4118-b924-8fb0c77105a2
config_txt = """
experiment_duration: 50000
step_duration: 1
preserve_population: true
experiment: "maximize-energy"

selection:
  fitness_function: "fit"
# any data will do, since truth tables are identical beyond the last col
  data: "./samples/2-MUX_overs-cohos-orbed_ALL.csv"
  d_fitness: 4
  t_size: 6
  fitness_sharing: true
  trace: true
  lexical: true
  fitness_weights:
    dirichlet: 10
    ingenuity: 1000
    information: 100
    parsimony: 5

genotype:
  max_depth: 8
  min_len: 4
  max_len: 200
  data_n: 6
  registers_n: 5
  output_reg: 1
  max_steps: 512
  mutation_rate: 0.1
  weight_crossover_points: false
  ops: "| & ~ mov xor"

population:
  size: [10, 10]
  toroidal: true
  locality: 16
  n_elites: 10
  migration_rate: 0.2
  migration_type: "elite"

logging:
  log_every: 1
  save_every: 50

dashboard:
  server: "0.0.0.0"
  port: 9124
  enable: false
"""

# ╔═╡ 8fc9944a-8a02-4bba-b6a1-3b55df55ab52
write("/tmp/energy-max.yaml", config_txt)

# ╔═╡ e796384d-42ff-49ee-a77b-a6544de30cc2
config = prep_config("/tmp/energy-max.yaml")

# ╔═╡ 99e0594d-5384-42b8-a3be-9d581215c1f1


# ╔═╡ af7c8f36-f37f-423f-af43-f77b65a5e33a
INPUT = begin 
	FF._set_data(config.selection.data)
	FF.INPUT
end

# ╔═╡ 16b54726-3d61-42db-893a-e47e6ccc291d
function maximize_energy_ff(geo, i)
	g = geo.deme[i]
	if isfinite(g.fitness.dirichlet)
		return g.fitness
	end
	if g.phenotype === nothing
		res, _ = FF.evaluate(g, config = geo.config,
			INPUT = INPUT,
			make_trace = false)
		g.phenotype = (results = res, trace_info = [1 for _ in g.chromosome])
	end
	dirichlet = FF.dirichlet_energy_of_phenotype(
		g.phenotype, 
		geo.config) |> Float64
	g.fitness = (
		dirichlet = dirichlet,
		ingenuity = 0.0,
		information = 0.0,
		parsimony = 0.0,
	)
	return g.fitness
end

# ╔═╡ bf4a8ad7-7c6e-4873-be92-1cd03497f788


# ╔═╡ 8109a1c5-6187-4a9f-9200-801cc5ce9050
function evolve(steps)
	EVO = Cockatrice.Evo.Evolution(
        config,
        creature_type = LinearGenotype.Creature,
        fitness = maximize_energy_ff,
        tracers = TRACERS,
        mutate = LinearGenotype.mutate!,
        crossover = LinearGenotype.crossover,
        objective_performance = objective_performance,
    )
	# get an initial measure of the population
	for i in eachindex(EVO.geo.deme)
		maximize_energy_ff(EVO.geo, i)
	end
	for i in 1:steps
		Cockatrice.Evo.step!(EVO)
	end
	population_energies = [g.fitness.dirichlet for g in EVO.geo.deme]
	plot_distribution(filter(isfinite, vec(population_energies)), "population energies after $steps steps")
end


# ╔═╡ 0f2b8c8b-6d60-4813-835f-867c4d654afe
evolve(0)

# ╔═╡ 58a32aa9-1ec9-4d9d-a613-1e48708ff649


# ╔═╡ 46c9a01f-4a83-4876-8c4a-fefec75e75ce
evolve(10)

# ╔═╡ d0d786b3-1979-4f1d-97b3-9422f7654261
evolve(100)

# ╔═╡ 512dfc65-9cef-40ff-8692-e6664172498f
evolve(1000)

# ╔═╡ 57c914f2-bf7c-43ff-979d-b379514e5047
evolve(10000)

# ╔═╡ 568dc58e-406a-4601-823e-ee4cd66d7bcb
#population_funcs = [bfunc_by_prog(g.chromosome) for g in EVO.geo.deme]

# ╔═╡ 9970f1b8-b4df-4928-8e05-323995bd3652


# ╔═╡ fbfb7447-d3d3-4dfb-9bae-b529527a2002


# ╔═╡ Cell order:
# ╠═0424a62a-3692-11ec-3d69-158cb1b525d0
# ╠═d31dfd8f-2442-46cc-b788-3751a4f74308
# ╠═0cba539b-f584-4ecc-8aba-271850962e61
# ╠═dad07b34-0884-4f8d-970d-0b6ba744856e
# ╠═6c7d69c4-15bd-4e3c-82d0-843a2502d152
# ╠═a8291800-35c5-464f-bbf4-485cf5cfe6a6
# ╠═36e1a9e3-4b74-4dde-9892-cb15687522ec
# ╠═fc9a3455-dc8e-4115-bab8-07648104affd
# ╠═7c042acb-9364-4f2a-b7bb-dab11241fa92
# ╠═e33a17dd-e519-45d5-836a-b2804390d399
# ╠═5262a2d0-e042-4cc1-90f7-28e98af93479
# ╠═fd1b7bdb-1332-49e7-a9be-86753e3aa8a1
# ╠═b3f5b9ae-2504-434e-8289-2248e91da60e
# ╠═67e4629b-17ef-47dd-bd25-cd0d1661f65e
# ╠═824404db-2b5b-43b5-b997-18ba35c93a0e
# ╠═3d833fe9-86ff-47af-a091-a1ea1018cc37
# ╠═feaf71eb-6eb8-4df4-a051-e7462613df47
# ╠═aed154fa-cd6f-4b09-b43e-9029c990f51e
# ╠═d51112b5-55a2-42c9-a094-f0703f382827
# ╠═2c5f16fc-f8a8-4991-b777-2b74cddfe1d7
# ╠═d42204e3-df2c-4a04-b2c3-e5b8aeba7c07
# ╠═2ac91393-056d-462d-b4d1-347c3fa0f9d6
# ╠═aab7b362-a668-405a-99f9-2c0f2ed8ae7c
# ╠═ab94bf4c-5e22-4859-b118-3eef6aa88c04
# ╠═f9770acb-9104-4b08-ae18-d945ad17e5a4
# ╠═a275d09c-f044-4e52-ba14-5cf5089b7102
# ╠═07e4e2fc-00d7-41fc-bb7e-63aeefd73a5f
# ╠═f4bc4bef-a589-4297-a461-faeb8683914e
# ╠═28bf94c9-12d3-497b-917b-cfcece527e33
# ╠═708edd80-42ea-4033-b900-c27e7ba74eee
# ╠═edf9f31c-dc91-46d9-baef-eda4ce9a64db
# ╠═7e63ddfb-6c9d-457a-b927-5c51b65d68f8
# ╠═f31072b1-e872-4a51-8a63-8df170165056
# ╠═f7e39a3b-14ba-4682-b386-a4b08525a955
# ╠═9f651db0-3611-437a-a852-f3ba0c385c79
# ╠═6f9e3071-8488-438b-b7fe-c779d767f780
# ╠═b085a2e6-1193-4d3c-856d-da44ab6d9af2
# ╠═0a8e8ef5-7558-4180-ab76-319d8db8f4a6
# ╠═42e1aad9-6330-40e9-9aea-f7558edf4f1d
# ╠═137353ab-751e-4109-b301-87ac28ecff47
# ╠═7750a86b-e502-4a45-9677-b000ef88fc94
# ╠═a20e6356-afe2-4380-a076-2404b06f40b4
# ╠═0f09f58d-aff7-400a-ae78-5308b878e48a
# ╠═787b233a-5c90-4f9c-af4a-942ae8e26129
# ╠═f6fee4e2-cff4-4814-99c3-b0ef7ca4d965
# ╠═8bf52a33-60ca-4203-938a-ab34ee8025b3
# ╠═2cf5c4c2-deee-4648-a0ec-7acf7a537736
# ╠═ac1d8933-6e9d-441c-9a96-80397190431c
# ╠═3bb91cde-9c56-4e53-afae-8bbc20dff83e
# ╠═e6e51786-5d29-4177-bc15-f40b9e9d5409
# ╠═dfc9c722-bfe8-479b-91ed-9ca98558953f
# ╠═8ecf4ede-f882-4bdb-b7e1-8098b07e6591
# ╠═d8ac5a80-30fd-43e2-a30b-e2339f3c212b
# ╠═4e8ec8ef-2152-4118-b924-8fb0c77105a2
# ╠═8fc9944a-8a02-4bba-b6a1-3b55df55ab52
# ╠═e796384d-42ff-49ee-a77b-a6544de30cc2
# ╠═99e0594d-5384-42b8-a3be-9d581215c1f1
# ╠═af7c8f36-f37f-423f-af43-f77b65a5e33a
# ╠═16b54726-3d61-42db-893a-e47e6ccc291d
# ╠═bf4a8ad7-7c6e-4873-be92-1cd03497f788
# ╠═8109a1c5-6187-4a9f-9200-801cc5ce9050
# ╠═0f2b8c8b-6d60-4813-835f-867c4d654afe
# ╠═58a32aa9-1ec9-4d9d-a613-1e48708ff649
# ╠═46c9a01f-4a83-4876-8c4a-fefec75e75ce
# ╠═d0d786b3-1979-4f1d-97b3-9422f7654261
# ╠═512dfc65-9cef-40ff-8692-e6664172498f
# ╠═57c914f2-bf7c-43ff-979d-b379514e5047
# ╠═568dc58e-406a-4601-823e-ee4cd66d7bcb
# ╠═9970f1b8-b4df-4928-8e05-323995bd3652
# ╠═fbfb7447-d3d3-4dfb-9bae-b529527a2002
