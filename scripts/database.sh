#!/bin/sh
BRANCH=''
AHEAD=''
BEHIND=''
get_current_branch()
{
   BRANCH=$(git branch | grep \* | cut -d ' ' -f2)
}
get_numCommitsAhead()
{
   AHEAD=$(git rev-list origin/$BRANCH..HEAD | wc -l)
}
get_numCommitsBehind()
{
   BEHIND=$(git rev-list HEAD..origin/$BRANCH | wc -l)
}
update_check()
{
   if [ $BRANCH=='master' ]
   then
      if [ $BEHIND -gt 0 ]
      then
         git pull origin/$BRANCH
      fi
   else
      if [ $BEHIND -gt 0 ]
      then
         git pull origin/$BRANCH
      fi
   fi
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
   cd $DATABASE_DIRECTORY
   git init
   get_current_branch
   get_numCommitsAhead
   get_numCommitsBehind
   update_check
}

dump_database_check()
{
   cd $DATABASE_DIRECTORY
   git init
   get_current_branch
   get_numCommitsAhead
   get_numCommitsBehind
   dump_check
}
