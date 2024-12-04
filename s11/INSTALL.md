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

6. Restriction des périphériques amovible
7. Gestion d'un compte du domaine qui est administrateur local des machines
8. Gestion du pare-feu
9. Écran de veille avec mot de passe en sortie
10. Limitation des tentatives d'élévation de privilèges
11. Politique de sécurité PowerShell
6. Restriction des périphériques amovible
7. Gestion d'un compte du domaine qui est administrateur local des machines
8. Gestion du pare-feu
9. Écran de veille avec mot de passe en sortie
10. Limitation des tentatives d'élévation de privilèges
11. Politique de sécurité PowerShell
## GPO standard
### 1. Fond d'écran

### 2. Mappage de lecteurs

### 3. Gestion de l'alimentation
#### verrouillage automatique des sessions
- Afin d'intégrer le GPO du verrouillage automatique des sessions, nous allons dans le group Policy Management.  
- Sur le dossier **Group Policy Objects** , click droit et selectionner **New**  
- Entrer le nom du GPO: **User-Configuration-Power**  
- Click droit sur le GPO et selectionner **Edit...**  
- Une nouvelle fenetre nommer **Group Policy Management Editor** s'ouvrira  
- Il faudra selectionner 3 éléments:
  - Enable screen saver  
  - Password protect the screen saver  
  - Screen saver timeout  

- Pour le **Enable screen saver** et **Password protect the screen saver**, il faut cocher le **Enable** pour l'activer puis enregistrer les modifications.  
- Et pour le **Screen saver timeout**,  il faut cocher le **Enable** pour l'activer puis entrer le temps avant que l'écran se mette en veille, par exemple dans notre cas on a mis 600 seconde (10 minutes) puis on enregistre les modifications.
- Fermer la fenetre **Group Policy Management Editor** et faite click droit sur le dossier PgUsers et selectionner **Link an Existing GPO**
- Sur la fenetre **Select GPO**, selectionner le GPO qu'on veut enregistrer: **User-Configuration-Power**
- Votre GPO de verrouillage automatique des sessions est fait

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
