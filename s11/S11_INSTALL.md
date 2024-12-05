# Mise en place des GPO
## GPO sécurité
### 1. **Politique de mot de passe**  
- Créez une GPO nommée : `computer-security-passwordPolicies-enable-v1`.
- Modifiez la **Default Domain Policy** :
- **Chemin** : Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Password Policy.
- **Paramètres à configurer** :
  1. **Minimum password length** : 12
  2. **Password must meet complexity requirements** : Activez cette option.
  3. **Enforce password history** :
     - Activez cette option.
     - Spécifiez "**24**" le nombre de mots de passe précédents qu’un utilisateur ne pourra pas réutiliser.
  4. **Minimum password age** :
     - Activez cette option.
     - Spécifiez "**1**" le nombre de jours avant qu'un mot de passe puisse être modifié à nouveau.
  5. **Maximum password age** :
     - Activez cette option.
     - Définissez "**30**"le nombre de jours après lesquels un mot de passe expirera.

### 2. **Verrouillage de compte**  
- Créez une GPO nommée : `computer-security-accountLockout-enable-v1`.  
- Modifiez la **Default Domain Policy** :  
- **Chemin** : Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Account Lockout Policy.  
- **Paramètres à configurer** :  
  1. **Account lockout threshold** : Définir à **3** tentatives incorrectes.  
  2. **Account lockout duration** : Définir à **10 minutes**.  
  3. **Reset account lockout counter after** : Définir à **10 minutes**.  
  4. Activer **Allow administrator account lockout**  

### 3. **Restriction d'installation de logiciel pour les utilisateurs non-administrateurs**  
- Créez une GPO nommée : `computer-security-SoftwareInstallation-deny-v1`.
- Faites un clic droit sur la GPO et sélectionnez **Edit**.
- **Chemin** : Computer Configuration > Policies > Administrative Templates > Windows Components > Windows Installer.
- **Paramètres à configurer** :
  1. **Prohibit User Installs** : Activez cette option pour interdire aux utilisateurs d'installer des logiciels.
  2. **Always install with elevated privileges** : Désactivez cette option pour éviter l'installation de logiciels avec des privilèges élevés.

### 4. **Blocage de l'accès à la base de registre**  
- Créez une GPO nommée : `computer-security-accessRegistre-deny-v1`.
- Faites un clic droit sur la GPO et sélectionnez **Edit**.
- **Chemin** : Computer Configuration > Policies > Administrative Templates > System > Prevent Access to the Registry Editor.
- **Prevent access to registry editing tools** : Activez cette option pour bloquer l'accès à l'éditeur de registre pour les utilisateurs.

### 5. **Blocage complet ou partiel au panneau de configuration**  
- Créez une GPO nommée : `computer-security-controlPanel-deny-v1`.
- Faites un clic droit sur la GPO et sélectionnez **Edit**.
- **Chemin** : Computer Configuration > Policies > Administrative Templates > Control Panel.
- **Prohibit access to the Control Panel and PC settings** : Activez cette option pour interdire l'accès complet au Panneau de configuration et aux paramètres PC.

### 6. Restriction des périphériques amovible
- Créez une GPO nommée : `computer-security-block-usb`.
- Modifiez la **Group Policy Management Editor** :  
  - **Chemin** : Computer Configuration > Policies > Administrative Template > System > Removable Storage Access > All Removable Storage classes: Deny all access.  
  - Mettre en **Enable**  
### 7. Gestion d'un compte du domaine qui est administrateur local des machines
- Il est question de définir un ou plusieurs comptes qui seront Administrateurs locaux sur les machines du domaines
- Création du groupe de sécurité dans l'Active Directory (AD) :
	- Aller sur un serveur AD > Server Manager > Tools > Active Directory Users and Computers > PgSecurityGroups > Créer un nouveau groupe ;
	- Donner le nom souhaité au groupe ;
	- Group Scope = Global ;
	- Group Type = Security ;
	- Ajouter le ou les comptes souhaités pour devenir administrateurs locaux dedans ;
