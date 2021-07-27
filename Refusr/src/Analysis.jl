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


function summarize(L::Logger, g)
    symbolic = LinearGenotype.to_expr(g.chromosome) 
    simple = Expressions.simplify(symbolic)

    DIR = pwd()
    cd(L.log_dir)
    # Create some syntax graphs
    img_path = "img/"
    mkpath(img_path)
    syntax_tree_path = "$(img_path)/champion_ast.svg"
    syntax_dag_path = "$(img_path)/champion_dag.svg"
    Expressions.save_diagram(simple, syntax_tree_path, tree=true)
    Expressions.save_diagram(simple, syntax_dag_path, tree=false)

    chrom_str = join(map(string, g.chromosome), "\n")
    effec_str = isnothing(g.effective_code) ? "" : join(map(string, g.effective_code), "\n")

    header = """
title: Champion
header-includes:
- \\usepackage{fvextra}
- \\DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines, commandchars=\\\\\\{\\}}
"""

    md = """
---
$(header)
---

# Name: $(g.name)
## Generation: $(g.generation)


## Chromosome

```
$(chrom_str)
```

## Effective Code

```
$(effec_str)
```

## Symbolic Expression:

### Translated from Linear Code

```
$(symbolic)
```

### Simplified

```
$(simple)
```


### Syntax Tree of Simplified Expression

![Syntax tree for $(g.name)]($(syntax_tree_path))


### Directed Acyclic Graph

![Syntax DAG for $(g.name)]($(syntax_dag_path))

## Phenotype.results

```
$(join(string.(Int.(g.phenotype.results)), ""))
```

## Parents

$(join(g.parents, "\n"))

## Fitness

`$(g.fitness)`

## Performance: $(g.performance)
"""
    md_path = "champion.md"
    html_path = "champion.html"
    write(md_path, md)
    run(`pandoc $(md_path) -o $(html_path)`)
    cd(DIR)
    return "$(L.log_dir)/$(html_path)"
end



end
