<#
    .SYNOPSIS 
    Windows 10 Remove C:\Windows.old

    .DESCRIPTION
    Install:   PowerShell.exe -ExecutionPolicy Bypass -Command .\W10_RemoveWindowsOLD.ps1

    .ENVIRONMENT
    PowerShell 5.0

    .AUTHOR
    Niklas Rast
#>

$logFile = ('{0}\{1}.log' -f $env:Temp, [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name))
Start-Transcript -path $logFile

#Check if the script run with administrator privilege
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
	$arguments = "& '" + $myinvocation.mycommand.definition + "'"
	Start-Process powershell -Verb runAs -ArgumentList $arguments
	Break
}

#Windows.old path 
$path = $env:HOMEDRIVE+"\windows.old"
If(Test-Path -Path $path)
{
    #create registry value
    $regpath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Previous Installations"
    New-ItemProperty -Path $regpath -Name "StateFlags1221" -PropertyType DWORD  -Value 2 -Force  | Out-Null
    #start clean application
    cleanmgr /SAGERUN:1221
}
Else
{
	Write-Warning "There is no 'Windows.old' folder in system driver"
    cmd /c pause 
}
Stop-Transcript
