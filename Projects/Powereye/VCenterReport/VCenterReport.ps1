Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope AllUsers, Session, User

Connect-VIServer -Server  -User '' -Password ''

$Results2 = @()
$Index = 0

foreach($VM in (Get-VM)){
	$VM.extensiondata.config.datastoreurl.name | Foreach-Object {
        $Index++
        $Results2 += [PSCustomObject][Ordered]@{
            Index          = $Index
            Name           = $VM
            DataStoreName  = $_
		    PowerState     = $VM.PowerState
		    CreateDate     = $VM.CreateDate
        }
    }
}

$SummaryHeader = "<h3>VM Summary</h3>"
$Summary = @"
<ul>
<li><b>Number of VMs: $((Get-VM).Count)</b></li>
<li style="color:#0bde0f;"><b>Online: $((Get-VM | Where-Object {$_.PowerState -eq 'PoweredOn'}).Count)</b></li>
<li style="color:#a3a0a0;"><b>Offline: $((Get-VM | Where-Object {$_.PowerState -eq 'PoweredOff'}).Count)</b></li>
<li style="color:#5a29cc;"><b>Suspended: $((Get-VM | Where-Object {$_.PowerState -eq 'Suspended'}).Count)</b></li>
</ul>
$(
    $NumberofColumns = 5
    $ColumnCounter = $NumberofColumns
    Get-VM | Sort-Object -Property PowerState -Descending | ForEach-Object -Begin {'<table>'} -End {'</table>'} {
        #Start new row if counter is equal to number of columns
        if($ColumnCounter -eq $NumberofColumns){
            '<TR>'
            if($_.PowerState -eq 'PoweredOn'){
                "<TD style=`"background-color:#0bde0f;`">$($_.Name)</TD>"
            }
            elseif($_.PowerState -eq 'Suspended'){
                "<TD style=`"background-color:#4520b3;`">$($_.Name)</TD>"
            }
            else{
                "<TD style=`"background-color:#a3a0a0;`">$($_.Name)</TD>"
            }
            $ColumnCounter--
        }
        #End row if counter is equal to 1
        elseif($ColumnCounter -eq 1){
            if($_.PowerState -eq 'PoweredOn'){
                "<TD style=`"background-color:#0bde0f;`">$($_.Name)</TD>"
            }
            elseif($_.PowerState -eq 'Suspended'){
                "<TD style=`"background-color:#4520b3;`">$($_.Name)</TD>"
            }
            else{
                "<TD style=`"background-color:#a3a0a0;`">$($_.Name)</TD>"
            }
            '</TR>'
            $ColumnCounter = $NumberofColumns
        }
        #write a normal table data otherwise
        else{
            if($_.PowerState -eq 'PoweredOn'){
                "<TD style=`"background-color:#0bde0f;`">$($_.Name)</TD>"
            }
            elseif($_.PowerState -eq 'Suspended'){
                "<TD style=`"background-color:#4520b3;`">$($_.Name)</TD>"
            }
            else{
                "<TD style=`"background-color:#a3a0a0;`">$($_.Name)</TD>"
            }
            $ColumnCounter--
        }
    }
)
"@

$Header1 = "<h3>VCenter Report</h3>"
$Header2 = "<h3>VCenter Local DataStore Report</h3>"

Write-Output "$(Get-Date) [+] Report generated. Sending mail."

Send-MailMessage @MailSettings1 -BodyAsHtml "$Style $SummaryHeader $Summary $Header1 $(
    Get-VM | Select-Object -Property Name,PowerState,NumCpu,CoresPerSocket,MemoryGB,@{n='UsedSpaceGB';e={[Math]::Round($_.UsedSpaceGB,2)}}, ResourcePool, CreateDate |
    ConvertTo-Html -Fragment | Out-String
)"

Disconnect-VIServer -Confirm:$false

Send-MailMessage @MailSettings2 -BodyAsHtml "$Style $Header2 $($Results2 | ConvertTo-Html -Fragment | Out-String)"