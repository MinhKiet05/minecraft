#!/bin/bash
RAM_MIN="4G"
RAM_MAX="6G"
FORGE="1.20.1-47.3.0"
JAVA="/usr/lib/jvm/java-17-openjdk-amd64/bin/java"

echo "=== KHỞI ĐỘNG SERVER... ==="

# 1. TẠO THƯ MỤC LOGS (Fix lỗi No such file)
mkdir -p logs

# 2. XỬ LÝ PLAYIT
# Nếu chưa có file Playit thì tải
if [ ! -f ./playit ]; then
    curl -Lo playit https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64
    chmod +x playit
fi

# Nếu Playit CHƯA chạy thì bật lên và ghi log
if ! pgrep -f "playit" > /dev/null; then
    echo "🌐 Đang bật Playit ngầm..."
    nohup ./playit --secret_path playit.toml > logs/playit.log 2>&1 &
    sleep 5 # Chờ 5 giây cho nó kịp lấy IP
else
    echo "✅ Playit đang chạy sẵn."
    # Nếu đang chạy sẵn mà không có log thì phải tắt đi bật lại để lấy log
    if [ ! -f logs/playit.log ]; then
        echo "⚠️  Không tìm thấy log IP. Đang khởi động lại Playit..."
        pkill -f playit
        nohup ./playit --secret_path playit.toml > logs/playit.log 2>&1 &
        sleep 5
    fi
fi

# 3. HIỂN THỊ IP
echo "------------------------------------------------"
# Lọc lấy dòng chứa link connection
IP=$(grep -o 'https://playit.gg/claim/.*' logs/playit.log | head -1)
# Nếu không có link claim thì tìm link joinmc
if [ -z "$IP" ]; then
    IP=$(grep -o '[a-z0-9.-]*\.gl\.joinmc\.link' logs/playit.log | head -1)
fi

if [ -z "$IP" ]; then
    echo "⚠️  Chưa lấy được IP. Vui lòng kiểm tra: cat logs/playit.log"
else
    echo "🔗 IP CỦA BẠN: $IP"
fi
echo "------------------------------------------------"

# 4. DỌN RAM & CHẠY SERVER
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null

echo "🧟 ĐANG VÀO GAME... (Ctrl+C để dừng)"
$JAVA -Xms$RAM_MIN -Xmx$RAM_MAX @libraries/net/minecraftforge/forge/$FORGE/unix_args.txt "$@"
