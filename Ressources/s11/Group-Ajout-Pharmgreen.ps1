Clear-Host
###############################################
#                                             #
#   Remplissage des groupes automatiquement   #
#                                             #
###############################################

# Initialisation
$DomainDN = (Get-ADDomain).DistinguishedName

# Pour chaque membre d'une OU, on l'ajoute au groupe correspondant
# Communication
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match Publicite | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersCOMPublicite -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match RPP | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersCOMRPP -Members $_}

# Direction Financière
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match Comptabilite | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersFINComptabilite -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match ControleGestion | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersFINControleGestion -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match Finance | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersFINFinance -Members $_}


# Direction Générale
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match DirectionGenerale | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersDGE -Members $_}

# Marketing
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match Digital | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersMARDigital -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match Operationnel | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersMAROperationnel -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match Produit | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersMARProduit -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match Strategique | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersMARStrategique -Members $_}

# Service Juridique
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match Contrats | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersJURContrats -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match Contentieux | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersJURContentieux -Members $_}

# R&D
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match Innovation | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity "GrpUsersR&DInnovationStrategie" -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match Laboratoire | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity "GrpUsersR&DLaboratoire" -Members $_}

# RH
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match Formation | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersRHFormation -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match GestionPerformances | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersRHGestionPerformances -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match Recrutement | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersRHRecrutement -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match SST | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersRHSST -Members $_}

# Services Généraux
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match GestionImmobiliere | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersSGEGestionImmobiliere -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match Logistique | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersSGELogistique -Members $_}

# Systèmes d'Information
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match "Data" | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersSICData -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match DevLogiciel | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersSICDevLogiciel -Members $_}

# Ventes et Dvlpt Commercial
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match Achat | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersVDCAchat -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match ADV | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersVDCADV -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match B2B | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersVDCB2B -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match B2C | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersVDCB2C -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match DevInternational | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersVDCDevInternational -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match GrandsComptes | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersVDCGrandsComptes -Members $_}
Get-ADUser -Filter * -SearchBase "OU=PgUsers,$DomainDN" | Where-object -Property DistinguishedName -match ServiceClient | Select-Object -ExpandProperty SamAccountName | `
ForEach {Add-ADGroupMember -Identity GrpUsersVDCClient -Members $_}

