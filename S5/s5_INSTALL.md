# DOSSIERS PARTAGES - Mettre en place des dossiers réseaux pour les utilisateurs	100 %
## Stockage des données sur un volume spécifique
- Les données personnelles seront stockées sur le serveur de fichiers `SRVPROD` dans l'arborescence `Pharmgreen\00_Commun\002_Dossiers Individuels\`
  - L'emplacement du répertoire partagé `Pharmgreen` est libre. Sur notre serveur, il a été placé sur le disque de stockage `E:\`, configuré en RAID 1 ;
## Sécurité de partage des dossiers par groupe AD
## Mappage des lecteurs sur les clients
- Tous les lecteurs ont été mappés via une GPO. 
- Chaque utilisateur a accès à :
### 1. Dossier individuel, sur I:, accessible uniquement par cet utilisateur
- La création des dossiers individuels a été faite par script Powershell, disponible sur ce GitHub dans `Ressources\S5\DossiersIndiv-Crea.ps1`
  - Ce script récupère les noms de l'ensemble des utilisateurs de l'Active Directory et liste leur `SAMAccountName` ;
  - Ensuite, via une structure itérative `Foreach`, il va :
    - Récupérer le nom de chaque utilisateur ;
    - Définir à quel endroit créer un dossier à ce nom ;
    - Créer le répertoire ;
    - Générer des droits d'accès `Full Control` pour l'utilisateur et le rendre propriétaire de son dossier.
- On lance ensuite un second script pour affiner les droits sur les répertoires, disponible sur ce GitHub dans `Ressources\S5\DossiersIndiv-Deny-Deletion.ps1` :
  - Ce script récupère la liste des dossiers individuels ;
  - Il récupère la liste des utilisateurs standards ;
  - Ensuite, via une structure itérative `Foreach`, il va créer une règle interdisant la suppression du répertoire par les utilisateurs standards (les administrateurs en ont toujours la possibilité) ;
- On lance enfin un troisième script pour définir ce répertoire comme étant le *Home Directory* de l'utilisateur, disponible sur ce GitHub dans `Ressources\S5\DossiersIndiv-HomeDir.ps1` :
  - Ce script récupère la liste des utilisateurs de l'Active Directory ;
  - Il spécifie que l'attribut *Home Directory* de chaque utilisateur se situe à l'emplacement réseau où se trouve le répertoire créé précédemment pour chacun d'entre eux.
- On crée enfin une GPO `User-Mappage-DossierIndividuel-I:-v1`
  - Chemin : `User Configuration` > `Preferences` > `Windows Settings` > `Drive Maps` > Clic Droit > `New Mapped Drive`
  - Paramètres à configurer :
    - Action : `Update`
    - Location : `"\\srvprod\pharmgreen\00_Commun\002_Dossiers Individuels\%USERNAME%"`    # *%USERNAME%* va sera remplacé pour chaque utilisateur par son SAMAccountName, qui est pour chacun le nom du répertoire individuel
    - Reconnect : Yes
    - Label as : `%USERNAME%`
    - Drive Letter : `Use: I`
    - Hide/Show this drive : `Show this drive`
  - Cette GPO aura pour :
    - Lien : `PgUsers`
    - Security Filtering : `Domain Computers` et `GrpUsersPharmgreenTous`                   # Pour s'appliquer à tous sur tous les ordinateurs du domaine
    - GPO Status : `Computer configuration settings disabled`                               # Puisqu'il s'agit d'une configuration utilisateur
- Ainsi, chaque utilisateur aura accès à son répertoire individuel, mappé sur I:, nommé selon son identifiant de connexion.
 
### 2. Dossier de service, sur J:, accessible par tous les utilisateurs d'un même service

### 3. Dossier de département, sur K:, accessible par tous les utilisateurs d'un même département


___
# SAUVEGARDE - Mettre en place une sauvegarde de données	100 %	
RAID 1	100 %	
1. Faire le bon choix des données à sauvegarder (ex.: dossiers partagés des utilisateurs)	100 %	
2. Emplacement de la sauvegarde sur un disque différents de celui des données d'origine	100 %	
3. Mettre en place une planification de sauvegarde (script, AT, GPO, logiciel, etc.)	100 %	
# Déplacement automatique des ordinateurs dans les bonnes OU
1. Suivant le nom d'une machine et/ou la valeur d'un attribut AD
2. Automatisation par script PS exécuté par une tâches AT
SÉCURITÉ D'ACCÈS - Restriction d'utilisation
1. Pour les utilisateurs standard : connexion autorisée de 8h à 18h, du lundi au vendredi sur les clients (bloquée le reste du temps)
2. Pour les administrateurs : bypass
3. Gestion des exceptions : prévoir un groupe bypass
