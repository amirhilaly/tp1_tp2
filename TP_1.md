## Amir HILALY

# Partie I - Prérequis

### A - Choix de l'algorithme de chiffrement
**🌞 Déterminer quel algorithme de chiffrement utiliser pour vos clés**

Bon, p'tite recherche sur Google très rapide, et paf je trouve:


> *"Utiliser une paire de clés forte (ed25519 ou RSA ≥ 4096) L'ANSSI recommande d'utiliser ed25519, ou à défaut, RSA 4096 bits. Le -a 100 renforce la dérivation de la clé privée, donc plus de sécurité côté brute force. Et évidemment, protège ta clé privée avec une passphrase solide.5 sept. 2025"*
(https://ninjalinux.com/2025/09/05/durcir-la-configuration-ssh-avec-les-bonnes-pratiques-anssi/)

En gros c'est un chiffrement comme RSA, mais en plus rapide, et mieux quoi nan ? C'est ce que à l'air de dire IBM (https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys&locale=fr&interface=ui), je cherche un peu plus, pour pas citer Reddit, je trouve ca paf:

```
Il est également intéressant de préciser qu’ED25519 est résistant à certaines attaques quantiques, contrairement à RSA, même si le vrai “quantum-proof” n’existe pas encore.
```
(https://www.ethersys.fr/actualites/20241022-quelle-cle-ssh-generer/)

Ok, c'est plus sécu, donc je prends, et c'est plus rapide, et c'est aussi pourquoi RSA commence à être déconseillé pour les clés SSH.


### Génération de votre paire de clés

**🌞 Générer une paire de clés pour ce TP**

```
[amir@bomboclat ~]$ ssh-keygen -t ed25519 -a 100
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/amir/.ssh/id_ed25519): /home/amir/.ssh/cloud_tp
/home/amir/.ssh/cloud_tp already exists.
Overwrite (y/n)? y
Enter passphrase for "/home/amir/.ssh/cloud_tp" (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/amir/.ssh/cloud_tp
Your public key has been saved in /home/amir/.ssh/cloud_tp.pub

[amir@bomboclat ~]$ ls /home/amir/.ssh/
cloud_tp  cloud_tp.pub  id_rsa  id_rsa.pub  known_hosts  known_hosts.old
```

> *Le -a 100 renforce la dérivation de la clé privée, donc elle est plus sécu contre le brute force, et oui overwrite car ma première commande avait pas la p'tite option*

**🌞 Configurer un agent SSH sur votre poste**

```
[amir@bomboclat JeReflechis]$ ssh-add ~/.ssh/cloud_tp
Enter passphrase for /home/amir/.ssh/cloud_tp: 
Identity added: /home/amir/.ssh/cloud_tp (amir@bomboclat)
```

# Partie II - Spawn des VMs
### 1 - WebUI

**🌞 Connectez-vous en SSH à la VM pour preuve**

```
[amir@bomboclat JeReflechis]$ ssh 20.199.16.137
The authenticity of host '20.199.16.137 (20.199.16.137)' can't be established.
ED25519 key fingerprint is: SHA256:PmBQGj29uEmncJ9NnycdxiL0++4aPqU6AXpHRDIjGc8
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '20.199.16.137' (ED25519) to the list of known hosts.
Welcome to Ubuntu 24.04.3 LTS (GNU/Linux 6.14.0-1012-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Wed Oct 29 09:53:40 UTC 2025

  System load:  0.35              Processes:             116
  Usage of /:   5.6% of 28.02GB   Users logged in:       0
  Memory usage: 29%               IPv4 address for eth0: 172.17.0.4
  Swap usage:   0%

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

amir@IncroyableVMV2:~$ 
```

### 2 - az : a programmatic approach
**🌞 Créez une VM depuis le Azure CLI : azure1.tp1**

```
[amir@bomboclat JeReflechis]$ az vm create --resource-group "SuperVMGroup" --name "azure1.tp1" --admin-username "amir" --size Standard_B1s --image Ubuntu2404 --ssh-key-value ~/.ssh/cloud_tp.pub
The default value of '--size' will be changed to 'Standard_D2s_v5' from 'Standard_DS1_v2' in a future release.
Selecting "northeurope" may reduce your costs. The region you've selected may cost more for the same services. You can disable this message in the future with the command "az config set core.display_region_identified=false". Learn more at https://go.microsoft.com/fwlink/?linkid=222571 

{
  "fqdns": "",
  "id": "/subscriptions/90e6ab35-a4f8-4e6a-bb3f-d5fe0549d3f9/resourceGroups/SuperVMGroup/providers/Microsoft.Compute/virtualMachines/azure1.tp1",
  "location": "francecentral",
  "macAddress": "7C-ED-8D-84-9B-98",
  "powerState": "VM running",
  "privateIpAddress": "10.0.0.4",
  "publicIpAddress": "COOKIE{NiqueDB1}",
  "resourceGroup": "SuperVMGroup"
}
```


**🌞 Assurez-vous que vous pouvez vous connecter à la VM en SSH sur son IP publique**

```
[amir@bomboclat JeReflechis]$ ssh 4.211.168.87
Welcome to Ubuntu 24.04.3 LTS (GNU/Linux 6.14.0-1012-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Wed Oct 29 10:34:03 UTC 2025

  System load:  0.01              Processes:             113
  Usage of /:   5.7% of 28.02GB   Users logged in:       0
  Memory usage: 31%               IPv4 address for eth0: 10.0.0.4
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update

Last login: Wed Oct 29 10:31:14 2025 from 159.117.224.27
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

amir@azure1:~$ exit
```

**🌞 Une fois connecté, prouvez la présence...**

- ...du service walinuxagent.service

```
amir@azure1:~$ systemctl status walinuxagent.service | head -n 12
● walinuxagent.service - Azure Linux Agent
     Loaded: loaded (/usr/lib/systemd/system/walinuxagent.service; enabled; preset: enabled)
    Drop-In: /run/systemd/system.control/walinuxagent.service.d
             └─50-CPUAccounting.conf, 50-MemoryAccounting.conf
     Active: active (running) since Wed 2025-10-29 10:28:03 UTC; 8min ago
   Main PID: 1063 (python3)
      Tasks: 7 (limit: 993)
     Memory: 53.4M (peak: 54.9M)
        CPU: 2.669s
     CGroup: /azure.slice/walinuxagent.service
             ├─1063 /usr/bin/python3 -u /usr/sbin/waagent -daemon
             └─1563 /usr/bin/python3 -u bin/WALinuxAgent-2.15.0.1-py3.12.egg -run-exthandlers
```

- ...du service cloud-init.service

```
amir@azure1:~$ systemctl status cloud-init.service | head -n 5
● cloud-init.service - Cloud-init: Network Stage
     Loaded: loaded (/usr/lib/systemd/system/cloud-init.service; enabled; preset: enabled)
     Active: active (exited) since Wed 2025-10-29 10:28:02 UTC; 10min ago
   Main PID: 734 (code=exited, status=0/SUCCESS)
        CPU: 879ms
```

### 3 - Spawn moar moar moaaar VMs

## A - Another VM another friend :d

**🌞 Créez une deuxième VM : azure2.tp1**

```
[amir@bomboclat JeReflechis]$ az vm create --resource-group "SuperVMGroup" --name "azure2.tp1" --admin-username "amir" --size Standard_B1s --image Ubuntu2404 --ssh-key-value ~/.ssh/cloud_tp.pub --public-ip-address ""

{
  "fqdns": "",
  "id": "/subscriptions/90e6ab35-a4f8-4e6a-bb3f-d5fe0549d3f9/resourceGroups/SuperVMGroup/providers/Microsoft.Compute/virtualMachines/azure2.tp1",
  "location": "francecentral",
  "macAddress": "00-22-48-3A-BC-0D",
  "powerState": "VM running",
  "privateIpAddress": "10.0.0.5",
  "publicIpAddress": "",
  "resourceGroup": "SuperVMGroup"
}
```

**🌞 Affichez des infos au sujet de vos deux VMs**

```
[amir@bomboclat JeReflechis]$ az vm list-ip-addresses
[
  {
    "virtualMachine": {
      "name": "azure1.tp1",
      "network": {
        "privateIpAddresses": [
          "10.0.0.4"
        ],
        "publicIpAddresses": [
          {
            "id": "/subscriptions/90e6ab35-a4f8-4e6a-bb3f-d5fe0549d3f9/resourceGroups/SuperVMGroup/providers/Microsoft.Network/publicIPAddresses/azure1.tp1PublicIP",
            "ipAddress": "4.211.XXX.XX",
            "ipAllocationMethod": "Static",
            "name": "azure1.tp1PublicIP",
            "resourceGroup": "SuperVMGroup",
            "zone": null
          }
        ]
      },
      "resourceGroup": "SuperVMGroup"
    }
  },
  {
    "virtualMachine": {
      "name": "azure2.tp1",
      "network": {[amir@bomboclat JeReflechis]$ az ssh config --file ./ssh_config --resource-group SuperVMGroup --name azure1.tp1
Generated SSH certificate /home/amir/Desktop/cours/JeReflechis/az_ssh_config/SuperVMGroup-azure1.tp1/id_rsa.pub-aadcert.pub is valid until 2025-10-29 01:15:14 PM in local time.
/home/amir/Desktop/cours/JeReflechis/az_ssh_config/SuperVMGroup-azure1.tp1 contains sensitive information (id_rsa, id_rsa.pub, id_rsa.pub-aadcert.pub). Please delete it once you no longer need this config file.
[amir@bomboclat JeReflechis]$ az ssh config --file ./ssh_config --resource-group SuperVMGroup --name azure2.tp1
No public IP detected, attempting private IP (you must bring your own connectivity).
Use --prefer-private-ip to avoid this message.
Generated SSH certificate /home/amir/Desktop/cours/JeReflechis/az_ssh_config/SuperVMGroup-azure2.tp1/id_rsa.pub-aadcert.pub is valid until 2025-10-29 01:15:47 PM in local time.
/home/amir/Desktop/cours/JeReflechis/az_ssh_config/SuperVMGroup-azure2.tp1 contains sensitive information (id_rsa, id_rsa.pub, id_rsa.pub-aadcert.pub). Please delete it once you no longer need this config file.
        "privateIpAddresses": [
          "10.0.0.5"
        ],
        "publicIpAddresses": []
      },
      "resourceGroup": "SuperVMGroup"
    }
  }
]
```

## B - Config SSH client
** **

```
[amir@bomboclat .ssh]$ ssh az1
Welcome to Ubuntu 24.04.3 LTS (GNU/Linux 6.14.0-1012-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Wed Oct 29 10:35:26 UTC 2025

  System load:  0.0               Processes:             113
  Usage of /:   5.7% of 28.02GB   Users logged in:       0
  Memory usage: 31%               IPv4 address for eth0: 10.0.0.4
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update

Last login: Wed Oct 29 10:35:26 2025 from 159.117.224.27
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

amir@azure1:~$ exit
[amir@bomboclat .ssh]$ ssh az2
The authenticity of host '10.0.0.5 (<no hostip for proxy command>)' can't be established.
ED25519 key fingerprint is: SHA256:sKI1PTz5bvdz+qNHvSSOMLyyUFGq5Dj4pTkq8S/Fmdc
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.0.0.5' (ED25519) to the list of known hosts.
Welcome to Ubuntu 24.04.3 LTS (GNU/Linux 6.14.0-1012-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Wed Oct  1 04:15:08 UTC 2025

  System load:    1.15      Processes:             23
  Usage of /home: unknown   Users logged in:       0
  Memory usage:   5%        IPv4 address for eth0: 10.10.10.2
  Swap usage:     0%

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

amir@azure2:~$
```

Et mon fichier de conf:

```
[amir@bomboclat .ssh]$ cat config
Host az1
    HostName 4.211.168.87
    User amir
    Port 22
    ForwardAgent yes

Host az2
    HostName 10.0.0.5
    User amir
    Port 22
    ProxyJump az1
```



**🌞 Installer MySQL/MariaDB sur azure2.tp1**

```
amir@azure2:~$ mysql --version
mysql  Ver 8.0.43-0ubuntu0.24.04.2 for Linux on x86_64 ((Ubuntu))
```

**🌞 Démarrer le service MySQL/MariaDB sur azure2.tp1**
```
amir@azure2:~$ sudo systemctl start mysql.service
amir@azure2:~$ systemctl status mysql.service | head -12
● mysql.service - MySQL Community Server
     Loaded: loaded (/usr/lib/systemd/system/mysql.service; enabled; preset: enabled)
     Active: active (running) since Wed 2025-10-29 11:47:57 UTC; 6min ago
    Process: 2230 ExecStartPre=/usr/share/mysql/mysql-systemd-start pre (code=exited, status=0/SUCCESS)
   Main PID: 2239 (mysqld)
     Status: "Server is operational"
      Tasks: 37 (limit: 993)
     Memory: 369.2M (peak: 371.2M)
        CPU: 3.289s
     CGroup: /system.slice/mysql.service
             └─2239 /usr/sbin/mysqld
```

**🌞 Ajouter un utilisateur dans la base de données pour que mon app puisse s'y connecter**

```
mysql> create database database_meow;
Query OK, 1 row affected (0.03 sec)

mysql> create user 'meow'@'%' identified by 'meow';
Query OK, 0 rows affected (0.04 sec)

mysql> grant all privileges on * . * TO 'meow'@'%';
Query OK, 0 rows affected (0.01 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.01 sec)

```

### A. Récupération de l'application sur la machine

**🌞 Ouvrez un port firewall si nécessaire**

```
amir@azure2:~$ sudo ss -lntp | head -4
State  Recv-Q Send-Q Local Address:Port  Peer Address:PortProcess                                                
LISTEN 0      4096      127.0.0.54:53         0.0.0.0:*    users:(("systemd-resolve",pid=487,fd=17))             
LISTEN 0      70         127.0.0.1:33060      0.0.0.0:*    users:(("mysqld",pid=1366,fd=21))                     
LISTEN 0      151          0.0.0.0:3306       0.0.0.0:*    users:(("mysqld",pid=1366,fd=23))    
```

J'ouvre le 3306.


**🌞 Récupération de l'application sur la machine**

```
amir@azure1:~$ git clone https://gitlab.com/it4lik/b2-pano-cloud-2025.git
Cloning into 'b2-pano-cloud-2025'...
remote: Enumerating objects: 297, done.
remote: Counting objects: 100% (217/217), done.
remote: Compressing objects: 100% (214/214), done.
remote: Total 297 (delta 96), reused 0 (delta 0), pack-reused 80 (from 1)
Receiving objects: 100% (297/297), 7.92 MiB | 24.08 MiB/s, done.
Resolving deltas: 100% (119/119), done.
amir@azure1:/opt$ sudo mv /home/amir/b2-pano-cloud-2025/ /opt/meow/
amir@azure1:/opt$ ls
meow
```

### B - Installation des dépendances de l'application

**🌞 Installation des dépendances de l'application**

```
(venv) amir@azure1:/opt/meow/app$ pip install -r requirements.txt
...(j'envoie pas tout c'est long)...
Downloading pycparser-2.23-py3-none-any.whl (118 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 118.1/118.1 kB 8.3 MB/s eta 0:00:00
Installing collected packages: typing-extensions, python-dotenv, PyMySQL, pycparser, markupsafe, itsdangerous, greenlet, click, blinker, werkzeug, sqlalchemy, jinja2, cffi, Flask, cryptography, Flask-SQLAlchemy
Successfully installed Flask-3.1.2 Flask-SQLAlchemy-3.1.1 PyMySQL-1.1.2 blinker-1.9.0 cffi-2.0.0 click-8.3.0 cryptography-46.0.3 greenlet-3.2.4 itsdangerous-2.2.0 jinja2-3.1.6 markupsafe-3.0.3 pycparser-2.23 python-dotenv-1.2.1 sqlalchemy-2.0.44 typing-extensions-4.15.0 werkzeug-3.1.3
(venv) amir@azure1:/opt/meow/app$ 
```

### C - Configuration de l'application
**🌞 Configuration de l'application**

```
(venv) amir@azure1:/opt/meow/app$ cat .env
# Flask Configuration
FLASK_SECRET_KEY=COOKIE{noJWTchall?}
FLASK_DEBUG=False
FLASK_HOST=0.0.0.0
FLASK_PORT=8000

# Database Configuration
DB_HOST=10.0.0.5
DB_PORT=3306
DB_NAME=(chépa pour une sqli c'mieux de pas drop le nom de la db, hé, on sait pas)
DB_USER=not giving you
DB_PASSWORD=#### (on fait genre tu sais pas)
```


### D - Gestion de users et de droits
**🌞 Gestion de users et de droits**
```
(venv) amir@azure1:/opt/meow/app$ sudo useradd webapp --no-create-home --password meow
(venv) amir@azure1:/opt$ ls -la
total 12
drwxr-xr-x  3 root   root   4096 Oct 29 18:38 .
drwxr-xr-x 22 root   root   4096 Oct 29 17:38 ..
drwxr-xr-x  3 webapp webapp 4096 Oct 29 18:38 meow
(venv) amir@azure1:/opt$ 
```

### E - Création d'un service webapp.service pour lancer l'application

**🌞 Création d'un service webapp.service pour lancer l'application**

```
(venv) amir@azure1:/opt$ sudo nano /etc/systemd/system/webapp.service
(venv) amir@azure1:/opt$ sudo systemctl daemon-reload
```

### F - Ouverture du port dans le(s) firewall(s)

**🌞 Ouverture du port80 dans le(s) firewall(s)**

```
amir@azure1:/opt/meow/app$ sudo ss -lnpt | head -2
State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess                                                 
LISTEN 0      128          0.0.0.0:8000      0.0.0.0:*    users:(("python3",pid=5431,fd=4))
```

### 3 - Visitez l'application

**🌞 L'application devrait être fonctionnelle sans soucis à partir de là**

```
amir@azure2:~$ curl -s http://4.211.168.87:8000/messages | jq
[
  {
    "content": "COOKIE{lastone}",
    "id": 2,
    "timestamp": "2025-10-29 19:54:01",
    "username": "Gros Chat"
  },
  {
    "content": "hjyh",
    "id": 1,
    "timestamp": "2025-10-29 19:52:25",
    "username": "yo"
  }
]
amir@azure2:~$ 
```


# BONUS 1: and thus bash said 'ez VM'

J'ai mis le script dans un fichier, deploy.sh, que je remet la:


# BONUSS 2: Service hardening

```
amir@azure1:~$ sudo systemd-analyze security webapp.service | head -10
  NAME                                                        DESCRIPTION                                                             EXPOSURE
✗ RemoveIPC=                                                  Service user may leave SysV IPC objects around                               0.1
✗ RootDirectory=/RootImage=                                   Service runs within the host's root directory                                0.1
✓ User=/DynamicUser=                                          Service runs under a static non-root user identity                      
✗ CapabilityBoundingSet=~CAP_SYS_TIME                         Service processes may change the system clock                                0.2
✗ NoNewPrivileges=                                            Service processes may acquire new privileges                                 0.2
✓ AmbientCapabilities=                                        Service process does not receive ambient capabilities                   
✗ PrivateDevices=                                             Service potentially has access to hardware devices                           0.2
✗ ProtectClock=                                               Service may write to the hardware clock or system clock                      0.2
✗ CapabilityBoundingSet=~CAP_SYS_PACCT                        Service may use acct()                                                       0.1
```

Bon, la liste est longue, mais la la, y'en a un qui tappe dans l'oeil quand même, "NoNewPrivileges" ?

```
amir@azure1:~$ sudo systemd-analyze security webapp.service | grep "privilege" | head -1
✗ NoNewPrivileges=                                            Service processes may acquire new privileges                                 0.2
```

Pas mal non ? 

> *"The property NoNewPrivileges is a systemd unit setting used for sandboxing. It is available since systemd 187. Purpose: prevent processes from gaining new privileges*"
(https://linux-audit.com/systemd/settings/units/nonewprivileges/)

Stylé, bah je veux ! J't'épargne le reste de mes recherches, j'ai piqué sur ca quand même:

```
amir@azure1:~$ sudo systemd-analyze security webapp.service | grep "Protect"
✗ ProtectClock=                                               Service may write to the hardware clock or system clock                      0.2
✗ ProtectKernelLogs=                                          Service may read from or write to the kernel log ring buffer                 0.2
✗ ProtectControlGroups=                                       Service may modify the control group file system                             0.2
✗ ProtectKernelModules=                                       Service may load or read kernel modules                                      0.2
✗ ProtectHostname=                                            Service may change system host/domainname                                    0.1
✗ ProtectKernelTunables=                                      Service may alter kernel tunables                                            0.2
✗ ProtectSystem=                                              Service has full access to the OS file hierarchy                             0.2
✗ ProtectProc=                                                Service has full access to process tree (/proc hidepid=)                     0.2
✗ ProtectHome=                                                Service has full access to home directories                                  0.2
```

T'as vu, je grep protect, trop mimi...

Aller paf, on rajoute tout ça à la conf ! :

```
amir@azure1:~$ cat /etc/systemd/system/webapp.service 
[Unit]
Description=Super Webapp MEOW

[Service]
User=webapp
WorkingDirectory=/opt/meow/app
ExecStartPre=/usr/local/bin/get_secrets.sh
ExecStart=/opt/meow/app/venv/bin/python3 app.py
ProtectClock=yes
ProtectKernelLogs=yes
ProtectControlGroups=yes
ProtectKernelModules=yes
ProtectHostname=yes
ProtectKernelTunables=yes
ProtectSystem=strict
ProtectHome=yes

[Install]
WantedBy=multi-user.target
```