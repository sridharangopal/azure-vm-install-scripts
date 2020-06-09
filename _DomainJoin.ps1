<#
 .SYNOPSIS
    This script will take input from the consumer in the form of a username / password 
    and join the vm to the azr domain in Azure.

 .DESCRIPTION
    Executing this script will domain join a vm in Azure

 .PARAMETER adminid
    The domain join user id

 .PARAMETER adminpwd
    The domain join user password

 .PARAMETER sbu
    The SBU for which the VM will be owned by, allowed values: CI, Corp, GCS, GS, HS, USCM


 
.EXAMPLE
    .\domain-join.ps1 -adminid mydomainjoinid@libertymutual.onmicrosoft.com -adminpwd mydomainjoinpwd -sbu HS
    
#>


#Parameters from Command Line
param(
  [string]$adminid,
  [string]$adminpwd,
  [ValidateSet("CI", "Corp", "GCS", "GS", "HS", "USCM")]
  [string]$sbu
)


#Convert password to readable format
$secpasswd = ConvertTo-SecureString $adminpwd -AsPlainText -Force

#Package password with username
$mycreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($adminid, $secpasswd)

add-computer -domainname azr.lmig.com -OUPath "OU=Intermediate,OU=$sbu,OU=AZR Servers,DC=azr,DC=lmig,DC=com" -Credential $mycreds
