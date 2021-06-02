# Functions for manipulating expressions
module Expressions


export replace!, replace, count_subexpressions, enumerate_expr

function Base.replace!(e::Expr, p::Pair; all=true)
    old, new = p
    oldpred = old isa Function ? old : x -> typeof(x) == typeof(old) && x == old
    mknew = new isa Function ? new : _ -> deepcopy(new)
    if oldpred(e)
        oldpred(e)
        return mknew(deepcopy(e))
    end
    for i in eachindex(e.args)
        if oldpred(e.args[i])
            e.args[i], oldpred(e.args[i])
            e.args[i] = mknew(e.args[i])
            all || return e
        elseif e.args[i] isa Expr
            Base.replace!(e.args[i], oldpred=>mknew, all=all)
        end
    end
    return e
end


function Base.replace(e::Expr, p::Pair; all=true)
    Base.replace!(deepcopy(e), p, all=all)
end


count_subexpressions(x) = 0

function count_subexpressions(e::Expr)
    1 + mapreduce(count_subexpressions, +, e.args)
end


depth(x) = 0

function depth(e::Expr)
    1 + mapreduce(depth, max, e.args)
end



function enumerate_expr!(table, path, expr::Expr; startat = 2)
    if !isterminal(expr)
        for (i, a) in enumerate(expr.args[startat:end])
            if !isterminal(a)
                p = [path..., (i + startat - 1)]
                table[p] = a
                enumerate_expr!(table, p, a, startat = startat)
            end
        end
    end
    table
end


function enumerate_expr(expr::Expr; startat = 2)
    table = Dict()
    path = []
    table[[]] = expr
    enumerate_expr!(table, path, expr, startat = startat)
    table
end

function validate_path!(path::Vector, table::Dict)
    if length(path) > 0 && isterminal(table[path])
        pop!(path)
        validate_path!(path, table)
    else
        path
    end
end


function random_subexpr(e::Expr; maxdepth=8)
    table = filter(x -> length(x) <= maxdepth, enumerate_expr(e))
    if isempty(table)
        return [], e
    end
    path = validate_path!(rand(keys(table)), table)
    if isempty(path)
        [], e
    end
    path, table[path]
end


function prune!(e::Expr, depth, terminals)
    isterminal(e) && return
    if depth <= 1
        for i in 2:length(e.args)
            if e.args[i] isa Expr
                e.args[i] = rand(terminals).first
            end
        end
    else
        for arg in e.args[2:end]
            prune!(arg, depth-1, terminals)
        end
    end
end


prune!(e, depth, terminals) = nothing




# Rewriting rules


andfalse_p(e::Expr) = (e.head === :call && e.args[1] === :& && false ∈ e.args)

andfalse_p(e) = false

false_absorption(e::Expr) = Base.replace(e, andfalse_p=>false, all=true)

ortrue_p(e::Expr) = (e.head === :call && e.args[1] === :| && true ∈ e.args)

ortrue_p(e) = false

true_absorption(e::Expr) = Base.replace(e, ortrue_p=>true)
false_absorption(e::Expr) = Base.replace(e, andfalse_p=>false)

isnot(e::Expr) = (e.head === :call && e.args[1] === :!)
isnot(e) = false

notnot_p(e::Expr) = isnot(e) && isnot(e.args[2])
notnot_p(e) = false

double_neg_elim_cons(e::Expr) = e.args[2].args[2]

double_negation(e::Expr) = Base.replace(e, notnot_p=>double_neg_elim_cons)



end # module Expressions
