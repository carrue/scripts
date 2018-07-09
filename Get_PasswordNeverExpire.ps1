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
            
            Get-ADUser -filter {Enabled -eq $true -and PasswordNeverExpires -eq $true} -server $domain -Properties SamAccountName,Name,Department,Description,LastLogonDate,PasswordLastSet,PasswordNeverExpires,whencreated,Enabled | Select @{Label="Domain";Expression={$domain}},SamAccountName,Name,Description,Department,whencreated,PasswordLastSet,LastLogonDate,PasswordNeverExpires,Enabled |Export-csv -append $path\PasswordNeverExpires_$date.csv -NoTypeInformation
            Write-Host $domain  " exporting list of users" -ForegroundColor Green
            }
            catch { 
                Write-Host $domain  " unable to export list" -ForegroundColor Red
                }
        }
        