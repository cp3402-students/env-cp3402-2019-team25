# THis function returns the absolute path of the project directory
project_directory()
{
   if [[ "$OSTYTPE" == "darwin"* ]]
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
      PROJECT_DIRECTORY= echo `pwd -P` | echo $(sed -E 's/\/scripts//g') | sed -E 's/\/.git\/hooks//g'
   else
      SCRIPT=$(readlink -f "$0")
      PROJECT_DIRECTORY= echo $(dirname "$SCRIPT") | echo $(sed -E 's/\/scripts//g') | sed -E 's/\/.git\/hooks//g'
   fi
   echo $PROJECT_DIRECTORY
}
PROJECT_DIRECTORY="$(project_directory)"
MYSQL_DATABASE_NAME="scotchbox"
MYSQL_USER="WebAdmin"
MYSQL_PASSWORD="gG5XCvUSL4keOwamsEz"
MYSQL_DUMP="/home/vagrant/database/mysql.sql"
MYSQL_CREATE_USER=$PROJECT_DIRECTORY"/database/database-cp3402-2019-team25/create_user.sql"
MYSQL_SSH_CREATE_USER="/home/vagrant/database/create_user.sql"
DATABASE_DIRECTORY=$PROJECT_DIRECTORY"/database/database-cp3402-2019-team25"
THEMES="$PROJECT_DIRECTORY/www/public/wp-content/themes/"
PLUGINS="$PROJECT_DIRECTORY/www/public/wp-content/plugins/"
set_project()
{
   cd $1
   git init &> /dev/nul
   git fetch origin
}
revert_project()
{
   cd $PROJECT_DIRECTORY
   git init &> /dev/null
}
get_current_branch()
{
   echo $(git branch | grep \* | cut -d ' ' -f2)
}
get_numCommitsAhead()
{
   echo $(git rev-list origin/$1..HEAD | wc -l)
}
get_numCommitsBehind()
{
   echo $(git rev-list HEAD..origin/$1 | wc -l)
}
update_check()
{
   set_project $1
   if [ $(get_numCommitsBehind $(get_current_branch)) -gt 0 ]
   then
      git pull origin
   fi
   revert_project
   set_update_commands
}
dump_check()
{
   while true
   do
      echo "Would you like to dump the database?"
      read -p "" yn
      case $yn in
         [Yy]* ) COMMANDS=$COMMANDS"sudo mysqldump -u$MYSQL_USER -p'$MYSQL_PASSWORD' scotchbox > $MYSQL_DUMP; echo \"Dumping MYSQL Databases\""; break;;
         [Nn]* ) echo "Skipping database dump"; break;;
         * ) echo "Please answer yes or no"
      esac
   done
}
update_database()
{
   update_check $DATABASE_DIRECTORY
}
dump_database()
{
   dump_check $DATABASE_DIRECTORY
}
update_themes_plugins()
{
   for dir in $(find "$THEMES" -maxdepth 1 -type d \( ! -name . \))
   do
      DIRECTORY="$dir"/".git"
      if [ -f "$DIRECTORY" ]
      then
         set_project $dir
         if [ $(get_numCommitsBehind $(get_current_branch)) -gt 0 ]
         then
            echo "Updating $dir"
            git pull origin
         fi
         revert_project
      fi
   done
   for dir in $(find "$PLUGINS" -maxdepth 1 -type d \( ! -name . \))
   do
      DIRECTORY="$dir"/".git"
      if [ -f "$DIRECTORY" ]
      then
         set_project $dir
         if [ $(get_numCommitsBehind $(get_current_branch)) -gt 0 ]
         then
            echo "Updating $dir"
            git pull origin
         fi
         revert_project
      fi
   done
}
change_submodule_branch()
{
   cd $1
   git init
   git checkout $2
   git branch
   git push origin $2
   cd $PROJECT_DIRECTORY
   git init
   git config -f .gitmodules submodule.$1.branch $2
}
set_update_commands()
{
   COMMANDS+="sudo mysql -u'root' -p'root' -e \"drop database $MYSQL_DATABASE_NAME\"; echo \"Clearing MYSQL Database\"; "
   COMMANDS+="sudo mysql -u'root' -p'root' -e \"create database $MYSQL_DATABASE_NAME\"; echo \"Creating $MYSQL_DATABASE_NAME Database\"; "
   COMMANDS+="sudo mysql -u'root' -p'root' -e \"use $MYSQL_DATABASE_NAME\"; echo \"Selecting Database $MYSQL_DATABASE_NAME\"; "
   COMMANDS+="sudo mysql -u'root' -p'root' $MYSQL_DATABASE_NAME < $MYSQL_DUMP; echo \"Updating MYSQL Database from MYSQL Dump File\"; "
}
create_user()
{
   A="GRANT ALL PRIVILEGES ON $MYSQL_DATABASE_NAME.* TO '"$MYSQL_USER"'@'localhost' IDENTIFIED BY '"$MYSQL_PASSWORD"'"
   echo $A > $MYSQL_CREATE_USER
}
create_webadmin()
{
   create_user
   COMMANDS[1]="sudo mysql -u'root' -p'root' < $MYSQL_SSH_CREATE_USER; "
}
install()
{
   if [[ "$OSTYPE" == "darwin"* ]]
   then
      cp -RL $PROJECT_DIRECTORY"/hooks" $PROJECT_DIRECTORY"/.git"
      ln -s $PROJECT_DIRECTORY"/www/public/wp-content/themes" $PROJECT_DIRECTORY"/themes"
      ln -s $PROJECT_DIRECTORY"/www/public/wp-content/plugins" $PROJECT_DIRECTORY"/plugins"
   elif [[ "$OSTYPE" == "msys" ]]
   then
      cp -rl $PROJECT_DIRECTORY"/hooks" $PROJECT_DIRECTORY"/.git"
      $PROJECT_DIRECTORY"/scripts/make_symlinks.bat" $PROJECT_DIRECTORY"/themes" $PROJECT_DIRECTORY"/www/public/wp-content/themes"
      $PROJECT_DIRECTORY"/scripts/make_symlinks.bat" $PROJECT_DIRECTORY"/plugins" $PROJECT_DIRECTORY"/www/public/wp-content/plugins"
   else
      cp -rl $PROJECT_DIRECTORY"/hooks" $PROJECT_DIRECTORY"/.git"
      cp -l $PROJECT_DIRECTORY"/www/public/wp-content/themes" $PROJECT_DIRECTORY"/themes"
      cp -l $PROJECT_DIRECTORY"/www/public/wp-content/plugins" $PROJECT_DIRECTORY"/plugins"
   fi
   change_submodule_branch "database/database-cp3402-2019-team25" "master"
   change_submodule_branch "www/public/wp-content/themes/theme-cp3402-2019-team25" "master"
}
start()
{
   COMMANDS[0]="sudo service apache2 stop; echo \"Stopping Apache Web Server\"; "
   create_webadmin
   update_database
   update_themes_plugins
   COMMANDS+="sudo service apache2 start; echo \"Starting Apache Web Server\"; "
   vagrant up
   for i in "${COMMANDS[@]}"
   do
      COMMAND=$COMMAND$i
   done
   RESULT=$(vagrant ssh -- -t $COMMAND )
   echo "$RESULT"
}
dump()
{
   COMMANDS[0]="sudo service apache2 stop; echo \"Stopping Apache Web Server\"; "
   dump_database
   COMMANDS+="sudo service apache2 start; echo \"Starting Apache Web Server\"; "
   for i in "${COMMANDS[@]}"
   do
      COMMAND=$COMMAND$i
   done
   RESULT=$(vagrant ssh -- -t $COMMAND )
   echo "$RESULT"
}
stop()
{
   COMMANDS="sudo service apache2 stop; echo \"Stopping Apache Web Server\"; "
   dump_database
   RESULT=$(vagrant ssh -- -t $COMMANDS)
   echo "$RESULT"
   vagrant halt
}
ssh()
{
   vagrant ssh
}
sass()
{
  $PROJECT_DIRECTORY"/dart-sass/sass.bat" $PROJECT_DIRECTORY"/www/public/wp-content/themes/theme-cp3402-2019-team25/sass/theme.scss" $PROJECT_DIRECTORY"/www/public/wp-content/themes/theme-cp3402-2019-team25/css/theme.css"
  $PROJECT_DIRECTORY"/dart-sass/sass.bat" $PROJECT_DIRECTORY"/www/public/wp-content/themes/theme-cp3402-2019-team25/sass/theme.scss" $PROJECT_DIRECTORY"/www/public/wp-content/themes/theme-cp3402-2019-team25/css/theme.min.css" "--style=compressed"
}
if [[ "$1" == "install" ]]
then
   install
