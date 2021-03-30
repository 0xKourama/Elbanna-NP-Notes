$script = {

    $Ignored_Shares = @(
        'IPC$'
        'C$'
        'ADMIN$'
    )

    Get-SmbShare | Where-Object {$Ignored_Shares -notcontains $_.Name} | Select-Object -Property Name, Path, Description
}

$result = Invoke-Command -Session $sessions -ScriptBlock $script | Select-Object -Property * -ExcludeProperty RunSpaceID, PSShowComputerName

$Header = @"
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
    background-color: #0000CD;
    padding: 3px;
    text-align: Center;
    border: 2px solid black;
}
</style>
<h3>Results:</h3>
"@

$ResultHTML = $Result | ConvertTo-Html -Fragment

Send-MailMessage -SmtpServer $SMTPServer -From $Sender -To $Recipient -Subject $Subject -BodyAsHtml "$Header $ResultHTML"