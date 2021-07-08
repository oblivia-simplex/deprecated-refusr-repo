#! /bin/sh

[ -n "$REFUSR_PROCS" ] || REFUSR_PROCS=$2
[ -n "$REFUSR_PROCS" ] || REFUSR_PROCS=4

exec julia --startup-file no --project ./src/start.jl $1
