## Demos

include("base.jl")
include("z3_bridge.jl")


evoL = Cockatrice.Evo.Evolution(Cockatrice.Config.parse("./config.yaml"), creature_type=LinearGenotype.Creature, fitness=FF.fit, tracers=TRACERS, mutate=LinearGenotype.mutate!, crossover=LinearGenotype.crossover)

