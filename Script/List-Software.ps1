New-Module -name get_software -scriptblock {
  Function Get-Software() {
      param(
          [Parameter(Position = 0)]
          [String]$WebAPI
        )
      
  
  Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName}| Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Sort-Object DisplayName  |Export-Csv -Path "$env:TEMP\soft.csv" -Delimiter "," -NoTypeInformation -Encoding UTF8
  $os = ((Get-WmiObject -Class Win32_OperatingSystem).caption).Trim() 
  $osVer=(Get-WmiObject Win32_OperatingSystem).Version
  $domain = (Get-CimInstance -ClassName Win32_ComputerSystem).Domain
  $biosVer= (Get-CimInstance -ClassName Win32_BIOS).SMBIOSBIOSVersion
  $serial= (Get-CimInstance -ClassName Win32_BIOS).SerialNumber
  $processor = (Get-WmiObject -Class Win32_Processor).Name
  $Model= (Get-WmiObject -Class:Win32_ComputerSystem).Model
  $ram = Get-WmiObject win32_physicalmemory | Measure-Object Capacity -Sum
  
  
  $apinfo = "" | Select-Object Hostname,OS,OSVer,Username,Domain,BiosVersion,Serial,Processor,Monitor,Model,RamCount,RamSize,Software
  $apinfo.Hostname = $env:COMPUTERNAME
  $apinfo.OS = $os 
  $apinfo.OSVer = $osVer
  $apinfo.Username = $env:USERNAME
  $apinfo.Domain = $domain
  $apinfo.BiosVersion = $biosVer
  $apinfo.Serial = $serial
  $apinfo.processor = $processor
  $apinfo.Model = $Model
  $apinfo.RamCount = $ram.Count
  $apinfo.RamSize = $ram.Sum
  $apinfo.Monitor = Import-Csv -Path "$env:TEMP\hardware.csv" 
  $apinfo.Software = Import-Csv -Path "$env:TEMP\soft.csv"
  $json += $apinfo
  
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
  Invoke-WebRequest -Uri $WebAPI -Method POST -Body ($json | ConvertTo-Json) -ContentType "application/json" -UseBasicParsing
  
  Remove-Item -Path "$env:TEMP\soft.csv"
  Remove-Item -Path "$env:TEMP\hardware.csv"
  }
  Set-Alias getsoftware -Value Get-Software | Out-Null
  Export-ModuleMember -Alias 'getsoftware' -Function 'Get-Software' | Out-Null
  }