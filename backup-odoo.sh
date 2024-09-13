#!/bin/bash
#
# script to backup odoo DB and filestore on local server from local URL:
#    http://localhost:8069/web/database/backup
#
# and then backup to cloud using s3 bucket - comment out s3cmd command to skip cloud backup
#
# REQUIRES: curl  -  install on Ubuntu with: apt-get install curl
#
# see following links for details:
# - DO Spaces: https://docs.digitalocean.com/products/spaces/
# - DO Spaces using s3cmd: https://docs.digitalocean.com/products/spaces/reference/s3cmd-usage/
# - s3cmd usage: https://s3tools.org/usage
#
# Written by: Jacob Isreal, Isreal Consulting LLC (www.icllc.cc)
#             jisreal@icllc.cc
#
# Last updated: 09-12-2024

# *********************************************************************
# ** CHANGE THESE VARIABLES BEFORE RUNNING SCRIPT                    **
# DO NOT put a trailing slash / on the BACKUP_DIR, only preface with /

BACKUP_DIR=/backup
ODOO_DATABASE=ENTER-DB-NAME
ADMIN_PASSWORD=EnTerAdminPwd
S3BUCKET_NAME=bucketname
# **********************************************************************

# make entry in log file to start
CURRENTDATE=`date +"%Y-%m-%d-%H-%M"`
echo "${CURRENTDATE} - STARTED backup." >> /root/odoo-backup.log

# create backup directory if it does not exist
mkdir -p ${BACKUP_DIR}
cd ${BACKUP_DIR}

# create a backup
curl -X POST \
    -F "master_pwd=${ADMIN_PASSWORD}" \
    -F "name=${ODOO_DATABASE}" \
    -F "backup_format=zip" \
    -o ${BACKUP_DIR}/${ODOO_DATABASE}_${CURRENTDATE}.zip \
    http://localhost:8069/web/database/backup

# delete local backups older than 7 days
# YOU can change the number of days by changing the '+7' below to +14 or +anynumber
find ${BACKUP_DIR} -type f -mtime +7 -name "${ODOO_DATABASE}.*.zip" -delete
CURRENTDATE=`date +"%Y-%m-%d-%H-%M"`
echo "${CURRENTDATE} - Removed backups older than 7 days." >> /root/odoo-backup.log

# sync to s3 bucket on cloud in odoo folder - WILL NOT REMOVE any files on remote storage
# so be sure to keep your s3 bucket cleaned up or add scripting to delete older files
# YOU can also just remove the '--no-delete-removed' option below to just sync 7 days
s3cmd sync ${BACKUP_DIR}/ s3://${S3BUCKET_NAME}/odoo/ --recursive --no-delete-removed

# finish up and add log entry
CURRENTDATE=`date +"%Y-%m-%d-%H-%M"`
echo "${CURRENTDATE} - Synced backups to cloud storage." >> /root/odoo-backup.log
echo "${CURRENTDATE} - COMPLETED backup." >> /root/odoo-backup.log
echo "-----" >> /root/odoo-backup.log

