#!/bin/bash

# ==========================================
# SCRIPT BACKUP SIÊU TỐC (ALWAYS FORCE)
# ==========================================

echo "=== 💾 BACKUP SERVER (CHẾ ĐỘ GHI ĐÈ) ==="

# 1. KẾT NỐI GIT
# Nếu mất kết nối thì tạo lại ngay
if [ ! -d .git ]; then
    git init
    git branch -M main
    git remote add origin https://github.com/$GITHUB_REPOSITORY.git
fi
# Luôn set lại URL để đảm bảo Token sống
git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git

# 2. DỌN DẸP
# (Tắt server nếu cần thiết - Nếu bạn muốn vừa chơi vừa lưu thì bỏ đoạn tắt server đi cũng được, nhưng tắt thì an toàn hơn)
if pgrep -f "java" > /dev/null; then
    echo "⏳ Đang dừng Server để lưu..."
    pkill -15 -f "java"
    while pgrep -f "java" > /dev/null; do sleep 1; done
fi

rm -f logs/*.gz 
rm -rf cache/* crash-reports/*

# 3. LƯU VÀ ĐẨY THẲNG (FORCE)
echo "🚀 Đang đẩy dữ liệu..."
git add .

# Chỉ commit khi có thay đổi
if git diff-index --quiet HEAD --; then
    echo "ℹ️  Không có gì mới."
else
    git commit -m "Auto-save: $(date +'%H:%M %d/%m')"
    
    git push origin main
    
    echo "✅ ĐÃ LƯU XONG!"
fi
