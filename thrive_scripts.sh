#!/bin/bash
# thrive_scripts.sh - Logic to be sourced by .bashrc
#
# Contains all files here that need to sourced to work.

winpath() {
    source /usr/local/bin/winpath "$@"
}

teleport() {
    source /usr/local/bin/teleport "$@"
}

alias tp='teleport'
