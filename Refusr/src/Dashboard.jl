module Dashboard

using Distributed
using Dash
using Dates
using Memoize
using LRUCache
using DashDaq
using DashCoreComponents
using Images
using FileIO
using JSON
using ImageIO
using DashHtmlComponents
using DataFrames
using ..LinearGenotype
using ..Expressions
using Base64
using PlotlyBase
using Plotly
using Cockatrice.Logging: Logger
using Cockatrice.Logging
using Serialization



REFUSR_DEBUG = "REFUSR_DEBUG" ∈ keys(ENV) ? parse(Bool, ENV["REFUSR_DEBUG"]) : false

ASSET_DIR = "$(@__DIR__)/../assets"
UI = dash(assets_folder=ASSET_DIR, suppress_callback_exceptions=!REFUSR_DEBUG)



function initialize_server(;config,
                           update_interval=2,
                           debug=REFUSR_DEBUG,
                           background=true) 
    global UI
    UI.layout = html_div() do
        html_h1("REFUSR UI", style = Dict("textAlign" => "center")),
        html_div(id="loginfo", style = Dict("display" => "None")) do
            config.logging.dir,
            now() |> string
        end,
        dcc_interval(id="main-interval", interval=update_interval*1000),
        daq_toggleswitch(id="pause-switch", value=false, label="PAUSE", vertical=false,
                         style=Dict("display" => "None")),
        html_div(id="data-container", style = Dict("display" => "None")),
        generate_main_page(config)
    end
 
    enable_dev_tools!(UI, dev_tools_hot_reload=false)
    Dash.set_title!(UI, "REFUSR UI")
    @info "Starting Dash server..."
    if background
        return @async run_server(UI, config.dashboard.server, config.dashboard.port; debug)
    else
        return run_server(UI, config.dashboard.server, config.dashboard.port; debug)
    end
end




## TODO: Decompile and plot AST, etc. on demand, not automatically.
## The user should have to click something to trigger the decompilation, etc.
## And _all_ the elites from all the islands should be made available for this.
## the user can page through them, decompile them at will, inspect them, and so on.
## This will make up the interactive aspect of the app, _and_ reduce unnecessary overhead


function check_server(config)
    server = config.dashboard.server
    port = config.dashboard.port
    for i in 1:3
        try
            run(`nc -z $(server) $(port)`)
            @info "Server is listening"
            return true
        catch _
            sleep(1)
            continue
        end
    end
    return false
end




## Example:
# p1 = Plot(iris, x=:SepalLength, y=:SepalWidth, mode="markers", marker_size=8, group=:Species)

function fix_name(col)
    subs = [
        "_" => " ",
        "fitness 1" => "relative ingenuity",
        "fitness 2" => "trace information",
        "fitness 3" => "parsimony",
        "likeness" => "family resemblance",
        "meanfinite" => "mean",
        "std" => "(standard deviation)",
        "len" => "length",
        "num" => "number of",
    ]
    str = string(col)
    for p in subs
        str = replace(str, p)
    end
    parts = split(str)
    if parts[end] ∈ ["mean", "maximum"]
        return "$(parts[end]) $(join(parts[1:(end-1)], " "))"
    else
        return str
    end
end


function plot_stat(D::DataFrame;
                   cols::Vector,
                   id="stats-plot",
                   title="REFUSR Plot")
    X = D.iteration_mean
    names = fix_name.(cols)
    data = [(x = X, y = D[!,Y], name = N) for (Y,N) in zip(cols, names)]
    dcc_graph(
        id = id,
        figure = (
            data = data,
            layout = (title = title,)
        )
    )
end


function generate_table(D::DataFrame, max_rows = 10; id = "stats")

    range = if nrow(D) <= max_rows
        (1:nrow(D))
    else
        [Int(ceil(n)) for n in LinRange(1, nrow(D), max_rows)]
    end
    html_div() do
        html_h2("Time Series Statistics"),
        html_div(style = Dict(
            "border" => "2px solid #aaa",
            "overflow-x" => "scroll",
            "overflow-y" => "hidden",
            "width" => "100%",
        )) do
            html_table(id="stats-table",
                       style = Dict(
                           "padding" => "3px",
                           "border-spacing" => "15px",
                           "border" => "0px",
                       ),
                       [html_thead(html_tr([html_th(fix_name(col)) for col in names(D)])),
                        html_tbody([
                            html_tr([html_td(round(D[r, c], digits=4)) for c in names(D)])
                            for r in range
                        ])])
        end
    end
