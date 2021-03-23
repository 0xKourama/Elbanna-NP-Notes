$mail_path = 'C:\Users\admin\Desktop\Test Messages\*'

$ol = New-Object -ComObject Outlook.Application

foreach ($email in (Get-ChildItem $mail_path -Recurse | Select-Object -ExpandProperty fullname)){

    Write-Host "`n[*] Performing header analysis for $email`n" -ForegroundColor Yellow

    $msg = $ol.CreateItemFromTemplate("$email")
    $headers = $msg.PropertyAccessor.GetProperty("http://schemas.microsoft.com/mapi/proptag/0x007D001E")

    $headers

    pause

    $Sender = (
        $headers | Select-String -Pattern "From: .*\s+<(.*)>" -AllMatches |
        Select-Object -ExpandProperty matches |
        Select-Object -ExpandProperty groups
    )[1].value

    $Recipient = (
        $headers | Select-String -Pattern "To: <?(.*)>?" -AllMatches |
        Select-Object -ExpandProperty matches |
        Select-Object -ExpandProperty groups
    )[1].value

    $Subject = (
        $headers | Select-String -Pattern "Subject: (.*)" -AllMatches |
        Select-Object -ExpandProperty matches |
        Select-Object -ExpandProperty groups    
    )[1].value

    $SenderIP = (
        $headers | Select-String -Pattern "Received: from .*[\(\[](.*)[\)\]]" -AllMatches |
        Select-Object -ExpandProperty matches -Last 1 |
        Select-Object -ExpandProperty groups -Last 1
    )[1].value -replace "]"

    Write-Host -NoNewline "Sender   : "
    Write-Host -ForegroundColor Green $Sender
    Write-Host -NoNewline "SenderIP : " 
    Write-Host -ForegroundColor Cyan $SenderIP
    Write-Host -NoNewline "Recipient: "
    Write-Host -ForegroundColor Magenta $Recipient
    Write-Host -NoNewline "Subject  : "
    Write-Host -ForegroundColor Yellow $Subject

    Clear-Variable -Name Sender, SenderIP, Recipient, Subject, msg, headers

    pause
}