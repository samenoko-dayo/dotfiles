#!/bin/bash

WALLPAPER_DIR="$HOME/wallpaper"
STATE_FILE="$HOME/.cache/current_wallpaper_index"

mkdir -p "$(dirname "$STATE_FILE")"

# Get sorted image list
mapfile -t IMAGES < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | sort)

# Exit if no images
if [ ${#IMAGES[@]} -eq 0 ]; then
    echo "No images found in $WALLPAPER_DIR"
    exit 1
fi

# Load last index
if [ -f "$STATE_FILE" ]; then
    INDEX=$(<"$STATE_FILE")
else
    INDEX=0
fi

# Next index
INDEX=$(( (INDEX + 1) % ${#IMAGES[@]} ))
echo "$INDEX" > "$STATE_FILE"

# Current image
CURRENT="${IMAGES[$INDEX]}"

matugen image "$CURRENT" --source-color-index 0