#!/bin/bash

# Configuration
SOURCE_DIR="BBT"
DEST_DIR="BBT_opus"
BITRATE="40k"

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg is not installed. Please install it first."
    exit 1
fi

echo "Starting conversion (keeping Cover Art) from '$SOURCE_DIR' to '$DEST_DIR'..."
echo "Target Bitrate: $BITRATE (Opus)"

# Find all .mp3 files
find "$SOURCE_DIR" -type f -name "*.mp3" -print0 | while IFS= read -r -d '' input_file; do

    # 1. Calculate paths
    rel_path="${input_file#$SOURCE_DIR/}"
    sub_folder=$(dirname "$rel_path")
    mkdir -p "$DEST_DIR/$sub_folder"
    filename=$(basename "$input_file" .mp3)
    output_file="$DEST_DIR/$sub_folder/$filename.opus"

    # 2. Check if file exists
    if [ -f "$output_file" ]; then
        echo "Skipping (exists): $rel_path"
    else
        echo "Converting: $rel_path"

        # FFmpeg Command
        # -map 0:a  -> Map the audio stream
        # -map 0:v? -> Map the video stream (album art) ONLY if it exists (?)
        # -c:v copy -> Do not re-encode the image (keeps it small and original)
        ffmpeg -n -v error -stats \
            -i "$input_file" \
            -map 0:a -map 0:v? \
            -map_metadata 0 \
            -c:a libopus -b:a "$BITRATE" \
            -c:v copy \
            "$output_file" < /dev/null
    fi

done

echo "------------------------------------------------"
echo "Conversion complete!"