end


function specimen_summary(g, title; id = "specimen-summary")
    dcc_markdown(id=id,
                 """
    - Name: $(g.name)
    - Native Island: $(g.native_island)
    - Generation: $(g.generation)
    - Parents: $(isnothing(g.parents) ? "none" : join(g.parents, ", "))
    - Number of Offspring: $(g.num_offspring)
    - Phenotypic Resemblance to Parents: $(isnothing(g.likeness) ? "N/A" : join(string.(g.likeness), ", "))
    - Fitness Scores: $(join(string.(g.fitness), ", "))
    - **Performance: $(g.performance)**

    """)
end


function disassembly(g; id="disassembly")

    chromosome_disas = join(string.(g.chromosome), "\n") * "\n"
    effective_disas = join(string.(g.effective_code), "\n") * "\n"

    len_c = length(g.chromosome)
    len_e = length(g.effective_code)

    dcc_markdown(
        id = id,
"""
## Chromosome

$(len_c) Instructions

```{.asm}
$(chromosome_disas)
```

## Effective Code

$(len_e) Instructions ($(round(100.0 * len_e / len_c, digits=2))% of Chromosome)

```{.asm}
$(effective_disas)
```
""")
end


function encode_svg(svg)
    "data:image/svg+xml;base64,$(base64encode(svg))"
end


function encode_png(png)
    "data:image/png;base64,$(base64encode(png))"
end


function decompilation(cached::Dict)
    symbolic = cached["symbolic"]
    syntax_tree_url = cached["tree"]
    syntax_graph_url = cached["graph"]

    diagrams = if !isempty(syntax_tree_url)
        html_div() do
            html_h3("Expression Diagrams"),
            html_img(id="syntax-tree",
                     src=syntax_tree_url,
                     title="Syntax Tree"),
            html_img(id="syntax-graph",
                     src=syntax_graph_url,
                     title="Syntax Graph")
        end
    else
        html_div()
    end

    return html_div(id="decompilation") do
        html_h2("Decompiled to Symbolic Expression"),
        html_div(style = Dict(
            "border" => "2px solid #aaa",
            "overflow-x" => "scroll",
            "overflow-y" => "hidden",
            "width" => "100%",
        )) do
            html_pre("\n$(symbolic)\n", style = Dict("textAlign" => "center"))
        end,
        diagrams
    end

end

function decompilation_helper(g::LinearGenotype.Creature)::Dict
    symbolic = LinearGenotype.decompile(g)
    tree, graph = if symbolic isa Expr
        tr = Expressions.diagram(symbolic, format=:svg, tree=true) |> encode_svg
        gr = Expressions.diagram(symbolic, format=:svg, tree=false) |> encode_svg
        (tr, gr)
    else
        ("", "")
    end

    Dict("name" => g.name,
         "symbolic" => string(symbolic),
         "tree" => tree,
         "graph" => graph)
end


decompilation(g::LinearGenotype.Creature) = decompilation_helper(g) |> decompilation

function interaction_matrix_image(ims::Array)
    if isempty(ims)
        return ""
    end
    imgs = [colorant"white" .* im for im in ims]
    mos = mosaicview(imgs..., fillvalue=colorant"red", ncol=(length(imgs)÷2), npad=1)

    io = IOBuffer()
    save(Stream(format"PNG", io), mos)
    data = take!(io)
    encode_png(data)
end


interaction_matrix_image(already_png_encoded::String) = already_png_encoded


