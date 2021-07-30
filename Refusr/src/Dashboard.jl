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
        daq_toggleswitch(id="pause-switch", value=false, label="PAUSE", vertical=false),
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


function launcher_ui()
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
                       [html_thead(html_tr([html_th(col) for col in names(D)])),
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
                   marks = [Dict(Symbol(1) => Symbol(1))],
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


function specimen_selector(len; id="specimen-slider")
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


function decompilation_in_progress()
    # html_button(id="decompile-button",
    #             hidden=false,
    #             children="PRESS TO DECOMPILE (AND WAIT)",
    #             n_clicks = 0)

    html_div(id="decompilation-in-progress") do
        html_h2("Decompilation in progress..."),
        html_img(id="decompiling-hourglass", src="/assets/img/hourglass.gif")
    end
end


function specimen_report(g, len;
                         id="specimen-report")
    title = g.performance == 1.0 ? "Champion $(g.name)" : "Specimen $(g.name)"

    [
        html_h2(title),
        html_hr(),
        specimen_summary(g, title, id="specimen-summary"),
        html_hr(),
        specimen_decompilation_container(),
        html_hr(),
        disassembly(g, id="specimen-disassembly"),
    ]
end


function make_specimen_dropdown_options(specimen_vec::Vector)
    specimens = JSON.parse.(specimen_vec)
    s = sort(collect(enumerate(specimens)), by=p->p[2]["performance"])
    [
        (label="""Generation $(j["generation"]): $(j["name"]), performance: $(round(j["performance"], digits=4))""", value=i) for (i,j) in s
    ] |> reverse
end

# TODO: to replace the slider, maybe
function specimen_dropdown(specimen_vec::Vector)
    options = make_specimen_dropdown_options(specimen_vec)
    dcc_dropdown(id="specimen-dropdown",
                 placeholder="Choose a specimen to examine",
                 persistence=true,
                 persistence_type="session",
                 options=options,
                 )
end

LOGGER = nothing

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

function specimen_decompilation_container()
    html_div(id="specimen-decompilation-container") do
        decompilation_in_progress(),
        html_div(id="decompilation-cache",
                 children = json(Dict()),
                 style = Dict("display" => "None")),
        html_div(id="specimen-decompilation")
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
        specimen_selector(1, id="specimen-slider"),
        html_div(id="specimen-jar", children=[], style=Dict("display" => "None")),
        html_div(id="specimen-report")
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
    [
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
end

###
# Dash Callbacks
###

##
# Throws an exception if the serialized logger hasn't been modified
# since mod_time. This is fine. Dash.jl will catch it, and it's a useful
# way of preventing callbacks from executing if there's no new data.
##
function get_logger(log_dir, mod_time)
    path = "$(log_dir)/.L.dump"
    if !isfile(path)
        @debug "$(path) does not exist yet"
        throw(PreventUpdate())
    end
    # TODO check if file exists
    new_mod_time = mtime(path) |> unix2datetime
    old_mod_time = DateTime(mod_time)
    if true || old_mod_time < new_mod_time # FIXME
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
    State("im-data-container", "children"),
) do im_idx, im_vec
    if isempty(im_vec)
        throw(PreventUpdate())
    end
    if isnothing(im_idx)
        im_idx = length(im_vec)
    end
    interaction_matrix_image(im_vec[im_idx])
end

callback!(
    UI,
    #Output("specimen-slider", "max"),
    #Output("specimen-slider", "marks"),
    Output("specimen-dropdown", "options"),
    Input("specimen-data-container", "children"),
) do specimen_vec
    if isempty(specimen_vec)
        throw(PreventUpdate())
    end
    make_specimen_dropdown_options(specimen_vec)

    # slider_max = length(specimen_vec)
    # slider_marks = Dict([Symbol(v) => Symbol(v) for v in 1:slider_max])
    # (slider_max, slider_marks)
end


callback!(
    UI,
    Output("interaction-matrices-slider", "max"),
    Output("interaction-matrices-slider", "marks"),
    Output("interaction-matrices-slider", "value"),
    Input("im-data-container", "children"),
    State("interaction-matrices-slider", "value"),
) do im_vec, _cur_val
    if isempty(im_vec)
        throw(PreventUpdate())
    end
    slider_max = length(im_vec)
    slider_marks = Dict(Symbol(v) => Symbol(v) for v in 1:slider_max)
    (slider_max, slider_marks, slider_max)
end

callback!(
    UI,
    Output("specimen-report", "children"),
    Output("specimen-jar", "children"),
    Input("specimen-dropdown", "value"),
    State("specimen-data-container", "children"),
) do specimen_index, specimen_vec 
    if isempty(specimen_vec)
        throw(PreventUpdate())
    end
    if isnothing(specimen_index)
        specimen_index = length(specimen_vec)
    end
    # Creature knows how to parse JSON
    i = mod1(specimen_index, length(specimen_vec))
    specimen = LinearGenotype.Creature(specimen_vec[i])
    @debug "Generating report for specimen $(specimen.name)"
    report = specimen_report(specimen, length(specimen_vec))
    (report, [specimen_vec[i]])
end

callback!(
    UI,
    Output("specimen-decompilation", "children"),
    Output("decompilation-in-progress", "hidden"),
    Output("decompilation-cache", "children"),
    #Input("decompile-button", "n_clicks"),
    Input("specimen-jar", "children"),
    State("decompilation-cache", "children"),
) do specimen_jar, cache
    if isempty(specimen_jar)
        throw(PreventUpdate())
    end
    @debug "Decompile button clicks" clicks
    #if clicks != 1
    #    throw(PreventUpdate())
    #end
    specimen = LinearGenotype.Creature(specimen_jar[1])
    D = JSON.parse(cache)
    if specimen.name ∈ keys(D)
        d = D[specimen.name]
        return decompilation(d), true, cache
    else
        d = decompilation_helper(specimen)
        D[specimen.name] = d
        return decompilation(d), true, json(D)
    end
end


callback!(
    UI,
    Output("stats-dropdown-container", "children"),
    Input("table-data-container", "children"),
    State("stats-dropdown", "value"),
) do blob, selection
    j = JSON.parse(blob)
    @debug "Getting columns for dropdown" j["columns"]
    stats_dropdown(options=Symbol.(j["columns"]), value=selection)
end
# passing the current value through as a hint that this callback should be executed
# before the one that builds the plot


callback!(
    UI,
    Output("table-container", "children"),
    Output("plot-container", "children"),
    Input("stats-dropdown", "value"),
    Input("table-data-container", "children")
) do plot_columns, blob
    table = decode_table(blob)
    (generate_table(table, 10),
     plot_stat(table,
               cols=plot_columns,
               title="Time Series Plot"))
end


callback!(
    UI,
    Output("data-container", "children"),
    Output("loginfo", "children"),
    Input("main-interval", "n_intervals"),
    Input("pause-switch", "value"),
    State("loginfo", "children"),
) do n_intervals, pause, loginfo
    if pause
        throw(PreventUpdate())
    end
    with_logger(loginfo, populate_data_container)
end
## Consider:
# Things might run more smoothly if we stream data to disk, and then use callbacks
# in the UI to dynamically read and render that data.
##

end # End module

# TODO visualize the execution trace and its information content in an interesting, colourful way
