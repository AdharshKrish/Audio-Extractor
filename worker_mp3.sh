#!/bin/bash

# $1 is the input filename passed by parallel
INPUT_FILE="$1"

# --- CONFIGURATION ---
SOURCE_DIR="BBT"
DEST_DIR="BBT_mp3_64k"
# You can use system ffmpeg or your new static build
FFMPEG_CMD="ffmpeg" 
# ---------------------

# 1. Path Calculation
DIR_PATH=$(dirname "$INPUT_FILE")
NEW_DIR="${DIR_PATH/$SOURCE_DIR/$DEST_DIR}"
FILENAME=$(basename "$INPUT_FILE" .mp3)
OUTPUT_FILE="$NEW_DIR/$FILENAME.mp3"

# 2. Create Directory
mkdir -p "$NEW_DIR"

# 3. Convert
if [ -f "$OUTPUT_FILE" ]; then
    echo "Skipping: $OUTPUT_FILE"
else
    # FFmpeg Command for MP3
    # -c:a libmp3lame : The standard MP3 encoder
    # -b:a 64k        : 64kbps Constant Bitrate
    # -c:v copy       : Copy the album art data
    # -map 0:a -map 0:v : Ensure both Audio and Art are grabbed
    # -id3v2_version 3 : CRITICAL. Forces older ID3 tag version (v2.3). 
    #                    Many phones cannot read the newer v2.4 tags.
    $FFMPEG_CMD -n -v error -nostdin \
        -i "$INPUT_FILE" \
        -map 0:a -map 0:v? \
        -map_metadata 0 \
        -c:a libmp3lame -b:a 64k \
        -c:v copy \
        -id3v2_version 3 \
        "$OUTPUT_FILE"
fi
