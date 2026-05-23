#!/bin/bash

set -euo pipefail

echo "=== Minecraft vanilla init ==="

if ! command -v java >/dev/null 2>&1; then
    echo "Java is not installed. Install Java 17 before starting a 1.20.1 server."
    exit 1
fi

chmod +x start.sh stop.sh save.sh 2>/dev/null || true

if [ ! -f eula.txt ]; then
    echo "eula=true" > eula.txt
fi

if [ ! -f server.jar ]; then
    echo "Missing server.jar. Download the official Minecraft server jar and place it here as server.jar."
fi

echo "Init complete. Run ./start.sh when server.jar is ready."
