Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$FreeDiskUsagePercentThreshold = 30

#script to collect the needed data through WMI
$script = {Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} |  Select-Object -Property DeviceID, Size, FreeSpace}

Import-Module '..\UtilityFunctions.ps1'

#testing connetivity for all domain computers
$Online = (Get-ADComputer -Filter *).Name | Return-OnlineComputers

#running the script and processing the results
$Result = Invoke-Command -ComputerName $Online -ScriptBlock $script -ErrorAction SilentlyContinue |
          Select-Object -Property @{name='ComputerName'        ;expression={$_.PSComputerName}},
                                  @{name='DriveLetter'         ;expression={$_.DeviceID}},
                                  @{name='TotalDiskSpace(GB)'  ;expression={[math]::round((($_.Size) / 1GB),2)}},
                                  @{name='FreeDiskSpace(GB)'   ;expression={[math]::round(($_.FreeSpace / 1GB),2)}},
                                  @{name='FreeDiskSpacePercent';expression={[math]::Round((($_.FreeSpace/$_.Size)*100),2)}} |
          Where-Object {$_.FreeDiskSpacePercent -lt $FreeDiskUsagePercentThreshold} | Sort-Object -Property ComputerName

if($Result){
    Write-Output "$(Get-Date) [!] Disk usage percent exceeded threshold. Sending mail."
    Write-Output $Result
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Result | ConvertTo-Html -Fragment | Out-String)"
}
else{
    Write-Output "$(Get-Date) [*] Disk usage percent not exceeded."
}