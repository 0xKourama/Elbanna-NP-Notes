$ErrorActionPreference = 'stop'

$Object_properties = @(
    'ComputerName'
    'ADLocation'
    'LastLogonDate'
    'MemberOf'
    'Username'
    'Screen'
    'Manufacturer'
    'Model'
    'GraphicsCard'
    'IPV4'
    'MAC'
    'Processor'
    'RAM'
    'MemoryUsage'
    'OperatingSystem'
    'LastDeployed'
    'Uptime'
    'FreeDiskSpace'
)

$Object = @{} | Select-Object -Property $Object_properties

$LockProcess = Get-WmiObject -Query "SELECT * FROM Win32_Process WHERE Name = 'logonui.exe'"

if(!$LockProcess){
    $Object.Screen = 'Unlocked'
}
else{
    foreach($element in $User_list){
        if($element.Username -eq 'NONE'){
            $Object.Screen = 'Locked'
        }
        elseif($element.status -eq '[ACTIVE - LOCAL]' -or $element.status -eq '[ACTIVE - RDP]'){
            if(($LockProcess | ? {$_.SessionID -eq ($element.ID)} | select -ExpandProperty name) -notcontains 'LogonUI.exe'){
                $Object.Screen = 'Unlocked'
            }
            else{
                $Object.Screen = 'Locked'
            }
        }
        else{
            $Object.Screen = 'Locked'
        }
    }
}

$CS       = Get-WmiObject -Query "SELECT Manufacturer, Username, Name FROM Win32_ComputerSystem"
$MODEL    = Get-WmiObject -Query "SELECT Name, Version FROM Win32_ComputerSystemProduct"
$OS       = Get-WmiObject -Query "SELECT FreePhysicalMemory, TotalVisibleMemorySize, InstallDate, Caption, LastBootUpTime, BuildNumber, OSarchitecture FROM Win32_OperatingSystem"
$PROC     = Get-WmiObject -Query "SELECT Name, NumberOfCores FROM Win32_Processor"
$Uptime   = New-TimeSpan -Start ([Management.ManagementDatetimeConverter]::ToDateTime($OS.LastBootupTime)) -End (get-date)

$Object.ComputerName    = ($CS.Name).ToUpper()
$Object.LastLogonDate   = $ADObject.LastLogonDate
$Object.Manufacturer    = $CS.Manufacturer
$Object.Model           = "$($MODEL.Version)$($MODEL.Name)".TrimStart()
$Object.GraphicsCard    = Get-WmiObject Win32_VideoController | Select -ExpandProperty description
$Object.IPV4            = ((Test-Connection -ComputerName $env:COMPUTERNAME -Count 1).IPV4Address).ipaddresstoString
$Object.MAC             = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration | ? {$_.ipenabled -match "True"}).MACAddress | % {"[$_]"}
$Object.Processor       = "$(($PROC.name).replace('     ','').replace('  ',' ')) [$($PROC.NumberOfCores) cores]"
$Object.RAM             = "$([Math]::Round(($OS.TotalVisibleMemorySize / 1MB),1)) GB"
$Object.MemoryUsage     = "$((100 - (($OS.FreePhysicalMemory / $OS.TotalVisibleMemorySize)* 100)) -as [int])%"
$Object.OperatingSystem = "$($OS.Caption.trim()) [$($OS.OSArchitecture)] build $($OS.BuildNumber)"
$Object.LastDeployed    = ([Management.ManagementDatetimeConverter]::ToDateTime($OS.installdate)).toshortDatestring()
$Object.Uptime          = "$($Uptime.Days) Days $($Uptime.Hours) Hours $($Uptime.Minutes) Minutes"
$Object.FreeDiskSpace   = "$(((Get-WmiObject -Query "SELECT FreeSpace FROM Win32_LogicalDisk WHERE DeviceID = 'C:'").FreeSpace / 1GB) -as [int]) GB" 