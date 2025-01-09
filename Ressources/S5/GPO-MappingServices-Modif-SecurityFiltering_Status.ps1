################################################
#                                              #
#    Modification Security Filtering de GPO    #
#          Modification GPO Status             #
#                                              #
################################################

# Ajout des Domain Computers dans les Security Filtering
get-gpo -all -Domain "pharmgreen.lan" | Where-Object {$_.DisplayName -match "user-mappage-service*"} | Set-GPPermissions -PermissionLevel None -TargetName "Authenticated Users" -TargetType Group
# Retrait des Authenticated Users des Security Filtering
get-gpo -all -Domain "pharmgreen.lan" | Where-Object {$_.DisplayName -match "user-mappage-service*"} | Set-GPPermissions -PermissionLevel GpoApply -TargetName "Domain Computers" -TargetType Group


$GPOs = get-gpo -all -Domain "pharmgreen.lan" | Where-Object {$_.DisplayName -match "user-mappage-service*"}

# Modification du GPO Status pour désactiver les paramètres Ordinateur
foreach ($GPO in $GPOs)
{
    $GPO.GpoStatus="ComputerSettingsDisabled"
}