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
