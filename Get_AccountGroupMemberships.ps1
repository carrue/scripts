
<#
This scripts pulls the groups memberships for each account name added in 

#>


Import-Module activedirectory
$date = get-date -f yyyyMMdd
Import-Module activedirectory
$path="c:\PS_Script\Dump\"
$date = get-date -f yyyyMMdd
$forest = Get-ADforest | Select rootdomain 
$domains= Get-ADforest | Select domains

$users='testuser1','testuser2'

                     
foreach ($user in $users){
    Get-ADPrincipalGroupMembership $user -server "domain.na.local"  | select @{Label="Domain";Expression={"domain.na.local"}},@{Label="User";Expression={$user}},name | Export-csv -append $path\Membership_$date.csv -NoTypeInformation
              
    }  
