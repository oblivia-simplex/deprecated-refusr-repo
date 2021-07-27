#! /bin/sh

export GTK_PATH="/usr/lib/x86_64-linux-gnu/gtk-3.0:$PATH"

[ -n "$REFUSR_PROCS" ] || REFUSR_PROCS=$2
[ -n "$REFUSR_PROCS" ] || REFUSR_PROCS=4

IMAGE=""
[ -n "$REFUSR_IMAGE" ] && IMAGE="-Jrefusr.so"

exec julia $IMAGE --startup-file no --project ./src/start.jl $1
