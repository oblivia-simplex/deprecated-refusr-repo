### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ a2a2f0e5-c6b4-4645-b8f1-73984db2a5e4
using Pkg

# ╔═╡ 5665d3c5-3016-4faf-ae19-05c745dba07e
begin
	cd("/home/lucca/src/refusr/Refusr")
	Pkg.activate(".")
	include("./src/RefusrSingleProc.jl")
end

# ╔═╡ 02e839a6-8545-4f0b-a868-020e40fd0106
using Plots

# ╔═╡ 49a63711-5209-4606-be56-3f1cc291d899
using StatsBase

# ╔═╡ 1132404e-2828-4383-9903-e52428a1ffb7
using Statistics

# ╔═╡ cd6565f4-edba-11eb-290b-d313fbdb8aa7
md"# Distribution of Programs"

# ╔═╡ 18789d88-caae-4b3f-85af-aae8b5bf3e3d
md"What does the distribution of programs of length n, m input variables, and k registers look like with respect to the space of Boolean functions of m variables?"

# ╔═╡ 61f9a2f5-db5c-4c79-bec4-e25e3bf031ef
config = (genotype = (output_reg=1, registers_n=2, data_n=2, max_steps=10),)

# ╔═╡ 03f09d77-f04c-44bd-b6fa-ae0f0f2fa406
function scarcity(out)
	counts = countmap(out) |> values |> collect
	normed = counts ./ maximum(counts)
	minimum(normed)
end

# ╔═╡ ec26e2a6-9178-42d7-9f61-eb10a33fc229
INPUT = BitArray([0 0
		0 1
		1 1
		1 0])

# ╔═╡ 803dcb68-af69-44f9-9a24-5757be4d682f
md"Rather than enumerating all the possible instructions, we'll do it the lazy way."

# ╔═╡ bb0b53cc-d263-4407-be90-7a0c069a2c5e
num_insts = LinearGenotype.number_of_possible_insts(2, 2)

# ╔═╡ 58f74caa-942b-47c6-b0ad-96070c5f4250
INSTS = Set()

# ╔═╡ 168ce919-b720-436b-937d-f58781ec6555
while length(INSTS) < num_insts
	push!(INSTS, LinearGenotype.rand_inst(num_data=2, num_regs=2))
end

# ╔═╡ 0a980ef5-34ec-4bad-868e-2600dfc0f423
prog_len = 3

# ╔═╡ 4291193e-bcf8-4ffe-a77b-76a15048f8a3
build_all_programs_of_length(n) = vec([collect(p) for p in Iterators.product(repeat([INSTS], n)...)])

# ╔═╡ a10fb90e-cb2b-4377-a73e-a0265e2ac676
PROGRAMS3 = build_all_programs_of_length(3)

# ╔═╡ d7b71b41-e86f-4c9f-8a66-86b7f45d1a61
length(PROGRAMS3)

# ╔═╡ fa050ca1-803c-4b75-990e-b81a3cc1f7f2
evaluate_all(programs) = [LinearGenotype.execute_vec(prog, INPUT, config=config)[1] for prog in programs]

# ╔═╡ a168e8f4-8eaf-4e12-a30b-056eb4df0de2
OUT3 = evaluate_all(PROGRAMS3)

# ╔═╡ 50fc1dc6-e46e-4bd9-9d33-c90646c772c6
scarcity(OUT3)

# ╔═╡ ef16ba62-b9c9-4076-a62d-4ee05c8b19df
pack(row) = sum([row[i]<<(i-1) for i in 1:length(row)])


# ╔═╡ 1c67a91e-ba84-4d17-b94e-1347a7690f14
function hist(data)
	histogram(data, bins=16, xticks=0:15)
end

# ╔═╡ 57fe8e57-d2bd-4dfb-b98c-3595ca5c37b4
histogram(pack.(OUT3), nbins=16)

# ╔═╡ 1fb44304-d731-41bf-b275-1b5615aad003
covered3 = pack.(OUT3) |> sort |> unique

# ╔═╡ d15f55f9-e087-4a6a-94b2-6e3ab44f28e8
IFF, XOR = [Expressions.bits(n, 4) for n in filter(x->!(x ∈ covered3), 0:15)]

