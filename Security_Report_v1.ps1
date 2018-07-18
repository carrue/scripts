<#
Carlos Ruesta
07/16/2018

Description
1) Pulls AD accounts for privilege groups Administrators, Domain Admins and Enterprise Admin
2) Pulls AD accounts that have been dormant for over 90 days
3) Pulls AD accounts that are set to password never expired and password has not changed in over 365 days
4) Exports information to HTML file

#>


# Global Variables
Import-Module activedirectory
$date = get-date -f MM\/dd\/yyyy
$file_date = get-date -f yyyyMMdd
$forest = Get-ADforest | Select rootdomain 
$domains= Get-ADforest | Select domains
$domain_priv_groups ='Administrators','Enterprise Admins','Domain Admins','Domain Admins Universal'
$ErrorActionPreference= 'silentlycontinue' #This variable stops error from appearing during execution.
$PrivilegedAccounts = "C:\PS_Script\"+$file_date+"_PrivilegeAccounts.html"
$DormantAccounts = "C:\PS_Script\"+$file_date+"_DormantAccounts.html"
$SystemAccounts = "C:\PS_Script\"+$file_date+"_SystemAccounts.html"
$DaysInactive = 90
$oneYear=(Get-Date).Adddays(-365)
$time = (Get-Date).Adddays(-($DaysInactive))
$user_list = @()
$user_list2 = @()
$user_list3 = @()


#HTML Style
$Header = @"
<style>
h1, h3, h5, th { text-align: center;font-family: Segoe UI; }
p { line-height:1; text-align: left;font-family: Segoe UI;font-size: 12px }
table { margin: auto; font-family: Segoe UI; box-shadow: 10px 10px 5px #888; border: thin ridge grey; }
th { font-size: 10px; background: #0046c3; color: #fff; padding: 5px 10px; }
td { font-size: 10px; padding: 4px 5px; color: #000;}
tr { background: #b8d1f3; }
tr:nth-child(even) { background: #dae5f4; }
tr:nth-child(odd) { background: #b8d1f3; }
.danger {backgroup-color:red}
.warn{background-color:yellow}
</style>
"@

#Report Header
$Header_PrivilegedAccounts  =@"
<h3>GCP Report: Privilege Accounts as of $date</h3>
<h3>Questions? Concerns?  <a href="mailto:carlos.ruesta@fticonsulting.com?Subject=Privileged Accounts Report for $date" target="_top">Email</a></h3>
"@

$Header_DormantAccounts  =@"
<h3>GCP Report: Dormant AD Accounts (90 Days) as of $date</h3>
<h3>Questions? Concerns?  <a href="mailto:carlos.ruesta@fticonsulting.com?Subject=Dormant Accounts Report for $date" target="_top">Email</a></h3>
"@

$header_SystemAccounts  =@"
<h3>GCP Report: Accounts set to Password Never Expire and not change in over 365 days as of $date</h3>
<h3>Questions? Concerns?  <a href="mailto:carlos.ruesta@fticonsulting.com?Subject=System Accounts Report for $date" target="_top">Email</a></h3>
"@

# Delete Previous Reports
if (Test-Path $PrivilegedAccounts) 
{
  Remove-Item $PrivilegedAccounts
}

if (Test-Path $DormantAccounts) 
{
  Remove-Item $DormantAccounts
}

if (Test-Path $SystemAccounts) 
{
  Remove-Item $SystemAccounts
}


$Header_PrivilegedAccounts | Out-File -Filepath $PrivilegedAccounts
$Header_DormantAccounts | Out-File -Filepath $DormantAccounts
$header_SystemAccounts | Out-File -Filepath $SystemAccounts

# Pulling Population
# user_list = privilegedd accounts
# user_list2 = dormant accounts
# user_list3 = service accounts

foreach ($domain in $domains.domains)
{
       
       foreach ($domain_priv_group in $domain_priv_groups){
        $user_list+=Get-ADGroupMember $domain_priv_group -server $domain | sort objectClass,SamAccountName | Select-Object @{Label="Domain";Expression={$domain}},@{Label="Group Name";Expression={$domain_priv_group}},SamAccountName,distinguishedName,@{Label="Type";Expression={$_.objectClass}}
        }
       $user_list_count=$user_list.Count
       $user_list | ConvertTo-HTML -Head $Header -Body "<h3>$domain Total=$user_list_count</h3>" | Out-File -Width 512 -append -FilePath $PrivilegedAccounts
       Clear-Variable -Name user_list

       $user_list2 += Get-ADUser -Filter {LastLogonTimeStamp -lt $time -and enabled -eq $true} -server $domain -Properties DisplayName,Description,LastLogonDate | select-object @{Label="Domain";Expression={$domain}},SamAccountName,distinguishedName,Description,@{Label="Last Logon";Expression={$_.LastLogonDate.ToString("MM\/dd\/yyyy")}},@{Label="Days Inactive";Expression={($_.lastLogonDate-(Get-Date)).Days}} 
       $user_list3 += Get-ADUser -filter {PasswordLastSet -lt $oneYear -and enabled -eq $true -and PasswordNeverExpires -eq $true} -server $domain -Properties DisplayName,Description,LastLogonDate,PasswordLastSet | Select-Object @{Label="Domain";Expression={$domain}},SamAccountName,distinguishedName,Description,@{Label="Password Last Set";Expression={$_.PasswordLastSet.ToString("MM\/dd\/yyyy")}},@{Label="Password Age";Expression={($_.PasswordLastSet-(Get-Date)).Days}} 
      
}



$user_list_count2=$user_list2.Count
$user_list_count3=$user_list3.Count

$user_list2 | sort "Days Inactive"| ConvertTo-HTML -Head $Header -Body "<h3>Total=$user_list_count2</h3>" | Out-File -Width 512 -append -FilePath $DormantAccounts
$user_list3 | sort "Password Age"| ConvertTo-HTML -Head $Header -Body "<h3>Total=$user_list_count3</h3>" | Out-File -Width 512 -append -FilePath $SystemAccounts
