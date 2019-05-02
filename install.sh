#!/bin/sh
# Import variables
SCRIPT=$(readlink -f "$0")
PROJECT_DIRECTORY=$(dirname "$SCRIPT")
cp -rl hooks .git
if [[ "$OSTYPE" == "win32"]]; then
   # ...
else
   ln -s $PROJECT_DIRECTORY"/www/public/wp-content/themes" "themes"

# Pause at end
read -p "Press enter to continue"
exit