# ╔═╡ fd645497-cf89-4ab1-a4cb-1ca20c9b0566
INPUT

# ╔═╡ d835fd42-8324-459a-82e7-d2bc7c509cf2
md"When we restrict ourselves to programs of length 3, the two functions that aren't covered are: `~(A ⊻ B)` and `A ⊻ B`. Very interesting!"

# ╔═╡ 52e9ce45-0715-453c-a072-15f7839028ca


# ╔═╡ 58304e43-76c1-4c5f-b10a-5422bf2ba6bb
PROGRAMS4 = build_all_programs_of_length(4)

# ╔═╡ 5e965adb-fed7-4a86-8604-207f6e431383
length(PROGRAMS4)

# ╔═╡ 5d523166-d811-4f61-8e67-366e09b317a2
OUT4 = evaluate_all(PROGRAMS4)

# ╔═╡ 08c398c3-2681-44d1-b716-30cd1cc4e233
scarcity(OUT4)

# ╔═╡ 95e9d915-c70b-4064-afbd-a9a417fde720
histogram(pack.(OUT4), nbins=16)

# ╔═╡ 5e6a9063-edf2-4d2a-b55a-4cc5f2d94206
covered4 = pack.(OUT4) |> sort |> unique

# ╔═╡ b578f581-8301-46db-9e14-e10572b4dbd5
covered4 == covered3

# ╔═╡ a2acf5cf-2a8a-487a-bb4d-57ad08d24d30
PROGRAMS5 = build_all_programs_of_length(5)

# ╔═╡ 0ba8470c-1349-4a9f-b068-d99baba90680
length(PROGRAMS5)

# ╔═╡ f06bab2b-cffd-4531-828d-32adf218c106
length(PROGRAMS5) / length(PROGRAMS4)

# ╔═╡ 7042b84d-5bd1-4091-8816-bdda2aa63166
OUT5 = evaluate_all(PROGRAMS5)

# ╔═╡ e4a5b8cf-a721-4a5a-b036-1591f8ba6ef4
countmap(OUT5)

# ╔═╡ 2991b0e6-16bb-48f8-8526-239938867212
scarcity(OUT5)

# ╔═╡ f8e96710-00f6-443d-a4b8-a51e4295bf69
histogram(pack.(OUT5), nbins=16)

# ╔═╡ e0fd69f2-7448-42e4-8e13-5c3f0f2bec3a
covered5 = pack.(OUT5) |> sort |> unique

# ╔═╡ d5557ab7-55c1-4ac8-868b-8009ff91ab24
IFFcount = count(x -> x == IFF, OUT5)

# ╔═╡ 0b1ea5c0-dcf6-49d4-b39f-086a04307348
XORcount = count(x -> x == XOR, OUT5)

# ╔═╡ ae369a89-a32f-4a2c-b134-ae4fc591d437
length(OUT5)

# ╔═╡ d5d849aa-77d9-4303-8bc0-f3dbac3ca1e9
IFFcount / length(OUT5)

# ╔═╡ c6a5e6fa-a278-48bc-b7c6-bb6a2b0b4bd5
INSTSx = begin 
	INSTSx = Set()
	OPSx = deepcopy(LinearGenotype.OPS)
	push!(OPSx, (⊻, 2))
	num_insts_x = 2 * (2+2) * length(OPSx)
	while length(INSTSx) < num_insts_x
		push!(INSTSx, LinearGenotype.rand_inst(ops=OPSx, num_data=2, num_regs=2))
	end
	INSTSx
end

# ╔═╡ d2056bbb-5714-49aa-a7b0-d4997ea96151
build(insts, n) = vec([collect(p) for p in Iterators.product(repeat([insts], n)...)])

# ╔═╡ 6349059e-9e0f-4d4f-976e-e01e8bfa5e3a
PROGRAMS3x = build(INSTSx, 3)

# ╔═╡ cb6bbc86-b06f-43c4-855d-2542a186c1b0
length(PROGRAMS3x)

