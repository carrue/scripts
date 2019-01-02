Import-Module activedirectory
$date = get-date -f yyyyMMdd
Import-Module activedirectory
$path="c:\PS_Script\Output\"
$date = get-date -f yyyyMMdd
$forest = Get-ADforest | Select rootdomain 
$domains= Get-ADforest | Select domains
$ErrorActionPreference= 'silentlycontinue' #This variable stops error from appearing during execution.
$domain_priv_groups = 'Administrators','Domain Admins','Enterprise Admins'



foreach ($domain in $domains.domains){
    Get-ADUser -filter * -server $domain -Properties SamAccountName,DisplayName,EmployeeID,Name,Title,Description,EmailAddress,City,State,Company,Department,extensionAttribute2,extensionAttribute4,Enabled,AccountExpirationDate,LastLogonDate,PasswordLastSet,PasswordNeverExpires,whencreated | Select @{Label="Domain";Expression={$domain}},SamAccountName,DisplayName,EmployeeID,Name,Title,Description,EmailAddress,City,State,Company,Department,extensionAttribute2,extensionAttribute4,Enabled,AccountExpirationDate,LastLogonDate,PasswordLastSet,PasswordNeverExpires,whencreated |Export-csv -append $path\AD_Users_$date.csv -NoTypeInformation
}
          
foreach ($domain in $domains.domains){
    $result = foreach($domain_priv_group in $domain_priv_groups){
        Get-ADGroupMember $domain_priv_group -server $domain | sort ObjectClass | Select @{Label="Domain";Expression={$domain}},@{Label="Group Name";Expression={$domain_priv_group}},SamAccountName,name,objectClass | Export-Csv -append $path\Privilege_Users"_"$date.csv -NoTypeInformation
        }
    }  
