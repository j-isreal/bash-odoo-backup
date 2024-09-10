# bash-odoo-backup
BASH script to backup the Odoo database and files

## Update script with Admin password and DB name
Update the script variables at the top with your Odoo Master Admin password and Database name:
```
BACKUP_DIR=/backup
ODOO_DATABASE=ENTER-DB-NAME
ADMIN_PASSWORD=EnTerAdminPwd
```

## Make sure your s3cfg file is configured, if using offsite backup
Otherwise, comment out the ```s3cmd``` lines in the script.

## Make executable, set cron for automated backup
Make the file executable with:
```
chmod +x backup-odoo.sh
```

For automated backups, set your root cron as such:
```
crontab -e
# For more information see the manual pages of crontab(5) and cron(8)
# 
# m h  dom mon dow   command
30 1 * * * sh /root/backup-odoo.sh
```

Be sure to prepend the script with ```sh ``` as shown above or the script won't work in cron.

<br /><br/>
### View the project page on my website


Copyright &copy; 2024 Jacob Eiler, Isreal Consulting, LLC.  All rights reserved.
