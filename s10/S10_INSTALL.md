# Installation SRVAD1 - Serveur Windows Server 2022 GUI avec les rôles AD-DS, DNS

# Installation SRVAD2 - Serveur Windows Server 2022 Core avec le rôle AD-DS
- Cloner un Template WindowsServer 2022 Core
- Depuis la SConfig > `2) Computer name` > Renommer la machine `SRVAD2`+
- Depuis la SConfig > `15) Exit to command line (Powershell)`
``` Powershell
# Ajout de l'adresse IP - le CIDR est en /16 en l'absence de routeur pour atteindre la passerelle par défaut
New-NetIPAddress -IPAddress 10.15.200.2 -PrefixLength 16 -InterfaceIndex (Get-NetAdapter).ifIndex -DefaultGateway 10.15.255.254

# Ajout de l'adresse du serveur DNS
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses ("127.0.0.1")

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
Install-ADDSDomainController -CreateDnsDelegation:$false -DatabasePath 'C:\Windows\NTDS' -DomainName 'pharmgreen.lan' -SysvolPath 'C:\Windows\SYSVOL'

# Désactiver la mise en veille automatique
powercfg.exe /hibernate off
```

- Sur le serveur SRVAD1, en GUI
  - `Server Manager` > `Manage` > `Add Server`
  - "Servers that are in the current domain" > Ajouter `SRVAD2`

# Installation SRVDHCP - Serveur Windows Server 2022 Core avec le rôle DHCP

# Création d'un CT Serveur Linux Debian
