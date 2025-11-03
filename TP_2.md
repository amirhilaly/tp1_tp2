# I - Un p'tit nom DNS

**🌞 Prouvez que c'est effectif**

```
amir@azure1:/opt/meow/app$ curl http://ultrameow.francecentral.cloudapp.azure.com:8000/ | head -12
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Purr Messages - Cat Message Board</title>
    <style>
        /* Modern CSS with cat-themed design */
        :root {
            --primary: #ff6b6b;
            --secondary: #4ecdc4;
            --accent: #ffd166;
```

# II - Cloud-init

## 2 - Gooooo

**🌞 Tester cloud-init**

vm create --name azurePUTAIN --resource-group SuperVMGroup --size Standard_B1s --image Ubuntu2404 --custom-data cloud-init.txt --ssh-key-values ~/.

{
  "fqdns": "",
  "id": "",
  "location": "francecentral",
  "macAddress": "7C-ED-8D-84-34-73",
  "powerState": "VM running",
  "privateIpAddress": "10.0.0.6",
  "publicIpAddress": "nonc",
  "resourceGroup": "SuperVMGroup"
}

**🌞 Vérifier que cloud-init a bien fonctionné**

```
user2@azurePUTAIN:~$ sudo systemctl status cloud-init | head -5
● cloud-init.service - Cloud-init: Network Stage
     Loaded: loaded (/usr/lib/systemd/system/cloud-init.service; enabled; preset: enabled)
     Active: active (exited) since Thu 2025-10-30 11:05:18 UTC; 9min ago
   Main PID: 739 (code=exited, status=0/SUCCESS)
        CPU: 1.882s
user2@azurePUTAIN:~$ cloud-init status
status: done
user2@azurePUTAIN:~$ ls -al /var/log/cloud-init*
-rw-r----- 1 root   adm   4431 Oct 30 11:05 /var/log/cloud-init-output.log
-rw-r----- 1 syslog adm 159175 Oct 30 11:05 /var/log/cloud-init.log


```

## 3 - Write your own

**🌞 Utilisez cloud-init pour préconfigurer une VM comme azure2.tp2 :**

```
[amir@bomboclat ~]$ cat cloud-init.txt 
#cloud-config
users:
  - default
  - name: amir
    passwd: $6$IMUzQKxah/2AHPT9$yN2mOgYszhlQucdudKXKzEBVkfqj1rGOWe9BdKiyubiPG5Q9Czu6TyATypHSVE85z7Jet4MhkujLM7wJKz7Xh/
    sudo: true
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIFV1GoB8kW4wcgCn17FPi4kVibHrxr3apmaYxfp+9xI amir@bomboclat

package_update: true
packages:
 - mysql-server

write_files:
  - owner: root:root
    path: /root
    defer: true
    content: |
      CREATE DATABASE meow_database;
      CREATE USER 'meow'@'%' IDENTIFIED BY 'meow';
      ALTER USER 'meow' IDENTIFIED BY 'meow';
      GRANT ALL ON meow_database.* TO 'meow'@'%';
      FLUSH PRIVILEGES;

runcmd:
  - systemctl start mysql
  - until mysqladmin ping --silent; do sleep 1; done
  - mysql -u root < /root/init.sql
  - systemctl restart mysql
```

**🌞 Testez que ça fonctionne**

```
[amir@bomboclat ~]$ az vm create --name azurePUTAIN --resource-group SuperVMGroup --size Standard_B1s --image Ubuntu2404 --custom-data cloud-init.txt --ssh-key-values .ssh/cloud_tp.pub
The default value of '--size' will be changed to 'Standard_D2s_v5' from 'Standard_DS1_v2' in a future release.
Selecting "northeurope" may reduce your costs. The region you've selected may cost more for the same services. You can disable this message in the future with the command "az config set core.display_region_identified=false". Learn more at https://go.microsoft.com/fwlink/?linkid=222571 

{
  "fqdns": "",
  "id": "/subscriptions/90e6ab35-a4f8-4e6a-bb3f-d5fe0549d3f9/resourceGroups/SuperVMGroup/providers/Microsoft.Compute/virtualMachines/azurePUTAIN",
  "location": "francecentral",
  "macAddress": "x",
  "powerState": "VM running",
  "privateIpAddress": "10.0.0.6",
  "publicIpAddress": "x",
  "resourceGroup": "SuperVMGroup"
}
[amir@bomboclat ~]$ ssh amir@4.211.250.3
The authenticity of host '4.211.250.3 (4.211.250.3)' can't be established.
ED25519 key fingerprint is: SHA256:DuidgmUpOH42MB4lejxQQi64MMeb1eDj4zdRO62pLcI
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '4.211.250.3' (ED25519) to the list of known hosts.
Welcome to Ubuntu 24.04.3 LTS (GNU/Linux 6.14.0-1012-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Mon Nov  3 18:36:24 UTC 2025

  System load:  0.32              Processes:             117
  Usage of /:   8.4% of 28.02GB   Users logged in:       0
  Memory usage: 70%               IPv4 address for eth0: 10.0.0.6
  Swap usage:   0%

Expanded Security Maintenance for Applications is not enabled.

36 updates can be applied immediately.
21 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

amir@azurePUTAIN:~$ mysql
ERROR 1045 (28000): Access denied for user 'amir'@'localhost' (using password: NO)
amir@azurePUTAIN:~$ sudo mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 8.0.43-0ubuntu0.24.04.2 (Ubuntu)

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.01 sec)

mysql> 

```


