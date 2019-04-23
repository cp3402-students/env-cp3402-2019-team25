#!/bin/sh
# Import variables
SCRIPT=$(readlink -f "$0")
PROJECT_DIRECTORY=$(dirname "$SCRIPT")
cp -rl hooks .git

# Pause at end
read -p "Press enter to continue"
exit
