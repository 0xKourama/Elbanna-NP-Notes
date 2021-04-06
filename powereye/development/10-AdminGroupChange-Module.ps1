$Log_path = ""

$Admin_Security_Groups = @(
    'Server Operators'
    'Administrators'
    'Domain Admins'
    'Enterprise Admins'
    'Schema Admins'
)

Class SecurityGroup {
    [string]$Name
    [string]$Members
}

if(Test-Path $Log_path){
    $OldGroupData = Import-Csv $Log_path
}

$NewGroupData = @()

$Admin_Security_Groups | ForEach-Object {
    $NewGroupData += [SecurityGroup]@{
        Name = $_
        Members = (Get-ADGroupMember -Identity $_ | Where-Object {$_.ObjectClass -eq 'user'} | 
                  Select-Object -ExpandProperty SamAccountName | Sort-Object) -join ';'
    }
}

$ChangedGroups = @()

if($OldGroupData){
    0..($Admin_Security_Groups.Count - 1) | ForEach-Object {
        $difference = Compare-Object -ReferenceObject $OldGroupData[$_] -DifferenceObject $NewGroupData[$_]
        if($difference){
            $ChangedGroups += $Admin_Security_Groups[$_]
        }
    }
}

$NewGroupData | Export-Csv -NoTypeInformation GroupLog.csv

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

$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'AdminGroupChange@roaya.co'
    #To         = 'operation@roaya.co'
    To         = 'MGabr@roaya.co'
    Subject    = 'Admin Group Change'
}

if($ChangedGroups){
    $Body = $ChangedGroups | ConvertTo-Html -Fragment
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $Body"    
}