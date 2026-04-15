#!/bin/bash

# スクリーンショット管理スクリプト
# 処理フロー: 一時保存 -> pngquant圧縮 -> 保存 -> クリップボードコピー -> デスクトップ通知

# 環境変数の設定 (実行パスの不整合を防止)
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin

# 保存ディレクトリおよびファイル名の定義
SAVE_DIR="$HOME/Pictures/ScreenShots"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
FINAL_FILE="$SAVE_DIR/${TIMESTAMP}.png"

# 一時作業ファイルの設定
TEMP_DIR="/tmp"
TEMP_NAME="hyprshot_temp_${TIMESTAMP}.png"
TEMP_FILE="$TEMP_DIR/$TEMP_NAME"

# ディレクトリの準備
mkdir -p "$SAVE_DIR"

# 引数に応じた撮影モードの振り分け
case $1 in
    window) ARGS="-m window" ;;            # ウィンドウ選択
    active) ARGS="-m active -m window" ;; # アクティブウィンドウ
    region) ARGS="-m region" ;;            # 範囲指定
    output) ARGS="-m active -m output" ;; # アクティブな出力全体
    *) exit 1 ;;
esac

# スクリーンショットの実行
# hyprshotの出力を標準出力(-r -)に出し、cat経由でリダイレクトすることで対話モードの安定性を確保
# --silent でhyprshot側の通知を抑制
hyprshot $ARGS -r - --silent | cat > "$TEMP_FILE"

# 成功判定 (撮影がキャンセルされた場合はファイルが空、または作成されない)
if [ -s "$TEMP_FILE" ]; then
    # pngquantによる圧縮処理
    if command -v pngquant >/dev/null; then
        pngquant --force --output "$FINAL_FILE" "$TEMP_FILE" >/dev/null 2>&1
    else
        # pngquantが未インストールの場合はそのままコピー
        cp "$TEMP_FILE" "$FINAL_FILE"
    fi

    # 保存成功時のフィードバック処理
    if [ -f "$FINAL_FILE" ]; then
        # クリップボードに画像データをコピー
        wl-copy -t image/png < "$FINAL_FILE"
        # デスクトップ通知を送信
        notify-send "Screenshot Captured" "$TIMESTAMP" -i "$FINAL_FILE" -a "Hyprshot"
    fi
fi

# 作業用一時ファイルの削除
rm -f "$TEMP_FILE"
