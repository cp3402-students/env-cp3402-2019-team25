#!/bin/sh
# Import variables
SCRIPT=$(readlink -f "$0")
PROJECT_DIRECTORY=$(dirname "$SCRIPT")
MYSQL_DATABASE_NAME="scotchbox"
MYSQL_USER="WebAdmin"
MYSQL_PASSWORD="gG5XCvUSL4keOwamsEz"
MYSQL_DUMP="/home/vagrant/database/mysql.sql"
MYSQL_CREATE_USER=$PROJECT_DIRECTORY"/database/database-cp3402-2019-team25/create_user.sql"
MYSQL_SSH_CREATE_USER="/home/vagrant/database/create_user.sql"
DATABASE_DIRECTORY=$PROJECT_DIRECTORY"/database/database-cp3402-2019-team25"
# First ssh command ran on the server, stops the web server while we run commands
COMMANDS[0]="sudo service apache2 stop; echo \"Stopping Apache Web Server\"; "
# Last ssh command ran on the server, starts the web server as we are finished
COMMANDS[20]="sudo service apache2 start; echo \"Starting Apache Web Server\"; "
# Import update_database_check function
. $PROJECT_DIRECTORY"/scripts/update_database.sh"
# Import create_webadmin function
. $PROJECT_DIRECTORY"/scripts/create_mysql_webadmin.sh"
set_update_commands()
{
   COMMANDS[2]="sudo mysql -u'root' -p'root' -e \"drop database $MYSQL_DATABASE_NAME\"; echo \"Clearing MYSQL Database\"; "
   COMMANDS[3]="sudo mysql -u'root' -p'root' -e \"create database $MYSQL_DATABASE_NAME\"; echo \"Creating $MYSQL_DATABASE_NAME Database\"; "
   COMMANDS[4]="sudo mysql -u'root' -p'root' -e \"use $MYSQL_DATABASE_NAME\"; echo \"Selecting Database $MYSQL_DATABASE_NAME\"; "
   COMMANDS[5]="sudo mysql -u'root' -p'root' $MYSQL_DATABASE_NAME < $MYSQL_DUMP; echo \"Updating MYSQL Database from MYSQL Dump File\"; "
}
# Run commands function
run()
{
   COMMAND=""
   for i in "${COMMANDS[@]}"
   do
      COMMAND=$COMMAND$i
   done
   RESULT=$(vagrant ssh -- -t $COMMAND )
   echo "$RESULT"
}
# Create WebAdmin MYSQL user
create_webadmin
# Check if the database needs updating, and load commands to do it if so
update_database
# Start the vm
vagrant up
# Run our ssh commands
run
# Pause at end
read -p "Press enter to continue"
exit
