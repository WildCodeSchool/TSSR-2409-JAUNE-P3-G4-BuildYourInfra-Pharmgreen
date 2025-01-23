# Installation d'un serveur de gestion de mises à jour

## Prérequis
- 1 VM avec Windows Server 2022 installé et à jour.
- Un espace disque de :
  - 32 Go pour le système.
  - 20 Go pour stocker les mises à jour.
- 4 cœurs pour le CPU et 8 Go de RAM.
- Avant l'installation :
  - Renommer le PC en `SRVWSUS`.
  - Configurer l'adresse IP : `10.15.200.60/24`.

## Création de la partition de stockage des mises à jour
- Créer une partition formatée de 20 Go nommée **WSUS** avec la lettre `M:`.
- Sur cette partition, créer un dossier `WSUS`.
- Redémarrer le serveur.

## Installation du rôle WSUS
1. À partir du **Server Manager**, installer le rôle **Windows Server Update Services (WSUS)**.
2. Valider les fonctionnalités supplémentaires ajoutées automatiquement.
3. Sélectionner :
   - **WID Connectivity**
   - **WSUS Service**.
4. Indiquer l'emplacement du stockage des mises à jour : `M:\WSUS`.
5. Terminer l'installation et redémarrer le serveur.

## Configuration du service WSUS
1. Une fois le serveur redémarré, exécuter la tâche **Post Deployment Configuration for WSUS** dans le **Server Manager**.
2. Dans la fenêtre de gauche, cliquer avec le bouton droit sur **Windows Server Update Services**, ce qui lancera l'assistant de configuration.
3. Dans l'assistant :
   - **Décochez** la case `Yes, I would like to join the Microsoft Update Improvement Program`.
   - Laisser sélectionnée la case `Synchronize from Microsoft Update`.
   - Cliquer sur `Start Connecting` et patienter (le processus peut être long).
4. Sélectionner les langues : **English** et **French**.
5. Choisir les produits suivants :
   - Active Directory
   - Microsoft Security Essentials
   - Microsoft Defender Antivirus
   - Microsoft Edge
   - Microsoft Server Operating System 21H2
   - Windows 10 and later drivers
6. Sélectionner les classifications suivantes :
   - Critical Updates
   - Security Updates
7. Configurer la synchronisation :
   - **4 synchronisations par jour** à partir de **2h**.
   - Cocher `Begin initial synchronization` et cliquer sur `Finish`.

### Configuration des règles automatiques
1. Aller dans **Options** → **Automatic Approvals**.
2. Dans l'onglet **Update Rules**, cocher `Default Automatic Approval Rule`.
3. Cliquer sur :
   - `Run Rules`
   - `Apply`
   - `OK`.

## Liaison avec les ordinateurs du domaine
### Configuration sur WSUS
1. Aller dans **Options** → **Computers**.
2. Cocher l'option **Use Group Policy** et valider.
3. Sous **All Computers**, créer 3 groupes via `Add Computer Group` :
   - Domain_Controllers
   - Servers
   - Clients

### Configuration sur un contrôleur de domaine
#### Création d'une GPO pour les mises à jour
1. Dans **Group Policy Management**, créer une GPO nommée `COMPUTER-Update-DC-Automatic-V1` (changer selon le type de machine : `DC`, `Server` ou `Client`).
2. Naviguer dans :
   - `Computer Configuration` → `Policies` → `Administrative Templates` → `Windows Components` → `Windows Update`.

##### Paramètres de la GPO
1. **Specify intranet Microsoft update service location** :
   - Cocher `Enabled`.
   - Indiquer l'URL du serveur WSUS : `http://SRVWSUS.pharmgreen.lan:8530`.
2. **Do not connect to any Windows Update Internet locations** :
   - Cocher `Enabled`.
3. **Configure Automatic Updates** :
   - Cocher `Enabled`.
   - Configurer les options suivantes :
     - `Configure automatic updating` : **4 - Auto Download and schedule the install**.
     - `Scheduled install day` : **0 - Every day**.
     - `Scheduled install time` : **09:00**.
     - Cocher :
       - `Every week`.
       - `Install updates for other Microsoft Products`.
4. **Enable client-side targeting** :
   - Cocher `Enabled`.
   - Indiquer le nom du groupe cible WSUS (par exemple, `Domain_Controllers`).
