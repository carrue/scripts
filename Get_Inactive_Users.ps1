<#
Carlos Ruesta
05/11/2018

Description 
1) Pull users that have not logged on in 90 days
#>

#Default Variables to Use for all my scripts
Import-Module activedirectory
$path="c:\PS_Script\Dump\"
$date = get-date -f yyyyMMdd
$forest = Get-ADforest | Select rootdomain 
$domains= Get-ADforest | Select domains
$ErrorActionPreference= 'silentlycontinue' #This variable stops error from appearing during execution.
$DaysInactive = 90  
$time = (Get-Date).Adddays(-($DaysInactive)) 

foreach ($domain in $domains.domains){
    try {
        Get-ADUser -Filter {LastLogonTimeStamp -lt $time -and enabled -eq $true} -server $doamin -Properties LastLogonTimeStamp,DisplayName,Description,whenCreated,AccountExpirationDate,LastLogonDate | select-object @{Label="Server";Expression={$domain}},SamAccountName,DisplayName,Name,Description,whencreated,AccountExpirationDate,LastLogonDate,@{Label="Days Inactive";Expression={$_.lastLogonDate-(Get-Date)}} | export-csv $path\InactiveUser$date.csv -notypeinformation
        Write-Host $domain  " | Pulling users that have not logged 90+ days" -ForegroundColor Green}
        catch { 
            Write-Host $domain  " | No users found that have not logged in 90+ days" -ForegroundColor Red}
}
