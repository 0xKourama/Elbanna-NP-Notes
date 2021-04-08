$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'CortexEndpointMissing@Roaya.co'
    #To         = 'Operation@Roaya.co'
    To         = 'MGabr@Roaya.co'
    Subject    = 'Cortex Endpoint Missing'
}

#region HTML Layout
$Header = "<h3>Cortex Endpoint Missing</h3>"

$style = @"
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
    background-color: #FF0000;
    padding: 3px;
    text-align: Center;
    border: 2px solid black;
}
</style>
"@
#endregion

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