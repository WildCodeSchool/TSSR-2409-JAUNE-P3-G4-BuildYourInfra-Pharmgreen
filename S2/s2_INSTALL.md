# Installation SRVAD1 - Serveur Windows Server 2022 GUI avec les rôles AD-DS, DNS
- Cloner un Template WindowsServer 2022
- Aller dans le Server Manager > `Manage` > `Add roles & features` :
- Choisir `Active Directory Domain Service` ;
- Laisser tous les critères par défaut et laisser la fonctionnalité s'installer (/!\ Ne fermez PAS la fenêtre une fois l'installation terminée) ;
- Cliquer sur `Promote this server to a domain controller` ;
- Choisir d'ajouter une nouvelle forêt : `Add new forest`, que l'on nommera ici `pharmgreen.lan` ;
- Laisser par la suite tout le reste par défaut et finalisez l'installation (le serveur nécessitera un redémarrage pour cela) ;

# Installation SRVAD2 - Serveur Windows Server 2022 Core avec le rôle AD-DS
- Cloner un Template WindowsServer 2022 Core
- Depuis la SConfig > `2) Computer name` > Renommer la machine `SRVAD2`+
- Depuis la SConfig > `15) Exit to command line (Powershell)`
``` Powershell
# Ajout de l'adresse IP - le CIDR est en /16 en l'absence de routeur pour atteindre la passerelle par défaut
New-NetIPAddress -IPAddress 10.15.200.2 -PrefixLength 16 -InterfaceIndex (Get-NetAdapter).ifIndex -DefaultGateway 10.15.255.254

# Ajout de l'adresse du serveur DNS
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses ("10.15.200.1")
# Ajout du rôle Active Directory
Add-WindowsFeature -Name "RSAT-AD-Tools" -IncludeManagementTools -IncludeAllSubFeature
Add-WindowsFeature -Name "AD-Domain-Services" -IncludeManagementTools -IncludeAllSubFeature

```
- Ajout du serveur au domaine pharmgreen.lan :
	-  Depuis la SConfig > `1) Domain/workgroup`
``` Powershell
D				# Pour entrer dans un domaine
pharmgreen.lan			# Entrer le nom du domaine à rejoindre
pharmgreen.lan\Administrator	# Entrer un compte du domaine autorisé à nous y ajouter
```
- Rentrer le mot de passe administrateur, la machine rejoint le domaine et redémarrer la machine.

- Depuis la SConfig > `15) Exit to command line (Powershell)`
``` Powershell
# Promotion en tant que contrôleur de domaine
Install-ADDSDomainController -CreateDnsDelegation:$false -DatabasePath 'C:\Windows\NTDS' -DomainName 'pharmgreen.lan' -SysvolPath 'C:\Windows\SYSVOL' -Credential (Get-Credential "pharmgreen.lan\administrator")

# Désactiver la mise en veille automatique
powercfg.exe /hibernate off
```

- Sur le serveur SRVAD1, en GUI
  - `Server Manager` > `Manage` > `Add Server`
  - "Servers that are in the current domain" > Ajouter `SRVAD2`

---

# Création d'un Conteneur Serveur Linux Debian, Intégration au Domaine et Installation de SSH

## 1. Création du Conteneur

1. **Choisir "Créer un conteneur"** :
   - Sélectionnez l'option pour créer un nouveau conteneur dans votre interface de gestion (probablement Proxmox ou un autre outil).

2. **Configuration de l'ID et du Nom d'hôte** :
   - Attribuez un **ID** unique pour le conteneur (par exemple, `647`).
   - Choisissez un **nom d'hôte** pour le conteneur, par exemple `G4-Debian12-CT`.

3. **Sélection de la Template** :
   - Dans la section **local-templates**, sélectionnez la template **Debian12** (ou la version de Debian souhaitée).

4. **Configuration des ressources** :
   - **Espace disque** : 32 Go.
   - **RAM** : 4 Go.
   - **SWAP** : 1 Go.
   - **Processeur** : 1 cœur CPU.

5. **Configuration du réseau** :
   - **IPv4** : Attribuez une adresse **IP statique**.
   - **IPv6** : Configurez-le en **DHCP**.
   - **Firewall** : Décochez l'option du firewall.

6. **Configuration du DNS** :
   - Dans **Domaine DNS**, entrez `pharmgreen.lan` (ou votre domaine).
   - Dans **Serveur DNS**, entrez l'IP de votre serveur DNS Active Directory.

