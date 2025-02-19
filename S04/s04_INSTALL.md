# Gestion Pare-Feux
## Paramétrage de la VM pfSense
- Nom de la VM : **G4-pfsense-P3** (renommage possible)
- Interfaces réseau :

| Type de sortie pfSense | Nom interface Proxmox | Adresse réseau | Adresse IP       | Passerelle (si existence) | Rmq                  |
| ---------------------- | --------------------- | -------------- | ---------------- | ------------------------- | -------------------- |
| WAN                    | vmbr1                 | 10.0.0.0/29    | 10.0.0.3/29      | 10.0.0.1                  | Ne pas changer l'@IP |
| LAN                    | vmbr655               | 10.15.0.0/16   | 10.15.255.254/16 | -                         | Accès console web    |
| DMZ                    | vmbr670               | 10.17.0.0/16   | 10.17.255.254/16 | -                         | -                    |

## Paramétrage règles du pare-feu
- Sur un serveur graphique, ouvrir un navigateur web > `https://10.15.255.254` pour accéder à la console web de psSense
- Un message d'erreur apparaît : `Advanced` > `Continue to 10.15.255.254`
- Connexion : `admin` / `P0se!don` (Mot de passe classique de formation à remettre)
	- Si le mot de passe ne fonctionne pas, à remettre à 0 en CLI
- Onglet `Firewall` > `Rules`
- Dans chaque section WAN / LAN / DMZ :
  - Générer une règle (ou modifier une règle existante) pour autoriser tous le trafic en IPv4 sur chaque protocole
    - Action : `Pass`
    - Interface : *selon l'interface en cours de configuration*
    - Address Family : `IPv4`
    - Protocol : `Any`
  - Ces règles ne sont pas sécurisées mais permettent un accès internet et une communication interne pour le moment. Elles devront être modifiées par la suite.

___

# Gestion de la télémétrie sur les clients Windows 10/11
## Configurer la GPO
- Créez une GPO nommée : Computer-Configuration-Telemetry-Deactivate-v1.
- Faites un clic droit sur la GPO et sélectionnez Edit.
- Chemin : Computer Configuration > Policies > Administrative Templates > Windows Components > Data Collection and Preview Builds.
- Paramètres à configurer : Allow Diagnostic Data : Disabled.

## Lier la GPO
- Group Policy Management > Group Policy Objects > Sélectionner la GPO
- Scope : PgComputers
- Security Filtering : Domain Computers, Domain Controllers, GrpUsersPharmgeenTous ;
- Details : GPO Status - User Configuration settings disabled, puisqu'il s'agit d'une configuration ordinateur ;
- Sélectionner l'OU à laquelle vous souhaitez lier la GPO (pour nous PgComputers) > Clic droit > Link to an existing GPO > choisir la GPO.

___

# Amélioration de l'infrastructure Proxmox avec des routeurs
Utilisation de template de routeurs Vyos
- Sur Proxmox : Ajouter un total de 5 interfaces réseau LAN entreprise
- Sur la console du routeur :
```
  # Remplacer la disposition clavier en Azerty
  conf
  set system option keyboard-layout fr
  commit
  save

  # Configurer Interface vers Pare-feu
  conf
  set interfaces ethernet eth0 address 10.15.255.253/24
  commit
  save

  # Configurer les interfaces vers les postes clients
  ## Interface eth1
  conf
  set interfaces ethernet eth1 address 10.15.10.254/24
  set interfaces ethernet eth1 address 10.15.20.254/24    # Ajouter plusieurs adresses à la même interface permet de générer un trunk
  set interfaces ethernet eth1 address 10.15.30.254/24    # Une même interface se retrouve donc avec plusieurs adresses IP et
                                                          # atteindra différents réseaux
  commit
  ## Interface eth2
  set interfaces ethernet eth2 address 10.15.40.254/24
  set interfaces ethernet eth2 address 10.15.50.254/24    # Ajouter plusieurs adresses à la même interface permet de générer un trunk
  set interfaces ethernet eth2 address 10.15.60.254/24    # Une même interface se retrouve donc avec plusieurs adresses IP et
                                                          # atteindra différents réseaux
  commit
  ## Interface eth3
  set interfaces ethernet eth3 address 10.15.70.254/24
  set interfaces ethernet eth3 address 10.15.80.254/24    # Ajouter plusieurs adresses à la même interface permet de générer un trunk
  set interfaces ethernet eth3 address 10.15.90.254/24    # Une même interface se retrouve donc avec plusieurs adresses IP et
                                                          # atteindra différents réseaux
  set interfaces ethernet eth3 address 10.15.100.254/24
  commit
  save

  # Configurer l'interface vers les Serveurs et Conteneurs
  conf
  set interfaces ethernet eth4 address 10.15.190.254/24
  set interfaces ethernet eth4 address 10.15.200.254/24
  commit
  save
  exit

  # Vérifier la bonne acquisition des adresses IP
  show interfaces

  # Paramétrer routage vers Internet
  conf
  set protocols static route 0.0.0.0/0 next-hop 10.15.255.254    # Indique que pour rejoindre un autre réseau que ceux déjà configurés,
                                                                 # transférer les transmissions vers l'interface LAN du pare-feu

  ####  Pas besoin d'établir d'autre routes, chaque sous-réseau étant déjà connecté 
  ####  directement à l'une des interfaces du routeur, il les trouve de lui-même

  commit
  save
  exit
  show ip route    # Permet de vérifier les tables de routage

  # Paramétrer ip-helper pour DHCP
  conf
  set service dhcp-relay enable
  set service dhcp-relay listen-interface eth1      # le routeur s'attend à recevoir des demandes DHCP-DORA sur ces interfaces
  set service dhcp-relay listen-interface eth2
  set service dhcp-relay listen-interface eth3
  set service dhcp-relay upstream-interface eth4    # le routeur s'attend à recevoir des réponses du serveur DHCP sur cette interface
  commit
  save
  exit
  show service dhcp-relay                           # Vérifier la configuration ip-helper

  # Activer le service SSH pour une prise en main à distance
  conf
  set service ssh port 22222
  commit
  save
  exit
```
