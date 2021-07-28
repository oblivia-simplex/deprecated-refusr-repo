module Dashboard

# TODO:
# - decouple the logging rate from the UI refresh rate. Easy to do.

using Dash
using DashCoreComponents
using Images
using ImageIO
using DashHtmlComponents
using DataFrames
using ..LinearGenotype
using ..Expressions
using Base64

export ui_callback

ASSET_DIR = "$(@__DIR__)/../assets"
UI = dash(assets_folder=ASSET_DIR)


function initialize_server(config) # initialize UI
    global UI
    UI.layout = html_div() do
        html_h1("REFUSR UI"),
        html_div("Waiting for data...")
    end
    
    enable_dev_tools!(UI, dev_tools_hot_reload=false)
    Dash.set_title!(UI, "REFUSR UI")
    @info "Starting Dash server..."
    run_server(UI, config.dashboard.server, config.dashboard.port, debug=true)
    @warn "Dash server no longer running"
end


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


function plot_stat(D::DataFrame;
                   cols::Vector{Symbol},
                   names=nothing,
                   id="REFUSR-plot",
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


function generate_table(D::DataFrame, max_rows = 10)
    range = if nrow(D) <= max_rows
        (1:nrow(D))
    else
        [Int(ceil(n)) for n in LinRange(1, nrow(D), max_rows)]
    end
    html_table([
        html_thead(html_tr([html_th(col) for col in names(D)])),
        html_tbody([
            html_tr([html_td(D[r, c]) for c in names(D)]) for r in range
        ]),
    ])
end


function specimen_summary(g, title)
    #@show g
    dcc_markdown("""
# $(title)

- Name: $(g.name)
- Generation: $(g.generation)
- Parents: $(isnothing(g.parents) ? "none" : join(g.parents, ", "))
- Number of Offspring: $(g.num_offspring)
- Phenotypic Resemblance to Parents: $(isnothing(g.likeness) ? "N/A" : join(string.(g.likeness), ", "))
- Fitness Scores: $(join(string.(g.fitness), ", "))
- **Performance: $(g.performance)**

""")
end


function disassembly(g)

    chromosome_disas = join(string.(g.chromosome), "\n") * "\n"
    effective_disas = join(string.(g.effective_code), "\n") * "\n"

    len_c = length(g.chromosome)
    len_e = length(g.effective_code)

    dcc_markdown("""
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

SVG_TAG = "data:image/svg+xml;utf8,"

function encode_svg(svg)
    "data:image/svg+xml;base64,$(base64encode(svg))"
end

function decompilation(L, g)
    symbolic = LinearGenotype.decompile(g)
    #img_dir = "$(L.log_dir)/img/"
    #mkpath(img_dir)
    #syntax_tree_path = "$(img_dir)/$(g.name)_ast.png"
    #syntax_graph_path = "$(img_dir)/$(g.name)_dag.png"
    #Expressions.save_diagram(symbolic, syntax_tree_path, tree=true)
    #Expressions.save_diagram(symbolic, syntax_graph_path, tree=false)
    #syntax_tree_asset = "/assets/img/$(g.name)_ast.png"
    #syntax_graph_asset = "/assets/img/$(g.name)_dag.png"
    # TODO: figure out how to get SVG images to work
    #cp(syntax_tree_path, "$(@__DIR__)/../" * syntax_tree_asset, force=true)
    #cp(syntax_graph_path, "$(@__DIR__)/../" * syntax_graph_asset, force=true)
    syntax_tree = Expressions.diagram(symbolic, format=:svg, tree=true)
    syntax_graph = Expressions.diagram(symbolic, format=:svg, tree=false)
    syntax_tree_url = encode_svg(syntax_tree)
    syntax_graph_url = encode_svg(syntax_graph)

    symbolic_expr = dcc_markdown("""```$(symbolic)```""")
    html_div() do
        dcc_markdown("""
    ## Decompilation

    ```{.lisp}
    $(symbolic)
    ```
    """),
        html_img(src=syntax_tree_url,
                 title="Syntax Tree"),
        html_img(src=syntax_graph_url,
                 title="Syntax Graph")
    end
end


function interaction_matrix_image(L)
    ims = L.im_log[end]
    imgs = [colorant"white" .* im for im in ims]
    mos = mosaic(imgs..., fillvalue=colorant"red", ncol=(length(imgs)÷2), npad=1)
    dir = UI.config.assets_folder * "/img/tmp/"
    filename = "$(L.name).$(nrow(L.table)).png"
    save("$(dir)/$(filename)", mos)
    url = "/assets/img/tmp/$(filename)"
    html_img(src=url, title="Interaction Matrices", height="100%")
end

# TODO see Plotly heatmaps


function ui_callback(L; final=false)::Nothing
    global UI
    @async begin # TODO restore async macro
        #@assert check_server(L.config) "Server is down"

        content = []

        push!(content, html_h1("REFUSR UI",
                               style = Dict("textAlign" => "center")))


        # Let's add some graphs
        p = plot_stat(L.table,
                      cols=[:objective_meanfinite, :objective_maximum],
                      names=["mean performance", "best performance"],
                      title="Performance",
                      id="REFUSR-performance-plot")

        push!(content, p)

        push!(content, generate_table(L.table, 10))

        push!(content, interaction_matrix_image(L))

        # A specimen report
        g = L.specimens[end]
        title = final ? "Champion $(g.name)" : "Specimen $(g.name)"
        push!(content, specimen_summary(g, title))
        push!(content, disassembly(g))

        # Decompilation is expensive, so let's save it for the final product
        #if final
            @time push!(content, decompilation(L, g))
        #end

        UI.layout = html_div(children=content)
    end # end async block
    return nothing
end


end # end module
