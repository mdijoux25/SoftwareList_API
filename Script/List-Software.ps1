New-Module -name get_software -scriptblock {
Function Get-Software() {
    param(
        [Parameter(Position = 0)]
        [String]$WebAPI
      )
    


$Software=Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName}| Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Sort-Object DisplayName  |Export-Csv -Path "$env:TEMP\soft.csv" -Delimiter "," -NoTypeInformation -Encoding UTF8
$osver = (Get-WmiObject -Class Win32_OperatingSystem).caption +" "+[Environment]::OSVersion.Version  
$apinfo = "" | Select Hostname,OS,Username,Domain
$apinfo.Hostname = $env:COMPUTERNAME
$apinfo.OS = $osver
$apinfo.Username = $env:USERNAME
$apinfo.Domain = $env:USERDOMAIN
$json= Import-Csv -Path "$env:TEMP\soft.csv" | ConvertTo-Json 
$json += $apinfo| ConvertTo-Json  

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $WebAPI -Method POST -Body $json -ContentType "application/json" -UseBasicParsing
}
Set-Alias getsoftware -Value Get-Software | Out-Null
Export-ModuleMember -Alias 'getsoftware' -Function 'Get-Software' | Out-Null
}g