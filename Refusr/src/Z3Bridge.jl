#using Z3
module Z3Bridge

using ..Expressions

using PyCall
z3 = pyimport("z3")

function __init__()
    copy!(z3, pyimport("z3"))
    # We need to make sure that no ellipses are used in the string conversions
    z3.z3printer._PP.bounded = false
    z3.z3printer._PP.max_width = 999999999
    z3.z3printer._PP.max_lines = 999999999
end


mk_var(prefix, i) = z3.BitVec(prefix * string(i), 1)
mk_const(b::Bool) = z3.BitVecVal(b, 1)

mk_var_bool(prefix, i) = z3.Bool(prefix * string(i))
mk_const_bool(b::Bool) = z3.Bool(b)



mk_registers(prefix, num) = [mk_var_bool(prefix, i) for i in 1:num]


R = mk_registers("R", 64)
D = mk_registers("D", 64)


function translate_with_bools!(e::Expr)::Expr
    replace!(e, :& => :(z3.And))
    replace!(e, :| => :(z3.Or))
    replace!(e, :~ => :(z3.Not))
    #replace!(e, :true => mk_const_bool(true))
    #replace!(e, :false => mk_const_bool(false))
    e
end

function translate!(e::Expr)::Expr
    replace!(e, :true => mk_const(true))
    replace!(e, :false => mk_const(false))
    e
end

translate(b::Bool) = mk_const(b)

translate(e::Expr)::Expr = translate_with_bools!(deepcopy(e))



function demangle(s::Symbol)
    st = string(s)
    if st[1] ∈ "RD"
        letter = Symbol(st[1])
        number = parse(Int, st[2:end])
        :($(letter)[$(number)])
    else
        s
    end
end


function expr_to_z3(e::Expr)
    translate(e) |> eval
end

function z3_to_expr(z::PyObject)
    e = z3.obj_to_string(z) |> Meta.parse
    if e isa Expr
        # Needed for Bool variants only
        replace!(e, :Not => :~)
        replace!(e, :Or => :|)
        replace!(e, :And => :&)
        replace!(e, :(k!0) => false)
        replace!(e, :(k!1) => true)
        # For Bool or BitVec
        replace!(e, (x -> x isa Number) => (x -> Bool(x)))
        replace!(e, (x -> x isa Symbol) => demangle)
    end
    e
end


function simplify(e::Expr)
    z3.simplify(expr_to_z3(e), flat=false) |> z3_to_expr
end

simplify(x) = x

end # end module
