Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

#region testing connectivity for all domain computers
$online = (Test-Connection -ComputerName (
          Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address} |
          Select-Object -ExpandProperty Name
) -Count 1 -AsJob | Receive-Job -Wait | Where-Object {$_.statuscode -eq 0}).Address
#endregion

#script to test if cortex is installed in WMI
$script = {
    [PSCustomObject][Ordered]@{
        ComputerName    = $env:COMPUTERNAME
        CortexInstalled = if(Get-WmiObject -Query "SELECT Name FROM Win32_Product" | Where-Object {$_.Name -like '*Cortex*'}){$true}else{$false}
    }
}

#invoking the script to run on all online remote domain computers
$Result = Invoke-Command -ComputerName $online -ErrorAction SilentlyContinue -ScriptBlock $script |
          Where-Object {$_.CortexInstalled -eq $false} | 
          Select-Object -Property * -ExcludeProperty PSComputerName, PSShowComputerName, RunSpaceId

if($Result){
    Send-MailMessage @MailSettings -BodyAsHTML "$style $Header $($Result | ConvertTo-Html -Fragment | Out-String)"
}