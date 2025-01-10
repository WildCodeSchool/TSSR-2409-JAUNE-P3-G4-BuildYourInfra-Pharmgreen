################################################
#                                              #
#   Création de GPO liée à une OU spécifique   #
# et ajoutant un groupe aux Security Filtering #
#                                              #
################################################

# Fichier de configuration
$File = ".\Services.csv"

# Import du Fichier
$GPOs = Import-Csv -Path "$File" -Delimiter "," -Header "Service","OU","Groupe"

# Boucle de création des GPOs
foreach ($GPO in $GPOs)
{
    # Définition des variables
    $Service = $GPO.Service
    $OU = $GPO.OU
    $Groupe = $GPO.Groupe

    # Création de la GPO / Lien dans l'OU / Ajout du Security Filtering
    New-GPO -Name "User-Mappage-Service-$Service-v1" | New-GPLink -Target "$OU" | Set-GPPermissions -PermissionLevel GpoApply -TargetName "$Groupe" -TargetType Group
}