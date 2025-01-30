# Mise en place serveur Messagerie
## Création de conteneur
- Créer un conteneur pour accueillir le serveur de messagerie :
  - Nom de CT : `iredmail`
  - O.S. : Debian12
  - Stockage : 8 Go (local-datas)
  - CPU : 2 Cores
  - RAM : 4 Go (Swap : 4 Go)
  - Effectuez la configuration réseau et DNS de votre conteneur pour pouvoir joindre votre LAN / domaine

## Préparation Conteneur
- Tapez les commandes suivantes :
``` bash
  sudo apt update && sudo apt upgrade -y
  nano /etc/hostname
      iredmail.pharmgreen.lan
  nano /etc/hosts
      10.15.190.10  iredmail.pharmgreen.lan  iredmail
```
- Puis redémarrer le conteneur

## Ajout du conteneur au DNS
- Enregistrement MX:
  - Clic droit sur votre domaine -> `Nouvel enregistrement (MX)`
  - Dans "Nom de l'hôte de l'échangeur de courrier", entrez le nom d'hôte de votre serveur iredmail (ex: `iredmail.pharmgreen.lan`).
  - Dans "Priorité", entrez une valeur faible (ex: `10`).
  - Cliquez sur "OK".
- Enregistrement A:
  - Clic droit sur votre domaine -> `Nouvel enregistrement Hôte (A)`
  - Dans "Nom", entrez le nom d'hôte de votre serveur Iredmail (ex: `iredmail.pharmgreen.lan`)
  - Dans "Adresse IP", entrez l'adresse IP de votre serveur iredmail.
  - Cliquez sur "OK".
 
## Installation et Configuration iRedMail
- Sur votre Conteneur iRedMail, tapez :
``` bash
  wget https://github.com/iredmail/iRedMail/archive/refs/tags/1.7.1.tar.gz
  tar xvf 1.7.1.tar.gz
  cd iRedMail-1.7.1
  bash iRedMail.sh
```
- Configuration :
  - Stockage des emails: Choisissez l'emplacement (par défaut `/var/vmail`).
  - Serveur web: `Nginx`
  - Backend: `OpenLDAP`
  - Premier domaine: `pharmgreen.lan`
  - Mot de passe administrateur de la base de donnée: `Azerty1*`
  - Nom de domaine du premier mail : `pharmgreen.lan`
  - Mot de passe administrateur du premier mail: `Azerty1*`
  - Composant optionnel cochez toutes les options
  - Confirmation: Vérifiez les options et confirmez.
- Redémarrez la machine
- Le serveur de messagerie est prêt à être exploité.

## Déploiement Mozilla Thunderbird sur les postes clients par GPO
### Configurer la GPO
- Créez une GPO (ex. : `Computer-Install-Mail-Mozilla_Thunderbird-v1.`
- Faites un clic droit sur la GPO et sélectionnez Edit.
- Chemin : `Computer Configuration > Policies > Software Settings > Software Installation.`
- Clic Droit > `New Package` > Sélectionnez le fichier d'installation de Mozilla Thunderbird situé dans un emplacement réseau partagé avec les utilisateurs.
### Lier la GPO
Group Policy Management > Group Policy Objects > Sélectionner la GPO
Sélectionner l'OU à laquelle vous souhaitez lier la GPO (pour nous `Clients`) > Clic droit > Link to an existing GPO > choisir la GPO.
Scope : `PgComputers` > `Clients` ;
Security Filtering : `Domain Computers` ;
Details : GPO Status - `User Configuration settings disabled`, puisqu'il s'agit d'une configuration ordinateur ;

### Paramétrage Mozilla Thunderbird sur poste client :
- Ouvrez Mozilla Thunderbird nouvellement installé ;
- Rentrez votre adresse mail entreprise ainsi que votre mot de passe ;
- Dans le paramétrage avancé :
  - Serveur entrant: `iredmail.pharmgreen.lan (IMAP)`
  - Port: `143`
  - Serveur sortant (SMTP): `iredmail.pharmgreen.lan`
  - Port: `587`
  - Nom d'utilisateur: Adresse email complète.
  - Authentification: `Autodétection`
  - Sécurité de la connexion: `STARTTLS`.
