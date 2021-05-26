Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope AllUsers, Session, User

Connect-VIServer -Server 10.5.5.20 -User 'powercli@worldposta.com' -Password 'R4Jj2xrJG!9N-h'

$VMs = Get-VM

$Results1 = $VMs | Select-Object -Property Name,PowerState,NumCpu,CoresPerSocket,MemoryGB,@{n='UsedSpaceGB';e={[Math]::Round($_.UsedSpaceGB,2)}},ResourcePool,CreateDate

$Results2 = @()
$Index = 0

foreach($VM in $VMs){
	$VM.extensiondata.config.datastoreurl.name | Foreach-Object {
        if($_ -notmatch 'EMC-.*|wp-Exchange'){
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
}

Write-Output "$(Get-Date) [+] Report generated. Sending mail."

Write-Output $Results1
Write-Output $Results2

Send-MailMessage @MailSettings1 -BodyAsHtml "$Style $Header1 $($Results1 | ConvertTo-Html -Fragment | Out-String)"

Send-MailMessage @MailSettings2 -BodyAsHtml "$Style $Header2 $($Results2 | ConvertTo-Html -Fragment | Out-String)"