# Sitcom Audio Compressor

A set of high-performance shell scripts to batch compress audio files (specifically extracted from sitcoms) for optimal storage and background listening.

This project uses `ffmpeg` and `GNU parallel` to process entire seasons of TV shows in minutes. It is optimized to run on headless servers (via SSH) and ensures processes survive network disconnections.

## Features

* **Multi-Core Processing:** Saturates 100% of your CPU to convert dozens of episodes simultaneously.
* **Smart Renaming:** Automatically sanitizes filenames for cross-platform compatibility (e.g., "BBT S01E01.mp3" -> "BBT_S01E01.m4a").
* **Persistent Execution:** Designed to work with `tmux`, allowing long jobs to run even if you close your SSH session.
* **Three Compression Modes:**
1. **Universal (MP3):** 64kbps, ID3v2.3 tags, works on old car stereos.
2. **High-Efficiency (Opus):** 40kbps, tiny files, optimized for modern mobile listening.
3. **Hybrid (MKA):** 40kbps Opus + Album Art (Best of both worlds).



## Prerequisites

You need a Linux environment (Ubuntu/Debian) with these tools installed:

```bash
sudo apt update
sudo apt install ffmpeg parallel tmux

```

## Project Structure

Place your source audio files in a folder named `BBT` (or edit the scripts to match your source folder).

```text
.
├── BBT/                 # Source folder (e.g., MP3s extracted from video)
│   ├── S1/
│   │   └── BBT S01E01.mp3
│   └── ...
├── run_parallel.sh      # The main execution script
├── worker_mp3.sh        # Worker: Converts to 64k MP3 (Max Compatibility)
├── worker_opus.sh       # Worker: Converts to 40k Opus (Max Space Saving)
└── worker.sh            # Worker: Custom/Experimental configs

```

## Usage

### 1. Select your Compression Mode

Open `run_parallel.sh` and edit the last line to point to the worker you want to use.

* **Option A: Universal (Default)** - Best for sharing or old devices.
`... | parallel -0 --bar ./worker_mp3.sh {}`
* **Option B: Max Efficiency** - Best for personal storage (No Album Art).
`... | parallel -0 --bar ./worker_opus.sh {}`

### 2. Run with Persistence (The tmux Method)

Since converting hundreds of files takes time, use `tmux` to ensure the process keeps running even if your internet disconnects or you close the terminal.

1. **Start a new session:**
```bash
tmux new -s audio_job

```


2. **Run the script:**
```bash
chmod +x *.sh
./run_parallel.sh

```


3. **Detach (Leave it running):**
* Press `Ctrl` + `B`, release them, then press `D`.
* You will return to your main terminal. You can now safely close SSH.


4. **Re-attach (Check progress):**
* Log back in and run:


```bash
tmux attach -t audio_job

```



## Output & Naming

The scripts automatically create a new folder next to your source folder (e.g., `BBT_mp3_64k` or `BBT_opus_lite`).

**Filename Sanitization:**
Spaces in filenames are replaced with underscores to ensure compatibility with all operating systems and command-line tools.

* Input: `BBT/S1/BBT S01E01.mp3`
* Output: `BBT_mp3_64k/S1/BBT_S01E01.mp3`

## License

MIT
