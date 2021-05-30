Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$Groups = @(
    'Administrators'
    'Power Users'
    'Backup Operators'
    'Remote Desktop Users'
)

$LocalGroupScript = {
    $Groups = $args
    $GroupData = @()
    foreach($Group in $Groups){
        $Data = Get-LocalGroupMember -Group $Group
        $Data | ForEach-Object {$_ | Add-Member -NotePropertyName 'Group' -NotePropertyValue $Group}
        $GroupData += $Data
    }
    $GroupData
}

Import-Module '..\UtilityFunctions.ps1'

$Results = Invoke-Command -ComputerName (Return-ADOnlineComputers) -ScriptBlock $LocalGroupScript -ArgumentList $Groups |
           Select-Object -Property @{n='ComputerName';e={$_.PSComputername}},
                                   Group,
                                   @{n='Type';e={$_.ObjectClass}},
                                   @{n='Scope';e={if($_.name -match "$($_.PSComputerName)\\.*"){'Local'}else{'ActiveDirectory'}}},
                                   Name
$Body = ""
foreach($Group in $Groups){

$Data = $Results | Where-Object {$_.Group -eq $Group}
if($Data){
$Body += @"
<h3>$Group</h3>
$($Data | ConvertTo-Html -Fragment | Out-String)
"@    
}

}

Write-Output "$(Get-Date) [*] Report Generated. Sending mail."
Send-MailMessage @MailSettings -BodyAsHtml "$style $Body"