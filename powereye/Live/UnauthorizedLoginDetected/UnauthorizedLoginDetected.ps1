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
                        Where-Object {$AuthorizedPersonnel -notcontains $_.Username} | 
                        Sort-Object -Property ComputerName | Select-Object -Property * -ExcludeProperty PSComputerName, PSShowComputerName, RunSpaceID


Write-Output "$(Get-Date) [*] Sending mail"

Send-MailMessage @MailSettings -BodyAsHtml "$style $body"