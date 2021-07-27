using Base: String
include("Refusr.jl")

config = length(ARGS) > 0 ? ARGS[1] : "./config/config.yaml"
launch(config)
