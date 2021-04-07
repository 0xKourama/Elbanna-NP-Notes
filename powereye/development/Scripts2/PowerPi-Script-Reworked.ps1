#Exchange Server Monitoring

#ConnectExchangePowerShell

#powershell.exe -command ". '$env:exchangeinstallpath\bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto -ClientApplication:ManagementShell; c:\scripts\PowerPi-Script.ps1 "
#powershell.exe -command ". '%ExchangeInstallPath%\bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto -ClientApplication:ManagementShell; c:\scripts\PowerPi-Script.ps1 "

#1 Server Status

$Script = {
    [PSCustomObject][Ordered]@{
        'RAM(%)'        = (Get-WmiObject -Query "SELECT FreePhysicalMemory, TotalVisibleMemorySize FROM Win32_OperatingSystem" | 
                           Select-Object -Property @{Name = 'RAM(%)'; Expression = {[math]::Round((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory) / $_.TotalVisibleMemorySize) * 100, 2)}}).'RAM(%)'
        'CPU(%)'        = [math]::Round((Get-WmiObject -Query "SELECT LoadPercentage FROM Win32_Processor" | Measure-Object -Property LoadPercentage -Average).Average, 2)
        LogDiskFree     = (Get-WmiObject -Query "SELECT FreeSpace, Size FROM Win32_LogicalDisk WHERE DeviceID = 'Y:'" |
                           Select-Object -Property @{Name = 'LogDiskFree'; Expression = {[math]::Round((($_.FreeSpace/$_.Size)*100),2)}}).LogDiskFree
        StoppedServices = (Get-Service -ComputerName $Server -Name "MSExchange*" | Where-Object {$_.StartType -eq "Automatic" -and $_.Status -ne "Running"}) -join ' | '
        StuckQueues     = (Get-Queue -Filter {MessageCount -gt 5} | Where-Object {$_.DeliveryType -notlike "*Shadow*" -and "*Submission*"}).Count
        DBBadCopy       = (Get-MailboxDatabaseCopyStatus | Where-Object {$_.Status -ne "Healthy" -and $_.Status -ne "Mounted"}).Count
        DBBadIndex      = If((Get-MailboxServer).AdminDisplayVersion -like "*15.0*"){(Get-MailboxDatabaseCopyStatus | Where-Object {$_.ContentIndexState -ne "Healthy"}).Count}
    }
}

Invoke-Command -ComputerName (Get-ExchangeServer).Name -ScriptBlock $Script -ErrorAction SilentlyContinue