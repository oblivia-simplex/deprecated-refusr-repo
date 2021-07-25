#! /bin/sh

[ -n "$REFUSR_PROCS" ] || REFUSR_PROCS=$2
[ -n "$REFUSR_PROCS" ] || REFUSR_PROCS=4

IMAGE=""
[ -n "$REFUSR_NO_IMAGE" ] || IMAGE="-Jrefusr.so"

exec julia $IMAGE --startup-file no --project ./src/start.jl $1
