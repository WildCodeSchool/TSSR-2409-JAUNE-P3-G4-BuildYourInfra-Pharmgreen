# DOSSIERS PARTAGES - Mettre en place des dossiers réseaux pour les utilisateurs	100 %
Stockage des données sur un volume spécifique	100 %	
Sécurité de partage des dossiers par groupe AD	100 %	
Mappage des lecteurs sur les clients (au choix) :	100 %	
1. GPO	100 %	
2. Script PowerShell/batch		
3. Profil utilisateur AD		
Chaque utilisateur a accès à :		
Dossier individuel, sur I:, accessible uniquement par cet utilisateur	100 %	
Dossier de service, sur J:, accessible par tous les utilisateurs d'un même service.	100 %	
Dossier de département, sur K:, accessible par tous les utilisateurs d'un même département.	100 %	
# SAUVEGARDE - Mettre en place une sauvegarde de données

## Objectif
Garantir une sauvegarde régulière et fiable des données critiques tout en optimisant le temps et l’espace requis pour les sauvegardes quotidiennes.

---

## 1. Choix des données à sauvegarder

### Infrastructure mise en place
- **Serveur de sauvegarde** :
  - Mise en place d’un serveur dédié (“SRVSAVE”) sous **Windows Server 2022**.
  - Utilisation d’un système de stockage en **RAID 1** pour assurer la résilience des données.
  - Stockage des sauvegardes sur le volume `B:\Backup`.
- **Optimisation de l’espace disque** :
  - Compression activée sur le disque de sauvegarde.
    - **Procédure** : Cliquez droit sur le disque `B:\` > **Propriétés** > Cochez l’option **Compress this drive to save disk space**.

### Données à sauvegarder
- **Dossiers partagés** situés sur le serveur de production, incluant :
  - Les dossiers personnels des utilisateurs.
  - Les dossiers départementaux et de service.

---

## 2. Mettre en place une planification de sauvegarde

### Outil utilisé
- **Robocopy** est choisi pour la réalisation des sauvegardes.
- Les sauvegardes sont automatisées via des scripts PowerShell.

### Planification des sauvegardes
#### Sauvegarde complète
- **Fréquence** : Tous les **samedis à 23h**.
- **Script** : `back-up_general.ps1`.
- **Configuration dans le Planificateur de tâches** :
  - Ouvrir **Task Scheduler** et créer une nouvelle tâche.
- Onglet **General** :
     - Nom : `back-up_general`
     - Cocher **Run with highest privileges**.
  - Onglet **Triggers** :
     - Cliquer sur **New**.
     - Sélectionner **Weekly**, choisir **Saturday** et définir l’heure à **23h00**.
     - Cocher **Stop the task if it runs longer than** et sélectionner **1 day**.
  - Onglet **Actions** :
     - Cliquer sur **New**.
     - Dans **Program/Script**, entrer `powershell.exe`.
     - Dans **Add arguments**, indiquer le chemin du script `back-up_general.ps1`.
  - Onglet **Conditions** :
     - Décocher **Start the task only if the PC is on AC power**.
  - Onglet **Settings** :
     - Cocher **If the task fails, restart every** et choisir **5 minutes**.

#### Sauvegarde différentielle
- **Fréquence** : Tous les jours à 23h (sauf le samedi).
- **Script** : `back-up_differentielle.ps1`.
- **Configuration dans le Planificateur de tâches** :
  - Les étapes sont similaires à la sauvegarde complète, avec les différences suivantes :
    - Nom : `back-up_differentielle`.
    - Onglet **Triggers** :
      - Sélectionner **Weekly** et cocher tous les jours sauf **Saturday**.
      - Définir **Stop the task if it runs longer than** à **8 hours**.
    - Onglet **Actions** :
      - Indiquer le chemin du script `back-up_differentielle.ps1`.

# Déplacement automatique des ordinateurs dans les bonnes OU
1. Suivant le nom d'une machine et/ou la valeur d'un attribut AD
2. Automatisation par script PS exécuté par une tâches AT
SÉCURITÉ D'ACCÈS - Restriction d'utilisation
1. Pour les utilisateurs standard : connexion autorisée de 8h à 18h, du lundi au vendredi sur les clients (bloquée le reste du temps)
2. Pour les administrateurs : bypass
3. Gestion des exceptions : prévoir un groupe bypass