---

## 2. Rejoindre l'Active Directory

1. **Installer les paquets nécessaires** :
   Pour ajouter la machine au domaine, installez les paquets requis en exécutant la commande suivante :
   ```bash
   sudo apt update && sudo apt install -y realmd libnss-sss libpam-sss sssd sssd-tools adcli samba-common-bin oddjob oddjob-mkhomedir packagekit
   ```

2. **Rejoindre le domaine** :
   Utilisez la commande suivante pour joindre le domaine **pharmgreen.lan** (Vous pouvez remplacer `administrator` par le nom d'un utilisateur ayant les droits nécessaires) :
   ```bash
   sudo realm join -U administrator pharmgreen.lan
   ```

3. **Vérifier l'ajout au domaine** :
   Après avoir exécuté la commande précédente, vérifiez que la machine Debian a bien été ajoutée au domaine en exécutant :
   ```bash
   sudo realm list
   ```
   Vous pouvez également vérifier sur votre serveur Active Directory que Debian a bien été ajouté.

---

## 3. Installation et Configuration de SSH

1. **Installer OpenSSH Server** :
   Pour installer le serveur SSH, exécutez la commande suivante :
   ```bash
   sudo apt install openssh-server
   ```

2. **Vérifier si le serveur SSH est actif** :
   Pour vérifier si le serveur SSH est actif, utilisez la commande :
   ```bash
   sudo systemctl status ssh
   ```
   Si le service n'est pas actif, vous pouvez le démarrer avec :
   ```bash
   sudo systemctl start ssh
   ```

3. **Se connecter via SSH** :
   Pour vous connecter au serveur via SSH, vous pouvez utiliser la commande suivante depuis une autre machine (en remplaçant `<Username>` par un utilisateur du domaine et `<hostname>` par le nom d'hôte ou l'adresse IP de la machine) :
   ```bash
   ssh <Username>@<hostname>
   ```
   Exemple :
   ```bash
   ssh wilder@srvad1.pharmgreen.lan
   ```

---

### Vérifications et Dépannage

- Si vous rencontrez des problèmes de connexion SSH, assurez-vous que le port 22 est ouvert dans le pare-feu (si utilisé) et que l'authentification par mot de passe ou par clé est correctement configurée.
- Si la commande `realm join` échoue, vérifiez que le DNS est correctement configuré et que le serveur Active Directory est accessible depuis la machine Debian.

---

# Installation SRVDHCP - Serveur Windows Server 2022 Core avec le rôle DHCP
- Cloner un template de VM Windows Server 2022 Core
## Paramétrage général de la VM
- Depuis la SConfig > `2) Computer name` > Renommer la machine `SRVDHCP`
- Depuis la SConfig > `15) Exit to command line (Powershell)`
``` Powershell
# Ajout de l'adresse IP - le CIDR est en /16 en l'absence de routeur pour atteindre la passerelle par défaut
New-NetIPAddress -IPAddress 10.15.200.10 -PrefixLength 16 -InterfaceIndex (Get-NetAdapter).ifIndex -DefaultGateway 10.15.255.254

# Ajout de l'adresse du serveur DNS
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses ("10.15.200.1")
```
- Ajout du serveur au domaine pharmgreen.lan :
	-  Depuis la SConfig > `1) Domain/workgroup`
``` Powershell
D				# Pour entrer dans un domaine
pharmgreen.lan			# Entrer le nom du domaine à rejoindre
pharmgreen.lan\Administrator	# Entrer un compte du domaine autorisé à nous y ajouter
```
- Rentrer le mot de passe administrateur, la machine rejoint le domaine et redémarrer la machine.


## Installation du service DHCP
- Depuis la SConfig > `15) Exit to command line (Powershell)`
- Entrer les lignes de code suivantes :
``` Powershell
	Install-WindowsFeature DHCP -IncludeManagementTools
	Add-DhcpServerInDC -DnsName srvdhcp.pharmgreen.lan -IPAddress 10.15.200.10
	Get-DhcpServerInDC	# pour vérifier que notre serveur apparaît bien comme Serveur DHCP du domaine
```
- Sur le serveur SRVAD1, en GUI
  - `Server Manager` > `Manage` > `Add Server`
  - "Servers that are in the current domain" > Ajouter `SRVDHCP`
