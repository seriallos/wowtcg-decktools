#!/bin/bash

# Found at
# http://stackoverflow.com/questions/10909685/run-multiple-commands-at-once-in-the-same-terminal

for cmd in "$@"; do {
  echo "Process \"$cmd\" started";
  $cmd & pid=$!
  PID_LIST+=" $pid";
} done

trap "kill $PID_LIST" SIGINT

echo "Parallel processes have started";

wait $PID_LIST

echo
echo "All processes have completed";
