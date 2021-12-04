module Config

using YAML
using Dates
using ..Names

export get_config, get_fitness_function

"convert Dict to named tuple"
function proc_config(cfg::Dict)
    (; (Symbol(k) => proc_config(v) for (k, v) in cfg)...)
end

proc_config(v) = v


function normalize(weights)
    W = Dict()
    σ = sum(values(weights)) |> Float64
    for k in keys(weights)
        W[k] = weights[k] / σ
    end
    return W
end

"combine YAML file and kwargs, make sure ID is specified"
function parse(cfg_file::String, default_fields = [])
    cfg_txt = read(cfg_file, String)
    cfg = YAML.load_file(cfg_file)

    for (ks, val) in default_fields
        if length(ks) == 2
            k1, k2 = ks
            if !(k1 ∈ keys(cfg))
                cfg[k1] = Dict()
            end
            if !(k2 ∈ keys(cfg[k1]))
                cfg[k1][k2] = val
            end
        elseif length(ks) == 1
            k1 = ks[1]
            if !(k1 ∈ keys(cfg))
                cfg[k1] = val
            end
        end
    end

    # generate id, use date if no existing id
    if ~("id" in keys(cfg))
        cfg["id"] = "$(Names.rand_name(2))_$(Dates.now())"
    end

    # now, normalize the fitness weights if present
    if ("selection" ∈ keys(cfg)) &&
        ("fitness_weights" ∈ keys(cfg["selection"]))
        cfg["selection"]["fitness_weights"] = normalize(cfg["selection"]["fitness_weights"])
    end
    proc_config(cfg)
end


function get_fitness_function(config::NamedTuple, mod)
    Meta.parse("$(mod).$(config.selection.fitness_function)") |> eval
end


function get_fitness_function(config_path::String, mod)
    get_fitness_function(Config.parse(config_path), mod)
end


function to_dict(config::NamedTuple)
    d = Dict()
    for key in keys(config)
        val = config[key] isa NamedTuple ? to_dict(config[key]) : config[key]
        if val isa Vector{Symbol}
            val = join(string.(val), " ")
        end
        d[string(key)] = val
    end
    return d
end


function to_yaml(config::NamedTuple)
    to_dict(config) |> YAML.yaml
end



end # end module
