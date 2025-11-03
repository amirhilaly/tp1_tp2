#!/bin/bash

sudo mysqldump -u backup -pmeow database_meow > db_backup.sql
sudo tar -czf db_backup.tar.gz db_backup.sql
sudo az storage blob upload --account-name ultrasupermeow --container-name blobcontainer --file db_backup.tar.gz --name sql_backup --auth-mode login --overwrite

rm db_backup.sql db_backup.tar.gz
