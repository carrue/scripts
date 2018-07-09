<#
Carlos Ruesta
05/15/2018

Description
1) Pulls AD Users that are enabled. 
2) Circles through the different domains.
3) Only pulls accounts that are enabled

#>

Import-Module activedirectory
$date = get-date -f yyyyMMdd
Import-Module activedirectory
$path="c:\PS_Script\Dump\"
$date = get-date -f yyyyMMdd
$forest = Get-ADforest | Select rootdomain 
$domains= Get-ADforest | Select domains


foreach ($domain in $domains.domains){
    try {
            # This one pulls both enabled and disabled
            # Get-ADUser -filter * -server $domain -Properties SamAccountName,DisplayName,EmployeeID,Name,Description,EmailAddress,Enabled,AccountExpirationDate,LastLogonDate,PasswordLastSet,PasswordNeverExpires,whencreated | Select @{Label="Domain";Expression={$domain}},SamAccountName,DisplayName,EmployeeID,Name,Description,EmailAddress,Enabled,AccountExpirationDate,LastLogonDate,PasswordLastSet,PasswordNeverExpires,whencreated |Export-csv -append $path\AD_Users_$date.csv -NoTypeInformation
            
            #This one pulls only enabled
            Get-ADUser -filter {Enabled -eq $true} -server $domain -Properties SamAccountName,DisplayName,EmployeeID,Name,Description,EmailAddress,Enabled,AccountExpirationDate,LastLogonDate,PasswordLastSet,PasswordNeverExpires,whencreated | Select @{Label="Domain";Expression={$domain}},SamAccountName,DisplayName,EmployeeID,Name,Description,EmailAddress,Enabled,AccountExpirationDate,LastLogonDate,PasswordLastSet,PasswordNeverExpires,whencreated |Export-csv -append $path\AD_Users_$date.csv -NoTypeInformation
            Write-Host $domain  " exporting list of users" -ForegroundColor Green
            }
            catch { 
                Write-Host $domain  " unable to export list" -ForegroundColor Red
                }
        }
          

