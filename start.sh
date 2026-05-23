#!/bin/bash

set -euo pipefail

SERVER_JAR="${SERVER_JAR:-server.jar}"
RAM_MIN="${RAM_MIN:-1G}"
RAM_MAX="${RAM_MAX:-2G}"

if [ ! -f "$SERVER_JAR" ]; then
    echo "Missing $SERVER_JAR. Put the official vanilla server jar in this folder."
    exit 1
fi

echo "=== Starting vanilla server ==="
java -Xms"$RAM_MIN" -Xmx"$RAM_MAX" -jar "$SERVER_JAR" nogui
