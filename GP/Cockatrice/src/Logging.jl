module Logging


using ..Config
using ..Names
using CSV
using DataFrames
using Dates
using GZip
using Glob
using JSON
using Mmap
using Plots
using Printf
using Serialization
using StatsBase
export Logger, log!, dump, log_ims






function make_stats_table(loggers)
    cols = [Symbol("$(lg.key)_$(nameof(lg.reducer))") for lg in loggers]
    cols = [:iteration_mean; cols]
    Float64.(DataFrame([c => [] for c in cols]...))
end


function make_log_dir(name = Names.rand_name(2); make = false)
    stem = "$(ENV["HOME"])/logs/refusr/"
    n = now()
    dir = @sprintf "%s/%04d/%02d/%02d/%s" stem year(n) month(n) day(n) name
    make && mkpath(dir)
    return dir
end

function make_csv_filename(name = Names.rand_name(2))
    n = now()
    @sprintf "%s.%02d-%02d.csv" name hour(n) minute(n)
end


function make_dump_path(L)
    "$(L.log_dir)/$(L.name).dump"
end

struct Logger
    config::NamedTuple
    table::DataFrame
    im_log::Vector
    log_dir::String
    csv_name::String
    name::String
    specimens::Vector
    timing::Vector
    specimen_names::Set
end


function dump_logger(L::Logger)
    dump_path = "$(L.log_dir)/.L.dump"
    serialize(dump_path, L)
    stamp(L.log_dir)
    return dump_path
end


function Logger(loggers, config)
    n = now()
    experiment = if :experiment ∈ keys(config)
        config.experiment
    else
        experiment = Names.rand_name(2)
        @sprintf "%s.%02d-%02d" experiment hour(n) minute(n)
    end
    dir = if :logging ∈ keys(config) && :dir ∈ keys(config.logging)
        mkpath(config.logging.dir)
        config.logging.dir
    else
        dir = make_log_dir(experiment, make = true)
    end
    write("$(dir)/STATUS.TXT", "running")

    atexit() do
        status = read("$(dir)/STATUS.TXT", String) |> strip
        if status == "running"
            status = "terminated"
            write("$(dir)/STATUS.TXT", status)
        end
        @info "Shutting down..." status
    end

    csv_file = "report.csv"
    write("$(dir)/config.yaml", Config.to_yaml(config))

    Logger(
        config,
        make_stats_table(loggers),
        [],
        dir,
        csv_file,
        experiment,
        [],
        [],
        Set{String}(),
    )
end


function add_specimen(L, specimens...)
    specimen_dir = "$(L.log_dir)/specimens/"
    mkpath(specimen_dir)
    for g in specimens
        if g.name ∈ L.specimen_names
            continue
        end
        push!(L.specimen_names, g.name)
        push!(L.specimens, g)
        filename = @sprintf(
            "%06d_isle:%02d_gen:%04d_perf:%04f_name:%s_.json.gz",
            length(L.specimens),
            g.native_island,
            g.generation,
            g.performance,
            g.name
        )
        j_path = "$(specimen_dir)/$(filename)"
        GZip.open(j_path, "w") do io
            write(io, json(g))
        end
    end
    stamp(L.log_dir)
end

function parse_specimen_filename(filename)
    parts = split(filename, "_")
    index = parse(Int, parts[1])
    # last part is the extension
    attrs = parts[2:end-1]
    d = Dict{String,Any}(a[1] => a[2] for a in (split(attr, ":") for attr in attrs))

    d["isle"] = parse(Int, d["isle"])
    d["gen"] = parse(Int, d["gen"])
    d["perf"] = parse(Float64, d["perf"])

    return d
end


function read_specimen_file(; log_dir, filename, constructor = nothing)
    path = "$(log_dir)/specimens/$(filename)"
    GZip.open(path, "r") do io
        d = JSON.parse(io)
        if constructor !== nothing
            constructor(d)
        else
            d
        end
    end
end


function list_specimen_files(log_dir)
    try
        return walkdir("$(log_dir)/specimens/") |> first |> last
    catch IOError
        return []
    end
end

function read_specimens_from_disk(log_dir; constructor = nothing)
    try
        specimen_files = walkdir("$(log_dir)/specimens/") |> first |> last
        [read_specimen_file(s, constructor) for s in specimen_files]
    catch IOError
        return []
    end
end


function mark_as_finished(L, note = "")
    write("$(L.log_dir)/STATUS.TXT", "finished\n$(note)\n")
end

function stamp(log_dir)
    write("$(log_dir)/.L.stamp", string(now()))
end

function log!(L::Logger, row)
    records = size(L.table, 1)
    append = records > 0
    push!(L.table, row)
    CSV.write(
        "$(L.log_dir)/$(L.csv_name)",
        [L.table[end, :]],
        writeheader = !append,
        append = append,
    )

    stamp(L.log_dir)
    #dump_path = dump_logger(L)
    #@debug "Dumped logger" dump_path
    return records
end


function dump(L, obj)
    Serialization.serialize(make_dump_path(L), obj)
    stamp(L.log_dir)
end


function write_im(path, im)
    m, n = UInt16.(size(im))
    open(path, "w+") do f
        write(f, m)
        write(f, n)
        write(f, im)
    end
end

function log_ims(L::Logger, ims, step)
    push!(L.im_log, ims)
    dir = "$(L.log_dir)/IM/"
    mkpath(dir)
    for (i, im) in enumerate(ims)
        path = @sprintf "%s/IM_%05d_%02d.bin" dir step i
        write_im(path, im)
    end
    stamp(L.log_dir)
end


function read_ims_at_step(; log_dir, step = :last)
    dir = "$(log_dir)/IM/"
    if step === :last
        files = walkdir(dir) |> first |> last
        step = maximum(parse(Int, split(f, "_")[2]) for f in files)
        @debug "step was :last, set to $(step)"
    end
    prefix = @sprintf "IM_%05d_" step
    im_paths = glob("$(prefix)*.bin", dir)
    @debug "In read_ims_at_step" im_paths
    read_im.(im_paths)
end


function read_im(path)
    @debug "in read_im" path
    open(path) do f
        m = read(f, UInt16)
        n = read(f, UInt16)
        buf = BitArray(undef, (m, n))
        read!(f, buf)
        buf
    end
end


function count_im_batches(log_dir)
    dir = "$(log_dir)/IM/"
    try
        files = walkdir(dir) |> first |> last
        prefixes = [split(f, "_")[2] for f in files] |> Set
        length(prefixes)
    catch IOError
        @warn "Could not open directory $(dir)"
        return 0
    end
end


function read_table(log_dir)
    CSV.read("$(log_dir)/report.csv", DataFrame)
end


function make_plots(L::Logger)

end

end
