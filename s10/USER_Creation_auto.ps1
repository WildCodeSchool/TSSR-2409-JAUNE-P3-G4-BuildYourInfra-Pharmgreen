######################################################################################################
#                                                                                                    #
#   Création USER automatiquement avec fichier (avec suppression protection contre la suppression)   #
#                                                                                                    #
######################################################################################################

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$DomainDN = (Get-ADDomain).DistinguishedName

### Parametre(s) à modifier

$File = "$FilePath\s01_Pharmgreen - Liste Personnel.txt"

### Main program

Clear-Host
If (-not(Get-Module -Name activedirectory))
{
    Import-Module activedirectory
}

# Civilite,Prenom,Nom,Societe,Site,Departement,Service,fonction,ManagerPrenom,ManagerNom,PC,DateNaissance,TelephoneFixe,TelephonePortable,Nomadisme

$Users = Import-Csv -Path $File -Delimiter "," -Header "Civilite","Prenom","Nom","Societe","Site","Departement","Service","fonction","ManagerPrenom","ManagerNom","PC","DateNaissance","TelephoneFixe","TelephonePortable","Nomadisme"
$ADUsers = Get-ADUser -Filter * -Properties *
$count = 1
Foreach ($User in $Users)
{
    Write-Progress -Activity "Création des utilisateurs dans l'OU" -Status "%effectué" -PercentComplete ($Count/$Users.Length*100)
    $Name              = "$($User.nom) $($User.prenom)"
    $DisplayName       = "$($User.prenom) $($User.nom)"
    $SamAccountName    = "$($User.Prenom.tolower())" + "." + "$($User.Nom.ToLower())"
    $UserPrincipalName = (($User.prenom.tolower() + "." + $User.nom.ToLower()) + "@" + (Get-ADDomain).Forest)
    $GivenName         = $User.Prenom
    $Surname           = $User.Nom
    $OfficePhone       = $User.TelephoneFixe
    $MobilePhone       = $User.TelephonePortable
    $EmailAddress      = $UserPrincipalName
    If ( $User.Service -eq "-" )
        {
        $Path              = "ou=$($User.Departement),ou=PgUsers,$DomainDN"
        }
    Else
        {
        $Path              = "ou=$($User.Service),ou=$($User.Departement),ou=PgUsers,$DomainDN"
        }
    $Company           = $User.Societe
    $JobTitle          = $User.fonction
    $Department        = "$($User.Departement) - $($User.Service)"
    
    If (($ADUsers | Where {$_.SamAccountName -eq $SamAccountName}) -eq $Null)
    {
        New-ADUser -Name $Name -DisplayName $DisplayName -SamAccountName $SamAccountName -UserPrincipalName $UserPrincipalName -Description $JobTitle `
        -GivenName $GivenName -Surname $Surname -OfficePhone $OfficePhone -MobilePhone $MobilePhone -EmailAddress $EmailAddress -Title $JobTitle `
        -Path $Path -AccountPassword (ConvertTo-SecureString -AsPlainText Azerty1* -Force) -Enabled $True `
        -OtherAttributes @{Company = $Company;Department = $Department} -ChangePasswordAtLogon $True

        Write-Host "Création du USER $SamAccountName" -ForegroundColor Green
    }
    Else
    {
        Write-Host "Le USER $SamAccountName existe déjà" -ForegroundColor Black -BackgroundColor Yellow
    }
    $Count++
    sleep -Milliseconds 100
}