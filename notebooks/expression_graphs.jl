### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ 2640b027-31a2-4295-9ed7-ef40be72ec4a
begin
	cd("$(ENV["HOME"])/src/refusr/Refusr")
	using Pkg
	Pkg.activate(".")
	include("./src/base.jl")
end

# ╔═╡ 61b745b1-36a5-4639-bb13-483d2234cc45
using LightGraphs

# ╔═╡ aff0448a-ee50-11eb-3c22-05686eb71ea9
md"# Graph representations of expressions"

# ╔═╡ 8ae8bd36-cff1-4695-a8df-521e0908b9d0
md"TreeView kind of sucks. Let's try and do better."

# ╔═╡ 04ff106b-0753-400e-b889-be025cc9e590
label(e::Expr) = e.head === :call ? string(e.args[1]) : string(e)

# ╔═╡ f9a800ed-adf9-46e4-9f5b-ac3576407269
MUX3 = read("./MUX3-champ-simplified.sexp", String) |> Meta.parse

# ╔═╡ 246044c4-559c-4250-8748-faf66d31cdc1
label(MUX3)

# ╔═╡ 69ab553d-4ad6-41b1-a7d0-1d94c7686a31


# ╔═╡ Cell order:
# ╠═aff0448a-ee50-11eb-3c22-05686eb71ea9
# ╠═8ae8bd36-cff1-4695-a8df-521e0908b9d0
# ╠═2640b027-31a2-4295-9ed7-ef40be72ec4a
# ╠═61b745b1-36a5-4639-bb13-483d2234cc45
# ╠═04ff106b-0753-400e-b889-be025cc9e590
# ╠═f9a800ed-adf9-46e4-9f5b-ac3576407269
# ╠═246044c4-559c-4250-8748-faf66d31cdc1
# ╠═69ab553d-4ad6-41b1-a7d0-1d94c7686a31
