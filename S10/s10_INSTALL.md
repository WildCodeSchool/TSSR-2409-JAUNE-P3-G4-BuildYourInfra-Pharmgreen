# Mise en place d'un PC d'administration
## Restreindre l'accès aux administrateurs
## Activer les RSAT
___
## Installer Putty
`https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html`
___
## Mise en place Remote Desktop Protocol
### Sur le client
- Paramètres > Système > Bureau à distance > Activer > Confirmer
### Sur un contrôleur de domaine
- Configurer la GPO
  - Activation Remote Desktop
      - Créez une GPO (ex. : Computer-Configuration-RemoteDesktop-Activate-v1)
      - Faites un clic droit sur la GPO et sélectionnez Edit.
      - Chemin : Configuration ordinateur > Stratégies > Modèles d'administration > Composants Windows > Services bureau à distance > Hôte de la session Bureau à distance > Connexions
      - Autoriser les utilisateurs à se connecter à distance à l'aide des services Bureau à distance > Activer
    - Modification du port par défaut
      - Configuration ordinateur > Préférences > Paramètres Windows > Registre
        - Action : Mettre à jour
        - Ruche : HKEY_LOCAL_MACHINE
        - Chemin d'accès de la clé : SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp
        - Nom de la valeur : PortNumber
        - Type de valeur : REG_DWORD
        - Données de la valeur : 31174 (votre port personnalisé)
        - Base : Décimal
- Lier la GPO
    - Sélectionner l'OU à laquelle vous souhaitez lier la GPO (pour nous PgComputers) > Clic droit > Link to an existing GPO > choisir la GPO.
    - Group Policy Management > Group Policy Objects > Sélectionner la GPO
        - Scope : PgComputers ;
        - Security Filtering : Domain Computers, Domain Controllers ;
        - Details : GPO Status - User Configuration settings disabled, puisqu'il s'agit d'une configuration ordinateur ;
     
- Si nécessaire, pensez à autoriser le flux sur le nouveau port RDP dans votre pare-feu pour une connexion depuis l'extérieur.
