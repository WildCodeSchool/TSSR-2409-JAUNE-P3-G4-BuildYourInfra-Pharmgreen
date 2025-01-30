# Installation et configuration d'un serveur VOIP
## Création d'une VM FreePBX
### Prérequis
- L'image iso "SNG7-PBX16-64bit-2302-1.iso"
- Une carte réseau en bridge
- Une IP en 10.15.200.70
### Installation
1. Au démarrage de la VM, dans la liste, choisir la version recommandée
2. Puis sélectionner Graphical Installation - Output to VGA.
3. Enfin choisir FreePBX Standard
4. Pendant l'installation, il faut configurer le mot de passe root (Root password is not set s'affiche).
5. Clique sur ROOT PASSWORD et entre un mot de passe (Le clavier est en anglais donc attention aux lettres des touches du clavier QWERTY).
6. L'installation continue et se termine.
7. Éteindre la VM, enlever l'ISO du lecteur et redémarrer la VM.

## Configuration du serveur 
### Sur le serveur FreePBX
1. Connecte toi en root.
2. Ecrit les lignes de commandes suivantes pour mettre le clavier en français :
```bash
localectl set-locale LANG=fr_FR.utf8
localectl set-keymap fr
localectl set-x11-keymap fr
```
3. Vérifie avec la commande `localectl` :
```
System Locale: LANG=fr_FR.UTF-8
    VC Keymap: fr
   X11 Layout: fr
```
3. Modifier le mot de passe de root avec la commande `passwd root`
### Sur Windows Server22
A partir de ton navigateur web, connecte-toi sur l'adresse du serveur et tu arriveras sur l'interface de gestion de FreePBX :
- Dans la fenêtre, clique sur `FreePBX Administration` et reconnecte-toi en `root`.
- Clique sur `Skip` pour sauter l'activation du serveur et toutes les offres commerciales qui s'affichent.
- Laisse les langages par défaut et clique sur Submit.
- A la fenêtre d'activation du firewall, clique sur `Abort`
- A la fenêtre de l'essais de SIP Station clique sur `Not Now`
- Tu arrive sur le tableau de bord, clique sur `Apply Config` (en rouge) pour valider tout ce que tu viens de faire
### Activation du serveur
Cette activation n'est pas obligatoire, mais elle permet d'avoir accès à l'ensemble des fonctionnalités du serveur.
- Va dans le menu `Admin` puis `System Admin`.
- Un message indique que le système n'est pas activé.
- Clique sur `Activation` puis `Activate`
- Dans la fenêtre qui s'affiche, clique sur `Activate`
- Entre une adresse email et attend quelques instant.
- Dans la fenêtre qui s'affiche, renseigne les différentes informations, et :
    - Pour `Which best describes you` mets `I use your products and services with my Business(s) and do not want to resell it`
    - Pour `Do you agree to receive product and marketing emails from Sangoma ?` coche `No`
    - Clique sur `Create`
    - Dans la fenêtre d'activation, clique sur `Activate` et attends que l'activation se fasse.
- Dans les fenêtres qui s'affichent, clique sur `Skip`.

### Mise à jour des modules du serveur
La fenêtre de mise-à-jour des modules va s'afficher automatiquement.
- Clique sur `Update Now`
- Attend la mise-à-jour de tous les modules.
- Une fois que tout est terminé, clique sur `Apply config`.

Il peut y avoir des erreurs sur le serveurs suite à la mise-à-jour des modules et dans ce cas, l'accès au serveur ne se fait pas.
- Les modules incriminés sont précisés et il faut les réinstaller et les activer.
- Dans ce cas, sur le serveur en CLI, exécute les commandes suivantes :
```
fwconsole ma install userman
fwconsole ma enable userman
fwconsole ma install voicemail
fwconsole ma enable voicemail
fwconsole ma install sysadmin
fwconsole ma enable sysadmin
```

- Va sur le serveur en CLI et exécute la commande `yum update` pour faire la mise-à-jour du serveur.
- Répond `y` lorsque cela sera demandé.
- Redémarre le serveur

### Mise à jour complémentaire des modules
Connecte-toi en root via la console web, et vas dans le Dashboard pour voir s'il te manque des modules.
- Vas dans le menu `Admin` puis `Modules Admin`, et dans l'onglet `Module Update`.
- Dans la fenêtre qui s'affiche, dans la colonne `Status`, sélectionne ceux qui sont en `Disabled; Pending Upgrade...` et qui ont une licence ***GPL***.
- Sélectionne alors le bouton `Upgrade to ...`.
- Quand tu as géré tous les modules, clique sur `Process`.
- Dans la fenêtre qui apparaît, clique sur `Confirm`.
- Quand tout est terminé, clique sur `Apply config`.

### Configuration complémentaire du serveur
- Vas dans Admin --> System Admin et regarde à droite de la fenêtre, tu as différentes informations sur le serveur.
- DNS : Ici tu peux mettre les adresses IP des autres serveurs DNS de ton réseau
- Time Zone : Pour le fuseau horaire

### Ajout des utilisateurs Active Directory
- Sur la console web : `Administrator` > `User Manager` > `Directories` > `Add`
    - Directory Type : `Microsoft Active Directory`
    - Directory Name : `Pharmgreen`
    - Enable Directory : `Yes`
    - Host : `10.15.200.1`
    - Port : `389`
    - Nom d'utilisateur : `adminpbx` (il s'agit de l'utilisateur qui permettra au serveur FreePBX de joindre le domaine : cet utilisateur doit être créé. Nous avons fait le choix de dédier un utilisateur spécifique à cette tâche)
    - Mot de passe : entrer le mot de passe de l'utilisateur ci-dessus
    - Domaine : `pharmgreen.lan`
    - Base DN : OU=PgUsers,DC=Pharmgreen,DC=lan (l'emplacement des comptes utilisateurs du domaine)
    - Create Missing Extension : `SIP [chan_pjsip]`
    - **Laisser les autres champs par défaut**
 
- Afin que les utilisateurs puissent avoir un numéro VOIP, celui-ci doit être renseigné sur leur profil : `Telephones` > `IP Phone`

## Déploiement et Configuration du Softphone 3CX