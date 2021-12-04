module RandomFunctions

using Distributions
using FunctionWrappers: FunctionWrapper
using Statistics
using DataFrames
using StatsPlots
using PGFPlotsX
using Plots
using Memoize

using ..Expressions
using ..LinearGenotype


export bfunc_by_rnd_prog, bfunc_by_rnd_expr, bfunc_by_rnd_vec



function bitv_to_int(v,s=0)
    b = 0
    for i in view(v, length(v):-1:1)
        s |= (i << b)
        b += 1
    end
    s
end


function bfunc_by_rnd_vec(dim)
	  len = 2^dim
	  vector = rand(Bool, len) |> BitVector
	  function x(bv)
		    i = bitv_to_int(bv)
		    vector[i+1]
	  end |> FunctionWrapper{Bool, Tuple{BitVector}}
end

function bfunc_by_prog(prog::Vector{LinearGenotype.Inst})
	  function x(bv)
		    config = (genotype = (registers_n = dim - 1, 
				                      max_steps = len, output_reg = 1),) 
		    out, _ = LinearGenotype.execute(prog, bv; 
			                                  config=config, make_trace=false)
		    return out
	  end |> FunctionWrapper{Bool, Tuple{BitVector}}
end


function bfunc_by_rnd_prog(dim, len=512, ops="& | ~ xor")
	  len = len isa Integer ? len : rand(len)
	  registers = max(1, dim ÷ 2)
	  ops = Symbol.(split(ops))
	  prog = LinearGenotype.random_program(len; ops)
	  effective_indices = LinearGenotype.get_effective_indices(prog, [1])
	  prog = prog[effective_indices]
	  function x(bv)
		    config = (genotype=(registers_n=dim-1, max_steps=len, output_reg=1),) 
		    out, _ = LinearGenotype.execute(prog, bv; config=config, make_trace=false)
		    return out
	  end |> FunctionWrapper{Bool, Tuple{BitVector}}
end


function bfunc_by_rnd_expr(dim, depth=8)
	  e = Expressions.grow(depth, num_terminals=dim)
	  Expressions.compile_expression(e)
end


function bfunc_from_truth_table(df)
    ORACLE = Dict{BitVector, Bool}()
    for row in eachrow(df)
        ORACLE[BitVector(row[1:end-1])] = Bool(row[end])
    end
    function x(bv)
        ORACLE[bv]
    end |> FunctionWrapper{Bool, Tuple{BitVector}}
end

end #module
