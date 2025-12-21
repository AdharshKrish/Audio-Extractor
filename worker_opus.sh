#!/bin/bash

# $1 is the input filename passed by parallel
INPUT_FILE="$1"

# --- CONFIGURATION ---
SOURCE_DIR="BBT"
DEST_DIR="BBT_opus_40k"
# POINT THIS TO YOUR NEW FFMPEG FOLDER
FFMPEG_CMD="$HOME/workspace/ffmpeg-new/ffmpeg" 
# ---------------------

# 1. Path Calculation
DIR_PATH=$(dirname "$INPUT_FILE")
NEW_DIR="${DIR_PATH/$SOURCE_DIR/$DEST_DIR}"
FILENAME=$(basename "$INPUT_FILE" .mp3)
OUTPUT_FILE="$NEW_DIR/$FILENAME.m4a"

# 2. Create Directory
mkdir -p "$NEW_DIR"

# 3. Convert
if [ -f "$OUTPUT_FILE" ]; then
    echo "Skipping: $OUTPUT_FILE"
else
    # New FFmpeg Command
    # -strict -2 : Unlocks experimental support just in case
    $FFMPEG_CMD -n -v error -nostdin \
        -i "$INPUT_FILE" \
        -map 0:a -map 0:v? \
        -map_metadata 0 \
        -c:a libopus -b:a 40k \
        -c:v copy \
        -disposition:v attached_pic \
        -strict -2 \
        -f mp4 \
        "$OUTPUT_FILE"
fi
