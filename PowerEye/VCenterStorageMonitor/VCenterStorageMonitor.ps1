Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope AllUsers, Session, User

Connect-VIServer -Server  -User '' -Password ''

$Date = Get-Date

$DayMinus0CSV  = "$($date.datetime -replace ', | ','-' -replace "$($date.Day).*",$date.Day).csv"

$DayMinus1Date = (Get-Date).addDays(-1)
$DayMinus2Date = (Get-Date).addDays(-2)
$DayMinus3Date = (Get-Date).addDays(-3)
$DayMinus4Date = (Get-Date).addDays(-4)
$DayMinus5Date = (Get-Date).addDays(-5)
$DayMinus6Date = (Get-Date).addDays(-6)

$DayMinus1Data = Import-Csv "$($DayMinus1Date.datetime -replace ', | ','-' -replace "$($DayMinus1Date.Day).*",$DayMinus1Date.Day).csv"
$DayMinus2Data = Import-Csv "$($DayMinus2Date.datetime -replace ', | ','-' -replace "$($DayMinus2Date.Day).*",$DayMinus2Date.Day).csv"
$DayMinus3Data = Import-Csv "$($DayMinus3Date.datetime -replace ', | ','-' -replace "$($DayMinus3Date.Day).*",$DayMinus3Date.Day).csv"
$DayMinus4Data = Import-Csv "$($DayMinus4Date.datetime -replace ', | ','-' -replace "$($DayMinus4Date.Day).*",$DayMinus4Date.Day).csv"
$DayMinus5Data = Import-Csv "$($DayMinus5Date.datetime -replace ', | ','-' -replace "$($DayMinus5Date.Day).*",$DayMinus5Date.Day).csv"
$DayMinus6Data = Import-Csv "$($DayMinus6Date.datetime -replace ', | ','-' -replace "$($DayMinus6Date.Day).*",$DayMinus6Date.Day).csv"

$DayMinus0Data = Get-VM | Select-Object @{
                    n='Date'
                    e={"$($date.datetime -replace ', | ',' ' -replace "$($date.Day).*",$date.Day)"}
                },
               @{
                    n='VMName'
                    e={$_.name}
               },
               @{
                    n='UsedDiskSpaceGB'
                    e={[math]::Round($_.UsedSpaceGB,2)}
                },
               @{
                    n='HardDiskCount'
                    e={($_ | Get-HardDisk).count}
               },
               @{
                    n='HardDiskData'
                    e={
                        $index=1
                        (($_|Get-HardDisk).CapacityGB|ForEach-Object{"HD#$index`: $([math]::Round($_,2)) GB"; $index++}) -join ', '
                    }
                },
                @{
                    n='TotalDiskSpaceGB'
                    e={[Math]::Round(((($_|Get-HardDisk).CapacityGB|Measure -Sum).sum),2)}
                }, ProvisionedSpaceGB

Disconnect-VIServer -Confirm:$false

$DayMinus0Data | Export-Csv -NoTypeInformation $DayMinus0CSV

$results = @()

foreach($New in $DayMinus0Data){
    $results += [PSCustomObject][Ordered]@{
        VMName             = $New.VMName
        TotalSpaceGB       = $New.TotalDiskSpaceGB
        ProvisionedSpaceGB = [math]::Round($New.ProvisionedSpaceGB,2)
        UsedSpaceGB        = $New.UsedDiskSpaceGB
        UsageDifferenceGB  = ($New.UsedDiskSpaceGB -as [int]) - (($DayMinus1Data | Where-Object {$_.VMName -eq $New.VMName}).UsedDiskSpaceGB -as [int])
        #HardDiskCount     = $New.HardDiskCount
        #HardDiskData      = $New.HardDiskData
        "$($DayMinus1Date.datetime -replace ', | ',' ' -replace "$($DayMinus1Date.Day).*",$DayMinus1Date.Day) UsedSpaceGB" = ($DayMinus1Data | Where-Object {$_.VMName -eq $New.VMName}).UsedDiskSpaceGB
        "$($DayMinus2Date.datetime -replace ', | ',' ' -replace "$($DayMinus2Date.Day).*",$DayMinus2Date.Day) UsedSpaceGB" = ($DayMinus2Data | Where-Object {$_.VMName -eq $New.VMName}).UsedDiskSpaceGB
        "$($DayMinus3Date.datetime -replace ', | ',' ' -replace "$($DayMinus3Date.Day).*",$DayMinus3Date.Day) UsedSpaceGB" = ($DayMinus3Data | Where-Object {$_.VMName -eq $New.VMName}).UsedDiskSpaceGB
        "$($DayMinus4Date.datetime -replace ', | ',' ' -replace "$($DayMinus4Date.Day).*",$DayMinus4Date.Day) UsedSpaceGB" = ($DayMinus4Data | Where-Object {$_.VMName -eq $New.VMName}).UsedDiskSpaceGB
        "$($DayMinus5Date.datetime -replace ', | ',' ' -replace "$($DayMinus5Date.Day).*",$DayMinus5Date.Day) UsedSpaceGB" = ($DayMinus5Data | Where-Object {$_.VMName -eq $New.VMName}).UsedDiskSpaceGB
        "$($DayMinus6Date.datetime -replace ', | ',' ' -replace "$($DayMinus6Date.Day).*",$DayMinus6Date.Day) UsedSpaceGB" = ($DayMinus6Data | Where-Object {$_.VMName -eq $New.VMName}).UsedDiskSpaceGB
    }
}


$Header = "<h3>VCenter Storage Monitor</h3>"

Write-Output "$(Get-Date) [+] Report generated. Sending mail."

Write-Output $Results

Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Results | Sort-Object -Property UsageDifferenceGB -Descending | ConvertTo-Html | Out-String)"