# Functions for manipulating expressions

function Base.replace!(e::Expr, p::Pair; all=true)
    old, new = p
    if e == old
        return new
    end
    for i in eachindex(e.args)
        if e.args[i] == old
            e.args[i] = new
            all || return e
        elseif e.args[i] isa Expr
            Base.replace!(e.args[i], p, all=all)
        end
    end
    return e
end


function Base.replace(e::Expr, p::Pair; all=true)
    Base.replace!(deepcopy(e), p, all=all)
end
