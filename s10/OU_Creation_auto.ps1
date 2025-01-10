Clear-Host
####################################################################################################
#                                                                                                  #
#   Création OU automatiquement avec fichier (avec suppression protection contre la suppression)   #
#                                                                                                  #
####################################################################################################

### Initialisation

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$DomainDN = (Get-ADDomain).DistinguishedName

### Parametre(s) à modifier

$File = "$FilePath\OU_Creation_auto.txt"

### Main

function CreateOU
{
   param ([Parameter(Mandatory=$True, Position=0)][String]$OU,
            [Parameter(Mandatory=$True, Position=1)][ValidateSet("OU PgUsers","OU PgUsers/Communication","OU PgUsers/DirectionFinanciere","OU PgUsers/DirectionMarketing","OU PgUsers/R&D","OU PgUsers/RH","OU PgUsers/Juridique","OU PgUsers/SG","OU PgUsers/SystemesInformation","OU PgUsers/VDC")][String]$SearchBase)
    
    Switch ($SearchBase)
    {
        "OU PgUsers" {$DNSearchBase = "OU=PgUsers,$DomainDN"}
        "OU PgUsers/Communication" {$DNSearchBase = "OU=Communication,OU=PgUsers,$DomainDN"}
        "OU PgUsers/DirectionFinanciere" {$DNSearchBase = "OU=DirectionFinanciere,OU=PgUsers,$DomainDN"}
        "OU PgUsers/DirectionMarketing" {$DNSearchBase = "OU=DirectionMarketing,OU=PgUsers,$DomainDN"}
        "OU PgUsers/R&D" {$DNSearchBase = "OU=R&D,OU=PgUsers,$DomainDN"}
        "OU PgUsers/RH" {$DNSearchBase = "OU=RH,OU=PgUsers,$DomainDN"}
        "OU PgUsers/Juridique" {$DNSearchBase = "OU=Juridique,OU=PgUsers,$DomainDN"}
        "OU PgUsers/SG" {$DNSearchBase = "OU=SG,OU=PgUsers,$DomainDN"}
        "OU PgUsers/SystemesInformation" {$DNSearchBase = "OU=SystemesInformation,OU=PgUsers,$DomainDN"}
        "OU PgUsers/VDC" {$DNSearchBase = "OU=VDC,OU=PgUsers,$DomainDN"}

        default {$DNSearchBase = "OU=LabUtilisateurs,$DomainDN"}
    }

    If((Get-ADOrganizationalUnit -Filter {Name -like $ou} -SearchBase $DNSearchBase) -eq $Null)
    {
        New-ADOrganizationalUnit -Name $OU -Path $DNSearchBase
        $OUObj = Get-ADOrganizationalUnit "ou=$OU,$DNSearchBase"
        $OUObj | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion:$False
        Write-Host "Création de l'OU $($OUObj.DistinguishedName)" -ForegroundColor Green
    }
    Else
    {
        Write-Host "L'OU `"ou=$OU,$DNSearchBase`" existe déjà" -ForegroundColor Red
    }
}

If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}

$OUs = Import-Csv -Path $File -Delimiter ";" -Header "OUServices","OUPrincipales"

Foreach ($OU in $OUs)
{
    CreateOU -OU $OU.OUServices -SearchBase $OU.OUPrincipales
}

