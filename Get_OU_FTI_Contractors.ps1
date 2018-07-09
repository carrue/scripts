<#
Carlos Ruesta
05/15/2018

Description
1) Pull of group members from OU FTI_Contractors for each domain

#>

Import-Module activedirectory
$path="c:\PS_Script\Dump\"
$date = get-date -f yyyyMMdd


Get-ADUser -filter 'enabled -eq $true' -server fti.local -SearchBase “OU=FTI_Contractors,DC=fti,DC=local” -Properties SamAccountName,DisplayName,Name,Description,Enabled,whencreated,AccountExpirationDate | Select @{Label="Sever";Expression={"NA.FTI.LOCAL"}},SamAccountName,DisplayName,Name,Description,Enabled,whencreated,AccountExpirationDate,@{Label="Expiration - Created";Expression={($_.AccountExpirationDate-$_.whencreated)}} | Export-csv -append $path\Contractor_Accounts_$date.csv -NoTypeInformation
Get-ADUser -filter 'enabled -eq $true' -server na.fti.local -SearchBase “OU=FTI_Contractors,DC=na,DC=fti,DC=local” -Properties SamAccountName,DisplayName,Name,Description,Enabled,whencreated,AccountExpirationDate | Select @{Label="Sever";Expression={"NA.FTI.LOCAL"}},SamAccountName,DisplayName,Name,Description,Enabled,whencreated,AccountExpirationDate,@{Label="Expiration - Created";Expression={($_.AccountExpirationDate-$_.whencreated)}} | Export-csv -append $path\Contractor_Accounts_$date.csv -NoTypeInformation
Get-ADUser -filter 'enabled -eq $true' -server eu.fti.local -SearchBase “OU=FTI_Contractors,DC=eu,DC=fti,DC=local” -Properties SamAccountName,DisplayName,Name,Description,Enabled,whencreated,AccountExpirationDate | Select @{Label="Sever";Expression={"EU.FTI.LOCAL"}},SamAccountName,DisplayName,Name,Description,Enabled,whencreated,AccountExpirationDate,@{Label="Expiration - Created";Expression={($_.AccountExpirationDate-$_.whencreated)}} | Export-csv -append $path\Contractor_Accounts_$date.csv -NoTypeInformation
Get-ADUser -filter 'enabled -eq $true' -server sa.fti.local -SearchBase “OU=FTI_Contractors,DC=sa,DC=fti,DC=local” -Properties SamAccountName,DisplayName,Name,Description,Enabled,whencreated,AccountExpirationDate | Select @{Label="Sever";Expression={"SA.FTI.LOCAL"}},SamAccountName,DisplayName,Name,Description,Enabled,whencreated,AccountExpirationDate,@{Label="Expiration - Created";Expression={($_.AccountExpirationDate-$_.whencreated)}} | Export-csv -append $path\Contractor_Accounts_$date.csv -NoTypeInformation
Get-ADUser -filter 'enabled -eq $true' -server ap.fti.local -SearchBase “OU=FTI_Contractors,DC=ap,DC=fti,DC=local” -Properties SamAccountName,DisplayName,Name,Description,Enabled,whencreated,AccountExpirationDate | Select @{Label="Sever";Expression={"AP.FTI.LOCAL"}},SamAccountName,DisplayName,Name,Description,Enabled,whencreated,AccountExpirationDate,@{Label="Expiration - Created";Expression={($_.AccountExpirationDate-$_.whencreated)}} | Export-csv -append $path\Contractor_Accounts_$date.csv -NoTypeInformation