# ╔═╡ 5bda1ca2-8ae1-4d59-a693-ffcfda7e403c
OUT3x = evaluate_all(PROGRAMS3x)

# ╔═╡ 4498f47e-8f14-441e-a1e7-a1930f8d6303
histogram(pack.(OUT3x), nbins=16)

# ╔═╡ 18b9ba8e-0e42-49ba-9e60-60480284fd98
covered3x = pack.(OUT3x) |> sort |> unique

# ╔═╡ 8dc02699-666c-484c-9e06-012b62a910b7
count(x->x==XOR, OUT3x)

# ╔═╡ e6db3d84-ec3c-4f0e-ac7c-256d22a4d9ad
nand(a,b) = ~(a & b)

# ╔═╡ fdfcaabf-f172-4665-a34b-598df3ad8c15
 ( ⊃ )(a,b) = ~a | b

# ╔═╡ ae3247f3-fdd3-4d7e-8cb9-75f5784f93a5


# ╔═╡ 1bd783ef-634b-4f5a-9b7f-4ce1efa39274
OPSn = [(⊃, 2), (⊻, 2), (~, 1)]

# ╔═╡ 78ddbf17-24bf-45ec-a258-a6ae09083296
N=2

# ╔═╡ c9841199-e746-46ab-abeb-88025c16da6e
INSTSn = begin
	INSTSn = Set()
	num_insts_n = 2 * (2 + N) * length(OPSn)
	while length(INSTSn) < num_insts_n
		push!(INSTSn, LinearGenotype.rand_inst(ops=OPSn, num_data=2, num_regs=N))
	end
	INSTSn
end

# ╔═╡ 324b15a7-d233-4b33-896b-2bfddd6fce9b
PROGRAMS3n = build(INSTSn, 3)

# ╔═╡ 276eea09-b30e-45b5-9033-124c92d12c13
length(PROGRAMS3n)

# ╔═╡ f0d31e92-8faa-4cfc-8f67-cfd8b2aa15a5
evaluate_alln(programs; num_regs=2) = [LinearGenotype.execute_vec(prog, INPUT, config=(genotype=(registers_n=num_regs, data_n=2, max_steps=10, output_reg=1),))[1] for prog in programs]

# ╔═╡ 41e8f8b4-4f24-4461-968a-9d7a41650e61
OUT3n = evaluate_alln(PROGRAMS3n, num_regs=N)

# ╔═╡ 35b598e1-ed43-49a6-a2e5-258659bcffab
histogram(pack.(OUT3n), nbins=16, xticks=0:15)

# ╔═╡ a261af7a-c8d6-4b46-adb5-e6e90bdf1466
covered3n = pack.(OUT3n) |> sort |> unique

# ╔═╡ b4c77ddc-c5d5-4ff0-b4aa-05c4b998341b
missing3n = filter(x->!(x ∈ covered3n), 0:15)

# ╔═╡ 6efa2508-a7ef-47fc-86d7-e99f7ca00cdc
PROGRAMS4n = build(INSTSn, 4)

# ╔═╡ 2f62347d-83dc-405c-add6-aaee97d34255
OUT4n = evaluate_alln(PROGRAMS4n, num_regs=N)

# ╔═╡ 0346746b-ae9d-416d-8dd3-28009d76b098
histogram(pack.(OUT4n), bins=16, xticks=0:15)

# ╔═╡ be8b22fe-39a9-43d3-a1f0-08e587d612f8
covered4n = pack.(OUT4n) |> sort |> unique

# ╔═╡ 3382f0e7-71e0-4c33-8d94-a8f8cbcba2ad
missed4n = filter(x->!(x ∈ covered4n), 0:15)

# ╔═╡ 10e2b48f-4036-4334-9636-0a99e888150e
[Expressions.bits(n, 4) for n in missed4n]  # That's OR

# ╔═╡ e2f22822-eb3a-4ae3-98ee-5a8c74e8a479
PROGRAMS5n = build(INSTSn, 5)

# ╔═╡ 112927c0-0568-4b3e-95ca-7036506f375d
length(PROGRAMS5n)

