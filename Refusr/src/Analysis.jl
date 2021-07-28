module Analysis

using Plots
using Images
using MosaicViews
using ..Expressions
using ..LinearGenotype
using ..Cockatrice.Logging: Logger

function make_plots(L::Logger)
end


function IM_images(L::Logger, IM)
end


function summarize(L::Logger, g; label=g.name, decompile=true, make_pdf=false)
    @info "Preparing summary of $(g.name)..."
    specimen_dir = "$(L.log_dir)/specimens"
    mkpath(specimen_dir)

    chrom_str = join(map(string, g.chromosome), "\n")
    effec_str = isnothing(g.effective_code) ? "" : join(map(string, g.effective_code), "\n")

    @info "Effective Code:\n$effec_str"

    @info "Converting to symbolic expression..."

    decompiled = if decompile
        simple = LinearGenotype.decompile(g)
        #simple = Expressions.simplify(symbolic, use_espresso=true)

        # Create some syntax graphs
        img_path = "$(L.log_dir)/img/"
        mkpath(img_path)
        syntax_tree_path = "$(img_path)/champion_ast.svg"
        syntax_dag_path = "$(img_path)/champion_dag.svg"
        Expressions.save_diagram(simple, syntax_tree_path, tree=true)
        Expressions.save_diagram(simple, syntax_dag_path, tree=false)

        """
## Symbolic Representation

### Decompiled from Linear Code and Simplified

```
$(simple)
```


### Syntax Tree of Simplified Expression

![Syntax tree for $(g.name)]($(syntax_tree_path))


### Directed Acyclic Graph of Simplified Expression

![Syntax DAG for $(g.name)]($(syntax_dag_path))
"""
    else
        ""
    end # End of decompile conditional

        header = make_pdf ? """
---
title: Champion
header-includes:
- \\usepackage{fvextra}
- \\DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines, commandchars=\\\\\\{\\}}
---
""" : ""

    Title = label == "champion" ? "Champion Report" : "Specimen Report"

    md = """
$(header)

# $(Title)

- Name: $(g.name)
- Generation: $(g.generation)
- Parents: $(join(g.parents, ", "))
- Number of Offspring: $(g.num_offspring)
- Phenotypic Resemblance to Parents: $(join(string.(g.likeness), ", "))
- Fitness Scores: $(join(string.(g.fitness), ", "))
- **Performance: $(g.performance)**

## Chromosome

$(length(g.chromosome)) Instructions

```
$(chrom_str)
```

## Effective Code

$(length(g.effective_code)) Instructions

```
$(effec_str)
```

$(decompiled)

## Phenotype.results

```
$(join(string.(Int.(g.phenotype.results)), ""))
```

## Fitness

`$(g.fitness)`

"""
    md_path = "$(specimen_dir)/$(label).md"
    write(md_path, md)
    #html_path = "champion.html"
    #run(`pandoc $(md_path) -o $(html_path)`)
    return md_path
end



end
