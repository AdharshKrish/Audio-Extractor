#!/bin/bash

# --- CONFIGURATION ---
# Using 'realpath' locks in absolute paths so find/parallel never get confused
SOURCE_DIR=$(realpath "Brooklyn.Nine-Nine")
DEST_DIR=$(realpath "B99_Opus_Audio")
# ---------------------

# Safety checks
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Cannot find source directory: $SOURCE_DIR"
    exit 1
fi

mkdir -p "$DEST_DIR"
find "$DEST_DIR" -type f -size 0 -delete 2>/dev/null

echo "Starting Batch Conversion..."
echo "Source: $SOURCE_DIR"
echo "Dest: $DEST_DIR"

# VERY IMPORTANT: Added --jobs 2 to prevent mechanical HDD thrashing.
# If your files are on a fast NVMe SSD, you can remove --jobs 2.
find "$SOURCE_DIR" -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.avi" \) -print0 | \
    parallel -0 --jobs 2 --bar ./worker_b99.sh {} "$SOURCE_DIR" "$DEST_DIR"

echo -e "\nBatch conversion complete!"
