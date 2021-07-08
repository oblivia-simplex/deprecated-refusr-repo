include("Refusr.jl")

config = length(ARGS) > 0 ? ARGS[1] : "./config.yaml"
launch(config)
