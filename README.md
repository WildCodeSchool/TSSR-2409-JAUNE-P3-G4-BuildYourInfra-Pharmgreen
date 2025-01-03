# TSSR-2409-JAUNE-P3-G4-BuildYourInfra-Pharmgreen

## **Sommaire**

1. Présentation du Projet et Objectifs
2. Mise en contexte
3. Présentation des membres du groupe et rôles par Sprint
4. Choix techniques, contraintes et solutions
5. Conclusion

## **Présentation du Projet et Objectifs**

Le Projet **_Build Your Infra_** consiste à analyser l'infrastructure réseau actuelle de la société et à proposer un plan d'amélioration. L'objectif principal est de créer une architecture réseau efficace et évolutive en tenant compte des besoins à court et long terme de l'entreprise. Le projet se déroule sur plusieurs sprints, avec des livrables définis à chaque étape, permettant d'ajuster l'infrastructure en fonction des priorités et des contraintes identifiées.

## **Mise en contexte**

Notre équipe a été sollicitée par l'entreprise fictive **Pharmgreen** pour redéfinir et mettre en place son infrastructure réseau. L'entreprise fait face à une gestion inefficace de son réseau interne et de ses serveurs, avec des difficultés d'accès et de gestion centralisée. Notre mission est donc de concevoir une solution robuste, sécurisée et évolutive qui supporte les besoins actuels et futurs de Pharmgreen.

Dans ce contexte, **Matt** et **P.A.** sont les membres du groupe chargés de déployer l'infrastructure et de mettre en œuvre les différentes solutions proposées.

## **Présentation des membres du groupe et rôles par Sprint**

Le groupe est composé de :
- **P.A.** – Chef de Projet (PO) et Scrum Master (SM).
- **Matt** – Chef de Projet (PO) et Scrum Master (SM).

## **Choix techniques, contraintes et solutions**

### **Choix techniques**
- Mise en place d'un serveur **Active Directory** pour centraliser la gestion des utilisateurs et des ressources.
- Déploiement de VLAN pour segmenter le réseau en fonction des besoins des différents services de l'entreprise (administration, marketing, développement etc.).
- Mise en place de **serveurs de production et de sauvegarde** pour garantir une gestion centralisée des documents et des partages sécurisés.
- Installation de **PfSense** comme pare-feu pour assurer la sécurité de l'accès au réseau interne et la gestion du trafic entrant/sortant.

### **Contraintes**
- **Sécurité** : La priorité a été de s'assurer que le réseau soit sécurisé dès le début du projet (filtrage IP, règles de pare-feu).
- **Performance** : Assurer une faible latence et une haute disponibilité des services critiques.
- **Évolutivité** : Le réseau doit être modulable pour intégrer de nouveaux services dans le futur (ex. ajout de serveurs Web, bases de données, etc.).

### **Solutions**
- **Raid 1**
- Mise en place de **scripts d'automatisation**
- Utilisation de **Proxmox** pour la gestion des machines virtuelles

## **Conclusion**

À la fin de ce projet, nous avons réussi à mettre en place une infrastructure réseau solide et évolutive pour **Pharmgreen**. Le réseau est désormais segmenté, sécurisé et optimisé pour répondre aux besoins actuels tout en restant adaptable à de futures extensions.

Les principaux livrables de ce projet incluent :
- **architecture réseau** avec des VLANs et une segmentation appropriée.
- **solution de sécurité** complète incluant des pare-feu, des VPN, et des stratégies de contrôle d'accès.
- **scripts d'automatisation** pour faciliter la gestion des utilisateurs et des configurations.

Le projet s'est déroulé en étroite collaboration entre les membres de l'équipe et nous avons bien respecté les délais, tout en maintenant un haut niveau de qualité dans la conception de l'infrastructure.

---
