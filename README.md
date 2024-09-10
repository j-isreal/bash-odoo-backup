# bash-odoo-backup
BASH script to backup the Odoo database and filestore locally **and** to cloud storage

**More Info on Odoo**

Odoo is an awesome ERP / Accounting / CRM platform! 

I use the community edition (open-source, self-hosted) nightly version (17.0) from their community nightly build on an Ubuntu server with Postgresql 16 and Nginx.

For more info: https://www.odoo.com/page/download
<br/><br/><br/>
## 1. Setup s3cmd and cloud storage space
**FIRST**, either comment out the ```s3cmd``` lines, or setup s3cmd.

s3cmd is available from the linux repositories.  You can use any AWS (Amazon)-compatible cloud storage service.

I prefer DigitalOcean Spaces - it's only $5.00 a month for 250GB of storage.

Here's a $250 credit with them:

[![DigitalOcean Referral Badge](https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%201.svg)](https://www.digitalocean.com/?refcode=7774aa9a2bfa&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

### 1a. Ensure your s3cfg is configured and you can access the cloud storage
You will need your API key and secret to configure s3cmd.

Visit [DigitalOcean](https://docs.digitalocean.com/products/spaces/reference/s3cmd/) for complete instructions.


Use the following to setup s3cmd:
```
s3cmd --configure
```


See following links for details:
- DO Spaces: https://docs.digitalocean.com/products/spaces/
- DO Spaces using s3cmd: https://docs.digitalocean.com/products/spaces/reference/s3cmd-usage/
- s3cmd usage: https://s3tools.org/usage

## 2. Update script with Odoo Master Admin password and DB name
Update the script variables at the top with your Odoo Master Admin password and Database name, and backup folder path:
```
BACKUP_DIR=/backup
ODOO_DATABASE=ENTER-DB-NAME
ADMIN_PASSWORD=EnTerAdminPwd
```


## 3. Make executable, set cron for automated backup
Make the file executable with:
```
chmod +x backup-odoo.sh
```

Then you can run the script with:
```
./backup-odoo.sh
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
https://www.jinet.us/dev/scripts/bash-s3cmd-backup-odoo/
<br /><br />
Copyright &copy; 2024 Jacob Eiler, Isreal Consulting, LLC.  All rights reserved.

