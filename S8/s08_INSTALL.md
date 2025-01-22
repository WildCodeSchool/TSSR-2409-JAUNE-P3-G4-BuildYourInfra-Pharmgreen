# Mise en place Serveur Mise à Jour
Installation sur VM dédiée
Les groupes dans WSUS sont liés à l'AD
Les MAJ sont liées aux OU
"Gérer différemment les MAJ pour :
1. Les clients"
    2. Les serveurs
3. Les DC

___
# Partager les rôles FSMO entre les DC
- Une fois nos serveurs Active Directory mis en place et promus en tant que Contrôleurs de Domaine, on peut partager entre eux les rôles FSMO.
- On se connecte alors sur l'un des serveurs et on ouvre une session PowerShell en tant qu'administrateur :
  - On utilise la commande `Move-ADDirectoryServerOperationMasterRole` pour migrer les rôles ;
  - Deux options seront nécessaires :
    - `-Identity` suivi du nom de machine du serveur vers lequel on souhaite migrer le rôle ;
    - `-OperationMasterRole` suivi du rôle que l'on souhaite transférer :
      - `PDCEmulator` ou `0`
      - `RIDMaster` ou `1`
      - `InfrastructureMaster` ou `2`
      - `SchemaMaster` ou `3`
      - `DomainNamingMaster` ou `4`
  - Ce qui nous donne :
``` Powershell
Move-ADDirectoryServerOperationMasterRole -Identity SRVAD2 -OperationMasterRole DomainNamingMaster
Move-ADDirectoryServerOperationMasterRole -Identity SRVAD3 -OperationMasterRole PDCEmulator
Move-ADDirectoryServerOperationMasterRole -Identity SRVAD4 -OperationMasterRole RIDMaster
Move-ADDirectoryServerOperationMasterRole -Identity SRVAD5 -OperationMasterRole InfrastructureMaster
```
- Le Rôle de Maître de Schéma est conservé par SRVAD1.
- On vérifie dans un cmd avec la commande `netdom query fsmo`
- On obtient alors :
``` cmd
C:\Windows\system32>netdom query fsmo
Schema master            SRVAD1.pharmgreen.lan
Domain naming master     SRVAD2.pharmgreen.lan
PDC                      SRVAD3.pharmgreen.lan
RID pool manager         SRVAD4.pharmgreen.lan
Infrastructure master    SRVAD5.pharmgreen.lan
The command completed successfully.
```
    
