Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$LocalGroupScript = {
    $AdministratorMembershipData = Get-LocalGroupMember -Group 'Administrators'
    $RDPMembershipData = Get-LocalGroupMember -Group 'Remote Desktop Users'
    $PowerUsersMembershipData = Get-LocalGroupMember -Group 'Remote Desktop Users'
    $BackupOperatorsMembershipData = Get-LocalGroupMember -Group 'Backup Operators'
}

Import-Module '..\UtilityFunctions.ps1'

$Results = Invoke-Command -ComputerName (Return-ADOnlineComputers) -ScriptBlock $LocalGroupScript

Write-Output "$(Get-Date) [*] Report Generated. Sending mail."
Send-MailMessage @MailSettings -BodyAsHtml "$style "