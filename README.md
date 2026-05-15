# **ThriveScript - Linux & WSL Utility Scripts**

This project contains a collection of helpful scripts designed for Linux environments (optimized for Ubuntu) and Windows Subsystem for Linux (WSL). These utilities streamline system maintenance and bridge the gap between the WSL terminal and the Windows host browser.

## **Project Structure**

* install.sh: The installer that manages versioning and system PATH integration.  
* upkeep.sh: A shell script for automated system updates and cleanup.  
* wb.py: A Python-based web search tool that works across native Linux and WSL.
* sprout.py: A Python-based project scaffolder.
* mood.sh: A terminal-based background music utility.c
* winpath.sh: A utility to convert Windows File Explorer paths to WSL paths and navigate to them instantly.
* teleport.sh: A directory bookmarking utility to save and jump to frequently used paths.
* pulse.c: A utility to print out the pulse or system information of the machine.
* life.c: A terminal-based implementation of Conway's Game of Life written in C.  

## **Installation**

To install or update the scripts, run the included installation script from the project root. This will copy the tools to /usr/local/bin and ensure they are executable.

```{Bash}
./install.sh
```

What the installer does:

* Binary Compilation: Looks for C/C++ code compiles it using gcc/g++, and moves the resulting binary to /usr/local/bin before cleaning up the build artifacts.

* Binary Integration: Copies scripts to /usr/local/bin and ensures they are executable.

* Smart Updates: Uses md5sum to compare file hashes, skipping files that haven't changed.

* Automatically adds a source command to your ~/.bashrc (marked with [Thrive-Scripts-Auto-Source]) so that utilities like winpath work correctly in every new terminal session.

## **Script Descriptions**

### **1\. Upkeep (upkeep)**

A maintenance script to keep your Ubuntu/Debian system clean and updated.

* **Command:** upkeep  
* **Actions:**  
  * Updates package lists (apt update).  
  * Upgrades installed packages (apt upgrade).  
  * Removes unnecessary dependencies (autoremove).  
  * Cleans up the local repository of retrieved package files (autoclean).

### **2\. Web Browser Search (wb)**

A cross-platform search utility that opens a Google search directly from your terminal.

* **Command:** wb "search query" or wb search terms  
* **WSL Support:** If running inside WSL, it uses PowerShell to trigger the default browser on your Windows host.  
* **Native Linux Support:** Uses the standard webbrowser module to open your default Linux GUI browser.

### **3\. Sprout Project Scaffolder (sprout)**

A scaffolding utility to quickly initialize directory structures, virtual environments, and Git repositories for new projects.

* Command: sprout [project_name] [options]

* Supported Languages: Python, C, C++.

* Key Features:

  * Python: Automatically creates a venv, generates a pyproject.toml, and can install specified libraries using --libs.

  * C/C++: Sets up a src/include/build directory structure and can generate a basic Makefile.

  * Git Integration: Use the -g flag to initialize a Git repo and generate a language-specific .gitignore.

### **4\. Mood Music (mood)**

A background music utility that streams curated playlists using mpv.

* Command: mood [lofi|rain|jazz] or mood stop

* Key Features:

  * Streaming: Streams high-quality audio from YouTube directly to your terminal.

  * Background Execution: Runs in the background, allowing you to continue working while listening.

  * Process Control: Easily stop the music using the stop argument, which terminates the mpv process.

### **5\. Windows Path Navigator (winpath)**

A utility that bridges Windows File Explorer with the WSL terminal by translating path structures.

* Command: winpath "C:\Users\Name\Downloads"

* Handling Backslashes: Optimized to handle Windows-style backslashes and drive letters (e.g., C: to /mnt/c).

* Instant Navigation: Automatically changes your current terminal directory to the translated path.

Note: For paths containing spaces or to ensure best results, wrap the Windows path in single quotes: winpath 'C:\Users\Name\Folder Name'.

### **6\. Teleport (teleport)**

A directory bookmarking utility that allows you to "tag" directories and jump back to them instantly from anywhere in the file system.

* Command: teleport [tag | add [tag] | list | remove [tag] | clear]

* Bookmarks stored in .teleport_bookmarks in user's home.

* Key Features:

  * Add Bookmarks: Save your current location with teleport add [tag].

  * Instant Navigation: Jump to a saved location by typing teleport [tag].

  * Management: Easily list all saved tags with teleport list or delete them using remove or clear.

### **7\. Pulse (pulse)**

A lightweight system monitor written in C that provides a snapshot of your system's health.

* Command: pulse

* Key Features:

  * System Info: Displays your current Linux distribution and system uptime.

  * Live Metrics: Shows real-time CPU usage percentage and a visual progress bar for RAM consumption (Used/Total MB).

  * Process Tracking: Displays the count of currently running processes.

### **8\. Life (life)**

A terminal-based visualization of Conway’s Game of Life, using high-performance C and ANSI escape codes for a smooth, colorful experience.

* Command: life

* Key Features:

  * Dynamic Seeding: Uses the system clock to generate a unique random starting population every time the script is run.

  * Visuals: Utilizes ANSI color codes for green "living" cells and handles terminal refreshing without screen flickering.
  
  * Performance: Optimized in C to handle neighbor-calculation logic efficiently on a 60x30 grid.
  
  * Infinite Loop: Runs continuously until interrupted (Ctrl+C), simulating the infinite evolution of cellular automata.

## **Requirements**

* **Linux**: bash, python3, git, grep, and apt.

  * Compiler: gcc is required to compile the pulse utility during installation.

  * Media Player: mpv and yt-dlp (or youtube-dl) are required for the mood script.

  * Utilities: sed and column for teleport; md5sum for the installer.

* **WSL**: Ensure powershell.exe is available for wb and wslpath is available for winpath.
