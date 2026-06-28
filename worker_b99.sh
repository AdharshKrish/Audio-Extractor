#!/bin/bash

INPUT_FILE="$1"
SOURCE_DIR="$2"
DEST_DIR="$3"

# --- CONFIGURATION ---
FFMPEG_CMD="$HOME/workspace/ffmpeg-new/ffmpeg"
ALBUM_NAME="Brooklyn Nine-Nine"
GENRE="Adharsh"
# ---------------------

# 1. Bulletproof Directory Calculation
# Safely strip the base SOURCE_DIR path from the front of the INPUT_FILE path
RELATIVE_FILE_PATH="${INPUT_FILE#"$SOURCE_DIR/"}"
# Extract just the relative folder structure (e.g., "Season 1")
REL_DIR=$(dirname "$RELATIVE_FILE_PATH")

# Construct the final destination directory
NEW_DIR="$DEST_DIR/$REL_DIR"
mkdir -p "$NEW_DIR"

# Dynamically target the folder.jpg
DIR_PATH=$(dirname "$INPUT_FILE")
COVER_IMAGE="$DIR_PATH/folder.jpg"

# 2. Filename Transformation
BASENAME=$(basename "$INPUT_FILE")
ORIG_FILENAME="${BASENAME%.*}"

NEW_FILENAME="${ORIG_FILENAME/Brooklyn Nine-Nine - /B99.}"
NEW_FILENAME="${NEW_FILENAME/ - /.}"
NEW_FILENAME="${NEW_FILENAME// /.}"

OUTPUT_FILE="$NEW_DIR/${NEW_FILENAME}.m4a"

# Skip if already done
if [ -f "$OUTPUT_FILE" ]; then
    exit 0
fi

# 3. Extract Season Number
if [[ "$ORIG_FILENAME" =~ S([0-9]{2})E[0-9]{2} ]]; then
    SEASON_NUM=$((10#${BASH_REMATCH[1]}))
    ARTIST_NAME="Season $SEASON_NUM"
else
    ARTIST_NAME="Unknown Season"
fi

# 4. Extract, Convert, Embed, and Tag
if [ ! -f "$COVER_IMAGE" ]; then
    # Fallback (No cover art)
    $FFMPEG_CMD -y -v error -nostdin \
        -i "$INPUT_FILE" \
        -map 0:a:0 \
        -c:a libopus -b:a 40k \
        -metadata title="$NEW_FILENAME" \
        -metadata album="$ALBUM_NAME" \
        -metadata artist="$ARTIST_NAME" \
        -metadata genre="$GENRE" \
        -strict -2 -f mp4 \
        "$OUTPUT_FILE"
else
    # Primary (With cover art)
    $FFMPEG_CMD -y -v error -nostdin \
        -i "$INPUT_FILE" \
        -i "$COVER_IMAGE" \
        -map 0:a:0 \
        -map 1:v:0 \
        -c:a libopus -b:a 40k \
        -c:v copy \
        -disposition:v attached_pic \
        -metadata title="$NEW_FILENAME" \
        -metadata album="$ALBUM_NAME" \
        -metadata artist="$ARTIST_NAME" \
        -metadata genre="$GENRE" \
        -strict -2 -f mp4 \
        "$OUTPUT_FILE"
fi
