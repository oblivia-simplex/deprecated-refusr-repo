module Dashboard

# TODO:
# - decouple the logging rate from the UI refresh rate. Easy to do.

using Dash
using Dates
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


export ui_callback

REFUSR_DEBUG = "REFUSR_DEBUG" ∈ keys(ENV) ? parse(Bool, ENV["REFUSR_DEBUG"]) : false

ASSET_DIR = "$(@__DIR__)/../assets"
UI = dash(assets_folder=ASSET_DIR, suppress_callback_exceptions=!REFUSR_DEBUG)



function initialize_server(;server="0.0.0.0",
                           port=9123,
                           log_dir,
                           update_interval=2,
                           debug=REFUSR_DEBUG) # initialize UI
    global UI
    UI.layout = html_div() do
        html_h1("REFUSR UI", style = Dict("textAlign" => "center")),
        html_div(id="loginfo", style = Dict("display" => "None")) do
            log_dir,
            now() |> string
        end,
        dcc_interval(id="main-interval", interval=update_interval*1000),
        daq_toggleswitch(id="pause-switch", value=false, label="PAUSE", vertical=true),
        html_div(id="data-container", style = Dict("display" => "None")),
        html_div(id="main", "Waiting for data...")
    end
 
    enable_dev_tools!(UI, dev_tools_hot_reload=false)
    Dash.set_title!(UI, "REFUSR UI")
    @info "Starting Dash server..."
    run_server(UI, server, port; debug)
    @warn "Dash server no longer running"
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

function plot_stat(D::DataFrame;
                   cols::Vector,
                   names=nothing,
                   id="stats-plot",
                   title="REFUSR Plot")
    X = D.iteration_mean
    if names === nothing
        names = [replace(n, "_" => " ") for n in string.(cols)]
    end
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


function decompilation(g)
    symbolic = LinearGenotype.decompile(g)
    diagrams = if symbolic isa Expr
        syntax_tree = Expressions.diagram(symbolic, format=:svg, tree=true)
        syntax_graph = Expressions.diagram(symbolic, format=:svg, tree=false)
        syntax_tree_url = encode_svg(syntax_tree)
        syntax_graph_url = encode_svg(syntax_graph)
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

    html_div(id="decompilation") do
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


function interaction_matrix_image(ims::Array)
    imgs = [colorant"white" .* im for im in ims]
    mos = mosaicview(imgs..., fillvalue=colorant"red", ncol=(length(imgs)÷2), npad=1)

    io = IOBuffer()
    save(Stream(format"PNG", io), mos)
    data = take!(io)
    url = encode_png(data)
end


interaction_matrix_image(already_png_encoded::String) = already_png_encoded


function interaction_matrix_viewer(L, n=length(L.im_log); id="interaction-matrices")

    url = interaction_matrix_image(L.im_log[n])
    image = html_img(id="$(id)-image", src=url, title="Interaction Matrices", width="100%")
    #marks = Dict([Symbol(v) => Symbol(L.table.iteration_mean[v] |> ceil)
    #              for v in Int.(ceil.(LinRange(1, length(L.im_log), 100)))])
    html_div(id=id) do
        html_h1("Interaction Matrices"),
        image,
        daq_slider(id="interaction-matrices-slider",
                   min = 1,
                   max = length(L.im_log),
                   value = length(L.im_log),
                   persistence = true,
                   updatemode = "mouseup",
                   )
    end
end

# TODO see Plotly heatmaps

# I really wish there was a better way of doing this than mucking around
# with global state, but that seems to be the only way forward for now
# at least it's just in the gui


function specimen_selector(len; id="specimen-slider")
    daq_slider(id  = id,
               min = 1,
               max = len,
               marks = Dict([Symbol(v) => Symbol(v) for v in 1:len]),
               value = len,
               step = nothing,
               persistence = true,
               updatemode = "mouseup",
               )
end


function decompile_button()
    html_button(id="decompile-button",
                hidden=false,
                children="PRESS TO DECOMPILE (AND WAIT)",
                n_clicks = 0)
end


function specimen_report(g, len; id="specimen-report")
    title = g.performance == 1.0 ? "Champion $(g.name)" : "Specimen $(g.name)"

    specimen_report = html_div(id=id) do
        html_h1(title),
        specimen_selector(len, id="specimen-slider"),
        specimen_summary(g, title, id="specimen-summary"),
        html_div(id = "specimen-decompilation") do
            decompile_button()
        end,
        html_hr(),
        disassembly(g, id="specimen-disassembly")
    end
