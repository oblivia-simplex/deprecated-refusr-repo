### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ 49e2b3dc-434a-44df-8c6e-a8d0f00a4016
begin 
	DIR = "/home/lucca/src/refusr/Refusr"
	cd(DIR)
	using Pkg
	Pkg.activate(DIR)
	using Serialization, CSV, DataFrames, ProgressMeter, Plots
	using Setfield, Dates, Statistics, StatsBase
	using Images
	Images.load("./images/refus.jpg")
end

# ╔═╡ c8dafec8-7357-4a21-87fc-58a58b64f6be
using Cockatrice

# ╔═╡ 2d557a09-49f3-40ef-a5e0-7a6d177838d7
using Cockatrice.Geo

# ╔═╡ 7ef11922-36a5-416a-86bf-5d32188e7874
using RecursiveArrayTools

# ╔═╡ 45bfa6c9-10a2-4641-8170-4ac613a616e7
using ImageView

# ╔═╡ 0aa2bdf6-be5f-451b-954d-934538256b94
using InformationMeasures

# ╔═╡ 40f5bd31-2566-480c-8328-0f9d3ca06c99
using ImageTransformations

# ╔═╡ 7c0721d4-7120-40b4-937b-74446049f523
using Clustering

# ╔═╡ a2404f1b-8326-445e-b5ed-98d3254bffac
using JSON

# ╔═╡ aa39d4e5-30f6-4009-a7e5-b44a5331aaa8
include("$(DIR)/src/RefusrSingleProc.jl")

# ╔═╡ 99f22adc-deac-11eb-305b-2f82290de89b
md"# REFUSR Demonstrations"

# ╔═╡ 1016521d-ae3b-4c5c-99a6-7035e3f91d96
config_path = "$(DIR)/config.yaml"

# ╔═╡ b7b6b5f8-e3b7-4b7c-9513-e3c0a0723ed0
Markdown.parse("## Configuation\n```\n$(read(config_path, String))\n```")

# ╔═╡ ab99a20f-bf7c-4c54-b1b0-ff8b0119a306
config = Cockatrice.Config.parse(config_path)

# ╔═╡ 2a02a117-25f9-4996-80f9-41a2a5175e9c
sexp_file = replace(config.selection.data, "_ALL.csv" => ".sexp")

# ╔═╡ 351d39ca-15ea-4ec2-b5ab-284d25987067
st_file = replace(config.selection.data, "_ALL.csv" => ".st")

# ╔═╡ 7abb533c-c1b2-4ae0-8923-4191f1dd6e49
Markdown.parse("## Target as a Structured Text PLC Program\n```\n$(read(st_file, String))\n```")

# ╔═╡ 57e84f71-ed44-496c-be41-90c015abf36b
Markdown.parse("## Symbolic Expression of Target\n```\n$(read(sexp_file, String))\n```")

# ╔═╡ caee44f3-a33a-45fb-b9e8-95be60ee0e24
target_sexp = read(sexp_file, String) |> Meta.parse |> eval

# ╔═╡ 5bf2949a-6aed-4212-8f21-ab6117a96c3d
md"## Truth Table of Target"

# ╔═╡ 86e2a29a-cc33-42d9-9dad-273c7c998b62
target_tt = CSV.read(config.selection.data, DataFrame)

# ╔═╡ c4f5ac87-70cc-40ea-afc4-e1e9a3395351
target_tt == Expressions.truth_table(target_sexp) # sanity check

# ╔═╡ 5ac8193d-f22c-4f16-8fef-c3e8714860fc
md"## Geography"

# ╔═╡ 5c65b7a3-5b21-4d56-8ebb-9deed2748212
md"Populations are distributed across the surface of an 2-dim torus. Their spatial arrangement, or 'geography', is used to probabilistically restrict competition and breeding to local regions -- the idea being that this should inhibit premature convergence and the collapse of population diversity."

# ╔═╡ 0fa1a2b4-7d3c-4095-baab-73000ecd0039
epicentre = (5,1)

# ╔═╡ 8f2ffb86-5803-4caf-9107-2c068411d260
function see_combatants(geo, tsize; origin=epicentre)
    combatants = Cockatrice.Geo.choose_combatants(geo, tsize, origin=origin)
    cells = [c ∈ combatants ? 1.0 : 0.0 for c in geo.indices]
    colorant"cyan" .* cells
end


# ╔═╡ ff10c4ff-8270-4f31-ab19-21cbe51f7ea5


# ╔═╡ c4cf65a1-d00a-4e43-962c-b76dcea37573
md"## Results"

# ╔═╡ 5e399e43-adc1-4153-a98c-8c5fec5738f8
restore_from_backup = false

# ╔═╡ 9131b3cb-b957-4449-afe5-9817e5d3b5cf
backup_file = "demo_world_and_logger.dump"

# ╔═╡ 9b59ead6-5d95-48be-ba30-d8cd1ee1ef8c
WORLD, LOGGER, IM_LOG = restore_from_backup ? deserialize(backup_file) : launch("./config.yaml")

# ╔═╡ 139cfeb8-a9ee-418e-a5c4-d94d5fc0626b
geo_weights = colorant"hotpink" .* reshape(Geo.distance_weights(WORLD.geo, epicentre), size(WORLD.geo.deme))

# ╔═╡ 57f62d4b-97a4-4d16-9810-7de25e0b7dae
save("images/geo_weights.png", geo_weights)

# ╔═╡ f79497b3-bc51-44dd-ab5f-da668bbb6e04
[see_combatants(WORLD.geo, config.selection.t_size, origin=epicentre) for _ in 1:5]

# ╔═╡ 5aab86d9-0c00-4208-a757-7bc4a84e8385
md"Complete, after $(WORLD.iteration) tournaments."

# ╔═╡ 1cf44119-7256-44bc-96ac-e227ba3f701c
md"If this worked, let's create a backup, just in case."

# ╔═╡ 90780258-0c61-4c74-81fc-3606d617e317
if !restore_from_backup && objective_performance(WORLD.elites[1]) == 1.0 
	serialize("demo_world_and_logger.dump", (WORLD, LOGGER))
end

# ╔═╡ a98e5ce4-8cad-44d4-bcc4-6024ff4f287f
champion = WORLD.elites[1]

# ╔═╡ a0d60d6c-80e1-4e04-a643-2dbd632e833e
champion.phenotype.results == FF.get_answers(FF.DATA)

# ╔═╡ 35f77c7f-999e-4863-9d48-8cee9bfb17f0
LOGGER.table

# ╔═╡ fcf32481-c9ee-4370-b698-c0ee8bef14c4
X = Int.(floor.(LinRange(1, WORLD.iteration, nrow(LOGGER.table))))

# ╔═╡ ae479ca5-6211-4830-8bd7-875a6bccd881
plot(X, LOGGER.table.objective_maximum)

# ╔═╡ 25c4393d-fcc4-4476-923e-d09d8d4b1442
plot!(X, LOGGER.table.objective_meanfinite)

# ╔═╡ eca64dd6-23cc-477d-bfbb-5899baacb02c
plot!(X, LOGGER.table.fitness_1_maximum)

# ╔═╡ d0e1d459-9c58-4161-8865-f0ce57a101a5
plot!(X, LOGGER.table.fitness_1_meanfinite)

# ╔═╡ 4c19ba83-64ef-4ee2-8cdc-ff20c05f5850
plot!(X, LOGGER.table.fitness_2_maximum)

# ╔═╡ 0411aa7d-daa4-47cc-b47c-7326ec6a8631
plot!(X, LOGGER.table.fitness_2_meanfinite)

# ╔═╡ d36a9d04-a53b-466a-879e-e42de3c8c266
plot(X, LOGGER.table.chromosome_len_mean)                                                         

# ╔═╡ f0e1a7bf-c2bb-40c4-8e32-e0b217d10398
plot!(X, LOGGER.table.effective_len_mean)

# ╔═╡ 4ffd7ddb-877a-4756-a2e3-c8d55b7a3bd0
md"## Examining the Champion"

# ╔═╡ 14bd5e76-51ed-45a0-8c70-e1f33476a0e0
champion_sexp = LinearGenotype.to_expr(champion.chromosome).args[2]

# ╔═╡ 043a1af7-b15a-40ab-93b1-d0645cb1a7a5
# -- prone to segfaults, FIXME, bug with Z3 library? -- # simplified_champion_sexp = Z3Bridge.simplify(champion_sexp)

# ╔═╡ 63ee22bf-71c8-403e-b275-261079b43b17
champion_simplified = Expressions.simplify(champion_sexp)

# ╔═╡ 1b7537fe-97e1-424f-8717-e98c0f422d9d
Expressions.count_subexpressions(champion_sexp)

# ╔═╡ befae7e2-aaa6-4367-86e9-b4a63b6ff636
Expressions.count_subexpressions(champion_simplified)

# ╔═╡ c0e9af9e-0c93-4e14-bd67-ca9555333785
Expressions.count_subexpressions(target_sexp)

# ╔═╡ c0b73cc8-7a5e-470f-a1a8-2f6695e3f825
md"We can simplify this with Z3, to some extent, or Espresso.jl, but this is an area that still requires some refinement."

# ╔═╡ 922e1d09-803e-47fd-bbaf-c7a38615498f
md"This is still an order of magnitude more complex than the expression we used to generate the PLC code and its corresponding truth table."

# ╔═╡ 97638e0f-15b7-4bed-99d0-be1af7be8260
Expressions.count_subexpressions(target_sexp)

# ╔═╡ e69fcb0e-a289-4c62-bb58-beb7b84c4c41
Markdown.parse("### The Champion as a Structured Text PLC Program\n```\n$(Expressions.ST.structured_text(champion_sexp))\n```")

# ╔═╡ 737f46e5-1782-421d-b11a-3bc72fb2f306
md"## Proving Equivalence to the Target"

# ╔═╡ 89e00b61-7343-48ea-b6ce-9afec597b292
const z3 = Z3Bridge.z3

# ╔═╡ 26ae38f3-8557-4724-9e97-6c400bebdf79
begin
	
mk_var(prefix, i) = z3.BitVec(prefix * string(i), 1)
mk_const(b::Bool) = z3.BitVecVal(b, 1)

mk_var_bool(prefix, i) = z3.Bool(prefix * string(i))
mk_const_bool(b::Bool) = z3.Bool(b)



mk_registers(prefix, num) = [mk_var_bool(prefix, i) for i in 1:num]


R = mk_registers("R", 7)
D = mk_registers("D", 7)

end

# ╔═╡ 69b0f112-3530-4707-bbb4-4d9c3eea8af0
function translate_with_bools!(e::Expr)::Expr
    replace!(e, :& => :(z3.And))
    replace!(e, :| => :(z3.Or))
    replace!(e, :~ => :(z3.Not))
    #replace!(e, :true => mk_const_bool(true))
    #replace!(e, :false => mk_const_bool(false))
    e
end

# ╔═╡ a795a65e-47fc-42f1-b80a-e35ea8961384
expr_to_z3(e) = translate_with_bools!(deepcopy(e)) |> eval

# ╔═╡ ee74cebf-0069-4900-b1dd-75ac45e77586
champion_z = expr_to_z3(champion_sexp)

# ╔═╡ 8302125c-af20-4c49-a730-9f1437964d3d
target_z = expr_to_z3(target_sexp)

# ╔═╡ 9ecd1470-6126-4a21-abf0-ef0591aac55c
begin 
	Z3Bridge.z3.z3printer._PP.bounded = false
	Z3Bridge.z3.z3printer._PP.max_width = 999999999
	Z3Bridge.z3.z3printer._PP.max_lines = 999999999
end

# ╔═╡ c46d4f3b-b150-4cef-8940-ec4aa94598ed
Z3Bridge.z3.z3printer.obj_to_string(champion_z)

# ╔═╡ 380c0b73-d15b-45b4-966c-e7e60163970d
md"We can prove that the champion expression is semantically equivalent to the target by using **Z3** to search for a model where they take on different truth values. If no such model can be found -- if Z3 returns the value, `unsat` -- then we know that the two expressions are provably equivalent."

# ╔═╡ 28827316-1311-45da-a5e9-03cce92581c2
function prove_equivalence(p, q)
	S = Z3Bridge.z3.Solver()
	S.add(p != q)
	x = S.check()
	if x == Z3Bridge.z3.sat
		return S.model()
	else
		return x, "Cannot find a model where they differ"
	end
end

# ╔═╡ c5e49e27-0935-4bec-977d-2aa75823432c
prove_equivalence(champion_z, target_z)

# ╔═╡ 04661785-0d95-4708-8b3b-80209cd12462
target_fn = :(D -> $target_sexp) |> eval

# ╔═╡ a27db254-249d-41bd-a7ff-d92bdd737cc9
test_input = [false, true, false, false, false, false, true]

# ╔═╡ 18f9dcca-eab6-47df-b75b-828e8ed44b21
target_out = target_fn(test_input)

# ╔═╡ f8336bac-a5a1-4dbb-8e04-f5bfd42319f4
champion_out, trace = LinearGenotype.FF.evaluate(champion, config=config, data=test_input)

# ╔═╡ f4ff83a5-15f1-4dc7-8e23-895c1caa79dc
champion_out == target_out

# ╔═╡ 73afa0a7-a5da-45d2-907a-32f2b30d8a8b
md"If this doesn't work, let's at least note that we've found a useful debugging and unit testing tool in Z3. (Update: I did find a bug this way, and fixed it, this morning!)" 

# ╔═╡ afa197af-d623-47f2-9b2e-fc91b3391cef
tt = Expressions.truth_table(champion_sexp)

# ╔═╡ 624c4e52-7f72-4c7a-b343-a26e388a1105
tt[:,end] == champion.phenotype.results

# ╔═╡ 4ad75648-0677-411f-8f8b-6badb46ef6a2
md"## Visualizing the Population"

# ╔═╡ 0b3f27de-0a07-489c-8934-faa2b73772bf
function process_images(arr; color=nothing)
    m = maximum.(arr) |> maximum
    normed = m > 0.0 ? arr ./ m : arr
    finite = (A -> (a -> isfinite(a) ? Float64(a) : 0.0).(A)).(arr)
    @show typeof(finite)
    if color !== nothing
        finite .* color
    else
        finite
    end
end

# ╔═╡ a7300f14-5ee2-4085-849d-f6232cad5204
function trace_video(evo; key="fitness_1", color=colorant"green")
    trace = process_images(evo.trace[key], color=color)
    fvec = VectorOfArray(trace)
    video = convert(Array, fvec)
    AxisArray(video)
end

# ╔═╡ 4e829528-7fc7-4596-bc30-22339ea94241

function display_images(images; dims=(300,300), gui=nothing)
    rows, cols = size(images)
    show = ImageView.imshow!
    if gui ≡ nothing
        gui = imshow_gui(dims, (rows, cols))
        show = ImageView.imshow
    end
    canvases = gui["canvas"]

    for r in 1:rows
        for c in 1:cols
            i = r*c
            image = images[r,c]
            if image !== nothing
                show(canvases[r,c], images[r,c])
            end
        end
    end

    Gtk.showall(gui["window"])
    gui
end

# ╔═╡ 1ed61cdb-1805-4126-a097-e089e9a34e74
vid_objective = trace_video(WORLD, key="objective")

# ╔═╡ 2b59e140-99d6-4322-b656-fd67ca82be85
ImageView.closeall()

# ╔═╡ 1cb6b669-5fad-43a5-8428-c0fa61a955e5
idxs = Int.(floor.(LinRange(1, length(vid_objective), 1000)))

# ╔═╡ daa5247e-4578-4e78-8d3b-6024764f5e33
imshow(vid_objective)

# ╔═╡ 63a7116c-6a12-45e2-9f9d-10af6ff8d93b
md"## Mutual Information as a Selective Pressure"

# ╔═╡ 3d511cf0-23d9-48eb-a63e-dc95aa47198d
example_expr=:(D[1] & (D[2] | ~D[3]))

# ╔═╡ 65222887-62d7-4454-8825-9f65c5428b9e
Markdown.parse("""The motivation for using the _mutual information_ (in the information-theoretic sense) between an individual's output vector and the target vector as a selective pressure is that a Boolean function can be 'informationally' very close to the target without that proximity being reflected in hamming distance. For example, consider the function 

```
f(D) = $(example_expr)
```

this function has the following truth table:

""")

# ╔═╡ 0161452f-6a15-451c-9c33-10c56c0da637
tt_example = Expressions.truth_table(example_expr)

# ╔═╡ d2c95508-df91-4a86-bf54-5d81c3a5e6d9
neg_example = :(~ $example_expr)

# ╔═╡ 20967464-519f-4019-9854-b527b551a1ca
Markdown.parse("""Now suppose we have another function, 
	
```
	
	f'(D) = $neg_example
	
```
""")

# ╔═╡ 54fa2cea-ca18-4cfc-bbd0-0fefefd8fb8a
md"With the truth table:"

# ╔═╡ 3886842a-4c68-4cd9-b011-b23a1c0472c0
tt_neg = Expressions.truth_table(neg_example)

# ╔═╡ 64331880-49ea-404f-8c6d-d02baca8b01a


# ╔═╡ 0e32dbeb-009d-425e-ae7d-307af1266788
md"The hamming distance between these two is absolute."

# ╔═╡ 0f87f14b-14cf-41d9-84e8-1cd82a3cd2ff
md"And so `f'` would receive a fitness score of `0.0` if `f` were the target, even though it is clearly a single mutational step away from `f` -- we need only drop the negation."

# ╔═╡ 3044ea8a-a414-446b-adfe-cef34fa318f7
(!).(Array{Bool}(tt_neg[:,end] .⊻ tt_example[:,end])) |> mean

# ╔═╡ a809bde6-aa12-43e3-9512-55a610b70fd4
md"This informational proximity is captured well by a mutual information metric, defined as:"

# ╔═╡ d51e7d42-5bbb-456f-95c7-ba59be787fbe
mutualinfo_distance(a, b) = get_mutual_information(a,b) / get_entropy(a)

# ╔═╡ 705725fb-cdf8-4b36-9de8-c2d8ed9a3521
mutualinfo_distance(tt_neg[:,end], tt_example[:, end])

# ╔═╡ d3a90089-1ff0-438d-84d7-d3051c886a4d
md"We experimented with using this information theoretic distance metric as a primary fitness pressure, but ultimately found hamming distance better -- only, however, so long as it is _modified by an implicit fitness sharing mechanism_, which I'll discuss in the next section."

# ╔═╡ 81775e65-7ef6-465c-b161-e6e3ff8f51a3
begin 
	plot(X, LOGGER.table.fitness_2_maximum)
	plot!(X, LOGGER.table.fitness_2_meanfinite)
	plot!(X, LOGGER.table.objective_maximum)
	plot!(X, LOGGER.table.objective_meanfinite)
end

# ╔═╡ 9ed70e66-35bc-499c-83e2-a496171f0195
md"## Implicit Fitness Sharing"

# ╔═╡ 15f5219b-87d2-4e11-9c4f-6888fa1d1cdb
md"### Interaction Matrices and Implicit Fitness Sharing"

# ╔═╡ cbcb47e7-729a-446b-bdd1-781796936952
md"""The main idea behind implicit fitness sharing (IFS) is to reward the solution of difficult tasks, relative to the current task-solving capabilities of the population. We can track difficulty simply by maintaining a matrix whose rows represent tasks in the problem set (i.e., rows in the truth table of the target function), and whose columns represent individuals in the population. We set

```
M[i,j] = 1 if program j returns the correct value for problem i, and 0 otherwise
```
"""


# ╔═╡ 5547afe9-b903-4a3b-87a7-d514c2a19ee9
md"""The difficulty score of a given problem `i` is then equal to 

```
1.0 - mean(M[i,:]) 
```

and this becomes the score that's awarded for a correct solution to problem `j`.
"""

# ╔═╡ 81fada44-8ac5-43ff-a097-ee61a62a3946
log_sample = Int.(floor.(LinRange(1, length(IM_LOG), 128)))

# ╔═╡ c31b6ce0-2e41-4990-aa4f-16a049103482
md"Here's a view of the relative difficulty of problems (rows) over time (columns). The lighter  the pixel the more difficult the problem."

# ╔═╡ 949fbdaa-e92b-41e0-ae81-474d51fb9681
difficulty_matrix = (hcat([(x->1.0- mean(x)).(eachrow(M)) for M in IM_LOG[log_sample]]...))

# ╔═╡ 5ebb2e87-20df-4037-96f2-c720d72642d7
difficulty_image = imresize(Gray.(difficulty_matrix), ratio=6)

# ╔═╡ 20214d73-bf77-4d29-b091-d95d4ee87e14
save("difficulty.png", difficulty_image)

# ╔═╡ d06f2195-42ed-44a2-bfc4-29934ecb8390
md"Since the difficulty of each problem shifts over time, and reponds to the improvements made by the population, fitness measured in this fashion is not static, and the progress made by the population isn't reflected, for instance, in plots of the maximum and mean shared fitness."

# ╔═╡ 0fe76078-c5c7-4a80-b697-cedb14afee3d
begin
	plot(X, LOGGER.table.fitness_1_maximum)
	plot!(X, LOGGER.table.fitness_1_meanfinite)
end

# ╔═╡ 7b07fe27-0f8a-49a2-99a1-ffea335113cf
save("difficulty_over_time.png", difficulty_image)

# ╔═╡ bfce63b8-8d38-403f-a7d8-33366246bfa8
function compose_im_image(im_log, sample=10)
       bar = colorant"red" * ones(1,size(im_log[1],2))
       idxs = Int.(floor.(LinRange(1, length(im_log), sample)))
       [Gray.(m) for m in (im_log[idxs])]
end

# ╔═╡ b7dfc97c-04fd-45ba-8b9c-12337b3a24d5
md"Note that we initialize the interaction matrix with random Boolean values."

# ╔═╡ de782957-e472-427e-abfa-62c3f2cc731d
im1 = Gray.(IM_LOG[1])

# ╔═╡ 99d53423-a9b5-4d5d-9122-75f9b3821673
save("interaction_matrix_1.png", im1)

# ╔═╡ e5e60007-7dfa-4c52-a124-fb95e94046b6
md"Over time, structure appears."

# ╔═╡ a2b837d2-035a-4625-8579-dd5902e1df28
im2 = Gray.(IM_LOG[10])

# ╔═╡ a37bd287-e84a-4570-8091-2d46b532392e
save("interaction_matrix_10.png", im2)

# ╔═╡ 98c04cb4-2cae-4581-8fe5-f5a3ae712789
im3 = Gray.(IM_LOG[100])

# ╔═╡ 0a7dec29-c264-4f2a-b914-977fd3a1dddf
save("interaction_matrix_100.png", im3)

# ╔═╡ d685c521-2113-4882-b92d-09511cbb2e74
im4 = Gray.(IM_LOG[end])

# ╔═╡ 19221e15-ab34-47e1-968c-be8a3264b963
save("interaction_matrix_738.png", im4)

# ╔═╡ a42bf562-d0ba-47f4-bf61-924753ee3227
md"The groupings and regular patterns in these matrices may be partially explained by the geographic distribution of the population, which is unrolled along a single, horizontal axis, here."

# ╔═╡ c7841a1d-6325-40f2-a6fe-63646efe1fba
#Gray.(reshape(IM_LOG[end], (64, 12, 12))) |> imshow

# ╔═╡ c9b4f074-779e-4b1f-81e9-b85cc975c946
ims = compose_im_image(IM_LOG, 10)

# ╔═╡ 538eb037-4ed6-46dc-81a1-85fbdb031f2f
for (i, im) in enumerate(ims)
	save("IM_$(i).png", im)
