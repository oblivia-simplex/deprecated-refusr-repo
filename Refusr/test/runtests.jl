using Test
using ProgressMeter
using Dates
include("../src/base.jl")



function test_decompiler()
    ENV["JULIA_DEBUG"] = Main

    evoL = mkevo("$(@__DIR__)/../config.yaml")
    # now evolve it a little
    @info "Evolving..."
    @showprogress for i in 1:1000
        Cockatrice.Evo.step!(evoL)
    end

    function do_stuff(USE_ALPHA_CACHE)
        Expressions.flush_cache!()
        batch = deepcopy(evoL.geo.deme)
        @info "Decompiling $(length(batch)) fellas..."
        @time S = [LinearGenotype.decompile(g, alpha_cache=USE_ALPHA_CACHE)
                   for g in batch]
        @info "Testing for semantic discrepancies..."
        @showprogress for g in batch
            #@info "Disassembly & decompilation for $(g.name):\n" * join(string.(g.effective_code), "\n") g.symbolic
            for testdata in (Expressions.bits(i, 6) for i in 0:(2^6-1))
                testdata = rand(Bool, 6)
                s_res = Expressions.evalwith(g.symbolic, D=testdata)
                e_res,_ = LinearGenotype.execute(g.effective_code,
                                                 testdata;
                                                 config=evoL.config,
                                                 make_trace=false)
                @test s_res == e_res
            end
        end

        Expressions.get_cache_stats()
    end

    t = now()
    cache_stats = do_stuff(false)
    no_α_time = now() - t
    t = now()
    cache_stats_α = do_stuff(true)
    α_time = now() - t

    no_α_rate = cache_stats.hits / cache_stats.queries
    α_rate = cache_stats_α.hits / cache_stats_α.queries

    @info "Cache hit rate without α-cache: $(no_α_rate)"
    @info "Cache hit rate WITH α-cache: $(α_rate)"
    @info "Total runtime without: $(no_α_time); with: $(α_time)"
    @info "stats" cache_stats cache_stats_α

    @test α_rate > no_α_rate


    ENV["JULIA_DEBUG"] = 0
end


function test_alpha_equivalence()
    Expressions.flush_cache!()
    @info "Testing alpha-reduction invariance of simplification"
    @showprogress for i in 1:1000
        e = Expressions.grow(5, terminals=Expressions.generate_terminals(4))
        α, mapping = Expressions.rename_variables(e, letter=:R)
        es = Expressions.simplify(e, alpha_cache=false)
        αs = Expressions.simplify(α, alpha_cache=false)
        es2 = Expressions.restore_variables(αs, mapping)
        testdata = rand(Bool, 4)
        @test Expressions.evalwith(es, D=testdata) == Expressions.evalwith(es2, D=testdata) 
    end
end


#######
# Run the tests
######

test_decompiler()
#test_alpha_equivalence()


