### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ 57ae94f1-f91e-4233-be3f-37b14cb0c339
begin
	cd("$(ENV["HOME"])/src/refusr/Refusr/")
	using Pkg
	Pkg.activate(".")
	using Plots, StatsPlots
	using CSV, DataFrames
	include("./src/base.jl")
end

# ╔═╡ 6081ab2a-e713-466c-8538-5cb3340ccfa1
using Statistics

# ╔═╡ d3bceea1-79a4-456c-b539-6eed3750f4c2
using Cockatrice

# ╔═╡ 7ce399f5-cd61-4068-9735-d47721cf725e
using MosaicViews

# ╔═╡ cd5e70f4-0030-491c-a718-4a43b5a5ce38
using Setfield

# ╔═╡ 83732ace-29b8-43bb-984f-35311fbb1cab
using AxisArrays

# ╔═╡ d8068859-053e-4193-8812-2dcce776bb91
using LightGraphs

# ╔═╡ 36e9f994-f3f2-11eb-18f0-5b48a3a86ad9
md"# Putzing around with Data"

# ╔═╡ 616a954f-c789-442e-8942-78e9789a7df5
Plots.plotly()

# ╔═╡ 235845e3-c575-4922-beb1-47eba1fcb58a
data_dir = "/home/lucca/logs/refusr/2021/08/02/2MUX-with-sharing.19-11"

# ╔═╡ 462b15f1-f2bb-4c4e-9f6f-bf4822c1ed36
report = CSV.read("$(data_dir)/report.csv", DataFrame)

# ╔═╡ 89a20b5c-bfa0-4914-9dee-d424b7d8b273


# ╔═╡ 111ccf75-b34c-4d39-8f77-e3b353c1c31d


# ╔═╡ d932bec4-b46b-4a12-acc2-bdd431ad239f
ims = Cockatrice.Logging.read_ims_at_step(log_dir=data_dir, step=:last)

# ╔═╡ aa48d63a-3dda-4d73-ab0f-1ccdde755d05
im_images = [colorant"white" .* im for im in ims]


# ╔═╡ cebd4f67-cdce-41b6-b97a-602ab791e8c7
mos = mosaicview(im_images..., fillvalue=colorant"red", ncol=2, npad=1)

# ╔═╡ d747b597-fdd6-41de-84fa-1999ef03c6de


# ╔═╡ 08f84737-c9f2-47f1-b4ac-fa3820d77c2a
difficulties(im) = map(mean, eachrow(im))

# ╔═╡ 48a6378e-20ae-46a5-b4a4-7d5618f1845e
difficulty_vectors = [difficulties.(ims) for ims in [Cockatrice.Logging.read_ims_at_step(log_dir=data_dir, step=i) for i in 1:38]]

# ╔═╡ 87c79026-9346-4fe4-b5c0-ce915baf4bd6
dv1 = [dv[1] for dv in difficulty_vectors]

# ╔═╡ 856903c5-ca50-4790-a865-2f131c76c81e
diff_mat = hcat(dv1...)

# ╔═╡ be7d30df-49ec-4d03-8b43-ef03f818cfcf
diff_mats = [hcat([dv[i] for dv in difficulty_vectors]...) for i in 1:4]

# ╔═╡ f47b293f-a248-4bc7-b274-41ff8de44d48
diff_flags = [colorant"red" .* m for m in diff_mats]

# ╔═╡ fb740845-21c5-49ba-8d29-e6ae333a5ec6
function make_diff_flags_for_dir(dir, num_islands=4, flag=true)
	num =  walkdir("$(dir)/IM/") |> first |> last |> length
	difficulty_vectors = [difficulties.(ims) for ims in [Cockatrice.Logging.read_ims_at_step(log_dir=dir, step=i) for i in 1:num]]
	filter!(!isempty, difficulty_vectors)
	diff_mats = [hcat([dv[i] for dv in difficulty_vectors]...) for i in 1:num_islands]
	if flag
		diff_flags = [colorant"red" .* m for m in diff_mats]
	else
		diff_mats
	end
end
	 

# ╔═╡ 2586f809-a809-4d28-b5e1-a31fdcf19dd0
walkdir("$(data_dir)/IM") |> first |> last |> length

# ╔═╡ 945ae2af-83f5-4131-810e-6c85c0064376
mats = make_diff_flags_for_dir(data_dir, 4, false)

