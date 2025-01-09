################################################
#                                              #
#         Refuser le droit de supprimer        #
#           les dossiers individuels           #
#                                              #
################################################

# Récupération de la liste des dossiers individuels
$RepList = Get-ChildItem '\\srvprod\Pharmgreen\00_Commun\002_Dossiers Individuels\'
# Récupération du groupe des utilisateurs standards
$GrpStandard = (Get-ADGroup -Filter * | ?{$_.name -match "grpuserspharmgreenstandards"}).Name

# Boucle d'ajout d'une règle sur chaque dossier de la liste
foreach ($RepIndiv in $RepList)
{
    $Path = "\\srvprod\Pharmgreen\00_Commun\002_Dossiers Individuels\$RepIndiv"    $ACL = Get-Acl -Path $Path    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$GrpStandard","Delete","Deny")    $ACL.SetAccessRule($AccessRule)    $ACL | Set-Acl -Path $Path    (Get-Acl -Path $Path).Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize}