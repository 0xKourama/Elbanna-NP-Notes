$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'ServiceInstallation@Roaya.co'
    #To         = 'Operation@Roaya.co'
    To         = 'MGabr@Roaya.co'
    Subject    = 'Service Installation'
}

$Header = "<h3>Service Installation</h3>"

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
    background-color: #0596F4;
    text-align: Center;
    border: 2px solid black;
}
</style>
"@

$Script = {    
    $Results = @()
    $ErrorActionPreference = 'SilentlyContinue'
    $EventID = 7045
    $XML_Path = "C:\Users\Public\Event_$EventID`_LastCheck.xml"

    if(!(Test-Path -Path $XML_Path)){
        $Events = Get-WinEvent -FilterHashtable @{LogName = 'System'; ID = 7045} | Select-Object -Property Message, TimeCreated
    }
    else{
        $Events = Get-WinEvent -FilterHashtable @{LogName = 'System'; ID = 7045; StartTime = Import-Clixml -Path $XML_Path} |
                  Select-Object -Property Message, TimeCreated
    }
    Get-Date | Export-Clixml -Path $XML_Path

    foreach($Event in $Events){
        $SplitMessage = $Event.Message -split '\n'
        $Results += [PSCustomObject][Ordered]@{
            ComputerName      = $env:COMPUTERNAME
            Date              = $Event.TimeCreated
            ServiceName       = ($SplitMessage | Select-String -Pattern "^Service Name:  (.*)$"       -AllMatches).Matches.Groups[1].Value
            ServiceFileName   = ($SplitMessage | Select-String -Pattern "^Service File Name:  (.*)$"  -AllMatches).Matches.Groups[1].Value
            ServiceType       = ($SplitMessage | Select-String -Pattern "^Service Type:  (.*)$"       -AllMatches).Matches.Groups[1].Value
            ServiceStartType  = ($SplitMessage | Select-String -Pattern "^Service Start Type:  (.*)$" -AllMatches).Matches.Groups[1].Value
            ServiceAccount    = ($SplitMessage | Select-String -Pattern "^Service Account:  (.*)$"    -AllMatches).Matches.Groups[1].Value
        }
    }
    Write-Output $Results
}

$Online = (Get-ADComputer -Filter * | Select-Object -Property @{name = 'ComputerName'; Expression = {$_.name}} | 
          Test-Connection -Count 1 -AsJob | Receive-job -Wait | Where-Object {$_.statuscode -eq 0}).Address

$Results = Invoke-Command -ComputerName $Online -ScriptBlock $Script -ErrorAction SilentlyContinue | 
           Select-Object -Property * -ExcludeProperty PSComputerName, RunspaceId, PSShowComputerName

if($Results){
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Results | ConvertTo-Html -Fragment | Out-String)"
}