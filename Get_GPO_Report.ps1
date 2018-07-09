<#
Carlos Ruesta
05/15/2018

Description 
1) Pull Default Domain Policy for each domain
2) Export report to HTML

#>

Import-Module activedirectory
$path="c:\PS_Script\Dump\"
$date = get-date -f yyyyMMdd
$forest = Get-ADforest | Select rootdomain 
$domains= Get-ADforest | Select domains
$ErrorActionPreference= 'silentlycontinue' #This variable stops error from appearing during execution.

foreach ($domain in $domains){
    Get-GPOReport -domain $domain -Name "Default Domain Policy"  -ReportType Html -Path $path\$domain-$date.html
    }