- Création de la GPO :
	- Server Manager > Tools > Group Policy Management ;
	- Dans votre domaine > Group Policy Objects > Créer une nouvelle GPO et la nommer selon votre convention ;
	- Editer la GPO > Computer Configuration > Policies > Windows Settings > Security  Settings > Restricted Groups > Clic Droit > Add Group ;
	- Ajouter le groupe `Administrators`. Il s'agit du groupe des administrateurs locaux des machines (les clients Windows 10 étant configurés en anglais, il s'agit du nom en anglais, à modifier s'il s'agit de clients français) ;
	- Double clic sur le groupe nouvellement créé > Members of this group > Add > Ajouter le groupe créé dans l'AD
	- Sortir de l'éditeur ;
- Lier la GPO :
	- Group Policy Management > Group Policy Objects > Sélectionner la GPO
	- Scope :
		- Security Filtering : Authenticated Users ;
	- Details : GPO Status - `User Configuration settings disabled`, puisqu'il s'agit d'une configuration ordinateur ;
	- Sélectionner l'OU à laquelle vous souhaitez lier la GPO (pour nous `PgComputers`) > Clic droit > Link to an existing GPO > choisir la GPO.

### 8. Gestion du pare-feu
- Création de la GPO :
	- Server Manager > Tools > Group Policy Management ;
	- Dans votre domaine > Group Policy Objects > Créer une nouvelle GPO et la nommer selon votre convention ;
	- Editer la GPO > Computer Configuration > Policies > Administrative Templates > Network > Network Connections > Windows Defender Firewall > Domain Profile
	- Protect all network connections : `Disabled`
	- Sortir de l'éditeur ;
- Lier la GPO :
	- Group Policy Management > Group Policy Objects > Sélectionner la GPO
	- Scope :
		- Security Filtering : `Authenticated Users` ;
	- Details : GPO Status - `User Configuration settings disabled`, puisqu'il s'agit d'une configuration ordinateur ;
	- Sélectionner l'OU à laquelle vous souhaitez lier la GPO (pour nous `PgComputers`) > Clic droit > Link to an existing GPO > choisir la GPO.

9. Écran de veille avec mot de passe en sortie
### 10. Limitation des tentatives d'élévation de privilèges
- Création de la GPO :
	- Server Manager > Tools > Group Policy Management ;
	- Dans votre domaine > Group Policy Objects > Créer une nouvelle GPO et la nommer selon votre convention ;
	- Editer la GPO > Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > Security Options
	- User Account Control : Behavior of the elevation prompt for standard users : `Automatically Deny elevation requests`
	- Sortir de l'éditeur ;
- Lier la GPO :
	- Group Policy Management > Group Policy Objects > Sélectionner la GPO
	- Scope :
		- Security Filtering : `Authenticated Users` ;
	- Details : GPO Status - `User Configuration settings disabled`, puisqu'il s'agit d'une configuration ordinateur ;
	- Sélectionner l'OU à laquelle vous souhaitez lier la GPO (pour nous `PgComputers`) > Clic droit > Link to an existing GPO > choisir la GPO.
    
### 11. Politique de sécurité PowerShell
- Créez une GPO nommée : `computer-security-block-command`.
- Modifiez la **Group Policy Management Editor** :  
  - **Chemin** : User Configuration > Policies > Administrative Template > System > Prevent access to the command prompt.  
  - Mettre en **Enable**
  - **Chemin** : User Configuration > Policies > Administrative Template > System > Don't run specified Windows applications.  
  - Mettre en **Enable**
  - Aller dans **Show** et compléter ces lignes:
    - **powershell.exe**
    - **powershell_ise.exe**
    - **pwsh.exe**

