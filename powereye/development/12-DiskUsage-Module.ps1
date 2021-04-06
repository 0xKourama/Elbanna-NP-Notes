$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'DiskUsageWarning@roaya.co'
    To         = 'operation@roaya.co'
    #To         = 'mgabr@roaya.co'
    Subject    = 'DiskUsageWarning'
}

$Style = @"
<style>
th, td {
    border: 2px solid black;
    text-align: center;
}
table{
    border-collapse: collapse;
    border: 2px solid black;
    width: 100%;
}
h3{
    color: white;
    padding: 3px;
    background-color: #fc4103;
    text-align: Center;
    border: 2px solid black;
}
</style>
"@

$Header = @"
<h3>Disk Usage Warning</h3>
"@

$script = {
    Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} |  Select-Object -Property DeviceID, Size, FreeSpace
}

$FreeDiskUsagePercentThreshold = 30


while($true){
    Write-Host -ForegroundColor Cyan "[*] Running module at $(Get-Date)"
    $Online = Get-ADComputer -Filter * | Select-Object -Property @{name = 'ComputerName'; Expression = {$_.name}} | 
              Test-Connection -Count 1 -AsJob | Receive-job -Wait | Where-Object {$_.statuscode -eq 0} | Select-Object -ExpandProperty Address

    $Result = Invoke-Command -ComputerName $Online -ScriptBlock $script -ErrorAction SilentlyContinue |
               Select-Object -Property @{name='ComputerName'        ;expression={$_.PSComputerName}},
                                       @{name='DriveLetter'         ;expression={$_.DeviceID}},
                                       @{name='TotalDiskSpace(GB)'  ;expression={[math]::round((($_.Size) / 1GB),2)}},
                                       @{name='FreeDiskSpace(GB)'   ;expression={[math]::round(($_.FreeSpace / 1GB),2)}},
                                       @{name='FreeDiskSpacePercent';expression={[math]::Round((($_.FreeSpace/$_.Size)*100),2)}} |
               Where-Object {$_.FreeDiskSpacePercent -lt $FreeDiskUsagePercentThreshold} | Sort-Object -Property ComputerName



    if($Result){
        Write-Host -ForegroundColor Yellow "[!] Free disk usage threshold ($FreeDiskUsagePercentThreshold%) exceeded. Sending mail"
        Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Result | ConvertTo-Html)"
        Clear-Variable -Name Result
    }
    else{
        Write-Host -ForegroundColor Green "[+] Free disk usage threshold ($FreeDiskUsagePercentThreshold%) not exceeded."
    }
    Write-Host -ForegroundColor Cyan "Sleeping for 2 hours"
    [GC]::Collect()
    Start-Sleep -Seconds (2 * 60 * 60)
}