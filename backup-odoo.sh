#!/bin/bash
#
# script to backup odoo
#
# see following links for details:
# - DO Spaces: https://docs.digitalocean.com/products/spaces/
# - DO Spaces using s3cmd: https://docs.digitalocean.com/products/spaces/reference/s3cmd-usage/
# - s3cmd usage: https://s3tools.org/usage
#
# Written by: Jacob Isreal, Isreal Consulting LLC (www.icllc.cc)
#             jisreal@icllc.cc
#
# Last updated: 09-10-2024

# vars
BACKUP_DIR=/backup
ODOO_DATABASE=ENTER-DB-NAME
ADMIN_PASSWORD=EnTerAdminPwd
CURRENTDATE=`date +"%Y-%m-%d-%H-%M"`

# make entry in log file
echo "${CURRENTDATE} - STARTED backup." >> /root/odoo-backup.log

# create a backup directory if not exists
mkdir -p ${BACKUP_DIR}
cd ${BACKUP_DIR}

# create a backup
curl -X POST \
    -F "master_pwd=${ADMIN_PASSWORD}" \
    -F "name=${ODOO_DATABASE}" \
    -F "backup_format=zip" \
    -o ${BACKUP_DIR}/${ODOO_DATABASE}_${CURRENTDATE}.zip \
    http://localhost:8069/web/database/backup

# delete old backups
find ${BACKUP_DIR} -type f -mtime +7 -name "${ODOO_DATABASE}.*.zip" -delete
CURRENTDATE=`date +"%Y-%m-%d-%H-%M"`
echo "${CURRENTDATE} - Removed backups older than 7 days." >> /root/odoo-backup.log

# sync to DO Spaces on cloud
s3cmd sync /backup/ s3://bucketname/odoo/ --recursive --no-delete-removed
CURRENTDATE=`date +"%Y-%m-%d-%H-%M"`
echo "${CURRENTDATE} - Synced backups to cloud storage." >> /root/odoo-backup.log
echo "${CURRENTDATE} - COMPLETED backup." >> /root/odoo-backup.log
echo "-----" >> /root/odoo-backup.log

