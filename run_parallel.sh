#!/bin/bash

# Clean up previous empty failures
echo "Cleaning up 0-byte files..."
find BBT_mka -type f -size 0 -delete 2>/dev/null

echo "Starting Robust Parallel Conversion..."

# -print0 and -0 are crucial. They handle spaces in filenames perfectly.
find BBT -type f -name "*.mp3" -print0 | parallel -0 --bar ./worker_opus.sh {}

echo "Done!"
