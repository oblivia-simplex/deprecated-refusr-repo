#! /bin/sh

export GTK_PATH="/usr/lib/x86_64-linux-gnu/gtk-3.0:$PATH"
export DASH_HOT_RELOAD=0
#export JULIA_DEBUG="Main"
#export REFUSR_DEBUG="1"

# Set up the SSH tunnel
#if [ -z "$REFUSR_HEADLESS" ]; then
#  echo "[+] Setting up ssh tunnel on feral..."
#  ssh -N -f -R 9124:127.0.0.1:9124 feral || echo "\n[-] This may be because a tunnel is already open."
#fi



[ -n "$REFUSR_PROCS" ] || REFUSR_PROCS=4
[ -n "$REFUSR_HEADLESS" ] || REFUSR_HEADLESS=0

export REFUSR_PROCS
export REFUSR_HEADLESS

echo "[+] REFUSR_HEADLESS = $REFUSR_HEADLESS"
echo "[+] Starting REFUSR with $REFUSR_PROCS processes..."
IMAGE=""
#IMAGE="-Jrefusr.so"
[ -n "$IMAGE" ] && echo "[+] Using system image: $IMAGE"

exec julia $IMAGE --startup-file no --project ./src/start.jl $@
