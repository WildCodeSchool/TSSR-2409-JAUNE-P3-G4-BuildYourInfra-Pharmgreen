# Installation d'un serveur de gestion de mise à jour
## Prérequis
- 1 VM avec Windows Server 2022 installé et mise à jour
- Un espace disque dur de 32 Go pour le système et un de 20 Go pour stocker les MAJ
- 4 coeurs pour le CPU et 8 Go de RAM
- Avant d'installer renommer le PC en `SRVWSUS`Configurer l'adresse IP en `10.15.200.60/24`
## Création de la partition de stockage des mises à jour
Créer une partition formaté avec un espace de 20 Go qui se nomme WSUS sur la lettre `M:`.
Sur cette partition, créer un dossier `WSUS` puis redémarrer
## Installation du rôle WSUS
À partir du Server Manager, installer le rôle Windows Server Update Services.
Valider les fonctionnalités supplémentaires qui vont s'ajouter automatiquement.
Ensuite, sélectionner WID Connectivity et WSUS Service.
Indiquer le dossier pour l'emplacement du stockage des mises à jour `M:\WSUS`.
Terminer l'installation et redémarre le serveur.
## Configuration du service WSUS
Une fois le serveur redémarré, lancer la tâche `Post Deployment Configuration for WSUS` dans le Server Manager.
Ensuite, dans la fenêtre de gauche, aller dans WSUS.
Avec le bouton droit sélectionner Windows Server Update Services cela va lancer automatiquement l'assistant de configuration.

Décocher la case `Yes, I would like to join the Microsoft Update Improvement Program`
Laisser sélectionné la case `Synchronize from Microsoft Update`
À la fin, cliquer sur `Start Connecting`. Attendre la fin de la synchronisation, c'est très long.
Après, sélectionner les langues English et French
Dans la fenêtre d'après, sélectionner les produits :
    - Active Directory
    - Micosoft security essentials
    - Microsoft defender antivirus
    - Microsoft edge
    - Microsoft server operating system 21H2
    - Windows 10 and later drivers
Pour les classifications cocher :
    - Critical updates
    - Security updates
Pour la synchronisation, choisir 4 synchronisations par jour, à partir de 2h.
Enfin cocher la case `Begin initial synchronization` et clic sur `Finish`

Dans `Options`, puis `Automatic Approvals`.
Dans l'onglet `Update Rules`, cocher `Default Automatic Approval Rule`.

Cliquer sur `Run Rules`, `Apply` et `OK`
## Liaison avec les ordinateurs du domaine
### Configuration sur WSUS

Aller dans `Options`, puis `Computers`.
Cocher l'option `Use Group Policy` et valide
Dans l'arborescence des ordinateurs, sous All Computers, créer 3 groupes avec `Add Computer Group` :
    - Domain_Controllers
    - Servers
    - Clients

### Configuration sur un controleur de domaine
#### GPO pour les MAJ des controlleurs de domaine (quasi identique pour les serveurs et les clients)
Dans Group Policy Management, créer une GPO `COMPUTER-Update-DC-Automatic-V1` (changer en fonction pour les serveurs ou les clients)
Aller dans `Computer Configuration`--> Policies--> Administrative Templates--> Windows Components--> Windows update
Aller dans `Specify intranet Microsoft update service location`.
    Cocher Enabled
    Dans les options, pour les 2 premiers champs, mettre l'URL du serveur et le numéro du port `http://SRVWSUS.pharmgreen.lan:8530`
    Valider
Aller dans `Do not connect to any Windows Update Internet locations` qui bloque la connexion aux serveurs de Microsoft
Cocher Enabled.
Aller dans `Configure Automatic Updates`
    Cocher `Enabled`
    Dans les options mettre :
        - Dans `Configure automatic updating` sélectionne `4- Auto Download and schedule the install`
        - Dans `Scheduled install day` mets `0 - Every day`
        - Dans `Scheduled install time` mets `09:00`
        - Cocher `Every week`
        - Cocher `Install updates for other Microsoft Products`
Aller dans `Enable client-side targeting` qui fait la liaison avec les groupes crées dans WSUS
Coche Enabled
Dans les options, mettre le nom du groupe WSUS pour les ordinateurs cible, donc `Domain_Controllers` (changer en fonction pour les serveurs ou les clients)
Valider
Aller dans `Turn off auto-restart for updates during active hours`
Coche Enabled
Dans les options, mettre (par exemple) 8 AM - 6 PM

## Vérifier les GPO
Une fois crées et configurées, lier les GPO aux OU correspondantes.

Sur chaque client machine, exécuter la commande avec le compte administrateur local 
```powershell
# Pour mettre a jour les GPO
gpupdate /force.
# Pour vérifier si les GPO sont appliquée
gpresult /R
```