5. **Turn off auto-restart for updates during active hours** :
   - Cocher `Enabled`.
   - Configurer les heures d'activité : **8 AM - 6 PM**.

## Vérification des GPO
1. Lier les GPO aux OU correspondantes.
2. Sur chaque machine cliente, exécuter les commandes suivantes avec un compte administrateur local :
   ```powershell
   # Pour mettre à jour les GPO
   gpupdate /force
   
   # Pour vérifier si les GPO sont appliquées
   gpresult /R
   
___
# Partager les rôles FSMO entre les DC
- Une fois nos serveurs Active Directory mis en place et promus en tant que Contrôleurs de Domaine, on peut partager entre eux les rôles FSMO.
- On se connecte alors sur l'un des serveurs et on ouvre une session PowerShell en tant qu'administrateur :
  - On utilise la commande `Move-ADDirectoryServerOperationMasterRole` pour migrer les rôles ;
  - Deux options seront nécessaires :
    - `-Identity` suivi du nom de machine du serveur vers lequel on souhaite migrer le rôle ;
    - `-OperationMasterRole` suivi du rôle que l'on souhaite transférer :
      - `PDCEmulator` ou `0`
      - `RIDMaster` ou `1`
      - `InfrastructureMaster` ou `2`
      - `SchemaMaster` ou `3`
      - `DomainNamingMaster` ou `4`
  - Ce qui nous donne :
``` Powershell
Move-ADDirectoryServerOperationMasterRole -Identity SRVAD2 -OperationMasterRole DomainNamingMaster
Move-ADDirectoryServerOperationMasterRole -Identity SRVAD3 -OperationMasterRole PDCEmulator
Move-ADDirectoryServerOperationMasterRole -Identity SRVAD4 -OperationMasterRole RIDMaster
Move-ADDirectoryServerOperationMasterRole -Identity SRVAD5 -OperationMasterRole InfrastructureMaster
```
- Le Rôle de Maître de Schéma est conservé par SRVAD1.
- On vérifie dans un cmd avec la commande `netdom query fsmo`
- On obtient alors :
``` cmd
C:\Windows\system32>netdom query fsmo
Schema master            SRVAD1.pharmgreen.lan
Domain naming master     SRVAD2.pharmgreen.lan
PDC                      SRVAD3.pharmgreen.lan
RID pool manager         SRVAD4.pharmgreen.lan
Infrastructure master    SRVAD5.pharmgreen.lan
The command completed successfully.
```
---
# Installation de Passbolt
## Prérequis
- **Système d'exploitation** : Debian (sur une VM Proxmox).
- **Réseau** :
  - Nom de domaine : `pharmgreen.lan`
  - Adresse IP statique : `10.15.190.2/24`
- **Compte** : Root

## Étapes d'installation
### 1. Paramétrer le NTP
```bash
timedatectl set-timezone Europe/Paris
nano /etc/systemd/timesyncd.conf
```
```
NTP=fr.pool.ntp.org
```
```bash
timedatectl set-ntp true
systemctl restart systemd-timesyncd.service
```

### 2. Préparation du serveur
1. Mettre à jour le système :
   ```bash
   apt update && apt upgrade -y
   ```
2. Installer curl :
   ```bash
   apt install -y curl
   ```

### 3. Installation des dépendances
1. Télécharger le script :
   ```bash
   curl -LO https://download.passbolt.com/ce/installer/passbolt-repo-setup.ce.sh
   ```
2. lancer le script :
   ```bash
   bash ./passbolt-repo-setup.ce.sh
   ```
3. Mettre à jour la liste des paquets :
   ```bash
   apt update
   ```

### 4. Installation de Passbolt
1. Installer Passbolt CE et ses dépendances :
   ```bash
   apt install -y passbolt-ce-server
   ```
   Vous arriverez dans une fenetre de configuration, suivez les captures d'écran pour la suite.


### 5. Configuration de la base de données
**image**
![1ère image](../Ressources/S8/capture(1).png)


### 6. Finalisation et test
1. Accéder à Passbolt via votre navigateur à l’adresse :  
   `http://10.15.190.2`
2. Lors de la première connexion, un compte administrateur vous sera demandé. Suivez les étapes pour configurer cet utilisateur.
