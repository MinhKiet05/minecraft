..#!/bin/bash

# --- CẤU HÌNH RAM (Ưu tiên dùng 6G để Codespace ổn định) ---
RAM_MIN="4G"
RAM_MAX="6G"

echo "=== 🚀 START: SERVER OPTIMIZED MODE ==="

# 1. Khởi động Playit
if ! pgrep -f "playit" > /dev/null; then
    mkdir -p logs
    setsid ./playit --secret_path playit.toml > logs/playit.log 2>&1 &
    sleep 3
fi

# 2. Tìm file Forge
ARGS_FILE=$(find libraries -name "unix_args.txt" | head -n 1)

# 3. CHẠY VỚI JVM FLAGS TỐI ƯU (Aikar's Flags)
# Giúp Garbage Collector dọn dẹp RAM thông minh hơn, tránh treo server
java -Xms$RAM_MIN -Xmx$RAM_MAX \
    -XX:+UseG1GC \
    -XX:+ParallelRefProcEnabled \
    -XX:MaxGCPauseMillis=200 \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+DisableExplicitGC \
    -XX:+AlwaysPreTouch \
    -XX:G1NewSizePercent=30 \
    -XX:G1MaxNewSizePercent=40 \
    -XX:G1HeapRegionSize=8M \
    -XX:G1ReservePercent=20 \
    -XX:G1HeapWastePercent=5 \
    -XX:G1MixedGCCountTarget=4 \
    -XX:InitiatingHeapOccupancyPercent=15 \
    -XX:G1MixedGCLiveThresholdPercent=90 \
    -XX:G1RSetUpdatingPauseTimePercent=5 \
    -XX:SurvivorRatio=32 \
    -XX:+PerfDisableSharedMem \
    -XX:MaxTenuringThreshold=1 \
    @$ARGS_FILE "$@"
