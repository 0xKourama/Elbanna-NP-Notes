Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$Result = Get-ADObject -Filter {objectclass -eq 'organizationalUnit'} -Properties ProtectedFromAccidentalDeletion, CanonicalName |
          Where-Object {$_.ProtectedFromAccidentalDeletion -eq $false -and $_.canonicalname -notlike 'Roaya.loc/Delete/*'} |
          Set-ADObject -ProtectedFromAccidentalDeletion:$true -PassThru

if($Result){
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Result | ConvertTo-Html -Fragment)"
}