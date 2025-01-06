Clear-Host
#######################################
#                                     #
#   Création GROUPE automatiquement   #
#                                     #
#######################################

### Parametre(s) à modifier

$OuPgSecurity = "PgSecurityGroups"
$Groups = "GrpComputersCOM","GrpComputersFIN","GrpComputersDGE","GrpComputersMAR","GrpComputersR&D","GrpComputersRH",`
        "GrpComputersJUR","GrpComputersSGE","GrpComputersSIC","GrpComputersVDC",`
        "GrpUsersCOM","GrpUsersFIN","GrpUsersDGE","GrpUsersMAR","GrpUsersR&D","GrpUsersRH","GrpUsersJUR","GrpUsersSGE","GrpUsersSIC","GrpUsersVDC",`
        "GrpUsersCOMPublicite","GrpUsersCOMRPP","GrpUsersFINComptabilite","GrpUsersFINControleGestion","GrpUsersFINFinance","GrpUsersMARDigital",`
        "GrpUsersMAROperationnel","GrpUsersMARProduit","GrpUsersMARStrategique","GrpUsersR&DInnovationStrategie","GrpUsersR&DLaboratoire",`
        "GrpUsersRHFormation","GrpUsersRHGestionPerformances","GrpUsersRHRecrutement","GrpUsersRHSST","GrpUsersJURContrats","GrpUsersJURContentieux",`
        "GrpUsersSGEGestionImmobiliere","GrpUsersSGELogistique","GrpUsersSICData","GrpUsersSICDevLogiciel","GrpUsersVDCAchat","GrpUsersVDCADV",`
        "GrpUsersVDCB2B","GrpUsersVDCB2C","GrpUsersVDCDevInternational","GrpUsersVDCGrandsComptes","GrpUsersVDCClient"

### Initialisation

$DomainDN = (Get-ADDomain).DistinguishedName

### Main program

Foreach ($Group in $Groups)
{
    Try
    {
        New-AdGroup -Name $Group -Path "ou=$OuPgSecurity,$DomainDN" -GroupScope Global -GroupCategory Security
        Write-Host "Création du GROUPE $Group dans l'OU ou=$OuPgSecurity,$DomainDN"-ForegroundColor Green
    }
    Catch
    {
        Write-Host "Le GROUPE $Group existe déjà" -ForegroundColor Yellow -BackgroundColor Black
    }
}
