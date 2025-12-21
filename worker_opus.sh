#!/bin/bash

# $1 is the input filename passed by parallel
INPUT_FILE="$1"

# --- CONFIGURATION ---
SOURCE_DIR="BBT"
DEST_DIR="BBT_opus_40k" # Distinct folder for this version
FFMPEG_CMD="ffmpeg"      # Or path to your static build
# ---------------------

# 1. Path Calculation
DIR_PATH=$(dirname "$INPUT_FILE")
NEW_DIR="${DIR_PATH/$SOURCE_DIR/$DEST_DIR}"
FILENAME=$(basename "$INPUT_FILE" .mp3)
OUTPUT_FILE="$NEW_DIR/$FILENAME.opus"

# 2. Create Directory
mkdir -p "$NEW_DIR"

# 3. Convert
if [ -f "$OUTPUT_FILE" ]; then
    echo "Skipping: $OUTPUT_FILE"
else
    # FFmpeg Command for Pure Opus
    # -map 0:a       : Select ONLY the audio stream.
    # -vn            : "Video No". Explicitly disables video/images.
    # -map_metadata 0: Keep text tags (Title, Episode info).
    # -c:a libopus   : Opus Encoder.
    # -b:a 40k       : 40kbps Bitrate.
    $FFMPEG_CMD -n -v error -nostdin \
        -i "$INPUT_FILE" \
        -map 0:a \
        -map_metadata 0 \
        -c:a libopus -b:a 40k \
        -vn \
        "$OUTPUT_FILE"
fi
