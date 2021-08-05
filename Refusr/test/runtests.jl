using Test
using ProgressMeter
include("../src/base.jl")



function test_decompiler()
    evoL = mkevo("$(@__DIR__)/../config.yaml")
    # now evolve it a little
    @info "Evolving..."
    @showprogress for i in 1:100
        Cockatrice.Evo.step!(evoL)
    end
    @info "Decompiling $(length(evoL.elites)) elites..."
    @time S = LinearGenotype.decompile.(evoL.elites)
    for g in evoL.elites
        @info "Disassembly & decompilation for $(g.name):\n" * join(string.(g.effective_code), "\n") g.symbolic
    end
end


#######
# Run the tests
######

test_decompiler()




