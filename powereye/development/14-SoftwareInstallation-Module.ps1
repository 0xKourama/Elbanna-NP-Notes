﻿$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'SoftwareInstallation@Roaya.co'
    #To         = 'Operation@Roaya.co'
    To         = 'MGabr@Roaya.co'
    Subject    = 'Software Installation'
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
    background-color: #ebc402;
    text-align: Center;
    border: 2px solid black;
}
</style>
"@

$Header = "<h3>Software Installation</h3>"

$Script = {
    
    $ErrorActionPreference = 'SilentlyContinue'
        
    $Event_properties = @(
        'Message',
        'TimeCreated'
    )

    $EventID = 11707
    $XML_Path = "C:\Users\Public\Event_$EventID`_LastCheck.xml"

    $Results = @()

    if(!(Test-Path $XML_Path)){
        $Events = Get-WinEvent -FilterHashtable @{LogName = 'Application'; ID = $EventID} |
                  Select-Object -Property $Event_properties
    }
    else{
        $Events = Get-WinEvent -FilterHashtable @{LogName = 'Application'; ID = $EventID; StartTime = Import-Clixml -Path $XML_Path} |
                  Select-Object -Property $Event_properties    
    }

    Get-Date | Export-Clixml -Path $XML_Path

    $Events | ForEach-Object {
        $Results += [PSCustomObject][Ordered]@{
            ComputerName = $env:COMPUTERNAME
            Date         = $_.TimeCreated
            Product      = ($_.Message | Select-String -Pattern "^Product: (.*) -- Installation completed successfully.$" -AllMatches).Matches.Groups[1].Value
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