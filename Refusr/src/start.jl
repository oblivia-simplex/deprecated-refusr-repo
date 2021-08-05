
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
    reps = parse(Int, ARGS[1])
    configs = ARGS[2:end]
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