# III - Gestion des secrets

## 1 - Un premier secret

**🌞 Récupérer votre secret depuis la VM**

```
user2@azurePUTAIN:~$ az login --identity --allow-no-subscriptions
[
  {
    "environmentName": "AzureCloud",
    "homeTenantId": "",
    "id": "",
    "isDefault": true,
    "managedByTenants": [],
    "name": "Azure for Students",
    "state": "Enabled",
    "tenantId": "",
    "user": {
      "assignedIdentityInfo": "MSI",
      "name": "systemAssignedIdentity",
      "type": "servicePrincipal"
    }
  }
]

user2@azurePUTAIN:~$ az keyvault secret show   --vault-name SuperKeyV   --name meow
{
  "attributes": {
    "created": "2025-11-02T15:32:29+00:00",
    "enabled": true,
    "expires": null,
    "notBefore": null,
    "recoverableDays": 90,
    "recoveryLevel": "Recoverable+Purgeable",
    "updated": "2025-11-02T15:32:29+00:00"
  },
  "contentType": null,
  "id": "non, même si tu peux rien faire avec, c non",
  "kid": null,
  "managed": null,
  "name": "non j'te jure c vrm un truc de fous le nom, tu devineras jamais",
  "tags": {},
  "value": "deso mec c privé"
}

```


**🌞 Coder un ptit script bash : get_secrets.sh**
```
#!/bin/bash

az login --identity --allow-no-subscriptions 1>/dev/null

DB_PASSWORD=$(az keyvault secret show   --vault-name SuperKeyV   --name DBPASSWORD --query "value" | sed 's/"//g')

sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/g" /opt/meow/app/.env
```

**🌞 Environnement du script get_secrets.sh, il doit :**

```
amir@azure1:/usr/local/bin$ ls -la
total 12
drwxr-xr-x  2 root   root   4096 Nov  2 17:47 .
drwxr-xr-x 10 root   root   4096 Oct  1 04:13 ..
-rwx------  1 webapp webapp  260 Nov  2 17:41 get_secrets.sh
```

### B - Exécution automatique

**🌞 Ajouter le script en ExecStartPre= dans webapp.service**

```
amir@azure1:/usr/local/bin$ cat /etc/systemd/system/webapp.service | grep "ExecStartPre" 
ExecStartPre=/usr/local/bin/get_secrets.sh
```


**🌞 Prouvez que la ligne en ExecStartPre= a bien été exécutée**
```
amir@azure1:/usr/local/bin$ sudo systemctl status webapp | head -4
● webapp.service - Super Webapp MEOW
     Loaded: loaded (/etc/systemd/system/webapp.service; enabled; preset: enabled)
     Active: active (running) since Sun 2025-11-02 18:10:10 UTC; 3min 12s ago
    Process: 3983 ExecStartPre=/usr/local/bin/get_secrets.sh (code=exited, status=0/SUCCESS)
```

### C - Secret Flask

**🌞 Intégrez la gestion du secret Flask dans votre script get_secrets.sh**

```
mir@azure1:/usr/local/bin$ sudo nano get_secrets.sh 
amir@azure1:/usr/local/bin$ sudo ./get_secrets.sh
amir@azure1:/usr/local/bin$ sudo cat /opt/meow/app/.env | head -2
# Flask Configuration
FLASK_SECRET_KEY=meow
```

**🌞 Redémarrer le service**

