
using Base: String
include("Refusr.jl")


function julia_main()::Cint
    try
        real_main()
    catch
        Base.invokelatest(Base.display_error, Base.catch_stack())
        return 1
    end
    return 0
end


function real_main()
    @show ARGS
    a = 1
    reps = 1
    try
        reps = parse(Int, ARGS[1])
        a += 1
    catch er
        @info "No reps parameter given, assuming 1"
    end

    configs = ARGS[a:end]
    for rep = 1:reps
        for config in configs
            @info "[$(rep)/$(reps)] Launching with config $(config)..."
            launch(config)
        end
    end
end


if abspath(PROGRAM_FILE) == @__FILE__
    real_main()
end
