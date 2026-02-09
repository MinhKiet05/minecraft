#!/bin/bash

RAM_MIN="4G"
RAM_MAX="6G"

echo "=== 🚀 START: KHỞI ĐỘNG SERVER ==="

# 1. Kiểm tra Playit (Mạng)
if ! pgrep -f "playit" > /dev/null; then
    if [ -f ./playit ]; then
        echo "🌐 Đang bật Playit ngầm..."
        nohup ./playit --secret_path playit.toml > logs/playit.log 2>&1 &
        sleep 3
    else
        echo "⚠️  Cảnh báo: Không tìm thấy file playit. Hãy chạy ./init.sh trước."
    fi
fi

# 2. Hiển thị IP
IP=$(grep -o '[a-z0-9.-]*\.gl\.joinmc\.link' logs/playit.log | head -1)
echo "🔗 IP: ${IP:-"Đang lấy..."}"

# 3. Tự động tìm file cấu hình Forge
ARGS_FILE=$(find libraries -name "unix_args.txt" | head -n 1)

if [ -z "$ARGS_FILE" ]; then
    echo "❌ LỖI: Không tìm thấy unix_args.txt. Kiểm tra lại thư mục libraries."
    exit 1
fi

# 4. Chạy Game
echo "🧟 Đang vào game (No-GUI)..."
java -Xms$RAM_MIN -Xmx$RAM_MAX @$ARGS_FILE "$@" -nogui
