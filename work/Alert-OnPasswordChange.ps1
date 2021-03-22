#param($RecordID)

$ErrorActionPreference = 'Stop'

$Report  = @()

$Report += "<h3>Password Reset Detection Report from [$env:COMPUTERNAME]:</h3>"

try{
    $Admin_Security_Groups = @(
        'Administrators',
        'Domain Admins',
        'Enterprise Admins'
    )

    $Admin_Group_Members = $Admin_Security_Groups | % {Get-ADGroupMember -Identity $_ | ? {$_.ObjectClass -eq 'user'} | Select-Object -ExpandProperty SamAccountName} | Sort-Object -Unique

    $minutes_ago = 2
    $start_time  = (Get-Date).AddMinutes(-$minutes_ago)

    $Event_properties = @(
        'Message',
        'TimeCreated'
    )

    $Events = Get-WinEvent -FilterHashtable @{
        LogName='Security'
        id=4723,4724
        StartTime=$start_time
    } | Select-Object -Property $Event_properties

    $Report_empty = $true

    #loop through events, if the target account for password change was an administrator, add to report
    foreach($Event in $Events){
        $Message        = ($Event.Message | Select-String 'Account Name:.*' -AllMatches | Select-Object -ExpandProperty matches | Select-Object -ExpandProperty value) -replace ('\W') -replace ('AccountName')
        $Source_account = $Message[0]
        $Target_account = $Message[1]

        if($Admin_Group_Members -contains $Target_account){
            $Format_array = $Event.TimeCreated.ToString().Split(' ')
            $Date         = $Format_array[0]
            $Time         = $Format_array[1]
            $AMPM         = $Format_array[2]
            $Report      += '<b>[ ' + "$Date".PadLeft(10,' ') + ' ' + "$Time".PadLeft(8,' ') + ' ' + "$AMPM".PadLeft(2 ,' ') + " ]</b> an attempt was made by <b>$Source_account</b> to reset <b>$Target_account</b>'s password.<br>"
            $Report_empty = $false
        }
    }
}
catch{
    $Report += '<b>An error occured:</b><br>'
    $Report += $Error[0] | Select-Object -ExpandProperty Exception
    $Report_empty = $false
}

$Report = $Report | Out-String

if($Report_empty -eq $false){
    #send mail configuration
    $SMTP_server = 'mail.worldposta.com'
    $From        = 'PowerShell@worldposta.com'
    $To          = 'Operation@roaya.co'
    $Subject     = 'Admin Password Change'

    Send-MailMessage -SmtpServer $SMTP_server `
                     -From       $From        `
                     -To         $To          `
                     -Subject    $Subject     `
                     -Body       $Report      `
                     -Bcc        $bcc         `
                     -BodyAsHtml
                     
}