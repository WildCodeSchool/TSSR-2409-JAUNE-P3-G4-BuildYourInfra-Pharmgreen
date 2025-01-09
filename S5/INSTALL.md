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
- **Objectif** : Garantir une sauvegarde régulière et fiable des données critiques tout en optimisant le temps et l’espace nécessaires pour les sauvegardes quotidiennes.

## 1. Choix des données à sauvegarder
- **Infrastructure mise en place** :
  - Création d’un serveur de sauvegarde dédié sous **Windows Server 2022**.
  - Configuration d’un système de stockage en **RAID 1** pour une meilleure sécurité des données.
  - Le dossier contenant les sauvegardes complètes et différentielles est compressé afin d'optimiser l'espace du disque.

- **Données à sauvegarder** :
  - Dossier partagé contenant :
    - Les dossiers personnels des utilisateurs.
    - Les dossiers départementaux et de service situés sur le serveur de production.

## 2. Mettre en place une planification de sauvegarde
- **Outil utilisé** : Nous avons opté pour **Robocopy** pour exécuter les sauvegardes.

- **Planification des sauvegardes** :
  - **Sauvegarde complète** :
    - Programmée tous les **samedis à 23h**.
    - Exécutée via un **script automatisé** grâce au planificateur de tâches.
  - **Sauvegarde différentielle** :
    - Programmée **tous les jours à 23h (sauf le samedi)**.
    - Basée sur la date de la dernière sauvegarde complète.

# Déplacement automatique des ordinateurs dans les bonnes OU
1. Suivant le nom d'une machine et/ou la valeur d'un attribut AD
2. Automatisation par script PS exécuté par une tâches AT
SÉCURITÉ D'ACCÈS - Restriction d'utilisation
1. Pour les utilisateurs standard : connexion autorisée de 8h à 18h, du lundi au vendredi sur les clients (bloquée le reste du temps)
2. Pour les administrateurs : bypass
3. Gestion des exceptions : prévoir un groupe bypass
