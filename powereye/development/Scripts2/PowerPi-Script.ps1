#Exchange Server Monitoring

#ConnectExchangePowerShell

#powershell.exe -command ". '$env:exchangeinstallpath\bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto -ClientApplication:ManagementShell; c:\scripts\PowerPi-Script.ps1 "
#powershell.exe -command ". '%ExchangeInstallPath%\bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto -ClientApplication:ManagementShell; c:\scripts\PowerPi-Script.ps1 "

#1 Server Status

$EXServers = @()
$AllStatus = @()

$EXServers=(Get-ExchangeServer).Name | Sort

Foreach ($Server in $EXServers){

	$Online = Test-Connection $Server -Count 1 -Quiet

	If($Online -eq $false){
        $Status=New-Object -TypeName PSObject -Property @{Name=$Server; Online=$false}
        $AllStatus += $Status
        Continue
    }

	$CPU=[math]::Round((Get-WmiObject -Computer $Server -class win32_processor -EA SilentlyContinue | Measure-Object -property LoadPercentage -Average).Average,0)

    $RAM=[math]::Round((1-(Get-Ciminstance Win32_OperatingSystem -ComputerName $Server -EA SilentlyContinue).FreePhysicalMemory/(Get-Ciminstance Win32_OperatingSystem -ComputerName $Server -EA SilentlyContinue).TotalVisibleMemorySize)*100,0)

	If(Get-WmiObject -ComputerName $Server -Class Win32_logicalDisk -EA SilentlyContinue | ? {$_.DeviceID -eq "Y:"}){
        $LogDiskFree=[math]::Round(((Get-WmiObject -ComputerName $Server -Class Win32_logicalDisk -EA SilentlyContinue | ? {$_.DeviceID -eq "Y:"}).FreeSpace/(Get-WmiObject -ComputerName $Server -Class Win32_logicalDisk -EA SilentlyContinue | ? {$_.DeviceID -eq "Y:"}).Size)*100,0)
    }
    Else {
        $LogDiskFree=$null
    }

	If(Get-MailboxServer $Server -EA SilentlyContinue){
        $StuckedQueues=(Get-Queue -Server $Server -Filter {MessageCount -gt 5} -EA SilentlyContinue | ? {$_.DeliveryType -notlike "*Shadow*" -and "*Submission*"}).Count
    }
	Else{
        $StuckedQueues=$null
    }

	$StoppedServices=(Get-Service -ComputerName $Server -Name "MSExchange*" | ? {$_.StartType -eq "Automatic" -and $_.Status -ne "Running"}).Count

	If(Get-MailboxServer $Server -EA SilentlyContinue){
        $DBBadCopy=(Get-MailboxDatabaseCopyStatus -Server $Server -EA SilentlyContinue | ? {$_.Status -ne "Healthy" -and $_.Status -ne "Mounted"}).Count
    }
	Else{
        $DBBadCopy=$null
    }
	If((Get-MailboxServer $Server -EA SilentlyContinue).AdminDisplayVersion -like "*15.0*"){
        $DBBadIndex=(Get-MailboxDatabaseCopyStatus -Server $Server -EA SilentlyContinue | ? {$_.ContentIndexState -ne "Healthy"}).Count
    }
	Else{
        $DBBadIndex=$null
    }
	$Status = New-Object -TypeName PSObject -Property @{
														Name = $Server
														Online = $Online
														"CPU(%)" = $CPU
														"RAM(%)" = $RAM
														LogDiskFree = $LogDiskFree
														StuckedQueues = $StuckedQueues
														StoppedServices = $StoppedServices
														DBBadCopy = $DBBadCopy
														DBBadIndex = $DBBadIndex
														}
	$AllStatus += $Status | Select Name, Online, "CPU(%)", "RAM(%)", LogDiskFree, StuckedQueues, StoppedServices, DBBadCopy, DBBadIndex
}

$AllStatus