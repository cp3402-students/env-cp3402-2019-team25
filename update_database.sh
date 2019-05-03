#!/bin/sh
SCRIPT=$(readlink -f "$0")
PROJECT_DIRECTORY=$(dirname "$SCRIPT")
DATABASE_DIRECTORY=$PROJECT_DIRECTORY"/database/database-cp3402-2019-team25"
. $PROJECT_DIRECTORY"/scripts/update_database.sh"
update_database
read -p "Press enter to continue"
exit
