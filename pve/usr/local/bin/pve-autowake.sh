#!/bin/bash


# === 設定區 ===
# 閒置幾秒後關閉? (建議設 300 = 5分鐘，太短會導致瀏覽器重整時頻繁開關)
IDLE_LIMIT=30
# 每幾秒檢查一次? (建議 10-15 秒，減輕 CPU 負擔)
CHECK_INTERVAL=10
# ==============

idle_counter=0

# 啟動時紀錄一條訊息
logger -p user.warning -t pve-autowake "自動喚醒服務已啟動"

while true; do
    # 2. 偵測連線數 (關鍵修正：加上 -H 去掉標題列)
    # 邏輯：列出 Port 8006 的連線 -> 排除本機 -> 計算行數
    conn_count=$(ss -H -tn state established '( sport = :8006 )' | grep -v '127.0.0.1' | wc -l)

    if [ "$conn_count" -gt 0 ]; then
        # === 情境 A：有人正在連線 ===
        idle_counter=0

        # 只有當 pvestatd 是死的，才執行喚醒 (避免重複執行 start)
        if ! systemctl is-active --quiet pvestatd; then
            logger -p user.warning -t pve-autowake "偵測到連線 ($conn_count)，正在喚醒 pvestatd..."
            systemctl start pvestatd
        fi
    else
        # === 情境 B：沒人連線 ===
        
        # 只有當 pvestatd 是活的，才開始倒數計時
        if systemctl is-active --quiet pvestatd; then
            idle_counter=$((idle_counter + CHECK_INTERVAL))

            # 如果閒置時間超過設定值
            if [ "$idle_counter" -ge "$IDLE_LIMIT" ]; then
                logger -p user.warning -t pve-autowake "閒置已超過 $IDLE_LIMIT 秒，正在休眠 pvestatd..."
                systemctl stop pvestatd
                # 鎖定計數器，避免下一圈迴圈重複執行 stop
                idle_counter=$IDLE_LIMIT
            fi
        fi
    fi

    sleep $CHECK_INTERVAL
done
