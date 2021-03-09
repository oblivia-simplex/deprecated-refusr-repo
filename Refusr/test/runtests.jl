include("../src/Generate.jl")

using Test


function generate_test_cases()
    results = []
    for ins in 2:6
        this_iteration_terminals = vcat(TERMINALS[1:ins], TERMINALS[8:9])
        this_iteration_terminals
        for _ in 1:10
            push!(results, grow(5, nonterminals=NONTERMINALS, terminals=this_iteration_terminals))
        end
    end
    return results
end


for e in generate_test_cases()
    table = truth_table(e, width=9)
    irrelevant = check_for_juntas(table, expr=e)
    @test length(irrelevant) > 0
end
