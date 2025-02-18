# Mise en place d'une journalisation des scripts PS
Intégration aux scripts Powershell


___
# SUPERVISION - Mise en place d'une supervision de l'infrastructure réseau
## Installation PRTG
- Récupérer le programme d'installation de PRTG sur https://www.paessler.com/
- Lancer l'exécutable sur le serveur de Supervision
- Langue : `Français`
- Accepter les termes du contrat de licence
- Definir une adresse mail sur laquelle recevoir les alertes de supervision par mail ;
- Mode d'installation : `Rapide`
- Installer
## Configuration Portail Web
- A la fin de l'installation, un navigateur se lance avec la console web ;
- Se connecter avec les crédentiels par défaut : Login : `prtgadmin` ; Mot de passe : `prtgadmin`
- Aller dans paramètres, définir un nouveau groupe ;
  - Informations d'identification pour systèmes Windows
    - Nom de domaine : `pharmgreen.lan`
    - Nom d'utilisateur : `prtg` (un utilisateur de service `prtg@pharmgreen.lan` a été créé spécifiquement pour la connexion au domaine)
    - Mot de passe : Remplir le mot de passe du compte `prtg`
  - Enregistrer
- Le portail web, dans une popup orange, nous propose d'activer la découverte automatique : on accepte ;
- Dans l'onglet `Équipements` > `Vue d'ensemble`, les sondes remontent petit à petit depuis chaque machine.


___
# SUPERVISION - Surveillance du pare-feu pfsense
1. Mise en place de dashboard
2. Ajout et modification de widget


___
# AD - Nouveau fichier RH pour les utilisateurs de l'entreprise
1. Intégration des nouveaux utilisateurs
2. Modifications de certaines informations
Le département "RH" change de nom et devient la "Direction des Ressources Humaines"
Le service "Marketing Digital" s'appelle désormais "e-Marketing"
Le service "Recrutement" s'appelle désormais "Gestion des recrutements", et les collaborateurs de ce service ont désormais la fonction de "Recruteur RH"