end

# ╔═╡ ac3f0cb1-3dc5-4397-aa8e-db5b16f65d1b
begin 
	ImageView.closeall() 
	imshow(AxisArray(convert(Array, VectorOfArray(compose_im_image(IM_LOG, 256)))))
end

# ╔═╡ 2e51d9b5-de20-49fd-a9ec-00584bf8fc41


# ╔═╡ 0fa47310-b21d-4fc8-8ba1-05ea98877314
load("interaction_matrices.png")

# ╔═╡ 219c43b6-98eb-457f-98b3-810d617653ad
ImageView.closeall()

# ╔═╡ ebd7c2d5-0a95-4861-b029-a4caf3b425e8
write("/tmp/im.json", json(IM_LOG))

# ╔═╡ faf4181c-0003-4d50-a3de-0abf91a9567e
colorants = [colorant"red", colorant"yellow", colorant"green", colorant"orange", colorant"pink", colorant"purple", colorant"lavender", colorant"cyan", colorant"blue"]

# ╔═╡ 6d80189e-a05d-4197-ae96-95ec45754728
function cluster_interaction_matrix(M, n=4)
	colors = sort(colorants, by=_->rand())
	idxpairs = sort(collect(enumerate(kmeans(M', n).assignments)), by=x->x[2])
	mm = [M[idxs,:]  for idxs in [sort([ip[1] for ip in idxpairs if ip[2]==i]) for i in 1:n]]
	vcat(mm .* colors[1:n]...)
end
	

# ╔═╡ c1f62cf7-69d8-4329-9647-36ec07f850bc
md"We can experiment with using a clustering algorithm to group the problem set (the set of test cases) according to the population's performance. This may give us an interesting method of isolating common skills."

# ╔═╡ a283c8e8-0b93-423c-813c-b6b3e0773119
slice = 300

# ╔═╡ c0bd2e1b-cf59-4bd0-bb07-da2ee8282b8d
im_clusters = imresize(cluster_interaction_matrix(IM_LOG[slice], 5),ratio=4)

# ╔═╡ 43a47d09-c33d-4cc1-97d9-83135c992cb6
save("images/im_task_clusters_$(slice).png", im_clusters)

# ╔═╡ 713a4009-2572-4b64-9496-30af9f254ced
md"Alternately, we can transpose the interaction matrix and use clustering to distinguish between subpopulations, according to behaviour or phenotype."

# ╔═╡ 97e80ce3-81e1-478c-8b66-30077b754d98
im_geno_clusters = imresize(cluster_interaction_matrix(IM_LOG[slice]', 5)', ratio=4)

# ╔═╡ 4a05355f-7e61-4bed-a886-f0fd92d40df0
save("images/im_geno_clusters_$(slice).png", im_geno_clusters)

# ╔═╡ Cell order:
# ╟─99f22adc-deac-11eb-305b-2f82290de89b
# ╟─49e2b3dc-434a-44df-8c6e-a8d0f00a4016
# ╟─1016521d-ae3b-4c5c-99a6-7035e3f91d96
# ╠═aa39d4e5-30f6-4009-a7e5-b44a5331aaa8
# ╠═c8dafec8-7357-4a21-87fc-58a58b64f6be
# ╠═b7b6b5f8-e3b7-4b7c-9513-e3c0a0723ed0
# ╠═ab99a20f-bf7c-4c54-b1b0-ff8b0119a306
# ╠═2a02a117-25f9-4996-80f9-41a2a5175e9c
# ╠═351d39ca-15ea-4ec2-b5ab-284d25987067
# ╠═7abb533c-c1b2-4ae0-8923-4191f1dd6e49
# ╠═57e84f71-ed44-496c-be41-90c015abf36b
# ╠═caee44f3-a33a-45fb-b9e8-95be60ee0e24
# ╟─5bf2949a-6aed-4212-8f21-ab6117a96c3d
# ╠═86e2a29a-cc33-42d9-9dad-273c7c998b62
# ╠═c4f5ac87-70cc-40ea-afc4-e1e9a3395351
# ╠═5ac8193d-f22c-4f16-8fef-c3e8714860fc
# ╠═2d557a09-49f3-40ef-a5e0-7a6d177838d7
# ╠═5c65b7a3-5b21-4d56-8ebb-9deed2748212
# ╠═0fa1a2b4-7d3c-4095-baab-73000ecd0039
# ╠═139cfeb8-a9ee-418e-a5c4-d94d5fc0626b
# ╠═57f62d4b-97a4-4d16-9810-7de25e0b7dae
# ╠═8f2ffb86-5803-4caf-9107-2c068411d260
# ╠═f79497b3-bc51-44dd-ab5f-da668bbb6e04
# ╠═ff10c4ff-8270-4f31-ab19-21cbe51f7ea5
# ╠═c4cf65a1-d00a-4e43-962c-b76dcea37573
# ╠═5e399e43-adc1-4153-a98c-8c5fec5738f8
# ╠═9131b3cb-b957-4449-afe5-9817e5d3b5cf
# ╠═9b59ead6-5d95-48be-ba30-d8cd1ee1ef8c
# ╟─5aab86d9-0c00-4208-a757-7bc4a84e8385
# ╟─1cf44119-7256-44bc-96ac-e227ba3f701c
# ╠═90780258-0c61-4c74-81fc-3606d617e317
# ╠═a98e5ce4-8cad-44d4-bcc4-6024ff4f287f
# ╠═a0d60d6c-80e1-4e04-a643-2dbd632e833e
# ╠═35f77c7f-999e-4863-9d48-8cee9bfb17f0
# ╠═fcf32481-c9ee-4370-b698-c0ee8bef14c4
# ╠═ae479ca5-6211-4830-8bd7-875a6bccd881
# ╠═25c4393d-fcc4-4476-923e-d09d8d4b1442
# ╠═eca64dd6-23cc-477d-bfbb-5899baacb02c
# ╠═d0e1d459-9c58-4161-8865-f0ce57a101a5
# ╠═4c19ba83-64ef-4ee2-8cdc-ff20c05f5850
# ╠═0411aa7d-daa4-47cc-b47c-7326ec6a8631
# ╠═d36a9d04-a53b-466a-879e-e42de3c8c266
# ╠═f0e1a7bf-c2bb-40c4-8e32-e0b217d10398
# ╠═4ffd7ddb-877a-4756-a2e3-c8d55b7a3bd0
# ╠═14bd5e76-51ed-45a0-8c70-e1f33476a0e0
# ╠═043a1af7-b15a-40ab-93b1-d0645cb1a7a5
# ╠═63ee22bf-71c8-403e-b275-261079b43b17
# ╠═1b7537fe-97e1-424f-8717-e98c0f422d9d
# ╠═befae7e2-aaa6-4367-86e9-b4a63b6ff636
# ╠═c0e9af9e-0c93-4e14-bd67-ca9555333785
# ╠═c0b73cc8-7a5e-470f-a1a8-2f6695e3f825
# ╟─922e1d09-803e-47fd-bbaf-c7a38615498f
# ╠═97638e0f-15b7-4bed-99d0-be1af7be8260
# ╠═e69fcb0e-a289-4c62-bb58-beb7b84c4c41
# ╠═737f46e5-1782-421d-b11a-3bc72fb2f306
# ╠═89e00b61-7343-48ea-b6ce-9afec597b292
# ╠═26ae38f3-8557-4724-9e97-6c400bebdf79
# ╠═69b0f112-3530-4707-bbb4-4d9c3eea8af0
# ╠═a795a65e-47fc-42f1-b80a-e35ea8961384
# ╠═ee74cebf-0069-4900-b1dd-75ac45e77586
# ╠═8302125c-af20-4c49-a730-9f1437964d3d
# ╠═9ecd1470-6126-4a21-abf0-ef0591aac55c
# ╠═c46d4f3b-b150-4cef-8940-ec4aa94598ed
# ╠═380c0b73-d15b-45b4-966c-e7e60163970d
# ╠═28827316-1311-45da-a5e9-03cce92581c2
# ╠═c5e49e27-0935-4bec-977d-2aa75823432c
# ╠═04661785-0d95-4708-8b3b-80209cd12462
# ╠═a27db254-249d-41bd-a7ff-d92bdd737cc9
# ╠═18f9dcca-eab6-47df-b75b-828e8ed44b21
# ╠═f8336bac-a5a1-4dbb-8e04-f5bfd42319f4
# ╠═f4ff83a5-15f1-4dc7-8e23-895c1caa79dc
# ╠═73afa0a7-a5da-45d2-907a-32f2b30d8a8b
# ╠═afa197af-d623-47f2-9b2e-fc91b3391cef
# ╠═624c4e52-7f72-4c7a-b343-a26e388a1105
# ╠═4ad75648-0677-411f-8f8b-6badb46ef6a2
# ╠═7ef11922-36a5-416a-86bf-5d32188e7874
# ╠═0b3f27de-0a07-489c-8934-faa2b73772bf
# ╠═a7300f14-5ee2-4085-849d-f6232cad5204
# ╠═4e829528-7fc7-4596-bc30-22339ea94241
# ╠═1ed61cdb-1805-4126-a097-e089e9a34e74
# ╠═45bfa6c9-10a2-4641-8170-4ac613a616e7
# ╠═2b59e140-99d6-4322-b656-fd67ca82be85
# ╠═1cb6b669-5fad-43a5-8428-c0fa61a955e5
# ╠═daa5247e-4578-4e78-8d3b-6024764f5e33
# ╠═63a7116c-6a12-45e2-9f9d-10af6ff8d93b
# ╠═3d511cf0-23d9-48eb-a63e-dc95aa47198d
# ╠═65222887-62d7-4454-8825-9f65c5428b9e
# ╠═0161452f-6a15-451c-9c33-10c56c0da637
# ╠═d2c95508-df91-4a86-bf54-5d81c3a5e6d9
# ╠═20967464-519f-4019-9854-b527b551a1ca
# ╠═54fa2cea-ca18-4cfc-bbd0-0fefefd8fb8a
# ╠═3886842a-4c68-4cd9-b011-b23a1c0472c0
# ╠═64331880-49ea-404f-8c6d-d02baca8b01a
# ╠═0e32dbeb-009d-425e-ae7d-307af1266788
# ╠═0f87f14b-14cf-41d9-84e8-1cd82a3cd2ff
# ╠═3044ea8a-a414-446b-adfe-cef34fa318f7
# ╠═0aa2bdf6-be5f-451b-954d-934538256b94
# ╠═a809bde6-aa12-43e3-9512-55a610b70fd4
# ╠═d51e7d42-5bbb-456f-95c7-ba59be787fbe
# ╠═705725fb-cdf8-4b36-9de8-c2d8ed9a3521
# ╠═d3a90089-1ff0-438d-84d7-d3051c886a4d
# ╠═81775e65-7ef6-465c-b161-e6e3ff8f51a3
# ╠═9ed70e66-35bc-499c-83e2-a496171f0195
# ╠═15f5219b-87d2-4e11-9c4f-6888fa1d1cdb
# ╠═cbcb47e7-729a-446b-bdd1-781796936952
# ╠═5547afe9-b903-4a3b-87a7-d514c2a19ee9
# ╠═81fada44-8ac5-43ff-a097-ee61a62a3946
# ╠═c31b6ce0-2e41-4990-aa4f-16a049103482
# ╠═949fbdaa-e92b-41e0-ae81-474d51fb9681
# ╠═40f5bd31-2566-480c-8328-0f9d3ca06c99
# ╠═5ebb2e87-20df-4037-96f2-c720d72642d7
# ╠═20214d73-bf77-4d29-b091-d95d4ee87e14
# ╠═d06f2195-42ed-44a2-bfc4-29934ecb8390
# ╠═0fe76078-c5c7-4a80-b697-cedb14afee3d
# ╠═7b07fe27-0f8a-49a2-99a1-ffea335113cf
# ╠═bfce63b8-8d38-403f-a7d8-33366246bfa8
# ╠═b7dfc97c-04fd-45ba-8b9c-12337b3a24d5
# ╠═de782957-e472-427e-abfa-62c3f2cc731d
# ╠═99d53423-a9b5-4d5d-9122-75f9b3821673
# ╠═e5e60007-7dfa-4c52-a124-fb95e94046b6
# ╠═a2b837d2-035a-4625-8579-dd5902e1df28
# ╠═a37bd287-e84a-4570-8091-2d46b532392e
# ╠═98c04cb4-2cae-4581-8fe5-f5a3ae712789
# ╠═0a7dec29-c264-4f2a-b914-977fd3a1dddf
# ╠═d685c521-2113-4882-b92d-09511cbb2e74
# ╠═19221e15-ab34-47e1-968c-be8a3264b963
# ╠═a42bf562-d0ba-47f4-bf61-924753ee3227
# ╠═c7841a1d-6325-40f2-a6fe-63646efe1fba
# ╠═c9b4f074-779e-4b1f-81e9-b85cc975c946
# ╠═538eb037-4ed6-46dc-81a1-85fbdb031f2f
# ╠═ac3f0cb1-3dc5-4397-aa8e-db5b16f65d1b
# ╠═2e51d9b5-de20-49fd-a9ec-00584bf8fc41
# ╠═0fa47310-b21d-4fc8-8ba1-05ea98877314
# ╠═7c0721d4-7120-40b4-937b-74446049f523
# ╠═219c43b6-98eb-457f-98b3-810d617653ad
# ╠═a2404f1b-8326-445e-b5ed-98d3254bffac
# ╠═ebd7c2d5-0a95-4861-b029-a4caf3b425e8
# ╠═faf4181c-0003-4d50-a3de-0abf91a9567e
# ╠═6d80189e-a05d-4197-ae96-95ec45754728
# ╟─c1f62cf7-69d8-4329-9647-36ec07f850bc
# ╠═a283c8e8-0b93-423c-813c-b6b3e0773119
# ╠═c0bd2e1b-cf59-4bd0-bb07-da2ee8282b8d
# ╠═43a47d09-c33d-4cc1-97d9-83135c992cb6
# ╟─713a4009-2572-4b64-9496-30af9f254ced
# ╠═97e80ce3-81e1-478c-8b66-30077b754d98
# ╠═4a05355f-7e61-4bed-a886-f0fd92d40df0
