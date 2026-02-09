#!/bin/bash

# --- CẤU HÌNH ---
FORGE_VERSION="1.20.1-47.3.0"
FORGE_URL="https://maven.minecraftforge.net/net/minecraftforge/forge/${FORGE_VERSION}/forge-${FORGE_VERSION}-installer.jar"

echo "=== 🛠️  SIÊU INIT: TỰ ĐỘNG HOÁ TOÀN BỘ ==="

# 1. CẬP NHẬT REPOSITORY & CÀI JAVA (Cách 2 nếu apt lỗi)
echo "☕ Đang cài đặt Java 17..."
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk-headless || {
    echo "⚠️  Apt lỗi, đang tải Java thủ công bằng wget..."
    wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz
    tar -xvf jdk-17_linux-x64_bin.tar.gz
    export PATH=$PATH:$(pwd)/jdk-17*/bin
}

# 2. TẢI PLAYIT
if [ ! -f ./playit ]; then
    echo "🌐 Đang tải Playit..."
    wget -O playit https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64
    chmod +x playit
fi

# 3. TẢI VÀ CÀI ĐẶT FORGE SERVER
if [ ! -d "libraries" ]; then
    echo "📦 Đang tải Forge Installer (${FORGE_VERSION})..."
    wget -O forge-installer.jar "$FORGE_URL"
    
    echo "⚙️  Đang cài đặt Server (việc này mất vài phút)..."
    java -jar forge-installer.jar --installServer
    
    echo "🧹 Dọn dẹp file installer..."
    rm forge-installer.jar forge-installer.jar.log
else
    echo "✅ Thư mục libraries đã tồn tại, bỏ qua bước cài Forge."
fi

# 4. TẠO FILE EULA (Bắt buộc để chạy server)
echo "eula=true" > eula.txt

# 5. CẤP QUYỀN SCRIPTS
chmod +x start.sh save.sh 2>/dev/null

echo "------------------------------------------------"
echo "✅ TẤT CẢ ĐÃ SẴN SÀNG!"
echo "👉 Bây giờ hãy chạy: ./start.sh"
echo "------------------------------------------------"
