New-Module -name get_software -scriptblock {
Function Get-Software() {
    param(
        [Parameter(Position = 0)]
        [String]$WebAPI
      )
    


$osver = Get-ComputerInfo OsName,OsVersion,OsBuildNumber,OsHardwareAbstractionLayer,WindowsVersion
$Software=Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName }| Select-Object DisplayName, DisplayVersion, Publisher | Format-List | Out-String




$apinfo = New-Object psobject -Property @{

    "Hostname"          = $env:COMPUTERNAME
    "OS"                = $osver
    "Username"          = $env:USERNAME
    "Domain"            = $env:USERDOMAIN
    "Software"          = $Software

}

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $WebAPI -Method POST -Body ($apinfo | ConvertTo-Json) -ContentType "application/json" -UseBasicParsing
}
Set-Alias getsoftware -Value Get-Software | Out-Null
Export-ModuleMember -Alias 'getsoftware' -Function 'Get-Software' | Out-Null
}