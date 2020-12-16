### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ dc8bd81a-34d8-11eb-0317-d5ce35b2e9fa
md"# Analysis of Boolean Functions"

# ╔═╡ e85b29c0-34d8-11eb-2829-bda3644bd19b
md"Let's define a few convenience functions for generating truth tables."

# ╔═╡ 4170df98-34dc-11eb-17d3-1ba78682c54f
function ttargs(arity)
	m = zeros(Int, arity, 2^arity) 
	for i in 1:(2^arity)
		m[:,i] = digits(i-1, base=2, pad=arity) |> reverse 
	end
	m[m.==0] .= -1
	m 
end
	

# ╔═╡ 1a50e434-34dd-11eb-1493-edd42e64fb60
ttargs(4)

# ╔═╡ 1d4a5aa0-34dd-11eb-3e6e-033c25da6b6e
function random_truth_table(arity)
	args = ttargs(arity)
	vcat(args, rand((-1,1), 2^arity) |> transpose)
end

# ╔═╡ 2869d9b4-34de-11eb-264e-b5946c50a4fc
tt = random_truth_table(3)

# ╔═╡ 169eb72a-34e8-11eb-0a81-fd03a36c41b8
function truth_table_dict(table)
	n = size(table,2)
	[Tuple(x[1:end-1]) => x[end] for x in [table[:,i] for i in 1:n]] |> Dict
end

# ╔═╡ 36adba34-34e8-11eb-31f0-4dcd5370f492
d = truth_table_dict(tt)

# ╔═╡ 9e90ddd6-34e6-11eb-29d9-85794b97ae14
function tt_to_func(table)
	lookup = truth_table_dict(table)
	λ(args...) = lookup[args]
end
		

# ╔═╡ e8e5fe1a-34e7-11eb-083a-051605f26122
f = tt_to_func(tt)

# ╔═╡ f7774588-34e7-11eb-00c4-b7305dfa10cb
f(-1,-1,1)

# ╔═╡ f054ab00-34e3-11eb-0d64-03a252187f0b
md"Given an arbitrary Boolean function $f : \{-1,1\}^n \rightarrow \{-1,1\}$ there is a familiar method for finding a polynomial that interpolates the $2^n$ values that $f$ assigns to the points $\{-1,1\}^n \subset \mathbb{R}$. For each point $a = (a_1, \dots a_n) \in \{-1,1\}^n$ the _indicator polynomial_ 

$$\mathbb{1}_{\{a\}}(x) = (\frac{1+a_1x_1}{2})(\frac{1+a_2x_2}{2}) \cdots (\frac{1+a_{n}x_{n}}{2})$$

takes value 1 when $x = a$ and value 0 when $x \in \{-1,1\}^n \\ {a}$. Thus $f$ has the polynomial representation 

$$f(x) = \sum_{a \in \{-1,1\}^n} f(a)\mathbb{1}_{\{a\}}(x)$$
"

# ╔═╡ eb9b1308-34e1-11eb-2fb5-c3f55e90de33
function indicator(a)
	function λ(x)
		map(zip(a,x)) do (α,ξ)
			(1.0 + α * ξ) / 2.0
		end |> prod
	end
end
			

# ╔═╡ e3f8827e-34e2-11eb-3a9d-eb6893c339a7
p = indicator([-1,-1,-1,1])

# ╔═╡ f8f84d26-34e2-11eb-3cec-8b38373515d8
p([-1,-1,1,1])

# ╔═╡ 806127ba-34e8-11eb-38b6-2b8a6c5ddea6
function indicator_polynomial(table)
	𝒻 = tt_to_func(table)
	function λ(𝓍...)
		map(1:size(table,2)) do i
			a = table[:,i]
			args = a[1:end-1]
			𝟙ₐ = indicator(a)
			𝒻(args...) * 𝟙ₐ(𝓍)
		end |> sum
	end
end

# ╔═╡ 727b3d76-34ec-11eb-2481-5912b0730790
function make_truth_table(𝒻, arity=nothing)
	if arity ≡ nothing
		arity = first(methods(𝒻)).nargs - 1
	end
	@show arity
	@show args = ttargs(arity)
	cols = map(eachcol(args)) do col
		[col..., 𝒻(col...)]
	end
	hcat(cols...)
end
	

# ╔═╡ e8d2fda0-34ed-11eb-15c7-631e0d237c7e
ttargs(2)

# ╔═╡ be80f840-34ed-11eb-1dc3-4b510f2d47cb
AND(a,b) = min(a,b)

# ╔═╡ c9b5eb62-34ed-11eb-0f75-c3d2e29c04d5
ANDtt = make_truth_table(AND)

# ╔═╡ 6d6ec566-34ea-11eb-28cf-5bb527b35704
𝕡 = indicator_polynomial(ANDtt)

# ╔═╡ 1f40ce0a-34ec-11eb-061a-a5fe8183cd69
ANDtt

# ╔═╡ 7a00d094-34ea-11eb-13d5-bd206258d7b6
𝕡(1,1)

# ╔═╡ 2ae49d40-34ec-11eb-163b-ebd2698ff48c
𝒻 = tt_to_func(tt)

