$Exchange_Server = 'EU1MB9901.Roaya.loc'

$username = 'QueueMonitor'
$password = '97$p$*J5f7$#3$0DnA'

[SecureString]$secStringPassword = ConvertTo-SecureString $password -AsPlainText -Force
[PSCredential]$UserCredential    = New-Object System.Management.Automation.PSCredential ($username, $secStringPassword)
$Session = New-PSSession -ConfigurationName Microsoft.Exchange `
                            -ConnectionUri "http://$Exchange_Server/PowerShell/" `
                            -Authentication Kerberos `
                            -Credential $UserCredential

Import-PSSession $Session -DisableNameChecking -AllowClobber | Out-Null

#region main script
#Exchange Server Monitoring

#ConnectExchangePowerShell

#powershell.exe -command ". '$env:exchangeinstallpath\bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto -ClientApplication:ManagementShell; c:\scripts\PowerPi-Script-ToEmail.ps1 "
#powershell.exe -command ". '%ExchangeInstallPath%\bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto -ClientApplication:ManagementShell; c:\scripts\PowerPi-Script-ToEmail.ps1 "

#1 Server Status

$Header = "
		<style>
		TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
		TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;}
		TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
		</style>
		<h2 align=""center"">Exchange Servers Status Report</h3>
		<h4 align=""center"">Generated On $((Get-Date).ToString())</h5>
		"

$EXServers=@()
$AllStatus=@()
$EXServers=(Get-ExchangeServer).Name | Sort
$smtpsettings=@{
	To =  "Operation@Roaya.co"
	From = "ExchangeServersStatusReport@PowerEye.Roaya.loc"
	Subject = "Exchange Servers Status Report"
	SmtpServer = "192.168.3.202"
}
$reportime = Get-Date

$htmlhead="<html>
                <style>
                BODY{font-family: Arial; font-size: 8pt;}
                H1{font-size: 16px;}
                H2{font-size: 14px;}
                H3{font-size: 12px;}
                TABLE{border: 1px solid black; border-collapse: collapse; font-size: 8pt;}
                TH{border: 1px solid black; background: #dddddd; padding: 5px; color: #000000;}
                TD{border: 1px solid black; padding: 5px; }
                td.pass{background: #7FFF00;}
                td.warn{background: #FFE600;}
                td.fail{background: #FF0000; color: #ffffff;}
                td.info{background: #85D4FF;}
                </style>
                <body>
                <h1 align=""center"">Exchange Servers Status Report</h1>
                <h3 align=""center"">Generated: $reportime</h3>"


$htmltableheader = "    <p>
                        <table>
                        <tr>
                        <th>Name(Online)</th>
						<th>MountedDBs</th>
                        <th>CPU(%)</th>
                        <th>RAM(%)</th>
                        <th>LogDiskFree(%)</th>
                        <th>StuckedQueues</th>
                        <th>StoppedServices</th>
                        <th>DBBadCopy</th>
                        </tr>"
$exchangeserverreporthtmltable = $htmlhead + $htmltableheader 

Foreach ($Server in $EXServers){
	$Online=if (Test-Connection $Server -Count 1 -EA SilentlyContinue) {$true} else {$false}
	If($Online -eq $false){$Status=New-Object -TypeName PSObject -Property @{Name=$Server; Online=$false}; $AllStatus += $Status; Continue}
	If(Get-MailboxServer $Server -EA SilentlyContinue)
		{$mdbs=(Get-MailboxDatabaseCopyStatus -Server $Server | ?{$_.Status -eq "Mounted"}).Count}
		Else{$mdbs=$null}
	$CPU=[math]::Round((Get-WmiObject -Computer $Server -class win32_processor -EA SilentlyContinue | Measure-Object -property LoadPercentage -Average).Average,0)
	$RAM=[math]::Round((1-(Get-Ciminstance Win32_OperatingSystem -ComputerName $Server -EA SilentlyContinue).FreePhysicalMemory/(Get-Ciminstance Win32_OperatingSystem -ComputerName $Server -EA SilentlyContinue).TotalVisibleMemorySize)*100,0)
	If(Get-WmiObject -ComputerName $Server -Class Win32_logicalDisk -EA SilentlyContinue | ? {$_.DeviceID -eq "Y:"})
		{$LogDiskFree=[math]::Round(((Get-WmiObject -ComputerName $Server -Class Win32_logicalDisk -EA SilentlyContinue | ? {$_.DeviceID -eq "Y:"}).FreeSpace/(Get-WmiObject -ComputerName $Server -Class Win32_logicalDisk -EA SilentlyContinue | ? {$_.DeviceID -eq "Y:"}).Size)*100,0)}
		Else {$LogDiskFree=$null}
	If(Get-MailboxServer $Server -EA SilentlyContinue)
		{$StuckedQueues=(Get-Queue -Server $Server -Filter {MessageCount -gt 5} -EA SilentlyContinue | ? {$_.DeliveryType -notlike "*Shadow*" -and "*Submission*"}).Count}
		Else{$StuckedQueues=$null}
	$StoppedServices=(Get-Service -ComputerName $Server -Name "MSExchange*" | ? {$_.StartType -eq "Automatic" -and $_.Status -ne "Running"}).Count
	If(Get-MailboxServer $Server -EA SilentlyContinue)
		{$DBBadCopy=(Get-MailboxDatabaseCopyStatus -Server $Server -EA SilentlyContinue | ? {$_.Status -ne "Healthy" -and $_.Status -ne "Mounted"}).Count}
		Else{$DBBadCopy=$null}
	#If((Get-MailboxServer $Server -EA SilentlyContinue).AdminDisplayVersion -like "*15.0*")
		#{$DBBadIndex=(Get-MailboxDatabaseCopyStatus -Server $Server -EA SilentlyContinue | ? {$_.ContentIndexState -ne "Healthy"}).Count}
		#Else{$DBBadIndex=$null}
	$Status = New-Object -TypeName PSObject -Property @{
														Name = $Server
														Online = $Online
														MountedDBs = $mdbs
														CPU = $CPU
														RAM = $RAM
														LogDiskFree = $LogDiskFree
														StuckedQueues = $StuckedQueues
														StoppedServices = $StoppedServices
														DBBadCopy = $DBBadCopy
														#DBBadIndex = $DBBadIndex
														}

        $htmltablerow = "<tr>"
        if ($Status.Online -eq $false){$htmltablerow += "<td class=""fail"">$($Status.Name)</td>"}
            else{$htmltablerow += "<td class=""pass"">$($Status.Name)</td>"}
        $htmltablerow += "<td class=""pass"">$($Status.MountedDBs)</td>"
        if ($Status.CPU -gt 75){$htmltablerow += "<td class=""fail"">$($Status.CPU)</td>"}
            else{$htmltablerow += "<td class=""pass"">$($Status.CPU)</td>"}
        if ($Status.RAM -gt 75){$htmltablerow += "<td class=""fail"">$($Status.RAM)</td>"}
            else{$htmltablerow += "<td class=""pass"">$($Status.RAM)</td>"}
        if ($Status.LogDiskFree -lt 75 -and $Status.LogDiskFree -ne $null){$htmltablerow += "<td class=""fail"">$($Status.LogDiskFree)</td>"}
            else{$htmltablerow += "<td class=""pass"">$($Status.LogDiskFree)</td>"}
        if ($Status.StuckedQueues -gt 0){$htmltablerow += "<td class=""fail"">$($Status.StuckedQueues)</td>"}
            else{$htmltablerow += "<td class=""pass"">$($Status.StuckedQueues)</td>"}
        if ($Status.StoppedServices -gt 0){$htmltablerow += "<td class=""fail"">$($Status.StoppedServices)</td>"}
            else{$htmltablerow += "<td class=""pass"">$($Status.StoppedServices)</td>"}
        if ($Status.DBBadCopy -gt 0){$htmltablerow += "<td class=""fail"">$($Status.DBBadCopy)</td>"}
            else{$htmltablerow += "<td class=""pass"">$($Status.DBBadCopy)</td>"}
        $exchangeserverreporthtmltable = $exchangeserverreporthtmltable + $htmltablerow

}
$exchangeserverreporthtmltable = $exchangeserverreporthtmltable + "</table></p>"

$htmltail = "</body>
			</html>"
$exchangeserverreporthtmltable = $exchangeserverreporthtmltable + $htmltail


Send-MailMessage @smtpsettings -Body $exchangeserverreporthtmltable -BodyAsHtml -Encoding ([System.Text.Encoding]::UTF8)			
#endregion

Remove-PSSession -Session $Session