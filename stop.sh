#!/bin/sh
SCRIPT=$(readlink -f "$0")
PROJECT_DIRECTORY=$(dirname "$SCRIPT")
DATABASE_DIRECTORY=$PROJECT_DIRECTORY"/database/database-cp3402-2019-team25"
# Import dump_database_check function
. $PROJECT_DIRECTORY"/scripts/dump_database_check.sh"
MYSQL_USER="WebAdmin"
MYSQL_PASSWORD="gG5XCvUSL4keOwamsEz"
MYSQL_DUMP="/home/vagrant/database/mysql.sql"
# Run commands function
run()
{
   COMMAND="sudo service apache2 stop; echo \"Stopping Apache Web Server\"; "
   dump_database_check
   RESULT=$(vagrant ssh -- -t $COMMAND)
   echo "$RESULT"
}
# Run our ssh commands
run
# Stop the vm
vagrant halt
# Pause at end
read -p "Press enter to continue"
exit
#.
