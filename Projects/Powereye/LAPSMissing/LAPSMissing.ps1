Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

#script to test if LAPS is installed in WMI
$script = {
    [PSCustomObject][Ordered]@{
        ComputerName    = $env:COMPUTERNAME
        LAPSInstalled = if(Get-WmiObject -Query "SELECT Name FROM Win32_Product" | Where-Object {$_.Name -eq 'Local Administrator Password Solution'}){$true}else{$false}
    }
}

Import-Module '..\UtilityFunctions.ps1'

$online = Return-OnlineComputers -ComputerNames (Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address}).Name

#invoking the script to run on all online remote domain computers
$Result = Invoke-Command -ComputerName $online -ErrorAction SilentlyContinue -ScriptBlock $script |
          Where-Object {$_.LAPSInstalled -eq $false} | 
          Select-Object -Property * -ExcludeProperty PSComputerName, PSShowComputerName, RunSpaceId

if($Result){
    Write-Output "$(Get-Date) [!] LAPS missing on some hosts. Sending mail."
    Write-Output $Result
    Send-MailMessage @MailSettings -BodyAsHTML "$style $Header $($Result | ConvertTo-Html -Fragment | Out-String)"
}
else{
    Write-Output "$(Get-Date) [*] LAPS found on all contacted hosts."
}