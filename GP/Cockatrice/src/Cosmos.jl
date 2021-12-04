module Cosmos

using DataFrames: IteratorInterfaceExtensions
using ProgressMeter
using Printf
using Serialization
using Distributed
using DistributedArrays
using StatsBase
using Dates
using CSV
using Images
using DataFrames
using ..Names
using ..Evo
using ..Config
using ..Logging


Evolution = Evo.Evolution
World = DArray{Evo.Evolution,1,Array{Evo.Evolution,1}}


function δ_step_for_duration!(E::World, duration::TimePeriod; kwargs...)
    futs =
        [@spawnat w Evo.step_for_duration!(E[:L][1], duration; kwargs...) for w in procs(E)]
    iters = asyncmap(fetch, futs)
    if rand() < 0.1
        extra = iters .- minimum(iters) |> sum
        @info "Iterations per $(duration): mean $(mean(iters)), min $(minimum(iters)), extra $(extra), total $(sum(iters))"
    end
    return
end


function δ_step!(E::World; kwargs...)
    if !(:step ∈ keys(kwargs))
        step = Evo.step!
    else
        step = kwargs.data.step
    end
    futs = [@spawnat w Evo.step!(E[:L][1]; kwargs...) for w in procs(E)]
    asyncmap(fetch, futs)
    return
end


DEFAULT_LOGGERS = []




function δ_stats(E::World; key = "fitness_1", ϕ = mean)
    futs = [@spawnat w begin
        m = filter(isfinite, E[:L][1].trace[key][end])
        isempty(m) ? -Inf : ϕ(m)
    end for w in procs(E)]
    m = asyncmap(fetch, futs)
    isempty(m) ? -Inf : ϕ(m)
end


function δ_interaction_matrices(E::World)
    futs = [@spawnat w copy(E[:L][1].geo.interaction_matrix) for w in procs(E)]
    asyncmap(fetch, futs)
end


function δ_specimens(E::World)
    futs1 = [@spawnat w deepcopy(E[:L][1].elites[1]) for w in procs(E)]
    futs2 = [
        @spawnat w deepcopy(
            filter(g -> !isnothing(g.phenotype), E[:L][1].geo.deme) |> rand,
        ) for w in procs(E)
    ]
    futs = [futs1; futs2]
    asyncmap(fetch, futs)
end


function get_stats(evo; key = "fitness_1", ϕ = mean)
    evo.trace[key][end] |> ϕ
end

function δ_check_stopping_condition(E::World, condition::Function)
    futs = [@spawnat w condition(E[:L][1]) for w in procs(E)]
    asyncmap(fetch, futs) |> findfirst
end

function δ_init(;
    config::NamedTuple,
    fitness::Function = (_) -> [rand()],
    crossover::Function,
    mutate::Function,
    objective_performance::Function,
    creature_type::DataType,
    tracers = [],
    WORKERS = WORKERS,
)

    if length(WORKERS) > 1
        return DArray((length(WORKERS),), WORKERS) do I
            [
                Evo.Evolution(
                    config,
                    creature_type = creature_type,
                    fitness = fitness,
                    crossover = crossover,
                    mutate = mutate,
                    objective_performance = objective_performance,
                    tracers = tracers,
                ),
            ]
        end
    else
        return [
            Evo.Evolution(
                config,
                creature_type = creature_type,
                fitness = fitness,
                crossover = crossover,
                mutate = mutate,
                objective_performance = objective_performance,
                tracers = tracers,
            ),
        ]
    end
end

# TODO track migration

function run(;
    config::NamedTuple,
    fitness::Function,
    tracers = [],
    loggers = [],
    mutate::Function,
    crossover::Function,
    creature_type::DataType,
    stopping_condition::Function,
    objective_performance::Function,
    WORKERS = workers(),
    callback = _ -> (),
    LOGGER = Logger(loggers, config),
    kwargs...,
)

    cores = length(WORKERS)


    E = δ_init(
        config = config,
        fitness = fitness,
        creature_type = creature_type,
        tracers = tracers,
        crossover = crossover,
        mutate = mutate,
        WORKERS = WORKERS,
        objective_performance = objective_performance,
    )

    gui = nothing
    started_at = now()
    @info("Logging to $(LOGGER.log_dir)/$(LOGGER.csv_name)...")
    i = 0
    while true #for i in 1:(config.experiment_duration+1)
        if i > 0 && LOGGER.table[end, :iteration_mean] > config.experiment_duration
            Logging.mark_as_finished(LOGGER, "experiment_duration elapsed")
            break
        end

        i += 1

        if cores > 1
            δ_step_for_duration!(E, Second(config.step_duration); kwargs...)
        else
            Evo.step_for_duration!(E[1], Second(config.step_duration); kwargs...)
        end

        # Migration
        if cores > 1 && rand() < config.population.migration_rate
            if config.population.migration_type == "elite"
                elite_migration!(E)
            elseif config.population.migration_type == "swap"
                swap_migration!(E)
            end
        end

        # Logging
        begin
            if cores > 1
                mean_iteration =
                    asyncmap(fetch, [@spawnat w E[:L][1].iteration for w in procs(E)]) |> mean
            else
                mean_iteration = E[1].iteration |> Float64
            end

            s = [mean_iteration]
            for logger in loggers
                if cores > 1
                    push!(s, δ_stats(E, key = logger.key, ϕ = logger.reducer))
                else
                    push!(s, get_stats(E[1], key = logger.key, ϕ = logger.reducer))
                end
            end
            log!(LOGGER, s)

            if i > 1
                #specimen = rand(E).elites[1] |> deepcopy
                #push!(LOGGER.specimens, specimen)
                if cores > 1
                    Logging.add_specimen(LOGGER, δ_specimens(E)...)
                else
                    Logging.add_specimen(LOGGER, deepcopy(E[1].elites[1]))
                end
            end
            ims =
                cores > 1 ? δ_interaction_matrices(E) : [copy(E[1].geo.interaction_matrix)]
            log_ims(LOGGER, ims, i)
            @time callback(LOGGER)
        end

        if cores > 1 &&
           (isle = δ_check_stopping_condition(E, stopping_condition)) !== nothing
            @info "Stopping condition reached on Island $(isle)!"
            Logging.mark_as_finished(LOGGER, "stopping condition reached on island $(isle)")
            break
        elseif cores == 1 && stopping_condition(E[1])
            @info "Stopping condition reached!"
            Logging.mark_as_finished(LOGGER, "stopping condition reached")
            break
        end
    end
    return collect(E), LOGGER
end



function elite_migration!(E)
    src, dst = sample(1:length(E), 2, replace = false)
    i = rand(E[dst].geo.indices)
    if isempty(E[src].elites)
        return
    end
    emigrant = rand(E[src].elites)
    @info "Elite migration: $(emigrant.name) is moving from Island $(src) to $(dst):$(i)"
    E[dst].geo.deme[i] = emigrant
end


function swap_migration!(E)
    src, dst = sample(1:length(E), 2, replace = false)
    i = rand(E[dst].geo.indices)
    j = rand(E[src].geo.indices)
    @debug "Swap migration: Island $(src), slot $(j) is trading places with Island $(dst), slot $(i)"
    emigrant = E[src].geo.deme[j]
    E[dst].geo.deme[j] = E[src].geo.deme[i]
    E[dst].geo.deme[i] = emigrant
end


end # end module

# TODO
# decouple the logging and fork-join rate from the ui refresh rate