# ╔═╡ 66ba6d7e-62a6-4801-8e80-b42750496dc8
mdf = DataFrame(mats[1]', :auto)


# ╔═╡ f791b3d4-9794-469f-8142-463ab835918d
length.(mats)

# ╔═╡ 762d4429-8c7b-4e3e-8e4f-cc51607a58fe


# ╔═╡ 1c9aa89f-4094-4715-82b5-afea90973beb
im = ims[1]

# ╔═╡ 56753ee0-9c80-4d16-ade3-035626085327
im_data = begin 
	d = DataFrame(vcat([hcat(fill(n, 100), im') for (n,im) in enumerate(ims)]...), :auto)
	rename!(d, :x1 => :island)
	d
end

# ╔═╡ 3fae3199-e0e3-41f7-86f2-9ff33c7fb75b
@df im_data andrewsplot(:island, cols(2:65), label=["island $(i)" for i in 1:4])

# ╔═╡ 980d957b-15ff-4997-9dac-71d20b7e8cfd
md"Not much to see here."

# ╔═╡ e605e28c-666a-483f-8bf9-d5e14291ff87
andrewsplot(im')

# ╔═╡ 67f0773a-e6ad-40ca-ac4b-a63b43e860e7


# ╔═╡ d5e08ed1-9956-4fe4-872f-cab86e687f62
function find_log_dirs(parent)
	log_dirs = []
	for (dir, subdirs, files) in walkdir(parent)
		if "STATUS.TXT" in files
			status = read("$(dir)/STATUS.TXT", String)
			if !occursin("terminated", status)
				push!(log_dirs, dir)
			end
		end
	end
	return log_dirs
end
				

# ╔═╡ d89528d5-3f0b-4b61-99bf-bea7d924f005
dirs = find_log_dirs("/home/lucca/logs/refusr/2021/08")

# ╔═╡ b238a0a0-19b1-4e8d-80ca-a8cd6394fd29
find_log_dirs("/home/lucca/logs/refusr") |> length

# ╔═╡ 8705758f-9bf2-4efc-8da5-d54e65d06f44
function assemble_reports(;log_dirs=["$(ENV["HOME"])/logs/refusr/2021/08/03", "$(ENV["HOME"])/logs/refusr/2021/08/04"], 
		tag="2MUX-with-sharing", cap=18)
	dirs = vcat([[d for d in find_log_dirs(log_dir) if occursin(tag, d)] for log_dir in log_dirs]...)
	trials = [replace(split(d, ".")[end], "-" => ":") for d in dirs]
	reports = ["$(dir)/report.csv" for dir in dirs]
	sort!(reports, by=mtime)
	dataframes = []
	for report in reports
		try
			push!(dataframes, CSV.read(report, DataFrame))
		catch e
			@warn "Error reading csv" e
		end
	end
	
	dataframes = [hcat(DataFrame(fill(T, nrow(df), 1), [:trial]), df) for (T, df) in zip(trials, dataframes) if df.objective_maximum[end] == 1.0][1:cap]
	vcat(dataframes...)
end
	
	

# ╔═╡ 81ba5340-abf7-4c59-84d1-0f64c3a219af
DATA_WEIGHTED = assemble_reports(log_dirs=["$(ENV["HOME"])/logs/refusr/2021/08/06"], tag="2MUX-with-sharing-weighted", cap=8)

# ╔═╡ eb01c9f0-20cd-46ff-a3c8-75bc93ad0446
DATA_UNWEIGHTED = assemble_reports(log_dirs=["$(ENV["HOME"])/logs/refusr/2021/08/06"], tag="2MUX-with-sharing-unweighted", cap=8)

# ╔═╡ 0566d86b-f205-490a-aed3-748aa3e43a58
DATA_SHARING = assemble_reports(tag="2MUX-with-sharing", cap=18)

# ╔═╡ 4d446dab-c7e7-492d-a1fe-4fbb3754fd69
DATA_NO_SHARE = assemble_reports(tag="2MUX-without-sharing", cap=18)

# ╔═╡ 189ee3ab-af82-4cac-8017-4a2d0739d615
number_of_trials = DATA_SHARING.trial |> unique |> length

# ╔═╡ ebe0ab2b-667f-40e1-b568-c1750563c6bc
number_of_trials_no_share = DATA_NO_SHARE.trial |> unique |> length

# ╔═╡ 9e81cce5-e89a-49dc-9c03-5372c4bc9922
config_no_share = prep_config("./config/config-2MUX.yaml")

# ╔═╡ c0aa70f0-b682-4385-8082-1934b8abd2aa
config_share = prep_config("./config/config-2MUX-sharing.yaml")

# ╔═╡ 9895e6a8-59a0-48f5-bddf-61d0b86209cd
config_no_share.experiment_duration

# ╔═╡ 6e69e89c-d56f-42dd-ba29-d45292584088
max_iter = 50_000

# ╔═╡ 4bc2509e-0e9e-43b9-a656-fadcc1f1dcbd
function mass_plot(df, title, colors)
	trials_n = df.trial |> unique |> length
	@df df plot(:iteration_mean, [:objective_maximum], group=:trial, legend=false, line=1, smooth=false, title="$(trials_n) Trials $(title)", xlims=(1,max_iter), palette=palette(colors, trials_n), titlefont=(10, "lato"))
end

# ╔═╡ 22e528e0-b32e-4244-ba04-faa4d9f9082f
p1 = mass_plot(DATA_NO_SHARE, "without Fitness Sharing", :deep)

# ╔═╡ 83831f41-516b-45e3-92af-752fa1efe8f1
p2 = mass_plot(DATA_SHARING, "with Fitness Sharing", :algae)

# ╔═╡ c2550683-c2ea-46e7-b976-7ded0e060383
plot(p1, p2)

# ╔═╡ b3e79e9c-69fd-4287-a2a7-62d8b28f534c
pw = mass_plot(DATA_WEIGHTED, "with chromosome weighting", :algae)

# ╔═╡ 21002b43-e9ce-4972-a5ea-fb3db003432b
pu = mass_plot(DATA_UNWEIGHTED, "without chromosome weighting", :deep)

# ╔═╡ 9cce63ac-1c31-4fa4-a7a7-65076e9499de
plot(pu, pw)

# ╔═╡ f627d14b-396d-4654-b516-824dd1fc036a


# ╔═╡ c1ada39b-902b-459f-8df4-fc85557c3259
function summary_for_df(df)
	w = filter(m -> m <= max_iter, df[df.objective_maximum .== 1.0, :].iteration_mean)
	(num_winners = length(w),
	 mean_win_at = mean(w),
	 median_win_at = median(w),
	)
end
	

# ╔═╡ a0571bfd-a2f8-4888-b7b1-13935b1372e0
summ_no_share = summary_for_df(DATA_NO_SHARE)

# ╔═╡ badb0449-2df0-42d0-ade8-56dc2727ce19
summ_share = summary_for_df(DATA_SHARING)

# ╔═╡ a23b08e5-a4be-4331-92cd-e22267fe7a02
summ_no_share.num_winners / 18

# ╔═╡ 817b8e69-507b-4087-83fa-df8d7cc902b3
summ_share.mean_win_at / summ_no_share.mean_win_at 

# ╔═╡ 31d906ec-9d1b-4a57-9638-97d6f1c8dbed
summ_weighted = summary_for_df(DATA_WEIGHTED)

# ╔═╡ f650ad68-c676-48a0-87e5-9cc33a4659f6
summ_unweighted = summary_for_df(DATA_UNWEIGHTED)

# ╔═╡ 514f856f-4b10-4dd9-86c2-12ad7a174a8d


# ╔═╡ 8a27dd38-15b5-4065-a5cf-5ebb19c9196e
md"## Poking at specimens"

# ╔═╡ 9c26cc8d-503c-427c-969e-4b273f67139f
mux3_specimen_file="./2021/08/03/3-MUX_meaty-inane-flush.20-48/specimens/027878_isle:03_gen:1030_perf:1.000000_name:tamps-spurs-roads-tawny_.json.gz"


# ╔═╡ 767efe15-9ad8-47bb-8f18-7e7947897a11


# ╔═╡ 510d05b6-ad08-4ee2-8ec4-6b7b38c2f5c6
m3g = Cockatrice.Logging.read_specimen_file(log_dir="$(ENV["HOME"])/logs/refusr/2021/08/03/3-MUX_meaty-inane-flush.20-48/", filename="027878_isle:03_gen:1030_perf:1.000000_name:tamps-spurs-roads-tawny_.json.gz", constructor=LinearGenotype.Creature)

# ╔═╡ 5157b4c7-2d2a-4fa7-9956-eecdd874cac5
Base.summarysize(m3g) ÷ 1024

# ╔═╡ 9d3d56ad-0266-4dc9-9991-1e008d84e36d
Base.summarysize(@set m3g.phenotype = nothing) ÷ 1024

# ╔═╡ 150de81d-540f-419b-a85b-3d15316b6c96
Base.summarysize(@set m3g.phenotype.trace = nothing) ÷ 1024

# ╔═╡ c16b640b-ec42-4ab6-ad6d-e2a02adb49a8
function show_crossover_weights(g)
	base = zeros(length(g.chromosome))
	base[g.effective_indices] .= g.phenotype.trace_info
	base .* colorant"cyan"
end

# ╔═╡ 770749ba-8542-4457-9394-2762845caaac
show_crossover_weights(m3g)

# ╔═╡ 4718a305-6400-4d7a-b70f-c1333f53c48a
colorant"white" .* m3g.phenotype.trace |> AxisArray

# ╔═╡ f00a143c-0f3e-486a-a06b-7288ba6db070
trace = AxisArray(m3g.phenotype.trace, 
	register=1:6, #=[Symbol("R$(i)") for i in 1:6], =#
	input=1:2048, 
	pc=1:164)

# ╔═╡ 57b22d4a-eacc-4115-9e08-a630a22d6c41
size(m3g.phenotype.trace)

# ╔═╡ d5c4d48a-1c5b-4e1f-b56c-f5c4a1b12b41
mosaicview([colorant"lightgreen" .* trace[register=r] for r in 1:6], ncol=6, npad=10, fillvalue=colorant"white", border=nothing)'

# ╔═╡ c627adf0-47b7-40d7-99dc-6203645ff668
function visualize_execution_trace(trace)
	n_reg, n_case, n_step = size(trace)
	mosaicview([colorant"lightgreen" .* trace[r, :, :]' for r in 1:n_reg], nrow=n_reg, npad=10, fillvalue=colorant"white")'
end

# ╔═╡ eeb3b541-b2bd-4f1a-9c07-d483ef37ecf7
visualize_execution_trace(m3g.phenotype.trace)

# ╔═╡ 68498295-2ceb-41dd-bf87-31bd6b7853c5
trace[register=1][:,end] == m3g.phenotype.results # should be true

# ╔═╡ 6ec8f0ca-1f72-4336-bb44-75ed9435eac1


# ╔═╡ 73dffe9f-423e-45ef-8d7a-1828229817cf


# ╔═╡ 2a843f8b-ebe1-4dd8-a964-9aa35629c186
md"### TODO: use AxisArray in the code, but don't worry about it right now"

# ╔═╡ e109d2db-4723-4827-9339-dbf16d53ed56


# ╔═╡ fc2c2a7b-df11-4d4d-8327-4ecdbe2d346f
md"### TODO: drop the trace after taking measurements, or when deserializing, optionally, but don't fuck with this today"

# ╔═╡ 22b85c95-c2d7-4f3b-b29b-1a961134d5f4
md"# Trace information visualizations"

# ╔═╡ ee06a877-d902-426e-9175-3e31ef6ba968

function plot_trace_information(g;
                                title="",
                                measure=:trace_info)
    disas = string.(g.chromosome)
    X = 1:length(g.chromosome)
    Y = zeros(length(g.chromosome))
    Y[g.effective_indices] .= g.phenotype[measure]
    dst_registers = [inst.dst for inst in g.chromosome]
    distinct_reg = unique(dst_registers) |> sort
    function filter_by_reg(series, reg)
        [(dst_registers[i] == reg ? v : 0) for (i, v) in enumerate(series)]
    end
    data = [(x = X,
             y = filter_by_reg(Y, reg),
             name = "R[$(reg)]",
             type = "bar",
             text = disas)
     for reg in distinct_reg]
	
	data = [filter_by_reg(Y, r) for r in distinct_reg]
	

	groupedbar(X, data, group=distinct_reg)
#    dcc_graph(
#        id = "specimen-trace-info-plot",
#        figure = (
#            data = data,
#            layout = (title = title,
#                      barmode = "group",
#                      labels = (x = 1:length(X), y = 1:length(Y))),
#        )
#    )
end



# ╔═╡ eeae4436-39a5-43db-91d7-778d9a7f56c5
plot_trace_information(m3g)

# ╔═╡ ae9e52ed-9a1b-430e-bf23-c0bb24f5c03f


# ╔═╡ 304e7365-b0f0-48cb-8a6e-bcbd80dc0986


# ╔═╡ 1a2a17a4-c4fa-42ac-861d-d2f1d97c77f9
md"## Visualizing Linear Programs with Graphs"

# ╔═╡ 89d75d2f-daab-477e-b59a-5eccdafdba19
specimens = Cockatrice.Logging.list_specimen_files(data_dir)

# ╔═╡ 481d632a-5a03-4100-b877-deba66791313


# ╔═╡ 25d31591-84c9-4405-9e5c-da5229f4a57d


# ╔═╡ 42d12b00-80ca-48a5-8ee3-e1da4822d01f


# ╔═╡ Cell order:
# ╠═36e9f994-f3f2-11eb-18f0-5b48a3a86ad9
# ╠═57ae94f1-f91e-4233-be3f-37b14cb0c339
# ╠═6081ab2a-e713-466c-8538-5cb3340ccfa1
# ╠═d3bceea1-79a4-456c-b539-6eed3750f4c2
# ╠═7ce399f5-cd61-4068-9735-d47721cf725e
# ╠═616a954f-c789-442e-8942-78e9789a7df5
# ╠═235845e3-c575-4922-beb1-47eba1fcb58a
# ╠═462b15f1-f2bb-4c4e-9f6f-bf4822c1ed36
# ╠═89a20b5c-bfa0-4914-9dee-d424b7d8b273
# ╠═111ccf75-b34c-4d39-8f77-e3b353c1c31d
# ╠═d932bec4-b46b-4a12-acc2-bdd431ad239f
# ╠═aa48d63a-3dda-4d73-ab0f-1ccdde755d05
# ╠═cebd4f67-cdce-41b6-b97a-602ab791e8c7
# ╠═d747b597-fdd6-41de-84fa-1999ef03c6de
# ╠═08f84737-c9f2-47f1-b4ac-fa3820d77c2a
# ╠═48a6378e-20ae-46a5-b4a4-7d5618f1845e
# ╠═87c79026-9346-4fe4-b5c0-ce915baf4bd6
# ╠═856903c5-ca50-4790-a865-2f131c76c81e
# ╠═be7d30df-49ec-4d03-8b43-ef03f818cfcf
# ╠═f47b293f-a248-4bc7-b274-41ff8de44d48
# ╠═fb740845-21c5-49ba-8d29-e6ae333a5ec6
# ╠═2586f809-a809-4d28-b5e1-a31fdcf19dd0
# ╠═945ae2af-83f5-4131-810e-6c85c0064376
# ╠═66ba6d7e-62a6-4801-8e80-b42750496dc8
# ╠═f791b3d4-9794-469f-8142-463ab835918d
# ╠═d89528d5-3f0b-4b61-99bf-bea7d924f005
# ╠═762d4429-8c7b-4e3e-8e4f-cc51607a58fe
# ╠═1c9aa89f-4094-4715-82b5-afea90973beb
# ╠═56753ee0-9c80-4d16-ade3-035626085327
# ╠═3fae3199-e0e3-41f7-86f2-9ff33c7fb75b
# ╠═980d957b-15ff-4997-9dac-71d20b7e8cfd
# ╠═e605e28c-666a-483f-8bf9-d5e14291ff87
# ╠═67f0773a-e6ad-40ca-ac4b-a63b43e860e7
# ╠═d5e08ed1-9956-4fe4-872f-cab86e687f62
# ╠═b238a0a0-19b1-4e8d-80ca-a8cd6394fd29
# ╠═8705758f-9bf2-4efc-8da5-d54e65d06f44
# ╠═81ba5340-abf7-4c59-84d1-0f64c3a219af
# ╠═eb01c9f0-20cd-46ff-a3c8-75bc93ad0446
# ╠═0566d86b-f205-490a-aed3-748aa3e43a58
# ╠═4d446dab-c7e7-492d-a1fe-4fbb3754fd69
# ╠═189ee3ab-af82-4cac-8017-4a2d0739d615
# ╠═ebe0ab2b-667f-40e1-b568-c1750563c6bc
# ╠═9e81cce5-e89a-49dc-9c03-5372c4bc9922
# ╠═c0aa70f0-b682-4385-8082-1934b8abd2aa
# ╠═9895e6a8-59a0-48f5-bddf-61d0b86209cd
# ╠═6e69e89c-d56f-42dd-ba29-d45292584088
# ╠═4bc2509e-0e9e-43b9-a656-fadcc1f1dcbd
# ╠═22e528e0-b32e-4244-ba04-faa4d9f9082f
# ╠═83831f41-516b-45e3-92af-752fa1efe8f1
# ╠═c2550683-c2ea-46e7-b976-7ded0e060383
# ╠═b3e79e9c-69fd-4287-a2a7-62d8b28f534c
# ╠═21002b43-e9ce-4972-a5ea-fb3db003432b
# ╠═9cce63ac-1c31-4fa4-a7a7-65076e9499de
# ╠═f627d14b-396d-4654-b516-824dd1fc036a
# ╠═c1ada39b-902b-459f-8df4-fc85557c3259
# ╠═a0571bfd-a2f8-4888-b7b1-13935b1372e0
# ╠═badb0449-2df0-42d0-ade8-56dc2727ce19
# ╠═a23b08e5-a4be-4331-92cd-e22267fe7a02
# ╠═817b8e69-507b-4087-83fa-df8d7cc902b3
# ╠═31d906ec-9d1b-4a57-9638-97d6f1c8dbed
# ╠═f650ad68-c676-48a0-87e5-9cc33a4659f6
# ╠═514f856f-4b10-4dd9-86c2-12ad7a174a8d
# ╠═8a27dd38-15b5-4065-a5cf-5ebb19c9196e
# ╠═9c26cc8d-503c-427c-969e-4b273f67139f
# ╠═767efe15-9ad8-47bb-8f18-7e7947897a11
# ╠═510d05b6-ad08-4ee2-8ec4-6b7b38c2f5c6
# ╠═cd5e70f4-0030-491c-a718-4a43b5a5ce38
# ╠═5157b4c7-2d2a-4fa7-9956-eecdd874cac5
# ╠═9d3d56ad-0266-4dc9-9991-1e008d84e36d
# ╠═150de81d-540f-419b-a85b-3d15316b6c96
# ╠═c16b640b-ec42-4ab6-ad6d-e2a02adb49a8
# ╠═770749ba-8542-4457-9394-2762845caaac
# ╠═4718a305-6400-4d7a-b70f-c1333f53c48a
# ╠═83732ace-29b8-43bb-984f-35311fbb1cab
# ╠═f00a143c-0f3e-486a-a06b-7288ba6db070
# ╠═57b22d4a-eacc-4115-9e08-a630a22d6c41
# ╠═d5c4d48a-1c5b-4e1f-b56c-f5c4a1b12b41
# ╠═c627adf0-47b7-40d7-99dc-6203645ff668
# ╠═eeb3b541-b2bd-4f1a-9c07-d483ef37ecf7
# ╠═68498295-2ceb-41dd-bf87-31bd6b7853c5
# ╠═6ec8f0ca-1f72-4336-bb44-75ed9435eac1
# ╠═73dffe9f-423e-45ef-8d7a-1828229817cf
# ╠═2a843f8b-ebe1-4dd8-a964-9aa35629c186
# ╠═e109d2db-4723-4827-9339-dbf16d53ed56
# ╠═fc2c2a7b-df11-4d4d-8327-4ecdbe2d346f
# ╠═22b85c95-c2d7-4f3b-b29b-1a961134d5f4
# ╠═ee06a877-d902-426e-9175-3e31ef6ba968
# ╠═eeae4436-39a5-43db-91d7-778d9a7f56c5
# ╠═ae9e52ed-9a1b-430e-bf23-c0bb24f5c03f
# ╠═304e7365-b0f0-48cb-8a6e-bcbd80dc0986
# ╠═1a2a17a4-c4fa-42ac-861d-d2f1d97c77f9
# ╠═89d75d2f-daab-477e-b59a-5eccdafdba19
# ╠═481d632a-5a03-4100-b877-deba66791313
# ╠═25d31591-84c9-4405-9e5c-da5229f4a57d
# ╠═d8068859-053e-4193-8812-2dcce776bb91
# ╠═42d12b00-80ca-48a5-8ee3-e1da4822d01f
