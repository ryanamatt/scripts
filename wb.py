#!/usr/bin/env python3

"""
Web Search Utility for WSL and Native OS.

This script allows users to perform Google searches from the command line.
It specifically handles the Windows Subsystem for Linux (WSL) by routing 
the request through PowerShell to open the host machine's browser.
"""

import webbrowser
import urllib.parse
import sys
import os
import subprocess

def open_url(url: str) -> None:
    """
    Opens the URL by Checking if we are in WSL or not and running Command in PowerShell if in WSL.
    
    Args:
        url (str): The url to search in the web browser,
    """
    # Check if we are running in WSL
    if "microsoft" in os.uname().release.lower():
        # Use PowerShell to open the URL in the Windows host browser
        subprocess.run(["powershell.exe", "-Command", f"Start-Process '{url}'"], 
                       stdout=subprocess.DEVNULL, 
                       stderr=subprocess.DEVNULL)
    else:
        # Standard Linux/Mac/Windows behavior
        webbrowser.open(url)

def main():
    """
    The Main Function.
    """
    if len(sys.argv) < 2:
        print("Usage: wb \"search term\"")
        sys.exit(1)
    
    # Join all arguments in case of forgetting quotes (e.g., wb dog food)
    query_str = " ".join(sys.argv[1:])
    query = urllib.parse.quote(query_str)
    
    search_url = f"https://www.google.com/search?q={query}"
    
    print(f"Searching for: {query_str}")
    open_url(search_url)

if __name__ == "__main__":
    main()