# ╔═╡ 3e6da000-34ec-11eb-0186-03da8816c546
𝒻(1,1,1)

# ╔═╡ 3684cd50-34ec-11eb-1966-ffe616c6de85
AND_m_tt = make_truth_table((a,b) -> 𝕡(a,b))

# ╔═╡ 34be8a06-34ec-11eb-29b5-4f9ba8c15abd
MAJ₃(a,b,c) = max(a,b,c)

# ╔═╡ 870e97a0-34ea-11eb-0e39-799d307c347e
MAJ₃tt = make_truth_table(MAJ₃, 3)

# ╔═╡ b0f43f1a-34e2-11eb-355a-1f4efdecb788
MAJ₃ᵖ = indicator_polynomial(MAJ₃tt)

# ╔═╡ 4ec588b2-34e2-11eb-3d62-4b146140211e
MAJ₃ᵖtt = make_truth_table(MAJ₃ᵖ, 3)

# ╔═╡ 4331b040-34f1-11eb-2ab6-31ddb9e42d8a
MAJ₃ᵖᵖ = indicator_polynomial(MAJ₃ᵖtt)

# ╔═╡ 7385a198-34f1-11eb-268d-ef927ca06b18
MAJ₃ᵖᵖtt = make_truth_table(MAJ₃ᵖᵖ, 3)

# ╔═╡ 8aede294-34f1-11eb-0587-b560e190a74f
MAJ₃ᵖᵖtt == MAJ₃ᵖtt

# ╔═╡ 9a6595a2-34f1-11eb-20ba-59687de0be01
XOR(a,b) = (a > 0.0) ^ (b > 0.0) ? 1.0 : -1.0

# ╔═╡ 3d9b0ae6-34f6-11eb-3103-8330ac256477
make_truth_table(XOR, 2)

# ╔═╡ 441d4df2-34f6-11eb-2f28-d1be566ae3d5
XORᵖ = indicator_polynomial(make_truth_table(XOR, 2))

# ╔═╡ 74068b5a-34f6-11eb-0636-df830c3a8e91


# ╔═╡ Cell order:
# ╠═dc8bd81a-34d8-11eb-0317-d5ce35b2e9fa
# ╠═e85b29c0-34d8-11eb-2829-bda3644bd19b
# ╠═4170df98-34dc-11eb-17d3-1ba78682c54f
# ╠═1a50e434-34dd-11eb-1493-edd42e64fb60
# ╠═1d4a5aa0-34dd-11eb-3e6e-033c25da6b6e
# ╠═2869d9b4-34de-11eb-264e-b5946c50a4fc
# ╠═169eb72a-34e8-11eb-0a81-fd03a36c41b8
# ╠═36adba34-34e8-11eb-31f0-4dcd5370f492
# ╠═9e90ddd6-34e6-11eb-29d9-85794b97ae14
# ╠═e8e5fe1a-34e7-11eb-083a-051605f26122
# ╠═f7774588-34e7-11eb-00c4-b7305dfa10cb
# ╟─f054ab00-34e3-11eb-0d64-03a252187f0b
# ╠═eb9b1308-34e1-11eb-2fb5-c3f55e90de33
# ╠═e3f8827e-34e2-11eb-3a9d-eb6893c339a7
# ╠═f8f84d26-34e2-11eb-3cec-8b38373515d8
# ╠═806127ba-34e8-11eb-38b6-2b8a6c5ddea6
# ╠═727b3d76-34ec-11eb-2481-5912b0730790
# ╠═e8d2fda0-34ed-11eb-15c7-631e0d237c7e
# ╠═be80f840-34ed-11eb-1dc3-4b510f2d47cb
# ╠═c9b5eb62-34ed-11eb-0f75-c3d2e29c04d5
# ╠═6d6ec566-34ea-11eb-28cf-5bb527b35704
# ╠═1f40ce0a-34ec-11eb-061a-a5fe8183cd69
# ╠═7a00d094-34ea-11eb-13d5-bd206258d7b6
# ╠═2ae49d40-34ec-11eb-163b-ebd2698ff48c
# ╠═3e6da000-34ec-11eb-0186-03da8816c546
# ╠═3684cd50-34ec-11eb-1966-ffe616c6de85
# ╠═34be8a06-34ec-11eb-29b5-4f9ba8c15abd
# ╠═870e97a0-34ea-11eb-0e39-799d307c347e
# ╠═b0f43f1a-34e2-11eb-355a-1f4efdecb788
# ╠═4ec588b2-34e2-11eb-3d62-4b146140211e
# ╠═4331b040-34f1-11eb-2ab6-31ddb9e42d8a
# ╠═7385a198-34f1-11eb-268d-ef927ca06b18
# ╠═8aede294-34f1-11eb-0587-b560e190a74f
# ╠═9a6595a2-34f1-11eb-20ba-59687de0be01
# ╠═3d9b0ae6-34f6-11eb-3103-8330ac256477
# ╠═441d4df2-34f6-11eb-2f28-d1be566ae3d5
# ╠═74068b5a-34f6-11eb-0636-df830c3a8e91