function interaction_matrix_viewer(n; id="interaction-matrices")

    url = ""

    #if 1 <= n <= length(L.im_log)
    #    interaction_matrix_image(L.im_log[n])
    #else
    #    ""
    #end

    image = html_img(id="interaction-matrices-image",
                     src=url,
                     title="Interaction Matrices",
                     width="100%")
    #marks = Dict([Symbol(v) => Symbol(L.table.iteration_mean[v] |> ceil)
    #              for v in Int.(ceil.(LinRange(1, length(L.im_log), 100)))])
    html_div(id=id) do
        html_h1("Interaction Matrices"),
        image,
        dcc_slider(id="interaction-matrices-slider",
                   min = 1,
                   max = n,
                   marks = Dict(Symbol(1) => Symbol(1)),
                   value = n,
                   persistence = true,
                   persistence_type = "session",
                   updatemode = "mouseup",
                   ),
        dcc_markdown(id="interaction-matrix-explanation",
"""
### Explanation

Interaction matrices are a data structure used to calculate the relative selective
pressures of each test case -- which, in this context, means a set of inputs for a
Boolean function, or the input row of its truth table. Each test case is assigned a
_difficulty_ score, equal to 1 minus the frequency with which its solution appears in the
existing population (i.e., `(~).(row .⊻ answer_vector) |> mean`, in Julia). An
individual is then assigned a score equal to the sum of difficulties of the cases
they solved correctly, divided by the total number of cases. This is the source of
the value `fitness 1` in the fitness vector.

Each subpopulation, or "island", maintains its own interaction
matrix. In the visualizations above, each row represents a test case (a set of
inputs for a Boolean function), and each column represents an individual in the
subpopulation. Test cases are sorted by
[Gray code](https://en.wikipedia.org/wiki/Gray_code), to preserve locality on the
Boolean hypercube (two adjacent test cases differ by exactly one bit flip), and
individuals are sorted according to [Hilbert curve](https://en.wikipedia.org/wiki/Hilbert_curve)
through the 2-dimensional island population, to preserve geographical locality.

This provides us with a succinct impression of the phenotypic diversity of
each subpopulation.

""")
    end
end

# TODO see Plotly heatmaps

# I really wish there was a better way of doing this than mucking around
# with global state, but that seems to be the only way forward for now
# at least it's just in the gui


function specimen_selector(len; id="specimen-dropdown")
    return specimen_dropdown([])

    # dcc_slider(id  = id,
    #            min = 1,
    #            max = len,
    #            marks = Dict([Symbol(v) => Symbol(v) for v in 1:len]),
    #            value = len,
    #            step = nothing,
    #            persistence = true,
    #            persistence_type = "session",
    #            updatemode = "mouseup",
    #            )
end


function decompilation_in_progress(;hidden=false)
    # html_button(id="decompile-button",
    #             hidden=false,
    #             children="PRESS TO DECOMPILE (AND WAIT)",
    #             n_clicks = 0)

    style = hidden ? Dict("display" => "None") : Dict()
    html_div(id="decompilation-in-progress", style = style) do
        html_h2("Decompilation in progress..."),
        html_img(id="decompiling-hourglass", src="/assets/img/hourglass.gif")
    end
end


function specimen_report(g;
                         id="specimen-report")
    title = g.performance == 1.0 ? "Champion $(g.name)" : "Specimen $(g.name)"

    # TODO: put a plot of the trace information curve here
    [
        html_h2(title),
        html_hr(),
        specimen_summary(g, title, id="specimen-summary"),
        html_hr(),
        specimen_decompilation_container(hidden=false),
        html_hr(),
        disassembly(g, id="specimen-disassembly"),
        html_div(id="current-report-name", g.name, style=Dict("display" => "None"))
    ]
end

function __make_specimen_dropdown_options(specimens::Vector)
    #specimens = JSON.parse.(specimen_vec)
    s = sort(collect(enumerate(specimens)), by=p->p[2].performance)
    [
        (label="""Island $(g.native_island), Generation $(g.generation): $(g.name), performance: $(round(g.performance, digits=4))""", value=i) for (i,g) in s
    ] |> reverse
end

