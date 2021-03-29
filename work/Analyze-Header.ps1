$mailfolder_path = "$env:USERPROFILE\Desktop\Test Messages"

$ErrorActionPreference = 'stop'

#$ol = New-Object -ComObject Outlook.Application

$emails = Get-ChildItem $mailfolder_path

ForEach ($email in $emails) {

    if($email.Extension -eq '.msg'){
        continue
        Write-Host "[*] MSG file $($email.fullname)`n" -ForegroundColor Yellow
        $msg = $ol.CreateItemFromTemplate("$($email.fullname)")
        $content = $msg.PropertyAccessor.GetProperty("http://schemas.microsoft.com/mapi/proptag/0x007D001E") -split "\n"
    }
    elseif($email.Extension -eq '.eml'){
        Write-Host "[*] EML file $($email.fullname)`n" -ForegroundColor Yellow
        $content = Get-Content $email.fullname
    }
    else{continue}

    #$headers = $headers -replace "^\s+"

    $headers = @()
    $counter = 0
    foreach($line in $content){
        Write-Host "LINE:      $line" -ForegroundColor Yellow
        if($line -match '^\S+:'){
            Write-Host "HEADER MATCH!" -ForegroundColor Green
            $string = ''
            $string += $line
        }
        elseif($line -match '^\s'){
            Write-Host "FOOTER MATCH!" -ForegroundColor Red
            $string += $line
            if($content[$counter+1] -match '^\S+:'){
                Write-Host "STRING! $string" -ForegroundColor Magenta
                $headers += $string
            }
        }
        $counter++
    }

    $headers = $headers | Out-String -Stream

    $sender_pattern = "^From: (.*)$"
    $recipient_pattern = "^To: (.*)$"
    $subject_pattern = "^Subject: (.*)$"
    $sender_data_pattern = "^Received: from (.*)$"

    try{
        $sender = ($headers | Select-String -Pattern $sender_pattern -AllMatches).Matches.Groups[1].Value
    }catch{
        $sender = "None"
    }
    try{
        $recipient = ($headers | Select-String -Pattern $recipient_pattern -AllMatches).Matches.Groups[1].Value
    }catch{
        $recipient = "None"
    }
    try{
        $subject = ($headers | Select-String -Pattern $subject_pattern -AllMatches).Matches.Groups[1].Value
    }catch{
        $subject = "None"
    }
    try{
        $senderData = ($headers | Select-String -Pattern $sender_data_pattern -AllMatches).Matches.Groups | 
        Where-Object {$_.Name -eq 1} |
        Select-Object -Last 1 -ExpandProperty value
    }catch{
        $senderData = "None"
    }

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

#$ol.Quit()