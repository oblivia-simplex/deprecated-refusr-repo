using Z3
include("expressions.jl")

CTX = Context()

solver() = Solver(CTX, "QF_NRA")

mk_consts(ctx, letter, num) = [bool_const(ctx, letter * string(i)) for i in 1:num]

R = mk_consts(CTX, "R", 64)
D = mk_consts(CTX, "D", 64)

function translate!(e::Expr; ctx = CTX)::Expr
    replace!(e, :& => :and)
    replace!(e, :| => :or)
    replace!(e, :! => :not)
    replace!(e, :true => bool_val(ctx, true))
    replace!(e, :false => bool_val(ctx, false))
    e
end

translate(e::Expr)::Expr = translate!(deepcopy(e))
