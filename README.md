# Sitcom Audio Compressor

A set of high-performance shell scripts to batch compress audio files (specifically extracted from sitcoms) for optimal storage and background listening.

This project uses `ffmpeg` and `GNU parallel` to process entire seasons of TV shows in minutes, reducing file sizes by **50-70%** while preserving dialogue clarity and metadata.

## Features

* **Multi-Core Processing:** Uses 100% of your CPU to convert multiple episodes simultaneously.
* **Smart Metadata Copying:** Preserves Title, Episode, and Season tags.
* **Album Art Handling:** Includes specific fixes for cover art in MP3 and Matroska containers.
* **Three Compression Modes:**
1. **Universal (MP3):** 64kbps, works on any car stereo/phone, keeps Album Art.
2. **High-Efficiency (Opus):** 40kbps, tiny files (~6MB/episode), drops Album Art for max savings.
3. **Archival (MKA):** 40kbps Opus + Album Art (Best of both worlds, but requires VLC/MPV).



## Prerequisites

You need a Linux environment (Ubuntu/Debian) with these tools installed:

```bash
sudo apt update
sudo apt install ffmpeg parallel

```

## Project Structure

Place your source audio files in a folder named `BBT` (or edit the scripts to match your folder name).

```text
.
├── BBT/                 # Source folder (e.g., MP3s extracted from video)
│   ├── S1/
│   │   └── BBT S01E01.mp3
│   └── ...
├── run_parallel.sh      # The main execution script
├── worker_mp3.sh        # Worker: Converts to 64k MP3 (Max Compatibility)
├── worker_opus.sh       # Worker: Converts to 40k Opus (Max Space Saving)
└── worker.sh            # Worker: Converts to 40k Opus inside .mka (Hybrid)

```

## Usage

The project is designed to run via the `run_parallel.sh` script, which feeds files to one of the "worker" scripts.

### 1. Select your Mode

Open `run_parallel.sh` and look at the last line. Change the script name to the worker you want to use:

**For Maximum Compatibility (Default):**

```bash
# Inside run_parallel.sh
find BBT -type f -name "*.mp3" -print0 | parallel -0 --bar ./worker_mp3.sh {}

```

**For Maximum Space Saving (No Art):**

```bash
# Inside run_parallel.sh
find BBT -type f -name "*.mp3" -print0 | parallel -0 --bar ./worker_opus.sh {}

```

### 2. Run the Script

Make sure scripts are executable and run the parallel runner:

```bash
chmod +x *.sh
./run_parallel.sh

```

## Comparison of Modes

| Mode | Script | Codec | Bitrate | Album Art? | File Size (20m ep) | Compatibility |
| --- | --- | --- | --- | --- | --- | --- |
| **Universal** | `worker_mp3.sh` | MP3 | 64k | ✅ Yes | ~9.5 MB | 100% (Cars, Old iPods) |
| **Efficient** | `worker_opus.sh` | Opus | 40k | ❌ No | ~5.8 MB | High (Modern Phones) |
| **Hybrid** | `worker.sh` | Opus | 40k | ✅ Yes | ~6.0 MB | Medium (VLC, MPV, Android) |

## Technical Notes

* **MP3 Tagging:** The MP3 worker explicitly uses ID3v2.3 (`-id3v2_version 3`) to ensure cover art appears on Windows and older Android players.
* **Opus & Art:** Since the `.opus` container does not support video streams (album art), the Hybrid worker uses the Matroska (`.mka`) container to legally hold both the Opus audio and the JPEG cover art.
* **Parallelism:** The scripts use `find ... -print0 | parallel -0` to safely handle filenames containing spaces or special characters.

## License

MIT
