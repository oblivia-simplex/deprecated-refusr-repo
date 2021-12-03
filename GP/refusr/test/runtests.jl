using Test
using ProgressMeter
using Dates
include("../src/base.jl")

const Exp = Expressions


#### Utility functions

function inputs_of_width(w)
    (Exp.bits(i, w) for i in 0:(2^w-1))
end

function test_semantic_equivalence(e1, e2; width=4)
    for testdata in inputs_of_width(width)
        @test Exp.evalwith(e1, D=testdata) == Exp.evalwith(e2, D=testdata)
    end
end

###


function test_decompiler()
    # create a population
    evoL = mkevo("$(@__DIR__)/../config.yaml")
    # now evolve it a little
    @info "Evolving population, which will increase the implicit program complexity..."
    @showprogress for i in 1:1000
        Cockatrice.Evo.step!(evoL)
    end

    function do_stuff(;alpha_cache, incremental_simplify, batch_size)
        Exp.flush_cache!()
        batch = deepcopy(evoL.geo.deme[1:batch_size])
        @info "Decompiling $(length(batch)) fellas..." alpha_cache
        t = now()
        S = @showprogress [LinearGenotype.decompile(g; incremental_simplify, alpha_cache)
                   for g in batch]
        took = now() - t
        @info "Took $(took) to decompile $(length(batch)) specimens that have evolved over $(evoL.iteration) tournaments"
        @info "Testing for semantic discrepancies..."
        @showprogress for g in batch
            #@info "Disassembly & decompilation for $(g.name):\n" * join(string.(g.effective_code), "\n") g.symbolic
            for testdata in (Exp.bits(i, 6) for i in 0:(2^6-1))
                testdata = rand(Bool, 6)
                s_res = Exp.evalwith(g.symbolic, D=testdata)
                e_res,_ = LinearGenotype.execute(g.effective_code,
                                                 testdata;
                                                 config=evoL.config,
                                                 make_trace=false)
                @test s_res == e_res
            end
        end

        stats = Exp.get_cache_stats()
        (hits = stats.hits,
         queries = stats.queries,
         cache_time = stats.cache_time,
         took = took)
    end

    batch_size = 25
    cache_stats_no_incremental = do_stuff(; incremental_simplify=false, alpha_cache=false, batch_size)
    cache_stats = do_stuff(; incremental_simplify=true, alpha_cache=false, batch_size)
    cache_stats_α = do_stuff(; incremental_simplify=true, alpha_cache=true, batch_size)

    ## TODO: interesting! incremental simplification does NOT always save time.
    ## it saves time in the worst case, and makes it tractable, but not always
    ## and perhaps not even on average.
    #@test cache_stats_no_incremental.took > cache_stats.took
    @test cache_stats.took >= cache_stats_α.took
    @test cache_stats.hits > cache_stats_no_incremental.hits
    @test cache_stats_α.hits >= cache_stats.hits
    @test cache_stats.queries == cache_stats_α.queries
    @test cache_stats_no_incremental.queries < cache_stats.queries

    @info "Some stats:" cache_stats_no_incremental cache_stats cache_stats_α

    no_α_rate = cache_stats.hits / cache_stats.queries
    α_rate = cache_stats_α.hits / cache_stats_α.queries

    hit_improvement = round((α_rate - no_α_rate) * 100, digits=2)
    time_improvement = round((cache_stats_α.took / cache_stats.took) * 100, digits=2)

    @info "Cache hit rate without α-cache: $(no_α_rate)"
    @info "Cache hit rate WITH α-cache: $(α_rate)"
    @info "Total runtime without: $(cache_stats.took); with: $(cache_stats_α.took)"
    @info """α-caching results in a $(hit_improvement)% improvement in hit rate
and requires $(time_improvement)% less time"""

    @info "stats" cache_stats cache_stats_α

    @test α_rate > no_α_rate

end


function test_alpha_equivalence()
    Exp.flush_cache!()
    depth, width = 5, 5
    @info "Testing alpha-reduction invariance of simplification"
    @showprogress for i in 1:100
        e1 = Exp.grow(depth, terminals=Exp.generate_terminals(width))
        α, mapping = Exp.rename_variables(e1, letter=:R)
        es1 = Exp.simplify(e1, alpha_cache=false)
        αs = Exp.simplify(α, alpha_cache=false)
        es2 = Exp.restore_variables(αs, mapping)
        test_semantic_equivalence(es1, es2; width)
    end
end


function test_alpha_idempotence()
    depth, width = 5, 5
    @info "Testing idempotence of Exp.rename_variables..."
    @showprogress for i in 1:1000
        e = Exp.grow(depth, terminals=Exp.generate_terminals(width))
        α1, _mapping = Exp.rename_variables(e)
        α2, _mapping = Exp.rename_variables(α1)
        @test α1 == α2
        vars = Exp.variables_used(e)
        vars_shuf = sort(vars, by=_->rand())
        e_shuf, _m = Exp.rename_variables(e, mapping=zip(vars, vars_shuf))
        α_shuf, _m = Exp.rename_variables(e_shuf)
        @test α_shuf == α1
    end
end

function test_julia_sympy_translation()
    @info "Testing translation between julia and sympy expressions..."
    depth, width = 5, 5
    @showprogress for i in 1:1000
        e1 = Exp.grow(depth, terminals=Exp.generate_terminals(width))
        e2 = e1 |> Exp.as_sympy_expr |> Exp.as_julia_expr
        test_semantic_equivalence(e1, e2; width)
    end
end

#######
# Run the tests
######

function expression_tests()
    test_alpha_idempotence()
    test_julia_sympy_translation()
    test_alpha_equivalence()
    test_decompiler()
end


expression_tests()