function _make_specimen_dropdown_options(specimen_vec::Vector)
    specimens = JSON.parse.(specimen_vec)
    s = sort(collect(enumerate(specimens)), by=p->p[2]["performance"])
    [
        (label="""Island $(j["native_island"]), Generation $(j["generation"]): $(j["name"]), performance: $(round(j["performance"], digits=4))""", value=i) for (i,j) in s
    ] |> reverse
end


function make_specimen_dropdown_options(specimen_files::Vector)
    mklabel(d) = """Island $(d["isle"]), Generation $(d["gen"]): $(d["name"]), performance: $(d["perf"])"""
    pre = [(label_info=Logging.parse_specimen_filename(f), value=f) for f in specimen_files]
    sort!(pre, by=p->p[1]["perf"], rev=true)
    [(label=mklabel(p.label_info), value=p.value) for p in pre]
end


function specimen_dropdown(specimen_files::Vector; id="specimen-dropdown")
    options = make_specimen_dropdown_options(specimen_files)
    dcc_dropdown(id=id,
                 placeholder="Choose a specimen to examine",
                 persistence=true,
                 persistence_type="session",
                 options=options,
                 )
end


# TODO consider refactoring. You don't actually need to rebuild the layout
# on every refresh. instead, just update the global LOGGER variable.
# initialize the layout early on, and then just update the elements. See if
# you can trigger an element refresh from julia.

function encode_table(table)
    columns = names(table)
    data = reinterpret(UInt8, Array{Float64}(table)) |> base64encode
    (columns = columns, data = data) |> json
end


function decode_table(blob)
    j = JSON.parse(blob)
    columns = Symbol.(j["columns"])
    raw = base64decode(j["data"])
    vec = reinterpret(Float64, raw)
    data = reshape(vec, (length(vec)÷length(columns), length(columns))) |> collect
    DataFrame(data, columns)
end


function stats_dropdown(;options, value=options)
    options = [(label = fix_name(v), value = v) for v in options]
    dcc_dropdown(
        id= "stats-dropdown",
        options = options,
        value = value,
        persistence = true,
        persistence_type = "session",
        multi = true,
    )
end

function specimen_decompilation_container(;hidden=false)
    html_div(id="specimen-decompilation-container") do
        decompilation_in_progress(hidden=hidden),
        html_div(id="decompilation-cache",
                 children = json(Dict()),
                 style = Dict("display" => "None")),
        html_div(id="specimen-decompilation"),
        html_div(id="current-decompilation-name", "nothing has been decompiled yet",
                 style=Dict("display" => "None"))
    end
end

# FIXME do NOT put the content here. just put the containers
# and then update the content through individual callbacks
# triggered by changes in the data container
function generate_main_page(config)
    ##
    # L just needs to be an object with the fields:
    # - table
    # - specimens
    # - im_log
    ##
    #@assert check_server(L.config) "Server is down"

    content = []

    #push!(content, html_h1("REFUSR UI", style = Dict("textAlign" => "center")))

    # Let's add some graphs
    statistics = html_div(id="statistics") do
        html_div(id="plot-container"),
        html_div(id="stats-dropdown-container") do
            stats_dropdown(options=[:objective_meanfinite, :objective_maximum])
        end,
        html_div(id="table-container") do
            #    generate_table(L.table, 10, id="stats-table")
        end #,
        #html_button(id="table-refresh", "PRESS TO REFRESH")
    end


    push!(content, statistics)


    push!(content, interaction_matrix_viewer(1, id="interaction-matrices"))

    # A specimen report
    #report = if !isempty(L.specimens)
    #    specimen_report(L.specimens[end], length(L.specimens))
    #else
    #html_div(id="specimen-report")
    #end

    specimen_report_container = html_div(id="specimen-report-container") do
        html_h1("Specimen Report"),
        specimen_dropdown([], id="specimen-dropdown"),
        html_div(id="specimen-jar", children=[], style=Dict("display" => "None")),
        html_div(id="specimen-report") do
            specimen_decompilation_container()
        end,
        html_div(id="current-report-name", "no report has been generated yet",
                 style=Dict("display" => "None"))
    end

    push!(content, specimen_report_container)

    config_txt = html_div(id="config-txt") do
        html_hr(),
        html_h1("Configuration for this Experiment"),
        html_pre("$(config.yaml)"),
        html_hr(),
        html_a(href="file://$(config.logging.dir)", "Log directory: $(config.logging.dir)")
    end

    push!(content, config_txt)


    html_div(id="main") do
        content
    end
