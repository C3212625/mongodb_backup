# mongodb_backup
MongoDB Database Backup Script with x509 Authentication


You can customize this Script this script based on your requirement . If you want to Trigger this Daily Backup with Basic Mongodb Authentication
Just Ignore the PEMKEY & CA parameters and make the changes in the AUTH_PARAM 

For Example :-

if [ ${AUTH_ENABLED} -eq 1 ]; then
 AUTH_PARAM=" --username ${MONGO_USER} --password ${MONGO_PASSWD}"
fi

This will help to Enable Daily Backup without SSL Enables.

Also, you can Alter your Retention Period on:

## Number of days to keep local backup copy
BACKUP_RETAIN_DAYS=30

GZIP is Enabled along with Mongodump this will compress your backup by default.