## GPO standard
### 1. Fond d'écran
- Crée un dossier nommé : `Wallpaper` et ajouter une image pour le fond d'écran
- Partager le dossier avec d'autre utilisateur
- Créez une GPO nommée : `User-Configuration-Wallpaper-Default-v1`.
    - **Chemin** : User Configuration > Policies > Administrative Template > Desktop > Desktop > Desktop Wallpaper.
    - Mettre en **Enable** et metter le lien de l'image du dossier Wallpaper
### 2. Mappage de lecteurs

### 3. Gestion de l'alimentation
#### verrouillage automatique des sessions
- Créez une GPO nommée : `User-Configuration-Power`.
- Il faudra selectionner 3 éléments:
  - Enable screen saver  
  - Password protect the screen saver  
  - Screen saver timeout  

- Pour le **Enable screen saver** et **Password protect the screen saver**, il faut cocher le **Enable** pour l'activer puis enregistrer les modifications.  
- Et pour le **Screen saver timeout**,  il faut cocher le **Enable** pour l'activer puis entrer le temps avant que l'écran se mette en veille, par exemple dans notre cas on a mis 600 seconde (10 minutes) puis on enregistre les modifications.
- Fermer la fenetre **Group Policy Management Editor** et faite click droit sur le dossier PgUsers et selectionner **Link an Existing GPO**
- Sur la fenetre **Select GPO**, selectionner le GPO qu'on veut enregistrer: **User-Configuration-Power**

### 4. Déploiement (publication) de logiciels
### 5. Redirection de dossiers (Documents, Bureau, etc.)
### 6. Configuration des paramètres du navigateur (Firefox ou Chrome)
# Installation de Glpi
---
# Configuration DHCP
Nous avons configuré le DHCP pour qu'il attribue sur chaque sous-réseau 100 IP sur la plage **adresse_réseau.100 > adresse_réseau.200**
Notre serveur DHCP est en core, nous l'avons configuré depuis le serveur graphique après avoir installé **RSAT-DHCP** via la commande suivante :
```powershell
Install-WindowsFeature -Name RSAT-DHCP
```
1. **Ouvrir le gestionnaire DHCP** :  
Ouvrez le menu Démarrer et tapez dhcpmgmt.msc dans la barre de recherche, puis appuyez sur Entrée.
Cela ouvrira la console de gestion DHCP. 
2. **Se connecter au serveur Core** :  
Dans la console de gestion DHCP, faites un clic droit sur DHCP dans le volet gauche et sélectionnez Ajouter un serveur.
Entrez le nom ou l'adresse IP du serveur Core que vous souhaitez gérer.
Cliquez sur OK pour établir la connexion avec le serveur Core.
3. **Gérer les configurations DHCP**  
Une fois connecté, vous pouvez gérer les configurations DHCP de votre serveur Core via l'interface graphique


| Départements                  | Adresses réseau          | Plages IP attribuées     |
|------------------------------|-------------------------|------------------------|
| R&D                          | 10.15.10.0/24           | 10.15.10.100 > 10.15.10.200 |
| Ventes & Développement Commercial | 10.15.20.0/24           | 10.15.20.100 > 10.15.20.200 |
| Communication                | 10.15.30.0/24           | 10.15.30.100 > 10.15.30.200 |
| Direction Financière         | 10.15.40.0/24           | 10.15.40.100 > 10.15.40.200 |
| Direction Marketing          | 10.15.50.0/24           | 10.15.50.100 > 10.15.50.200 |
| RH                           | 10.15.60.0/24           | 10.15.60.100 > 10.15.60.200 |
| Services Généraux            | 10.15.70.0/24           | 10.15.70.100 > 10.15.70.200 |
| Direction Générale           | 10.15.80.0/24           | 10.15.80.100 > 10.15.80.200 |
| Service Juridique            | 10.15.90.0/24           | 10.15.90.100 > 10.15.90.200 |
| Systèmes d'Information       | 10.15.100.0/24          | 10.15.100.100 > 10.15.100.200 |