# ╔═╡ 671d80fe-dbcc-4d84-9c69-463737da8245
OUT5n = evaluate_alln(PROGRAMS5n, num_regs=N)

# ╔═╡ 0d6382bc-7b02-4b3c-a411-7e74ea11d4f4
histogram(pack.(OUT5n), bins=16)

# ╔═╡ 9dbede1c-2f42-4210-ae49-a5c3720d57f2
covered5n = pack.(OUT5n) |> sort |> unique

# ╔═╡ 653ee0ce-3082-455f-ba9b-2b07d84c154f
missed5n = filter(x->!(x ∈ covered5n), 0:15)

# ╔═╡ ce60c2a4-cdca-4f83-86d7-966b10f66ce3
counts = countmap(OUT5n)

# ╔═╡ 5c292fe0-3e72-4080-90c9-a5399d5b91b6
scarcity(OUT5n)

# ╔═╡ 1b506035-0db5-40e4-85b1-64e2d11747c7
c = counts |> values |> collect

# ╔═╡ 16d6b11e-5763-4ae8-9224-f80552cbd404
c ./ maximum(c) |> minimum

# ╔═╡ daaa0e89-23e3-46e0-87d8-6716938ecc95


# ╔═╡ Cell order:
# ╠═cd6565f4-edba-11eb-290b-d313fbdb8aa7
# ╠═a2a2f0e5-c6b4-4645-b8f1-73984db2a5e4
# ╠═5665d3c5-3016-4faf-ae19-05c745dba07e
# ╠═18789d88-caae-4b3f-85af-aae8b5bf3e3d
# ╠═61f9a2f5-db5c-4c79-bec4-e25e3bf031ef
# ╠═03f09d77-f04c-44bd-b6fa-ae0f0f2fa406
# ╠═ec26e2a6-9178-42d7-9f61-eb10a33fc229
# ╠═803dcb68-af69-44f9-9a24-5757be4d682f
# ╠═bb0b53cc-d263-4407-be90-7a0c069a2c5e
# ╠═58f74caa-942b-47c6-b0ad-96070c5f4250
# ╠═168ce919-b720-436b-937d-f58781ec6555
# ╠═0a980ef5-34ec-4bad-868e-2600dfc0f423
# ╠═4291193e-bcf8-4ffe-a77b-76a15048f8a3
# ╠═a10fb90e-cb2b-4377-a73e-a0265e2ac676
# ╠═d7b71b41-e86f-4c9f-8a66-86b7f45d1a61
# ╠═fa050ca1-803c-4b75-990e-b81a3cc1f7f2
# ╠═a168e8f4-8eaf-4e12-a30b-056eb4df0de2
# ╠═50fc1dc6-e46e-4bd9-9d33-c90646c772c6
# ╠═ef16ba62-b9c9-4076-a62d-4ee05c8b19df
# ╠═02e839a6-8545-4f0b-a868-020e40fd0106
# ╠═1c67a91e-ba84-4d17-b94e-1347a7690f14
# ╠═57fe8e57-d2bd-4dfb-b98c-3595ca5c37b4
# ╠═1fb44304-d731-41bf-b275-1b5615aad003
# ╠═d15f55f9-e087-4a6a-94b2-6e3ab44f28e8
# ╠═fd645497-cf89-4ab1-a4cb-1ca20c9b0566
# ╠═d835fd42-8324-459a-82e7-d2bc7c509cf2
# ╠═52e9ce45-0715-453c-a072-15f7839028ca
# ╠═58304e43-76c1-4c5f-b10a-5422bf2ba6bb
# ╠═5e965adb-fed7-4a86-8604-207f6e431383
# ╠═5d523166-d811-4f61-8e67-366e09b317a2
# ╠═08c398c3-2681-44d1-b716-30cd1cc4e233
# ╠═95e9d915-c70b-4064-afbd-a9a417fde720
# ╠═5e6a9063-edf2-4d2a-b55a-4cc5f2d94206
# ╠═b578f581-8301-46db-9e14-e10572b4dbd5
# ╠═a2acf5cf-2a8a-487a-bb4d-57ad08d24d30
# ╠═0ba8470c-1349-4a9f-b068-d99baba90680
# ╠═f06bab2b-cffd-4531-828d-32adf218c106
# ╠═7042b84d-5bd1-4091-8816-bdda2aa63166
# ╠═e4a5b8cf-a721-4a5a-b036-1591f8ba6ef4
# ╠═2991b0e6-16bb-48f8-8526-239938867212
# ╠═f8e96710-00f6-443d-a4b8-a51e4295bf69
# ╠═e0fd69f2-7448-42e4-8e13-5c3f0f2bec3a
# ╠═d5557ab7-55c1-4ac8-868b-8009ff91ab24
# ╠═0b1ea5c0-dcf6-49d4-b39f-086a04307348
# ╠═ae369a89-a32f-4a2c-b134-ae4fc591d437
# ╠═d5d849aa-77d9-4303-8bc0-f3dbac3ca1e9
# ╠═c6a5e6fa-a278-48bc-b7c6-bb6a2b0b4bd5
# ╠═d2056bbb-5714-49aa-a7b0-d4997ea96151
# ╠═6349059e-9e0f-4d4f-976e-e01e8bfa5e3a
# ╠═cb6bbc86-b06f-43c4-855d-2542a186c1b0
# ╠═5bda1ca2-8ae1-4d59-a693-ffcfda7e403c
# ╠═4498f47e-8f14-441e-a1e7-a1930f8d6303
# ╠═18b9ba8e-0e42-49ba-9e60-60480284fd98
# ╠═8dc02699-666c-484c-9e06-012b62a910b7
# ╠═e6db3d84-ec3c-4f0e-ac7c-256d22a4d9ad
# ╠═fdfcaabf-f172-4665-a34b-598df3ad8c15
# ╠═ae3247f3-fdd3-4d7e-8cb9-75f5784f93a5
# ╠═1bd783ef-634b-4f5a-9b7f-4ce1efa39274
# ╠═78ddbf17-24bf-45ec-a258-a6ae09083296
# ╠═c9841199-e746-46ab-abeb-88025c16da6e
# ╠═324b15a7-d233-4b33-896b-2bfddd6fce9b
# ╠═276eea09-b30e-45b5-9033-124c92d12c13
# ╠═f0d31e92-8faa-4cfc-8f67-cfd8b2aa15a5
# ╠═41e8f8b4-4f24-4461-968a-9d7a41650e61
# ╠═35b598e1-ed43-49a6-a2e5-258659bcffab
# ╠═a261af7a-c8d6-4b46-adb5-e6e90bdf1466
# ╠═b4c77ddc-c5d5-4ff0-b4aa-05c4b998341b
# ╠═6efa2508-a7ef-47fc-86d7-e99f7ca00cdc
# ╠═2f62347d-83dc-405c-add6-aaee97d34255
# ╠═0346746b-ae9d-416d-8dd3-28009d76b098
# ╠═be8b22fe-39a9-43d3-a1f0-08e587d612f8
# ╠═3382f0e7-71e0-4c33-8d94-a8f8cbcba2ad
# ╠═10e2b48f-4036-4334-9636-0a99e888150e
# ╠═e2f22822-eb3a-4ae3-98ee-5a8c74e8a479
# ╠═112927c0-0568-4b3e-95ca-7036506f375d
# ╠═671d80fe-dbcc-4d84-9c69-463737da8245
# ╠═0d6382bc-7b02-4b3c-a411-7e74ea11d4f4
# ╠═9dbede1c-2f42-4210-ae49-a5c3720d57f2
# ╠═653ee0ce-3082-455f-ba9b-2b07d84c154f
# ╠═49a63711-5209-4606-be56-3f1cc291d899
# ╠═ce60c2a4-cdca-4f83-86d7-966b10f66ce3
# ╠═1132404e-2828-4383-9903-e52428a1ffb7
# ╠═5c292fe0-3e72-4080-90c9-a5399d5b91b6
# ╠═1b506035-0db5-40e4-85b1-64e2d11747c7
# ╠═16d6b11e-5763-4ae8-9224-f80552cbd404
# ╠═daaa0e89-23e3-46e0-87d8-6716938ecc95
