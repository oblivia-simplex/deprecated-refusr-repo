function likeness(a, b)
    if a == b
        return 1.0
    end
    e = get_entropy(a)
    m = get_mutual_information(a, b)
    iszero(e) ? m : m / e
end

function do_step!(evo)
    parent_indices, children_indices = Cockatrice.Evo.step!(evo, eval_children=true)
    parents = evo.geo[parent_indices]
    children = evo.geo[children_indices]
    # now, measure mutual information
    for child in children
        child.parents = [p.name for p in parents]
        child.likeness = [likeness(p.phenotype, child.phenotype) for p in parents]
    end
end
