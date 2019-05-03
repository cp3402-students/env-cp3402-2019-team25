#!/bin/sh
# Import variables
if [[ "$OSTYPE" == "win32" ]]
then
   SCRIPT=$(readlink -f "$0")
   PROJECT_DIRECTORY=$(dirname "$SCRIPT")
   cp -rl hooks .git
   call $PROJECT_DIRECTORY"scripts/make_symlinks.bat" "themes" $PROJECT_DIRECTORY"/www/public/wp-content/themes"
elif [[ "$OSTYPE" == "darwin"* ]]
then
   TARGET_FILE=$0
   cd `dirname $TARGET_FILE`
   TARGET_FILE=`basename $TARGET_FILE`
   # Iterate down a (possible) chain of symlinks
   while [ -L "$TARGET_FILE" ]
   do
     TARGET_FILE=`readlink $TARGET_FILE`
     cd `dirname $TARGET_FILE`
     TARGET_FILE=`basename $TARGET_FILE`
   done
   PROJECT_DIRECTORY=`pwd -P`
   cp -RL hooks .git
   ln -s $PROJECT_DIRECTORY"/www/public/wp-content/themes" "themes"
else
   SCRIPT=$(readlink -f "$0")
   PROJECT_DIRECTORY=$(dirname "$SCRIPT")
   cp -rl hooks .git
   cp -l $PROJECT_DIRECTORY"/www/public/wp-content/themes" $PROJECT_DIRECTORY"themes"
fi
# Pause at end
read -p "Press enter to continue"
exit