end


function populate_data_container(L)
    @debug "In populate_data_container"
    @time children = [
        html_div(id="table-data-container") do
        L.table |> encode_table
        end,
        html_div(id="specimen-data-container") do
        json.(L.specimens)
        end,
        html_div(id="im-data-container") do
        interaction_matrix_image.(L.im_log)
        end,
    ]
    @debug "Size of data container's children:" Base.summarysize(children)
    return children
end

###
# Dash Callbacks
###

##
# Throws an exception if the serialized logger hasn't been modified
# since mod_time. This is fine. Dash.jl will catch it, and it's a useful
# way of preventing callbacks from executing if there's no new data.
##
function get_logger(log_dir, mod_time=nothing)
    path = "$(log_dir)/.L.dump"
    if !isfile(path)
        throw(PreventUpdate())
    end
    if isnothing(mod_time)
        return deserialize(path)
    end
    # TODO check if file exists
    new_mod_time = mtime(path) |> unix2datetime
    old_mod_time = DateTime(mod_time)
    if old_mod_time < new_mod_time # FIXME
        @debug "$(path) has changed, deserializing Logger" old_mod_time new_mod_time
        (deserialize(path), new_mod_time)
    else
        throw(PreventUpdate())
    end
end



function with_logger(loginfo, method, args...)
    log_dir, mod_time = loginfo
    L, new_mod_time = get_logger(log_dir, mod_time)
    loginfo_children = [log_dir, new_mod_time]
    (method(L, args...), loginfo_children)
end



callback!(
    UI,
    Output("interaction-matrices-image", "src"),
    Input("interaction-matrices-slider", "value"),
    Input("loginfo", "children"),
) do im_idx, loginfo
    log_dir, _mod_time = loginfo
    if isnothing(im_idx)
        im_idx = :last
    end

    try
        @debug "interaction matrix time" im_idx
        ims = Logging.read_ims_at_step(log_dir=log_dir, step=im_idx)
        @debug "got ims" ims
        interaction_matrix_image(ims)
    catch e
        @warn "error $(e) in interaction-matrix-image callback!"
        
        throw(PreventUpdate())
    end
end

callback!(
    UI,
    Output("specimen-dropdown", "options"),
    Input("loginfo", "children"),
) do loginfo
    log_dir, _mod_time = loginfo
    specimen_files = Logging.list_specimen_files(log_dir)
    @debug "in specimen-dropdown callback, to make options" specimen_files
    if isempty(specimen_files)
        throw(PreventUpdate())
    end
    res = make_specimen_dropdown_options(specimen_files)
    @debug "made options" res
    return res
end


callback!(
    UI,
    Output("interaction-matrices-slider", "max"),
    Output("interaction-matrices-slider", "marks"),
    Output("interaction-matrices-slider", "value"),
    #Input("im-data-container", "children"),
    Input("loginfo", "children"),
    State("interaction-matrices-slider", "value"),
) do loginfo, _cur_val
    log_dir, _mod_time = loginfo
    slider_max = Logging.count_im_batches(log_dir)
    if slider_max == 0
        throw(PreventUpdate())
    end
    slider_marks = Dict("" => "" for v in 1:slider_max)
    (slider_max, slider_marks, slider_max)
end

