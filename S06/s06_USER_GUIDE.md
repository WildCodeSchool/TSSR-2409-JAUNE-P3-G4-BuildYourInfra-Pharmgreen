# SUPERVISION - Mise en place d'une supervision de l'infrastructure réseau
## Ajout d'un capteur
- Sur le portail web > Onglet `Capteurs` > `Ajouter un capteur`
- Ajouter un capteur :
  - Sélectionner un équipement auquel ajouter le nouveau capteur : `Créer un nouvel équipement`
  - `Continuer`
- Ajouter un équipement : 
  - Choisissez un groupe pour l'ajout du nouvel équipement :  `Ajouter un équipement à un groupe déjà existant`
  - Sélectionner un groupe dans la liste : Choisir dans l'arborescence en-dessous l'emplacement où apparaîtra la capteur
  - `Continuer`
- Ajouter un équipement au <groupe choisi> :
  - Paramétrages de base de l'équipement :
    - Nom de l'équipement : Nom sous lequel apparaîtra l'équipement dans la supervision ;
    - Version IP : `IPv4`
    - Adresse IPv4 : Renseigner l'adresse IPv4 de l'équipement à surveiller ;
    - Balises : *Optionnel*
  - Paramètres de la découverte automatique :
    - Niveau de la découverte automatique : `Découverte automatique par défaut`
  - `Ajouter`

## Mise en place de dashboard
- Sur le portail web > Onglet `Cartes` > `Ajouter une carte`
- Ajouter une carte :
  - Nom de la carte : `Nom que vous souhaitez pour votre dashboard`
  - Disposition de la carte : Valeurs recommandées `1600 x 600`
  - Accès de la carte : `Aucun accès au public`
- Création de cartes
  - Glisser-déposer les différents équipements à observer depuis l'arborescence d'équipements (à gauche), sur la carte (au centre), et les personnaliser avec les icônes (à droite)
