# **Linux & WSL Utility Scripts**

This project contains a collection of helpful scripts designed for Linux environments (optimized for Ubuntu) and Windows Subsystem for Linux (WSL). These utilities streamline system maintenance and bridge the gap between the WSL terminal and the Windows host browser.

## **Project Structure**

* install\_scripts.sh: The installer that manages versioning and system PATH integration.  
* upkeep.sh: A shell script for automated system updates and cleanup.  
* wb.py: A Python-based web search tool that works across native Linux and WSL.

## **Installation**
c
To install or update the scripts, run the included installation script from the project root. This will copy the tools to /usr/local/bin and ensure they are executable.

```{Bash}
./install_scripts.sh
```

**Note:** The installer uses md5sum to check if your installed versions are already up to date, skipping the copy process if no changes are detected.

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

## **Requirements**

* **Linux:** bash, python3, and apt package manager (for upkeep).  
* **WSL:** Ensure powershell.exe is available in your WSL path (standard in most setups) to use the wb command effectively.