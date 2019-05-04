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
      PROJECT_DIRECTORY= echo `pwd -P` | sed -E 's/\/scripts//g'
   else
      SCRIPT=$(readlink -f "$0")
      PROJECT_DIRECTORY= echo $(dirname "$SCRIPT") | sed -E 's/\/scripts//g'
   fi
   echo $PROJECT_DIRECTORY
}
COMMAND=$1
PROJECT_DIRECTORY="$(project_directory)"
MYSQL_DATABASE_NAME="scotchbox"
MYSQL_USER="WebAdmin"
MYSQL_PASSWORD="gG5XCvUSL4keOwamsEz"
MYSQL_DUMP="/home/vagrant/database/mysql.sql"
MYSQL_CREATE_USER=$PROJECT_DIRECTORY"/database/database-cp3402-2019-team25/create_user.sql"
MYSQL_SSH_CREATE_USER="/home/vagrant/database/create_user.sql"
DATABASE_DIRECTORY=$PROJECT_DIRECTORY"/database/database-cp3402-2019-team25"

set_project()
{
   if [ $1 !='' ]
   then
      cd $PROJECT_DIRECTORY"/"$1
      git init
   fi
}
revert_project()
{
   if [ $1 !='' ]
   then
      cd $PROJECT_DIRECTORY
      git init
   fi
}
get_current_branch()
{
   set_project $1
   BRANCH=$(git branch | grep \* | cut -d ' ' -f2)
   revert_project $1
}
get_numCommitsAhead()
{
   set_project $1
   AHEAD=$(git rev-list origin/$BRANCH..HEAD | wc -l)
   revert_project $1
}
get_numCommitsBehind()
{
   set_project $1
   BEHIND=$(git rev-list HEAD..origin/$BRANCH | wc -l)
   revert_project $1
}
update_check()
{
   set_project $1
   if [ $BEHIND -gt 0 ]
   then
      git pull origin/$BRANCH
      set_update_commands
   fi
   revert_project $1
}
dump_check()
{
   if [ $AHEAD -gt 0 ]
      then
         COMMAND=$COMMAND"sudo mysqldump -u$MYSQL_USER -p'$MYSQL_PASSWORD' scotchbox > $MYSQL_DUMP; echo \"Dumping MYSQL Databases\""
      fi
}
update_database()
{
   get_current_branch "database"
   get_numCommitsAhead "database"
   get_numCommitsBehind "database"
   update_check "database"
}
dump_database_check()
{
   get_current_branch "database"
   get_numCommitsAhead "database"
   get_numCommitsBehind "database"
   dump_check
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
   elif [[ "$OSTYPE" == "msys" ]]
   then
      cp -rl $PROJECT_DIRECTORY"/hooks" $PROJECT_DIRECTORY"/.git"
      $PROJECT_DIRECTORY"/scripts/make_symlinks.bat" $PROJECT_DIRECTORY"/themes" $PROJECT_DIRECTORY"/www/public/wp-content/themes"
   else
      cp -rl $PROJECT_DIRECTORY"/hooks" $PROJECT_DIRECTORY"/.git"
      cp -l $PROJECT_DIRECTORY"/www/public/wp-content/themes" $PROJECT_DIRECTORY"/themes"
   fi
}
start()
{
   COMMANDS[0]="sudo service apache2 stop; echo \"Stopping Apache Web Server\"; "
   create_webadmin
   update_database
   COMMANDS+="sudo service apache2 start; echo \"Starting Apache Web Server\"; "
   vagrant up
   for i in "${COMMANDS[@]}"
   do
      COMMAND=$COMMAND$i
   done
   RESULT=$(vagrant ssh -- -t $COMMAND )
   echo "$RESULT"
}
stop()
{
   COMMAND="sudo service apache2 stop; echo \"Stopping Apache Web Server\"; "
   dump_database_check
   RESULT=$(vagrant ssh -- -t $COMMAND)
   echo "$RESULT"
   vagrant halt
}
ssh()
{
   vagrant ssh
}
if [ $COMMAND=="install" ]
then
   install
elif [ $COMMAND=="start" ]
then
   start
elif [ $COMMAND=="stop" ]
then
   stop
elif [ $COMMAND=="ssh" ]
then
   ssh
elif [ $COMMAND=="dump_database" ]
then
   dump_database
elif [ $COMMAND=="update_database" ]
then
   update_database
fi
# Pause at end
read -p "Press enter to continue"
exit
