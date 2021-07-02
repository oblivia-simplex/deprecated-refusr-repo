#using Z3
using PyCall
z3 = pyimport("z3")

function __init__()
    copy!(z3, pyimport("z3"))
end

include("expressions.jl")

mk_consts(prefix, num) = [z3.BitVec(prefix * string(i), 1) for i in 1:num]

R = mk_consts("R", 64)
D = mk_consts("D", 64)

CTX = nothing

function translate!(e::Expr; ctx = CTX)::Expr
    replace!(e, :true => z3.BitVecVal(true, 1)) # bool_val(ctx, true))
    replace!(e, :false => z3.BitVecVal(false, 1)) # bool_val(ctx, false))
    e
end

translate(b::Bool) = z3.Bool(b)

translate(e::Expr)::Expr = translate!(deepcopy(e))



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
    e = z.__str__() |> Meta.parse
    replace!(e, (x -> x isa Number) => (x -> Bool(x)))
    replace!(e, (x -> x isa Symbol) => demangle)
    e
end


function simplify(e::Expr)
    expr_to_z3(e) |> z3.simplify |> z3_to_expr
end
