#!/bin/bash

# ==========================================
# SCRIPT SAVE TỰ ĐỘNG (AUTO-KILL MODE)
# ==========================================

echo "=== 💾 BACKUP SERVER (TARGET: MAIN) ==="

# 1. KẾT NỐI GIT (Dự phòng)
if [ ! -d .git ]; then
    git init
    git branch -M main
    git remote add origin https://github.com/$GITHUB_REPOSITORY.git
fi
git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git

# 2. DỪNG SERVER (MẠNH TAY)
if pgrep -f "java" > /dev/null; then
    echo "🔪 Phát hiện Server đang chạy (PID: $(pgrep -f java)). Đang cưỡng chế dừng..."
    pkill -9 -f "java"
    # Đợi cho chắc chắn đã tắt
    while pgrep -f "java" > /dev/null; do sleep 1; done
    echo "💀 Đã tắt Server."
fi

# 3. DỌN RÁC
echo "🧹 Đang dọn dẹp file rác..."
rm -rf logs/*.log logs/*.gz cache/* crash-reports/* world/backups/* .mixin.out 2>/dev/null

# 4. LƯU & ĐẨY CODE
echo "🚀 Đang đẩy dữ liệu..."
git add .

if git diff-index --quiet HEAD --; then
    echo "ℹ️  Không có thay đổi gì mới."
else
    git commit -m "Auto-save: $(date +'%H:%M %d/%m')"
    git push origin main
    echo "✅ ĐÃ LƯU XONG!"
fi
