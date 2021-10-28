### A Pluto.jl notebook ###
# v0.16.4

using Markdown
using InteractiveUtils

# ╔═╡ 3a415ec7-1a98-49a0-b00f-944dbdeb3e4b
begin
	cd("$(ENV["HOME"])/src/refusr/Refusr")
	using Pkg
	Pkg.activate(".")
	include("./src/base.jl")
end

# ╔═╡ 199ee413-ca1c-41bb-b91f-a276b05beca0
using SimplePosets, LightGraphs

# ╔═╡ 669b8085-8f59-4703-8f2b-210363802073
using GraphPlot, MetaGraphs

# ╔═╡ cd9c9d35-d99b-429e-843b-09e1d33f228d
using Images

# ╔═╡ c5150d39-cca8-48d0-bbc4-3de23b862b6a
using GraphRecipes

# ╔═╡ e8132e60-67b3-4349-a952-e8eda63d3ffa
using Statistics

# ╔═╡ 8f536d2e-0057-11ec-007a-0db07da069f1
md"# Experiments re: the Sensitivity of Boolean Functions"

# ╔═╡ 7783c61d-7876-4abc-8ded-3aab14314388
dim = 4

# ╔═╡ 5981ae01-914e-44cb-aed8-b1e939fa88bf
e = Expressions.grow(dim)

# ╔═╡ 1e7aa9a0-7709-4bf4-b221-d16727718a0a
truth_matrix(e) = Bool.(Expressions.truth_table(e)) |> Matrix{Bool} |> BitArray

# ╔═╡ 9bbbc5a0-ed90-49b1-8942-731c9c803bb9
t = truth_matrix(e)

# ╔═╡ cdae07b2-1f14-42db-b05f-2f45648a3c75
the_vertices = t[:,1:end-1] |> eachrow |> collect

# ╔═╡ 792f4da3-fe3d-489e-9d77-27a147b58d43


# ╔═╡ 70a71b3f-a72f-48a0-8d7b-17bfa481e1f3
function lattice(dim)
	unstring(s) = BitVector(parse(Bool,ch) for ch in s)
	B = BooleanLattice(dim)
	R = [unstring.(r) for r in relations(B)]
	L = SimplePoset(BitVector)
	for (x,y) in R
		add!(L, x, y)
	end
	L
end

