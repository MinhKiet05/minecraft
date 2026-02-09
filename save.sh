#!/bin/bash

echo "=== 💾 CHUẨN BỊ BACKUP SERVER ==="

# --- 1. SỬA LỖI MẤT KẾT NỐI GIT (QUAN TRỌNG) ---
# Nếu không thấy thư mục .git, tự động khởi tạo lại
if [ ! -d .git ]; then
    echo "⚠️  Phát hiện mất kết nối Git. Đang khôi phục..."
    git init
    git branch -M main
    git remote add origin https://github.com/$GITHUB_REPOSITORY.git
    # Kéo code về để đồng bộ lịch sử (tránh lỗi conflict)
    git pull origin main --allow-unrelated-histories || echo "⚠️  Không kéo được lịch sử cũ (có thể do repo rỗng), sẽ tạo commit mới."
fi

# Cấu hình định danh (Bắt buộc để commit)
git config user.email "auto-save@codespace.com"
git config user.name "Backup Bot"
# Dùng Token có sẵn của Codespaces để không bao giờ hỏi mật khẩu
git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git


# --- 2. DỪNG SERVER (GIỐNG CODE CŨ CỦA BẠN) ---
# Đổi "paper" thành "java" để bắt dính Forge
if pgrep -f "java" > /dev/null; then
    echo "⏳ Đang dừng Minecraft Forge (Java)..."
    
    # Gửi tín hiệu tắt nhẹ nhàng (SIGTERM)
    pkill -15 -f "java"

    # Chờ cho đến khi tắt hẳn
    while pgrep -f "java" > /dev/null; do
        echo "   ...đang tắt..."
        sleep 2
    done
    echo "✅ Server đã dừng hoàn toàn."
else
    echo "ℹ️  Server đã tắt sẵn."
fi


# --- 3. DỌN DẸP RÁC ---
echo "🧹 Dọn dẹp logs và cache..."
# Xóa bớt log cũ cho nhẹ
rm -f logs/*.gz 
rm -rf cache/*
rm -rf crash-reports/*


# --- 4. BACKUP LÊN GITHUB ---
echo "☁️  Đang đẩy dữ liệu lên GitHub..."

# Thêm tất cả file hiện tại
git add .

# Kiểm tra xem có gì thay đổi không
if git diff-index --quiet HEAD --; then
    echo "ℹ️  Không có thay đổi nào mới."
else
    # Commit với ngày giờ
    git commit -m "Auto-backup: $(date +'%H:%M:%S %d-%m-%Y')"
    
    # Tự động lấy tên nhánh hiện tại (thường là main hoặc master)
    current_branch=$(git branch --show-current)
    if [ -z "$current_branch" ]; then
        current_branch="main"
    fi
    
    # Đẩy lên (Push)
    git push origin $current_branch
    
    echo "✅ Backup xong!"
fi

echo "🏁 HOÀN TẤT QUÁ TRÌNH!"
