#!/bin/bash

set -euo pipefail

BACKUP_DIR="backups"
STAMP="$(date +'%Y-%m-%d_%H-%M-%S')"
ARCHIVE_PATH="$BACKUP_DIR/world-$STAMP.tar.gz"

mkdir -p "$BACKUP_DIR"

items_to_backup=()
for item in world server.properties eula.txt start.sh stop.sh; do
    if [ -e "$item" ]; then
        items_to_backup+=("$item")
    fi
done

if [ "${#items_to_backup[@]}" -eq 0 ]; then
    echo "Nothing to back up."
    exit 1
fi

tar -czf "$ARCHIVE_PATH" "${items_to_backup[@]}"
echo "Backup created at $ARCHIVE_PATH"