elif [[ "$1" == "start" ]]
then
   start
elif [[ "$1" == "stop" ]]
then
   stop
elif [[ "$1" == "ssh" ]]
then
   ssh
elif [[ "$1" == "sass" ]]
then
   sass
elif [[ "$1" == "dump_database" ]]
then
   dump
elif [[ "$1" == "update_database" ]]
then
   update_database
elif [[ "$1" == "update_themes_plugins" ]]
then
   update_themes_plugins
elif [[ "$1" == "change_submodule_branch" ]]
then
   git init &> /dev/null
   SUBMODULES=($(git config --file .gitmodules --get-regexp path | awk '{ print $2 }'))
   echo "Choose submodule"
   for i in "${!SUBMODULES[@]}"
   do
      echo "$i)" "${SUBMODULES[$i]}"
   done
   read -p "" CHOICE
   read -p "Branch name: " BRANCH
   if [[ "$OSTYTPE" == "darwin"* ]]
   then
      git config --global credential.helper osxkeychain
   elif [[ "$OSTYPE" == "msys" ]]
   then
      git config --global credential.helper wincred
   else
      git config --global credential.helper cache
   fi
   change_submodule_branch "${SUBMODULES[$CHOICE]}" $BRANCH
fi
# Pause at end
read -p "Press enter to continue"
exit
