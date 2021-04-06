$SleepIntervalSeconds = New-TimeSpan -Minutes 10

$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'ServiceInstallation@roaya.co'
    To         = 'operation@roaya.co'
    #To         = 'mgabr@roaya.co'
    Subject    = 'Service Installation'
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
    background-color: #0596F4;
    text-align: Center;
    border: 2px solid black;
}
</style>
"@

$Header = "<h3>Service Installation</h3>"

$Script = {
        
    $Event_properties = @(
        'Message',
        'TimeCreated'
    )

    $Results = @()

    try{
        if(!(Test-Path 'C:\Users\Public\Event_7045_LastCheck.xml')){
            $Events = Get-WinEvent -FilterHashtable @{
                LogName = 'System'
                ID = 7045
            } -ErrorAction Stop | Select-Object -Property $Event_properties
        }
        else{
            $start_time = Import-Clixml 'C:\Users\Public\Event_7045_LastCheck.xml'
            $Events = Get-WinEvent -FilterHashtable @{
                LogName = 'System'
                ID = 7045
                StartTime=$start_time
            } -ErrorAction Stop | Select-Object -Property $Event_properties    
        }
        Get-Date | Export-Clixml 'C:\Users\Public\Event_7045_LastCheck.xml'

        foreach($Event in $Events){
            $SplitMessage = $Event.Message -split '\n'
            $obj = [PSCustomObject][Ordered]@{
                ComputerName      = $env:COMPUTERNAME
                Date              = $Event.TimeCreated
                ServiceName       = ($SplitMessage | Select-String -Pattern "^Service Name:  (.*)$" -AllMatches).Matches.Groups[1].Value
                ServiceFileName   = ($SplitMessage | Select-String -Pattern "^Service File Name:  (.*)$" -AllMatches).Matches.Groups[1].Value
                ServiceType       = ($SplitMessage | Select-String -Pattern "^Service Type:  (.*)$" -AllMatches).Matches.Groups[1].Value
                ServiceStartType  = ($SplitMessage | Select-String -Pattern "^Service Start Type:  (.*)$" -AllMatches).Matches.Groups[1].Value
                ServiceAccount    = ($SplitMessage | Select-String -Pattern "^Service Account:  (.*)$" -AllMatches).Matches.Groups[1].Value
                Error             = 'N/A'
            }
            $Results += $obj
        }
        Write-Output $Results
    }
    catch{
        $obj = [PSCustomObject][Ordered]@{
            ComputerName      = $env:COMPUTERNAME
            Date              = 'N/A'
            ServiceName       = 'N/A'
            ServiceFileName   = 'N/A'
            ServiceType       = 'N/A'
            ServiceStartType  = 'N/A'
            ServiceAccount    = 'N/A'
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
        Write-Host -ForegroundColor Yellow '[!] Service installation(s) detected. Sending Email'
        Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Results | ConvertTo-Html)"
        Clear-Variable -Name Results
    }
    else{
        Write-Host -ForegroundColor Green '[+] No Service installations detected'
    }

    Write-Host -ForegroundColor Cyan "[*] Sleeping for $($SleepIntervalSeconds.Hours) hours and $($SleepIntervalSeconds.Minutes) Minutes"

    Start-Sleep -Seconds $SleepIntervalSeconds.TotalSeconds
}