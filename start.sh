cat << 'EOF' > save.sh
#!/bin/bash

echo "=== 💾 CHUẨN BỊ BACKUP SERVER ==="

# --- 1. SỬA LỖI MẤT KẾT NỐI GIT ---
if [ ! -d .git ]; then
    echo "⚠️  Phát hiện mất kết nối Git. Đang khôi phục..."
    git init
    git branch -M main
    git remote add origin https://github.com/$GITHUB_REPOSITORY.git
fi

# Cấu hình định danh
git config user.email "auto-save@codespace.com"
git config user.name "Backup Bot"
git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git

# --- 2. DỪNG SERVER ---
if pgrep -f "java" > /dev/null; then
    echo "⏳ Đang dừng Minecraft Forge (Java)..."
    pkill -15 -f "java"
    while pgrep -f "java" > /dev/null; do
        sleep 1
    done
    echo "✅ Server đã dừng hoàn toàn."
else
    echo "ℹ️  Server đã tắt sẵn."
fi

# --- 3. DỌN DẸP RÁC ---
echo "🧹 Dọn dẹp logs và cache..."
rm -f logs/*.gz 
rm -rf cache/* crash-reports/*

# --- 4. BACKUP LÊN GITHUB (ĐÃ SỬA LỖI REJECTED) ---
echo "☁️  Đang đẩy dữ liệu lên GitHub..."

# Thêm file và commit
git add .
if git diff-index --quiet HEAD --; then
    echo "ℹ️  Không có thay đổi nào mới."
else
    git commit -m "Auto-backup: $(date +'%H:%M:%S %d-%m-%Y')"
    
    current_branch=$(git branch --show-current)
    [ -z "$current_branch" ] && current_branch="main"
    
    # === ĐOẠN QUAN TRỌNG: THỬ PUSH THƯỜNG TRƯỚC ===
    if git push origin $current_branch; then
        echo "✅ ĐÃ LƯU THÀNH CÔNG (Standard Push)!"
    else
        # === NẾU LỖI REJECTED -> CHUYỂN SANG FORCE PUSH ===
        echo "⚠️  Phát hiện lệch lịch sử (Rejected). Đang kích hoạt chế độ GHI ĐÈ..."
        echo "👉 Dữ liệu trên GitHub sẽ được cập nhật theo máy chủ này."
        
        if git push origin $current_branch --force; then
            echo "✅ ĐÃ LƯU THÀNH CÔNG (Force Push)!"
        else
            echo "❌ LỖI: Không thể đẩy dữ liệu. Vui lòng kiểm tra mạng."
        fi
    fi
fi

echo "🏁 HOÀN TẤT QUÁ TRÌNH!"
EOF

chmod +x save.sh