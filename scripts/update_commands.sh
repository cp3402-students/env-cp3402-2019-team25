#!/bin/sh
set_update_commands()
{
   COMMANDS[2]="sudo mysql -u'root' -p'root' -e \"drop database $MYSQL_DATABASE_NAME\"; echo \"Clearing MYSQL Database\"; "
   COMMANDS[3]="sudo mysql -u'root' -p'root' -e \"create database $MYSQL_DATABASE_NAME\"; echo \"Creating $MYSQL_DATABASE_NAME Database\"; "
   COMMANDS[4]="sudo mysql -u'root' -p'root' -e \"use $MYSQL_DATABASE_NAME\"; echo \"Selecting Database $MYSQL_DATABASE_NAME\"; "
   COMMANDS[5]="sudo mysql -u'root' -p'root' $MYSQL_DATABASE_NAME < $MYSQL_DUMP; echo \"Updating MYSQL Database from MYSQL Dump File\"; "
}
