<#
Carlos Ruesta
07/16/2018

Description 
1) Compare row counts from user listing to see adds/deletes
#>

#Default Variables to Use for all my scripts
Import-Module activedirectory
$path="\\server\share$\folder1"

Write-Host ""
Write-Host "-----------------------------------------------" -ForegroundColor White
Write-Host "Comparison to Domain Administrative Group Files" -ForegroundColor White
Write-Host "-----------------------------------------------" -ForegroundColor White

dir $path -Include *.txt -Recurse | 
   % { $_ | select name, @{n="lines";e={
       get-content $_ | 
         measure-object -line |
             select -expa lines }
                                       } 
     } | ft -AutoSize 



Write-Host ""
Write-Host "----------------------------------------------" -ForegroundColor White
Write-Host "Comparison to Local Administrative Group Files" -ForegroundColor White
Write-Host "----------------------------------------------" -ForegroundColor White

dir $path -Include *.csv -Recurse | 
   % { $_ | select name, @{n="lines";e={
       get-content $_ | 
         measure-object -line |
             select -expa lines }
                                       } 
     } | ft -AutoSize
