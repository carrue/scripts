# Data For Matrix
# - PS1 creates file dump
# - Use excel to create matrix. 

Import-Module activedirectory
$date = get-date -f yyyyMMdd
Import-Module activedirectory
$path="c:\PS_Script\Output\"
$date = get-date -f yyyyMMdd
$forest = Get-ADforest | Select rootdomain 
$domains= Get-ADforest | Select domains
$ErrorActionPreference= 'silentlycontinue' #This variable stops error from appearing during execution.
$domain_priv_groups = 'Administrators','Domain Admins','Enterprise Admins','Schema Admins','Account Operators','Server Operators','Backup Operators','Print Operators','Role_OMT_NA_Global','Role_OMT_NA_Local','Elite_Support','Elite_Developers','PS_Developers','Ntirety Contractor Access'
          
foreach ($domain in $domains.domains){
    foreach($domain_priv_group in $domain_priv_groups){
        Get-ADGroupMember $domain_priv_group -Recursive -server $domain | 
            where {$_.objectclass -eq 'user'} |
            Get-ADUSer -properties SamAccountName,Name,Displayname,Description,Department,Enabled,LastLogonDate |
            Select @{Label="Domain";Expression={$domain}},@{Label="Group Name";Expression={$domain_priv_group}},SamAccountName,Name,Displayname,Description,Department,Enabled,LastLogonDate | Export-Csv -append $path\QAR"_"$date.csv -NoTypeInformation
        }
    }  



