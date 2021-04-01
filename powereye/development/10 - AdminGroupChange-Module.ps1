$Admin_Security_Groups = @(
    'Server Operators'
    'Administrators'
    'Domain Admins'
    'Enterprise Admins'
    'Schema Admins'
)

$GroupFolder_Path = ""

#region load stored group membership files
$Admin_Security_Groups | ForEach-Object {
    New-Variable -Name ($_ -replace ' ') -Value (Get-Content (Join-Path -Path $GroupFolder_Path -ChildPath "$($_ -replace ' ')-Members.txt"))
}
#end region

#region get latest group membership data from AD
$Admin_Group_Members = $Admin_Security_Groups | ForEach-Object {
    Get-ADGroupMember -Identity $_ | Where-Object {$_.ObjectClass -eq 'user'} |
    Select-Object -ExpandProperty SamAccountName | Sort-Object -Unique > "$($_ -replace ' ')-Members.txt"
}
#end region



Write-Host -ForegroundColor Cyan "[*] Module running at $(Get-Date)"

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
    background-color: #FF0000;
    padding: 3px;
    text-align: Center;
    border: 2px solid black;
}
</style>
"@

$header = @"
<h3>Admin Group Changed</h3>
"@

<#
$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'AdminGroupChange@roaya.co'
    #To         = 'operation@roaya.co'
    To         = 'MGabr@roaya.co'
    Subject    = 'PowerEye | Admin Group Change'
}

Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header "
Write-Host -ForegroundColor Cyan '[*] Sleeping for 10 minutes'
Start-Sleep -Seconds 600
#>