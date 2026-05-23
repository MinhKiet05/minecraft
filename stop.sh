#!/bin/bash

set -euo pipefail

SERVER_JAR="${SERVER_JAR:-server.jar}"

if pgrep -f "java.*${SERVER_JAR}" >/dev/null 2>&1; then
    pkill -TERM -f "java.*${SERVER_JAR}"
    echo "Sent stop signal to the server process."
    exit 0
fi

echo "No matching server process was found."
echo "If the server is running in the current terminal, press Ctrl+C there or type stop in the server console."