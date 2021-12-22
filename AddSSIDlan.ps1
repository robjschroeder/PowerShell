﻿$computername = Read-host "Please enter the name of the computer to add the SSID"
$domain = "server.domain.com"
$PathToXML = "\\server.domain.com\path\SSID.xml"
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if(-not($IsAdmin)){
	throw "Current User has no administrative rights. Restart script as administrator."
}
		


if(-not(Test-Path $PathToProfileXML)){
	throw "Profile file do not exist at give path: $PathToProfileXML"
}
Invoke-Command -ComputerName $computerName -ScriptBlock {
    $strDump=netsh wlan show interfaces
    $strNameDump = $strDump[3]
    $Result = [regex]::match($strNameDump, "^.*Name.*: (.*)$")
    $WirlessAdapterName = $Result.Groups[1].Value

    if($WirlessAdapterName){
	    Write-Host "Adapter found: $WirlessAdapterName"	
	    Write-Host ""
	    Write-Host "Trying to add Profile"
	    Write-Host $PathToProfileXML
	    netsh wlan add profile filename=$PathToProfileXML interface="$WirlessAdapterName"
    }else{
	    Write-Host "No WiFi Adapter found" -ForegroundColor Red
    }
}