callback!(
    UI,
    Output("specimen-report", "children"),
    Input("specimen-dropdown", "value"),
    Input("loginfo", "children"),
    State("current-report-name", "children"),
    #State("specimen-data-container", "children"),
) do choice, loginfo, current_report_name

    @debug "In specimen report callback " choice current_report_name
 
    log_dir, _mod_time = loginfo

    if isnothing(choice)
        throw(PreventUpdate())
    end

    if occursin(current_report_name, choice)
        throw(PreventUpdate())
    end


    specimen = Logging.read_specimen_file(log_dir=log_dir,
                                          filename=choice,
                                          constructor=LinearGenotype.Creature)

    #if !isempty(jar) && specimen.name == JSON.parse(jar[1])["name"]
    #    throw(PreventUpdate())
    #end
    @debug "Generating report for specimen $(specimen.name)"
    specimen_report(specimen) #, length(specimen_vec))
end

callback!(
    UI,
    Output("specimen-decompilation", "children"),
    Output("decompilation-in-progress", "hidden"),
    Output("decompilation-cache", "children"),
    Output("current-decompilation-name", "children"),
    Input("specimen-dropdown", "value"),
    State("decompilation-cache", "children"),
    State("loginfo", "children"),
    State("current-decompilation-name", "children"),
) do choice, cache, loginfo, current_decompilation_name
    @debug "In specimen decompilation callback " choice cache
    if isnothing(choice)
        throw(PreventUpdate())
    end

    if occursin(current_decompilation_name, choice)
        throw(PreventUpdate())
    end

    log_dir, _mod_time = loginfo
    specimen = Logging.read_specimen_file(log_dir=log_dir,
                                          filename=choice,
                                          constructor=LinearGenotype.Creature)

    @debug "In decompilation handler. specimen: $(specimen.name)"
    D = JSON.parse(cache)
    if specimen.name ∈ keys(D)
        d = D[specimen.name]
        return decompilation(d), true, cache, specimen.name
    else
        d = decompilation_helper(specimen)
        D[specimen.name] = d
        return decompilation(d), true, json(D), specimen.name
    end
end


callback!(
    UI,
    Output("stats-dropdown-container", "children"),
    #Input("table-data-container", "children"),
    Input("loginfo", "children"),
    State("stats-dropdown", "value"),
) do loginfo, selection
    #j = JSON.parse(blob)
    log_dir, _mod_time = loginfo
    names = Symbol.(split(readline("$(log_dir)/report.csv"), ","))
    stats_dropdown(options=names, value=selection)
end
# passing the current value through as a hint that this callback should be executed
# before the one that builds the plot


callback!(
    UI,
    Output("table-container", "children"),
    Output("plot-container", "children"),
    Input("loginfo", "children"),
    Input("stats-dropdown", "value"),
    #Input("table-data-container", "children")
) do loginfo, plot_columns #, blob
    #table = decode_table(blob)
    log_dir, mod_time = loginfo
    try
        table = Logging.read_table(log_dir)
        (generate_table(table, 10),
         plot_stat(table,
                   cols=plot_columns,
                   title="Time Series Plots"))
    catch e # if file doesn't exist yet
        @warn "error $(e) in table handler"
        throw(PreventUpdate())
    end
end



callback!(
    UI,
    Output("loginfo", "children"),
    Input("main-interval", "n_intervals"),
    Input("pause-switch", "value"),
    State("loginfo", "children"),
) do n_intervals, pause, loginfo
    log_dir, mod_time = loginfo
    stamp_path = "$(log_dir)/.L.stamp"
    if !(isfile(stamp_path))
        throw(PreventUpdate())
    end
    new_mod_time = mtime(stamp_path) |> unix2datetime
    old_mod_time = DateTime(mod_time)
    if old_mod_time == new_mod_time
        throw(PreventUpdate())
    end
    [log_dir, string(new_mod_time)]
end

# callback!(
#     UI,
#     Output("data-container", "children"),
#     Output("loginfo", "children"),
#     Input("main-interval", "n_intervals"),
#     Input("pause-switch", "value"),
#     State("loginfo", "children"),
# ) do n_intervals, pause, loginfo
#     if pause
#         throw(PreventUpdate())
#     end
#     @time with_logger(loginfo, populate_data_container)
# end
## Consider:
# Things might run more smoothly if we stream data to disk, and then use callbacks
# in the UI to dynamically read and render that data.
##

end # End module

# TODO visualize the execution trace and its information content in an interesting, colourful way
