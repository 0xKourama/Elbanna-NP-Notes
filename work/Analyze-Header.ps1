$mailfolder_path = "$env:USERPROFILE\Desktop\Test Messages"

$ErrorActionPreference = 'stop'

$ol = New-Object -ComObject Outlook.Application

$emails = Get-ChildItem $mailfolder_path

ForEach ($email in $emails) {

    Write-Host "[*] Performing header analysis for $email" -ForegroundColor Cyan

    if($email.Extension -eq '.msg'){
        Write-Host "[*] MSG file $($email.fullname)`n" -ForegroundColor Yellow
        $msg = $ol.CreateItemFromTemplate("$($email.fullname)")
        $headers = $msg.PropertyAccessor.GetProperty("http://schemas.microsoft.com/mapi/proptag/0x007D001E") -split "\n"
    }
    elseif($email.Extension -eq '.eml'){
        Write-Host "[*] EML file $($email.fullname)`n" -ForegroundColor Yellow
        $headers  = Get-Content $email.fullname
    }

    $headers = $headers -replace "\n^\s+"

    $sender_pattern = "^From: (.*)"
    $recipient_pattern = "^To: (.*)"
    $subject_pattern = "^Subject: (.*)"
    $Sender_data_pattern = "^Received: from (.*)"

    $sender    = ($headers | Select-String -Pattern $sender_pattern    -AllMatches).matches.Groups[1].Value
    try{
        $Recipient = ($headers | Select-String -Pattern $recipient_pattern -AllMatches).matches.Groups[1].Value
    }catch{
        $Recipient = "None"
    }
    try{
        $Subject   = ($headers | Select-String -Pattern $subject_pattern   -AllMatches).matches.Groups[1].Value
    }catch{
        $Subject   = "None"
    }
    $SenderData = (
        $headers | Select-String -Pattern $Sender_data_pattern -AllMatches |
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
    Write-Host "-------------------------------------------------------------------------------"
    Read-Host
}

$ol.Quit()