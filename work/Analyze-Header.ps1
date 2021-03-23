$mail_path = "$env:USERPROFILE\Desktop\Test Messages\Headers"

#$ol = New-Object -ComObject Outlook.Application

foreach ($email in (Get-ChildItem $mail_path -Recurse | Select-Object -ExpandProperty fullname)){

    Write-Host "`n[*] Performing header analysis for $email`n" -ForegroundColor Yellow
    Clear-Variable -Name Sender, SenderData, Recipient, Subject, headers
    <#
    $msg = $ol.CreateItemFromTemplate("$email")
    $headers = $msg.PropertyAccessor.GetProperty("http://schemas.microsoft.com/mapi/proptag/0x007D001E")
    #>

    $headers = Get-Content $email

    $headers

    pause

    $Sender = (
        $headers | Select-String -Pattern "^From:.*\s+(\S+@\S+)" -AllMatches |
        Select-Object -ExpandProperty matches |
        Select-Object -ExpandProperty groups
    )[1].value -replace "<" -replace ">"

    $Recipient = (
        $headers | Select-String -Pattern "^To:.*\s+(\S+@\S+)" -AllMatches |  #^To: ((\S+\,\s+)*\S+)
        Select-Object -ExpandProperty matches |
        Select-Object -ExpandProperty groups
    )[1].value -replace "<" -replace ">"

    $Subject = (
        $headers | Select-String -Pattern "^Subject: (.*)" -AllMatches |
        Select-Object -ExpandProperty matches |
        Select-Object -ExpandProperty groups    
    )[1].value

    $SenderData = (
        $headers | Select-String -Pattern "^Received: from .*\((.*)\)" -AllMatches |
        Select-Object -ExpandProperty matches -Last 1 |
        Select-Object -ExpandProperty groups -Last 1
    )[1].Value

    Write-Host -NoNewline "Sender      : "
    Write-Host -ForegroundColor Green $Sender
    Write-Host -NoNewline "Sender Data : " 
    Write-Host -ForegroundColor Cyan $SenderData
    Write-Host -NoNewline "Recipient   : "
    Write-Host -ForegroundColor Magenta $Recipient
    Write-Host -NoNewline "Subject     : "
    Write-Host -ForegroundColor Yellow $Subject

    pause
}