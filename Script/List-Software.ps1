New-Module -name get_software -scriptblock {
Function Get-Software() {
    param(
        [Parameter(Position = 0)]
        [String]$WebAPI
      )
    


$osver = (Get-WmiObject -ComputerName $env:COMPUTERNAME -Credential $Credential -Class Win32_OperatingSystem).Version
$Publisher = Get-ItemProperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select Publisher
$DisplayName = Get-ItemProperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select DisplayName
$DisplayVersion = Get-ItemProperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select DisplayVersion

$Software={
    for ($i=0; $i -lt $DisplayName.Count; $i++)
    {
        ([string]::Concat($Publisher[$i].Publisher, ",", $DisplayName[$i].DisplayName, ",", $DisplayVersion[$i].DisplayVersion) | Out-String) 
    }
    }




$apinfo = New-Object psobject -Property @{

    "Hostname"          = $env:COMPUTERNAME
    "OS"                = $osver
    "Username"          = $env:USERNAME
    "Domain"            = $env:USERDOMAIN
    "Publisher"         = $Software
    "DisplayName"       = $DisplayName
    "DisplayVersion"    = $DisplayVersion
    "Count of Software" = $Software.count

}

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $WebAPI -Method POST -Body ($apinfo | ConvertTo-Json) -ContentType "application/json" -UseBasicParsing
pause
}
Set-Alias getsoftware -Value Get-Software | Out-Null
Export-ModuleMember -Alias 'getsoftware' -Function 'Get-Software' | Out-Null
}