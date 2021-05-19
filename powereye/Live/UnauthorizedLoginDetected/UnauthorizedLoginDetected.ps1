Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

Import-Module '..\UtilityFunctions.ps1'

$session_script = {
    $List = @()
    Try{
        $ErrorActionPreference = 'stop'
        Quser | Select -Skip 1 | ForEach-Object {
            $List += [PSCustomObject][Ordered]@{
                ComputerName = $env:COMPUTERNAME
                Username     = $_.Substring(1 , 22).Trim().toUpper()
                ID           = $_.Substring(42, 4 ).Trim()
                LogonTime    = $_.Substring(65, ($_.Length - 65)).Trim().toUpper()
                State        = if(($_.Substring(46, 8 ).Trim().toUpper()) -eq 'DISC'){'INACTIVE'}else{'ACTIVE'}
                SessionType  = $_.substring(23,19).Trim().toUpper() -replace '-.*'
            }
        }
    }
    Catch{
        $List += [PSCustomObject][Ordered]@{
            ComputerName = $env:COMPUTERNAME
            Username     = 'NONE'
        }
    }
    Write-Output $List
}

$Online = Return-OnlineComputers -ComputerNames (Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address}).Name

$AuthorizedPersonnel = (Get-ADGroupMember -Identity 'Authorized Personnel').SamAccountName

$UnAuthorizedSessions = Invoke-Command -ComputerName $Online -ErrorAction SilentlyContinue -ScriptBlock $session_script |
                        Where-Object {$AuthorizedPersonnel -notcontains $_.Username -and $_.Username -ne 'NONE'} |
                        Sort-Object -Property ComputerName | Select-Object -Property * -ExcludeProperty PSComputerName, PSShowComputerName, RunSpaceID

$LogoffScript = {
    logoff $args[0]
    if($?){
        [PSCustomObject][Ordered]@{
            ComputerName = $env:COMPUTERNAME
            Username     = $args[1]
            Logoff       = 'Success'
        }
    }
    else{
        [PSCustomObject][Ordered]@{
            ComputerName = $env:COMPUTERNAME
            Username     = $args[1]
            Logoff       = 'Fail'
        }        
    }
}

$LogoffResults = @()

$UnAuthorizedSessions | ForEach-Object {
    $LogoffResults += Invoke-Command -ComputerName $_.ComputerName -ScriptBlock $LogoffScript -ArgumentList $_.ID, $_.Username |
                      Select-Object -Property * -ExcludeProperty PSComputerName, RunspaceId, PSShowComputerName
}

$AuthorizedPersonnelList = @"
<h3>Authorized Personnel</h3>
$($AuthorizedPersonnel | Sort-Object | ForEach-Object -Begin {'<ul>'} -Process {"<li>$($_.ToUpper())</li>"} -End {"</ul>"})
"@

if($LogoffResults){

$UnAuthorizedUsersDetected = @"
<h3>Unauthorized User(s) Detected</h3>
$($UnAuthorizedSessions.Username | Sort-Object -Unique | ForEach-Object -Begin {'<ul>'} -Process {"<li>$($_.ToUpper())</li>"} -End {"</ul>"})
"@

$UnAuthorizedSessionDetails = @"
<h3>Unauthorized Session Details</h3>
$($UnAuthorizedSessions | Select-Object -Property * -ExcludeProperty ID | ConvertTo-Html -Fragment)
"@

$LogoffSummary = @"
<h3>Logoff Results</h3>
$($LogoffResults | ConvertTo-Html -Fragment)
"@

}

if($UnAuthorizedSessions){
    Write-Output "$(Get-Date) [*] Unauthorized logins detected. Sending mail"
    Send-MailMessage @MailSettings -BodyAsHtml "$style $UnAuthorizedUsersDetected $UnAuthorizedSessionDetails $LogoffSummary $AuthorizedPersonnelList"
}
else{
    Write-Output "$(Get-Date) [*] No unauthorized logins detected."
}