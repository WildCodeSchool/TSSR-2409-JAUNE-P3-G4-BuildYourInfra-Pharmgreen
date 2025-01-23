######################################################################################################
#                                                                                                    #
#                             Déplacer PCs automatiquement avec fichier                              #
#                                                                                                    #
######################################################################################################

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$DomainDN = (Get-ADDomain).DistinguishedName
$Domain   = (Get-ADDomain).Forest
$PCContainer = "CN=Computers,$DomainDN"

### Parametre(s) à modifier

$File = "$FilePath\PC_DeplacementOU.csv"

### Main program

Clear-Host
If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}

# Civilite,Prenom,Nom,Societe,Site,Departement,Service,fonction,ManagerPrenom,ManagerNom,PC,DateNaissance,TelephoneFixe,TelephonePortable,Nomadisme

$PCs = Import-Csv -Path $File -Delimiter "," -Header "Service","PC"
$ADComputers = Get-ADComputer -Filter *
$count = 1
Foreach ($PC in $PCs)
{
    Write-Progress -Activity "Déplacement des PCs dans l'OU" -Status "%effectué" -PercentComplete ($Count/$PCs.Length*100)
    $Name              = "CLI-" + "$($PC.Service)" + "-" + "$($PC.PC)"
    $DNSHostName       = "$Name.$Domain"
    $Service           = $PC.Service
    $GUID              = (Get-ADComputer $Name).objectguid 
    $Origin            = Get-ADComputer $Name
    Switch ( $Service )
    {
        "COM" { $Path = "OU=Communication,OU=Clients,OU=PgComputers,$DomainDN" }
        "FIN" { $Path = "OU=DirectionFinanciere,OU=Clients,OU=PgComputers,$DomainDN" }
        "DGE" { $Path = "OU=DirectionGenerale,OU=Clients,OU=PgComputers,$DomainDN" }
        "MAR" { $Path = "OU=DirectionMarketing,OU=Clients,OU=PgComputers,$DomainDN" }
        "RD" { $Path = "OU=R&D,OU=Clients,OU=PgComputers,$DomainDN" }
        "RH" { $Path = "OU=RH,OU=Clients,OU=PgComputers,$DomainDN" }
        "JUR" { $Path = "OU=ServiceJuridique,OU=Clients,OU=PgComputers,$DomainDN" }
        "SGEN" { $Path = "OU=ServicesGeneraux,OU=Clients,OU=PgComputers,$DomainDN" }
        "SIC" { $Path = "OU=SystemesInformation,OU=Clients,OU=PgComputers,$DomainDN" }
        "VDC" { $Path = "OU=VenteEtDeveloppementCommercial,OU=Clients,OU=PgComputers,$DomainDN" }
    }
    
    If (($ADComputers | Where {$_.Name -eq $Name}) -eq $Null)
    {
        Write-Host "Le PC $Name n'existe pas" -ForegroundColor Red
    }
    Else
    {
        $Origin | Move-ADObject -TargetPath $Path
        
        Write-Host "Déplacement du PC $Name effectué vers l'OU $Service" -ForegroundColor Green
    }
    $Count++
    sleep -Milliseconds 100
}