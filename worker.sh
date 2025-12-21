#!/bin/bash

# $1 is the input filename passed by parallel
INPUT_FILE="$1"

# Hardcoded config for safety
SOURCE_DIR="BBT"
DEST_DIR="BBT_mka"

# 1. Get the directory name (e.g., "BBT/S1")
DIR_PATH=$(dirname "$INPUT_FILE")

# 2. Create the new folder path (Replace BBT with BBT_mka)
# We use bash string replacement: ${VAR/Find/Replace}
NEW_DIR="${DIR_PATH/$SOURCE_DIR/$DEST_DIR}"

# 3. Create the output filename (Base name + .mka)
FILENAME=$(basename "$INPUT_FILE" .mp3)
OUTPUT_FILE="$NEW_DIR/$FILENAME.mka"

# 4. Create Directory
mkdir -p "$NEW_DIR"

# 5. Convert
# Checking if output exists to avoid re-work
if [ -f "$OUTPUT_FILE" ]; then
    echo "Skipping: $OUTPUT_FILE"
else
    # echo "Converting: $INPUT_FILE"
    ffmpeg -n -v error -nostdin \
        -i "$INPUT_FILE" \
        -map 0:a -map 0:v? \
        -map_metadata 0 \
        -c:a libopus -b:a 40k \
        -c:v copy \
	-disposition:v attached_pic \
        -f matroska \
        "$OUTPUT_FILE"
fi