end

LOGGER = nothing
LAYOUT_INITIALIZED = false

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


function generate_main_page(L)
    @debug "Entering generate_main_page with logger $(L.name)"
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
    plot_container = html_div(id="plot-container") do
        # TODO: a dictionary prettyfying the names of the columns
        plot_stat(L.table,
                  cols=[:objective_meanfinite, :objective_maximum],
                  names=["mean performance", "best performance"],
                  title="Time Series Plot")
    end

    push!(content, plot_container)

    stats_dropdown = dcc_dropdown(
        id= "stats-dropdown",
        options = [(label = col, value = Symbol(col))
                   for col in filter(x->x!="iteration_mean", names(L.table))],
        value = [:objective_meanfinite, :objective_maximum],
        multi = true,
    )

    push!(content, stats_dropdown)

    table_container = html_div(id="table-container") do
        generate_table(L.table, 10, id="stats-table")
    end
    push!(content, table_container)
    push!(content, html_button(id="table-refresh", "PRESS TO REFRESH"))

    push!(content, interaction_matrix_viewer(L, id="interaction-matrices"))

    # A specimen report
    report = if !isempty(L.specimens)
        specimen_report(L.specimens[end], length(L.specimens))
    else
        html_div(id="specimen-report")
    end

    specimen_report_container = html_div(id="specimen-report-container") do
        report
    end

    push!(content, specimen_report_container)

    config_txt = html_div(id="config-txt") do
        html_hr(),
        html_h1("Configuration for this Experiment"),
        html_pre("$(L.config.yaml)"),
        html_hr()
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
    @debug "Deserializing logger from $(log_dir)/.L.dump"
    path = "$(log_dir)/.L.dump"
    new_mod_time = mtime(path) |> unix2datetime
    old_mod_time = DateTime(mod_time)
    if old_mod_time < new_mod_time
        @debug "$(path) has changed, deserializing Logger" old_mod_time new_mod_time
        (deserialize(path), new_mod_time)
    else
        error("Logger unchanged (benign)")
    end
end



function with_logger(loginfo, method, args...)
    log_dir, mod_time = loginfo
    L, new_mod_time = get_logger(log_dir, mod_time)
    (method(L, args...), [log_dir, new_mod_time])
end



callback!(
    UI,
    Output("interaction-matrices-image", "src"),
    Input("interaction-matrices-slider", "value"),
    Input("im-data-container", "children"),
) do im_idx, im_vec
    interaction_matrix_image(im_vec[im_idx])
end


callback!(
    UI,
    Output("specimen-report-container", "children"),
    Input("specimen-slider", "value"),
    Input("specimen-data-container", "children"),
) do specimen_index, specimen_vec
    # Creature knows how to parse JSON
    specimen = LinearGenotype.Creature(specimen_vec[specimen_index])
    @debug "Generating report for specimen $(specimen.name)"
    return specimen_report(specimen, length(specimen_vec))
end

callback!(
    UI,
    Output("specimen-decompilation", "children"),
    Output("decompile-button", "hidden"),
    Input("decompile-button", "n_clicks"),
    State("specimen-slider", "value"),
    State("specimen-data-container", "children"),
) do clicks, specimen_index, specimen_vec
    if clicks != 1
        return decompile_button(), false
    end
    specimen = LinearGenotype.Creature(specimen_vec[specimen_index])
    @debug "Decompiling specimen $(specimen.name)..." specimen_index clicks
    return decompilation(specimen), true
end



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
    Output("main", "children"),
    Output("loginfo", "children"),
    Input("main-interval", "n_intervals"),
    Input("pause-switch", "value"),
    State("loginfo", "children"),
) do n_intervals, pause, loginfo
    @assert !pause "Refreshing paused (benign)"
    fn = L -> (populate_data_container(L), generate_main_page(L))
    ((data_children, main_children), loginfo) = with_logger(loginfo, fn)
    (data_children, main_children, loginfo)
end
## Consider:
# Things might run more smoothly if we stream data to disk, and then use callbacks
# in the UI to dynamically read and render that data.
##

end # End module

# TODO visualize the execution trace and its information content in an interesting, colourful way
