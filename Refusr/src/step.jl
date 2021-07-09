module Step

using ..InformationMeasures
using ..Cockatrice
using ..FF

## ---------------------------
## FIXME Deprecate this module
## ---------------------------


function do_step!(evo)
    function likeness(a, b)
        if a == b
            return 1.0
        end
        e = get_entropy(a)
        m = get_mutual_information(a, b)
        iszero(e) ? m : m / e
    end
    if !isnothing(FF.DATA)
        interaction_matrix = FF.build_interaction_matrix(evo.geo)
    else
        interaction_matrix = nothing
    end
    parent_indices, children_indices = Cockatrice.Evo.step!(evo, eval_children=true, interaction_matrix=interaction_matrix)
    
    parents = evo.geo[parent_indices]
    children = evo.geo[children_indices]
    # now, measure mutual information
    for child in children
        child.parents = [p.name for p in parents]
        child.likeness = [likeness(p.phenotype.results, child.phenotype.results) for p in parents]
    end
    parent_indices, children_indices
end

end
