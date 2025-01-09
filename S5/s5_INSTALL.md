# DOSSIERS PARTAGES - Mettre en place des dossiers réseaux pour les utilisateurs
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
- Le mappage des dossiers de service a été effectué par GPO ;
- Ces GPO ont été créées via script Powershell, disponible sur ce GitHub dans `Ressources\S5\GPO-MappingServices-Crea.ps1`
  - Ce script se base sur un fichier CSV dans lequel sont respectivement listés, pour chaque service, le nom que nous donnerons à la GPO, l'emplacement où cette GPO devra être liée et le groupe d'utilisateurs auquel elle s'appliquera ;
  - Ensuite, pour chaque service, une structure itérative `Foreach` permet de créer une GPO, dont le nom est standardisé, liée à l'OU de notre choix et s'appliquant au groupe concerné.
- Un second script permet ensuite d'ajouter `Domain Computers` et de retirer `Authenticated Users` aux `Security Filtering` ainsi que d'appliquer le statut `Computer Settings Disabled` à chacune des GPO de mappage ;
- Enfin, et c'est un point que nous n'avons pas réussi à automatiser, pour chaque GPO on la paramètre comme suit :
  - Chemin : `User Configuration` > `Preferences` > `Windows Settings` > `Drive Maps` > Clic Droit > `New Mapped Drive`
  - Paramètres à configurer :
    - Action : `Update`
    - Location : `"\\srvprod\pharmgreen\<Répertoire Département>\<Répertoire Service>`
    - Reconnect : Yes
    - Label as : `<Nom du Service>`
    - Drive Letter : `Use: J`
    - Hide/Show this drive : `Show this drive`
- Ainsi, chaque utilisateur aura accès au répertoire de son service, mappé sur J:, nommé selon son service.

### 3. Dossier de département, sur K:, accessible par tous les utilisateurs d'un même département
- Le mappage des dossiers de département a été effectué par GPO ;
- Ces GPO ont été créées manuellement ;
  - Chemin : `User Configuration` > `Preferences` > `Windows Settings` > `Drive Maps` > Clic Droit > `New Mapped Drive`
  - Paramètres à configurer :
    - Action : `Update`
    - Location : `"\\srvprod\pharmgreen\<Répertoire Département>`
    - Reconnect : Yes
    - Label as : `<Nom du Département>`
    - Drive Letter : `Use: K`
    - Hide/Show this drive : `Show this drive`
  - Cette GPO aura pour :
    - Lien : `<OU Département>`
    - Security Filtering : `Domain Computers` et `<Groupe des membres du Département>`      # Pour s'appliquer à tous les membres du département sur tous les ordinateurs du domaine
    - GPO Status : `Computer configuration settings disabled`                               # Puisqu'il s'agit d'une configuration utilisateur
- Ainsi, chaque utilisateur aura accès au répertoire de son département, mappé sur K:, nommé selon son département.

___
# SAUVEGARDE - Mettre en place une sauvegarde de données
RAID 1	100 %	
1. Faire le bon choix des données à sauvegarder (ex.: dossiers partagés des utilisateurs)	100 %	
2. Emplacement de la sauvegarde sur un disque différents de celui des données d'origine	100 %	
3. Mettre en place une planification de sauvegarde (script, AT, GPO, logiciel, etc.)	100 %

___
# Déplacement automatique des ordinateurs dans les bonnes OU
- Le déplacement des ordinateurs dans les bonnes OU est géré par script Powershell, disponible sur ce GitHub dans `Ressources\S5\PC_DeplacementOU_auto.ps1`
- Le script se base sur un fichier .CSV, disponible dans `Ressources\S5\PC_DeplacementOU.csv`, modifié à partir du fichier du personnel délivré par le service RH ;
  - le fichier .CSV ne contient que les départements des PCs ainsi que leur identifiant ;
- Le script, ensuite, récupère la liste de tous les ordinateurs du domaine ;
- Ensuite, via une structure itérative `Foreach`, il va traiter pour chaque PC du fichier .CSV :
  - Leur nom, concaténé à partir de leur Département et leur identifiant,
  - Leur département lui-même,
  - Leur emplacement actuel (généralement le conteneur `Computers`
  - Puis définir le nouvel emplacement dans l'AD vers lequel les envoyer ;
  - Si l'ordinateur est trouvé parmi les ordinateurs du domaine, il le redirige vers l'OU spécifiée précédemment (correspondant à son département) ;
  - S'il n'existe pas, il n'agit pas sur l'AD et nous prévient par message que l'ordinateur n'existe pas ;
- Ainsi, chaque ordinateur du domaine, quel que soit son emplacement d'origine, est redirigé vers l'OU auquel il appartient désormais selon le fichier de la RH.


___
# SÉCURITÉ D'ACCÈS - Restriction d'utilisation
- La gestion des heures travaillées des personnels de l'entreprise a été effectuée par script Powershell, disponible sur ce GitHub dans `Ressources\S5\HOURS_Set-Semaine.ps1`
- Le script commence par définir une longue fonction de modification des heures de travail :
  - Paramètres :
    - Plage horaire de travail ;
    - Autorisation d'utilisation des pipelines ;
    - Définition des *WorkingDays* et des *NonWorkingDays*
  - Process :
    - Traduction des horaires au format 24h en format binaire ;
    - Définition des horaires de travail pour les *WorkingDays* (24h/24) et des *NonWorkingDays* (0h/24)
    - Récupération des données des paramètres de jours ;
    - Uniformisation des Time zones ;
    - Modification des horaires pour l'utilisateur en cours d'observation ;
- Il faut ensuite définir les conditions d'appel de cette fonction :
  - `Get-ADUser -SearchBase "OU=PgUsers,DC=pharmgreen,DC=lan" -Filter * | Set-LogonHours -TimeIn24Format @(8,9,10,11,12,13,14,15,16,17) -Monday -Tuesday -Wednesday -Thursday -Friday -NonSelectedDaysare NonWorkingDays`
    - `Get-ADUser -SearchBase "OU=PgUsers,DC=pharmgreen,DC=lan" -Filter *` : Récupération de tous les utilisateurs de l'OU `PgUsers` ;
    - `Set-LogonHours` : Appel de la fonction précédemment rédigée ;
    - `-TimeIn24Format @(8,9,10,11,12,13,14,15,16,17)` : Définition des heures de travail de 8h à 18h (heures commencées à 8h, à 9h, ... , à 17h) ;
    - `-Monday -Tuesday -Wednesday -Thursday -Friday` : S'applique à tous les jours spécifiés
    - `-NonSelectedDaysare NonWorkingDays` : Les jours non spécifiés sont à considérer comme *NonWorkingDays* (0h/24)
  - A partir de là, tous nos utilisateurs ont des horaires de travail établis du lundi au vendredi, de 8h à 18h ;
  - Cependant, les membres du groupe et les administrateurs peuvent avoir besoin de se connecter en dehors de ces heures là.
  - Une autre ligne, similaire à la précédente, est alors rédigée. Elle précise que les membres de l'OU où se situent les administrateurs sont considérés en heures de travail 24h/24, 7j/7.
