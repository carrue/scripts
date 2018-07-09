<#
Carlos Ruesta
05/11/2018

Description 
1) Pulls privilege domain groups

#>

#Default Variables to Use for all my scripts
Import-Module activedirectory
$path="c:\PS_Script\Dump\"
$date = get-date -f yyyyMMdd
$forest = Get-ADforest | Select rootdomain 
$domains= Get-ADforest | Select domains
$ErrorActionPreference= 'silentlycontinue' #This variable stops error from appearing during execution.

#Create new variables here
$domain_priv_groups = 'Administrators',
                      'Enterprise Admins',
                      'Schema Admins',
                      'Domain Admins',
                      'Server Operators',
                      'Account Operators',
                      'Backup Operators'


foreach ($domain in $domains.domains){
    $result = foreach($domain_priv_group in $domain_priv_groups){
        try {
            Get-ADGroupMember $domain_priv_group -server $domain | sort ObjectClass | Select @{Label="Server";Expression={$domain}},@{Label="Group Name";Expression={$domain_priv_group}},SamAccountName,name,objectClass | Export-Csv -append $path\Privilege_Users"_"$date.csv -NoTypeInformation
            Write-Host $domain  " | " $domain_priv_group " found" -ForegroundColor Green
            }
            catch { 
                Write-Host $domain  " | " $domain_priv_group " not found" -ForegroundColor Red
                }
        }
           
    }

        