```
amir@azure1:/usr/local/bin$ sudo systemctl status webapp | head -4
● webapp.service - Super Webapp MEOW
     Loaded: loaded (/etc/systemd/system/webapp.service; enabled; preset: enabled)
     Active: active (running) since Sun 2025-11-02 18:21:18 UTC; 39s ago
    Process: 4267 ExecStartPre=/usr/local/bin/get_secrets.sh (code=exited, status=0/SUCCESS)
```


**🌞 Upload un fichier dans le Blob Container depuis azure2.tp2**

```
amir@azure2:~$ az storage blob upload \
  --account-name ultrasupermeow \
  --container-name blobcontainer \
  --name meow.txt \
  --file /tmp/meow.txt \
  --auth-mode login
Finished[#############################################################]  100.0000%
```

**🌞 Download un fichier du Blob Container**

## 1 - Un premier ptit blobz

(J'l'ai téléchargé 'vec la webui, ca prend deux clics, rapide)

```
amir@azure2:~$ echo "meow" > /tmp/meow.txt
amir@azure2:~$ az storage blob upload \
  --account-name ultrasupermeow \
  --container-name blobcontainer \
  --name meow.txt \
  --file /tmp/meow.txt \
  --auth-mode login
Finished[#############################################################]  100.0000%

amir@azure2:~$ exit
logout
Connection to 10.0.0.5 closed.
[amir@bomboclat ~]$ ls -la Downloads/meow.txt 
-rw-r--r-- 1 amir amir 5 Nov  2 21:21 Downloads/meow.txt
[amir@bomboclat ~]$ 
```

## 2 - Haïssez-moi (abuse)

## A - Intro

**🌞 Créer un ptit user SQL pour notre script**

```
mysql> create user 'backup'@'%' identified by 'meow';
Query OK, 0 rows affected (0.09 sec)

mysql> grant all privileges on * . * to 'backup'@'%';
Query OK, 0 rows affected (0.02 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.01 sec)
```

comment ca j'suis un flemmard?

oui bah aller stv

```
mysql> drop user 'backup'@'%';
Query OK, 0 rows affected (0.62 sec)

mysql> je drop car jsp si je change ses perms apres lui avoir tout give il va pas garder les perms....
    -> ^C
mysql> create user 'backup'@'%' identified by 'meow';
Query OK, 0 rows affected (0.47 sec)

mysql> grant select, show view, process, lock tables on * . * to 'backup'@'%';
Query OK, 0 rows affected (0.60 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.01 sec)
```

**🌞 Tester que vous pouvez vous connecter avec cet utilisateur**

```
amir@azure2:~$ mysql -u backup -h localhost -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.43-0ubuntu0.24.04.2 (Ubuntu)

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```

**🌞 Ecrire le script db_backup.sh**

```
#!/bin/bash

mysqldump -u backup -pmeow database_meow > db_backup.sql
tar -czf db_backup.tar.gz db_backup.sql
az storage blob upload --account-name ultrasupermeow --container-name blobcontainer --file db_backup.tar.gz --name sql_backup --auth-mode login --overwrite

rm db_backup.sql db_backup.tar.gz
```

**🌞 Environnement du script db_backup.sh**

**🌞 Récupérer le blob**

## D - Service

**🌞 Ecrire un fichier /etc/systemd/system/db_backup.service**

```
[Unit]
Description=Super MeowBackup

[Service]
User=backup
Type=oneshot
ExecStart=/usr/local/bin/db_backup.sh

[Install]
WantedBy=multi-user.target
```

## E - Timer

**🌞 Ecrire un fichier /etc/systemd/system/db_backup.timer**
```
[Unit]
Description=Sauvegarde de la DB toutes les 1 min

[Timer]
# Premier lancement 1 minutes après le boot
OnBootSec=1min

# Et ensuite, ça retrigger 1 minutes après que ça soit stopped
OnUnitActiveSec=1min
Unit=db_backup.service

[Install]
WantedBy=timers.target
```

```
amir@azure2:~$ sudo systemctl start db_backup.timer
amir@azure2:~$ sudo systemctl enable db_backup.timer
Created symlink /etc/systemd/system/timers.target.wants/db_backup.timer → /etc/systemd/system/db_backup.timer.
```

(hein, comment ca j'ai créer un faux fichier db_backup qui fais rien juste pour que je puisse lancer ma commande timer et gratter des points, heiiiinnnn?????)

Bon, j'suis pas fier du rendu, c'est nul, c'est fais vite, mais faut bien rendre quequ'chose quoi...