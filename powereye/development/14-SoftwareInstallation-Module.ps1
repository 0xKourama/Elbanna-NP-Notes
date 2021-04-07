$SleepIntervalSeconds = New-TimeSpan -Minutes 10

$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'SoftwareInstallation@roaya.co'
    #To         = 'operation@roaya.co'
    To         = 'mgabr@roaya.co'
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
        
    $Event_properties = @(
        'Message',
        'TimeCreated'
    )

    $Results = @()

    try{
        if(!(Test-Path 'C:\Users\Public\Event_11707_LastCheck.xml')){
            $Events = Get-WinEvent -FilterHashtable @{
                LogName = 'Application'
                ID = 11707
            } -ErrorAction Stop | Select-Object -Property $Event_properties
        }
        <#else{
            $start_time = Import-Clixml 'C:\Users\Public\Event_11707_LastCheck.xml'
            $Events = Get-WinEvent -FilterHashtable @{
                LogName = 'Application'
                ID = 11707
                StartTime=$start_time
            } -ErrorAction Stop | Select-Object -Property $Event_properties    
        }
        Get-Date | Export-Clixml 'C:\Users\Public\Event_11707_LastCheck.xml'
        #>


        #Product: Microsoft ASP.NET MVC 4 Runtime -- Installation completed successfully.

        foreach($Event in $Events){
            $obj = [PSCustomObject][Ordered]@{
                ComputerName = $env:COMPUTERNAME
                Date         = $Event.TimeCreated
                Product      = ($Event.Message | Select-String -Pattern "^Product: (.*) -- Installation completed successfully.$" -AllMatches).Matches.Groups[1].Value
                Error        = 'N/A'
            }
            $Results += $obj
        }
        Write-Output $Results
    }
    catch{
        $obj = [PSCustomObject][Ordered]@{
            ComputerName      = $env:COMPUTERNAME
            Date              = 'N/A'
            Product           = 'N/A'
            Error             = $Error[0]
        }
        $Results += $obj
    }
}

while($true){

    Write-Host -ForegroundColor Cyan "[*] Module running at $(Get-Date)"

    $Online = Get-ADComputer -Filter * | Select-Object -Property @{name = 'ComputerName'; Expression = {$_.name}} | 
              Test-Connection -Count 1 -AsJob | Receive-job -Wait | Where-Object {$_.statuscode -eq 0} | Select-Object -ExpandProperty Address

    $Results = Invoke-Command -ComputerName $Online -ScriptBlock $Script -ErrorAction SilentlyContinue | 
               Select-Object -Property * -ExcludeProperty PSComputerName, RunspaceId, PSShowComputerName

    if($Results){
        Write-Host -ForegroundColor Yellow '[!] Software installation(s) detected. Sending Email'
        Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Results | ConvertTo-Html)"
        Clear-Variable -Name Results
    }
    else{
        Write-Host -ForegroundColor Green '[+] No Software installations detected'
    }

    Write-Host -ForegroundColor Cyan "[*] Sleeping for $($SleepIntervalSeconds.Hours) hours and $($SleepIntervalSeconds.Minutes) Minutes"

    Start-Sleep -Seconds $SleepIntervalSeconds.TotalSeconds
}