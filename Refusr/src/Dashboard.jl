include("Refusr.jl")

config = prep_config("$(@__DIR__)/../config/config-2MUX-sharing.yaml")

cb = make_logging_callback(config)


@info "serving at port 9123"

readline()