#!/bin/bash
RAM_MIN="4G"
RAM_MAX="6G"
FORGE="1.20.1-47.3.0"
JAVA="/usr/lib/jvm/java-17-openjdk-amd64/bin/java"
pkill -f playit
pkill -f java
echo "=== 🚀 KHỞI ĐỘNG SERVER (NO GUI) ==="

# 1. TẠO THƯ MỤC LOGS
mkdir -p logs

# 2. XỬ LÝ PLAYIT
if [ ! -f ./playit ]; then
    curl -Lo playit https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64
    chmod +x playit
fi

if ! pgrep -f "playit" > /dev/null; then
    echo "🌐 Đang bật Playit ngầm..."
    nohup ./playit --secret_path playit.toml > logs/playit.log 2>&1 &
    sleep 5
else
    echo "✅ Playit đang chạy sẵn."
fi

# 3. HIỂN THỊ IP
echo "------------------------------------------------"
IP=$(grep -o 'https://playit.gg/claim/.*' logs/playit.log | head -1)
if [ -z "$IP" ]; then
    IP=$(grep -o '[a-z0-9.-]*\.gl\.joinmc\.link' logs/playit.log | head -1)
fi

if [ -z "$IP" ]; then
    echo "⚠️  Chưa lấy được IP. Kiểm tra: cat logs/playit.log"
else
    echo "🔗 IP CỦA BẠN: $IP"
fi
echo "------------------------------------------------"

# 4. DỌN RAM & CHẠY SERVER
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null

echo "🧟 ĐANG VÀO GAME... (Ctrl+C để dừng)"

# --- THAY ĐỔI Ở ĐÂY: Thêm -nogui vào cuối ---
$JAVA -Xms$RAM_MIN -Xmx$RAM_MAX @libraries/net/minecraftforge/forge/$FORGE/unix_args.txt "$@" -nogui
