#!bin/sh
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
