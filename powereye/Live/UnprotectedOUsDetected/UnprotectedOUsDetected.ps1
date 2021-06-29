Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$Result = Get-ADOrganizationalUnit -Filter * -Properties ProtectedFromAccidentalDeletion, CanonicalName |
Where-Object {$_.ProtectedFromAccidentalDeletion -eq $false -and $_.canonicalname -notlike 'Roaya.loc/Delete/*'} |
Select-Object @{n='OU';e={$_.Name}}, @{n='Location';e={$_.canonicalname -replace '/',' > '}} | Sort-Object

if($Result){
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Result | ConvertTo-Html -Fragment)"
}