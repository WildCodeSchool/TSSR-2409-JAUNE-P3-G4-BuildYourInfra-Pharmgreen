################################################
#                                              #
#     Création des dossiers individuels        #
#           des utilisateurs AD                #
#                                              #
################################################

$Users = (Get-ADUser -Filter * | Select-Object -ExpandProperty SamAccountName -Skip 3)
Foreach ($User in $Users)
{
    # Récupération du Nom de l'utilisateur pour le nom du répertoire
    $Name = (Get-ADUser -Filter * | Where-Object { $_.Samaccountname -Match "$User" }).SamAccountName

    # Définition du Chemin réseau où créer le répertoire
    $Path = "\\srvprod\Pharmgreen\00_Commun\002_Dossiers Individuels\$Name"

    # Création du répertoire
    New-Item -ItemType Directory -Path $Path

    # Allocation des droits Full Control à l'utilisateur sur son dossier
    $ACL = Get-Acl -Path $Path
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("PHARMGREEN\$Name","FullControl","Allow")
    $ACL.SetAccessRule($AccessRule)
    $ACL | Set-Acl -Path $Path
    (Get-Acl -Path $Path).Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize

    # Changement de propriétaire sur le dossier individuel
    $ACL = Get-Acl -Path $Path
    $Owner = New-Object System.Security.Principal.NTAccount("PHARMGREEN\$Name")
    $ACL.SetOwner(($Owner)
    $ACL | Set-Acl -Path $Path
    Get-Acl -Path $Path
    
}