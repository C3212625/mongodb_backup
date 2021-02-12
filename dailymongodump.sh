#!/bin/bash
######################################################################
#    MongoDB Database Backup Script with x509 Authetication
##   Written By: Nagarajan Palaniappan
##   Created on: December 3,2020
##
######################################################################

export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%d%b%Y"`

######################################################################
######################################################################

DB_BACKUP_PATH='/apps/backup/mongodump'
MONGO_HOST='Hostname'
MONGO_PORT='Port'

# If mongodb is protected with username password.
# Set AUTH_ENABLED to 1
# and add MONGO_USER and MONGO_PASSWD values correctly

AUTH_ENABLED=1
MONGO_USER='admin'
MONGO_PASSWD='password'
SSLPEMKEY='/etc/ssl/mongodb/client.pem'
SSLCA='/etc/ssl/mongodb/mongo_ca.pem'


# Set DATABASE_NAMES to "ALL" to backup all databases.
# or specify databases names seprated with space to backup
# specific databases only.

DATABASE_NAMES='ALL'
#DATABASE_NAMES='mydb db2 newdb'

## Number of days to keep local backup copy
BACKUP_RETAIN_DAYS=30

######################################################################
######################################################################

mkdir -p ${DB_BACKUP_PATH}/${TODAY}

AUTH_PARAM=""

if [ ${AUTH_ENABLED} -eq 1 ]; then
 AUTH_PARAM=" --username ${MONGO_USER} --password ${MONGO_PASSWD} --sslPEMKeyFile ${SSLPEMKEY} --sslCAFile ${SSLCA}"
fi

if [ ${DATABASE_NAMES} = "ALL" ]; then
 echo "You have choose to backup all databases"
 mongodump --gzip --host ${MONGO_HOST} --port ${MONGO_PORT} --ssl ${AUTH_PARAM} --out ${DB_BACKUP_PATH}/${TODAY}/
else
echo "Running backup for selected databases"
 for DB_NAME in ${DATABASE_NAMES}
 do
 mongodump --gzip --host ${MONGO_HOST} --port ${MONGO_PORT} --db ${DB_NAME} --ssl ${AUTH_PARAM} --out ${DB_BACKUP_PATH}/${TODAY}/
 done
fi

echo ${MONGO_HOST} ${MONGO_PORT} ${AUTH_PARAM} ${DB_BACKUP_PATH} ${TODAY}
######## Remove backups older than {BACKUP_RETAIN_DAYS} days  ########

DBDELDATE=`date +"%d%b%Y" --date="${BACKUP_RETAIN_DAYS} days ago"`

if [ ! -z ${DB_BACKUP_PATH} ]; then
      cd ${DB_BACKUP_PATH}
      if [ ! -z ${DBDELDATE} ] && [ -d ${DBDELDATE} ]; then
            rm -rf ${DBDELDATE}
      fi
fi

######################### End of script ##############################
