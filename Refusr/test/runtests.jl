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


function test_mux(ctrl_bits=3)
    println("[+] Testing MUX with $ctrl_bits control bits")
    m, controls, input = mux(ctrl_bits)
    #table = truth_table(m, width=length(controls) + length(input))
    map(0:(2^ctrl_bits-1)) do i
        bs = bits(i, ctrl_bits)
        assignments = map(zip(bs, controls)) do (b, ctrl)
            b == 0 ? ctrl ← false : ctrl ← true
        end
        @show choice = input[i+1]
        random_context = [p ← rand(Bool) for p in input if p.name ≠ choice.name]
        for V in [true, false]
            assignments = [vcat(assignments, random_context)..., choice ← V]
            assertion = (m ⊃ choice) & (choice ⊃ m)
            println("[+] Testing assertion: $(assertion)")
            @test (Let(assignments, assertion) |> toexpr |> eval)
        end
    end
end


for i in 1:5
    test_mux(i)
end