# ╔═╡ edd4880c-24c3-452d-9ca5-1f7bc6735349
function hypercube(L::SimplePoset)
	# assume L is a lattice
	# this is another translation wrapper, to translate a simple poset
	# into a LightGraphs compatible graph, instead of using the
	# SimplePosets author's own graph library
	A = CoverDigraph(L) |> SimplePosets.SimpleGraphs.adjacency
	g = LightGraphs.SimpleGraph(A + A')
	G = MetaGraph(g)
	for (v, e) in zip(vertices(g), elements(L))
		set_prop!(G, v, :value, e)
		set_prop!(G, v, :label, join(string.(Int.(e)), ""))
	end
	G
	
end

# ╔═╡ c72b9599-4249-4ab8-9541-10e5a57e9a94


# ╔═╡ 335703b5-dbde-43be-85f4-bd1ee529441b
hypercube(dim::Integer) = hypercube(lattice(dim))

# ╔═╡ 113a4069-1228-40a5-bd8a-681fca420c30
B = lattice(dim)

# ╔═╡ 8e96b767-7f7a-4c1d-8911-32fd50d023a8
A = CoverDigraph(B) |> SimplePosets.SimpleGraphs.adjacency

# ╔═╡ 69bdeedd-33a7-49cc-9116-bb7b6dccea2e
A' + A

# ╔═╡ dacc2fc7-c61f-4249-a660-9d7851053250
vname(v) = join(string.(Int.(v)),"")

# ╔═╡ dabd57b5-2d53-49a5-a68a-32beddede165
Q = hypercube(B)

# ╔═╡ cc84d907-483f-4646-991b-98ef5833b952
gplot(Q,
	nodelabel=[get_prop(Q, v, :label) for v in vertices(Q)],
	edgelinewidth=0.5,
	edgestrokec=RGBA(0.2,0.2,0.2,0.1),
	nodefillc=[RGBA(0,0.5,0,0.1) for _ in elements(B)])

# ╔═╡ 96054fe6-539f-44aa-8a89-a8cc5f073152
graphplot(Q, names=[get_prop(Q, v, :label) for v in vertices(Q)]) # alternate graph plotting function, kinda weird looking

# ╔═╡ 2960416f-1503-42f7-9b1b-bf05481a845b
md"Wonderful, the order is preserved through these janky translations."

# ╔═╡ ed2043ab-c421-4d51-9c57-8d8e1284bf99
function mapvertex(f, G)
	[f(get_prop(G, v, :value)) for v in vertices(G)]
end

# ╔═╡ 48a624bf-278d-4e47-ae96-5bdc7858ad2b
function eval_at_vertex(expr, G, v)
	Expressions.evalwith(expr, D=get_prop(G, v, :value))
end

# ╔═╡ faa58a00-b8fc-4890-9b3e-8548110061fd
ex = Expressions.grow(dim)

# ╔═╡ 0e1df530-77ac-4a82-88c1-59187c3218d6
[eval_at_vertex(ex, Q, v) for v in vertices(Q)]

# ╔═╡ 1b29469c-2cf0-474c-a10b-20c3a5c8d9f3
mapvertex(v -> Expressions.evalwith(ex, D=v), Q)

# ╔═╡ fc6182cb-8711-43e5-9f30-a62011059248
vals = [get_prop(Q, v, :value) for v in vertices(Q)]

# ╔═╡ 4971cded-30e3-4524-a01d-8589c9f0a0ba
Expressions.evalwith(e, D=vals[1])

# ╔═╡ dedfd8a6-c637-4a82-9497-84b768028fb4
gplot(Q,
	nodelabel=[get_prop(Q, v, :label) for v in vertices(Q)],
	edgelinewidth=0.5,
	edgestrokec=RGBA(0.2,0.2,0.2,0.1),
	nodefillc=[RGBA(x,!x,0,0.4) for x in (eval_at_vertex(ex, Q, v) for v in vertices(Q))])

# ╔═╡ bf9e7900-9ad6-44dd-aa46-a371ad6b8fcd
Expressions.variables_used_upper_bound(ex)

# ╔═╡ ef007aa4-9186-4ca3-a915-ee605a5e324b
function evaluated_hypercube(L, expr)
	Q = hypercube(L)
	for v in vertices(Q)
		set_prop!(Q, v, :f, eval_at_vertex(expr, Q, v))
	end
	return Q
end

# ╔═╡ f7239c62-f213-47fc-8f29-debe1c895dd6
expr = Expressions.grow(dim)

# ╔═╡ 3722930f-02fe-4806-836d-147b23816345
H = evaluated_hypercube(lattice(dim), expr)

# ╔═╡ 19cc3f6f-33ee-4697-8464-8388d607404d
δ(H)

# ╔═╡ e282e255-b4a6-4040-9f94-5d3eeeb6be4b
to_Z(b) = b ? 1 : -1

# ╔═╡ 2373001b-7f46-4cb5-98de-f73607415189
function dirichlet_energy!(H)
	for v in vertices(H)
		x = get_prop(H, v, :value)
		fx = get_prop(H, v, :f) |> to_Z
		nfxs = [get_prop(H, n, :f) |> to_Z for n in all_neighbors(H, v)]
		energy = (((nfxs .- fx) ./ 2.0) .^ 2) |> mean
		set_prop!(H, v, :energy, energy)
	end
end
		
		

# ╔═╡ 7f0822cc-a817-42fe-824b-ea0a03636b09
dirichlet_energy!(H)

# ╔═╡ 4072b165-56e1-4ed3-b6d4-3fd8470feffb
function vis(Q)
	gplot(Q,
	nodelabel=[get_prop(Q, v, :label) for v in vertices(Q)],
	edgelinewidth=0.5,
	edgestrokec=RGBA(0.2,0.2,0.2,0.1),
	nodefillc=[RGBA(x,!x,0,0.4) for x in (get_prop(Q, v, :f) for v in vertices(Q))])
end

# ╔═╡ 62a2d107-5c81-4d76-9bac-d7ecac19e4fe
vis(H)

# ╔═╡ d7ed744d-b4ea-4c87-b250-032143573dd3
function vis_energy(Q)
	gplot(Q,
	nodelabel=[get_prop(Q, v, :label) for v in vertices(Q)],
	edgelinewidth=0.5,
	edgestrokec=RGBA(0.2,0.2,0.2,0.1),
	nodefillc=[RGBA(get_prop(Q, v, :energy),0,0, 1) for (x,v) in ((get_prop(Q, v, :f),v) for v in vertices(Q))])
end

# ╔═╡ b332b713-b2fb-4902-8537-d1987133349f
expr |> Expressions.simplify

# ╔═╡ 8b93c0e6-ac25-475c-a91f-ddf5b7a3cab7
vis_energy(H)

# ╔═╡ 45a019d3-b4d1-402a-8765-760887118ec3
[get_prop(H, v, :energy) for v in vertices(H)]

# ╔═╡ Cell order:
# ╠═8f536d2e-0057-11ec-007a-0db07da069f1
# ╠═3a415ec7-1a98-49a0-b00f-944dbdeb3e4b
# ╠═199ee413-ca1c-41bb-b91f-a276b05beca0
# ╠═669b8085-8f59-4703-8f2b-210363802073
# ╠═7783c61d-7876-4abc-8ded-3aab14314388
# ╠═5981ae01-914e-44cb-aed8-b1e939fa88bf
# ╠═1e7aa9a0-7709-4bf4-b221-d16727718a0a
# ╠═9bbbc5a0-ed90-49b1-8942-731c9c803bb9
# ╠═cdae07b2-1f14-42db-b05f-2f45648a3c75
# ╠═792f4da3-fe3d-489e-9d77-27a147b58d43
# ╠═70a71b3f-a72f-48a0-8d7b-17bfa481e1f3
# ╠═edd4880c-24c3-452d-9ca5-1f7bc6735349
# ╠═c72b9599-4249-4ab8-9541-10e5a57e9a94
# ╠═335703b5-dbde-43be-85f4-bd1ee529441b
# ╠═8e96b767-7f7a-4c1d-8911-32fd50d023a8
# ╠═69bdeedd-33a7-49cc-9116-bb7b6dccea2e
# ╠═113a4069-1228-40a5-bd8a-681fca420c30
# ╠═dacc2fc7-c61f-4249-a660-9d7851053250
# ╠═dabd57b5-2d53-49a5-a68a-32beddede165
# ╠═cd9c9d35-d99b-429e-843b-09e1d33f228d
# ╠═c5150d39-cca8-48d0-bbc4-3de23b862b6a
# ╠═cc84d907-483f-4646-991b-98ef5833b952
# ╠═96054fe6-539f-44aa-8a89-a8cc5f073152
# ╠═2960416f-1503-42f7-9b1b-bf05481a845b
# ╠═ed2043ab-c421-4d51-9c57-8d8e1284bf99
# ╠═48a624bf-278d-4e47-ae96-5bdc7858ad2b
# ╠═faa58a00-b8fc-4890-9b3e-8548110061fd
# ╠═0e1df530-77ac-4a82-88c1-59187c3218d6
# ╠═1b29469c-2cf0-474c-a10b-20c3a5c8d9f3
# ╠═fc6182cb-8711-43e5-9f30-a62011059248
# ╠═4971cded-30e3-4524-a01d-8589c9f0a0ba
# ╠═dedfd8a6-c637-4a82-9497-84b768028fb4
# ╠═bf9e7900-9ad6-44dd-aa46-a371ad6b8fcd
# ╠═ef007aa4-9186-4ca3-a915-ee605a5e324b
# ╠═f7239c62-f213-47fc-8f29-debe1c895dd6
# ╠═3722930f-02fe-4806-836d-147b23816345
# ╠═62a2d107-5c81-4d76-9bac-d7ecac19e4fe
# ╠═19cc3f6f-33ee-4697-8464-8388d607404d
# ╠═e282e255-b4a6-4040-9f94-5d3eeeb6be4b
# ╠═e8132e60-67b3-4349-a952-e8eda63d3ffa
# ╠═2373001b-7f46-4cb5-98de-f73607415189
# ╠═7f0822cc-a817-42fe-824b-ea0a03636b09
# ╠═4072b165-56e1-4ed3-b6d4-3fd8470feffb
# ╠═d7ed744d-b4ea-4c87-b250-032143573dd3
# ╠═b332b713-b2fb-4902-8537-d1987133349f
# ╠═8b93c0e6-ac25-475c-a91f-ddf5b7a3cab7
# ╠═45a019d3-b4d1-402a-8765-760887118ec3
