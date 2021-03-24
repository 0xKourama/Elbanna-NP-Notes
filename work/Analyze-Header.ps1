<#
$mailfolder_path = "$env:USERPROFILE\Desktop\Test Messages"

$ErrorActionPreference = 'stop'

$ol = New-Object -ComObject Outlook.Application

foreach ($email in (Get-ChildItem $mailfolder_path -Recurse)){

    Clear-Variable -Name Sender, SenderData, Recipient, Subject, headers, headers_multi, headers_single

    Write-Host "[*] Performing header analysis for $($email.Fullname)" -ForegroundColor Yellow

    if($email.Extension -eq '.msg'){
        Write-Host "[*] MSG file $($email.fullname)`n" -ForegroundColor Cyan
        $msg = $ol.CreateItemFromTemplate("$($email.fullname)")
        $headers = $msg.PropertyAccessor.GetProperty("http://schemas.microsoft.com/mapi/proptag/0x007D001E")
    }
    elseif($email.Extension -eq '.eml'){
        Write-Host "[*] EML file $($email.fullname)`n" -ForegroundColor Cyan
        $headers = Get-Content $email.fullname
    }

    $headers_multi = $headers -split "\n"
    $headers_single = $headers | Out-String

    try{

        $Sender = (
            $headers_multi | Select-String -Pattern "^From:.*\s+(\S+@\S+)" -AllMatches | #  # "From: [\S\s]*?(\S+@\S+)[\S\s]*?Date:"
            Select-Object -ExpandProperty matches |
            Select-Object -ExpandProperty groups
        )[1].value -replace "<" -replace ">"

    }
    catch{
        try{
            $Sender = (
                $headers_single | Select-String -Pattern "From: [\S\s]*?(\S+@\S+)" -AllMatches | #Date:  #[\S\s]*?
                Select-Object -ExpandProperty matches |
                Select-Object -ExpandProperty groups
            )[1].value -replace "<" -replace ">"
        }
        catch{
            $Sender = (
                $headers_multi | Select-String -Pattern "^Sender:.*\s+(\S+@\S+)" -AllMatches |
                Select-Object -ExpandProperty matches |
                Select-Object -ExpandProperty groups
            )[1].value -replace "<" -replace ">"
        }
    }

    try{
        $Recipient = (
            $headers_multi | Select-String -Pattern "^To: [\S\s]*?(\S+@\S+)" -AllMatches |  #  ^To:.*\s+(\S+@\S+)
            Select-Object -ExpandProperty matches |
            Select-Object -ExpandProperty groups
        )[1].value -replace "<" -replace ">"
    }
    catch{
        try{
            $Recipient = (
                $headers_single | Select-String -Pattern "\sTo: [\S\s]*?(\S+@\S+)" -AllMatches |  #  ^To:.*\s+(\S+@\S+)
                Select-Object -ExpandProperty matches |
                Select-Object -ExpandProperty groups
            )[1].value -replace "<" -replace ">"
        }
        catch{
            $Recipient = "None"
        }
    }

    $Subject = (
        $headers_multi | Select-String -Pattern "^Subject: (.*)" -AllMatches |  #  "Subject: (.*) To:"
        Select-Object -ExpandProperty matches |
        Select-Object -ExpandProperty groups    
    )[1].value

    $SenderData = (
        $headers_multi | Select-String -Pattern "^Received: from ([\[\(]?.*[\]\)]?)" -AllMatches |  #  "^Received: from .*\((.*)\)"
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
    Write-Host "-------------------------------------------------------------------------"
    Read-Host
}
#>

$mailfolder_path = "$env:USERPROFILE\Desktop\Test Messages"

$ErrorActionPreference = 'stop'

$ol = New-Object -ComObject Outlook.Application

Get-ChildItem $mailfolder_path -Recurse | ForEach-Object {

    Write-Host "[*] Performing header analysis for $($_.Fullname)" -ForegroundColor Cyan

    if($_.Extension -eq '.msg'){
        Write-Host "[*] MSG file $($_.fullname)`n" -ForegroundColor Yellow
        $msg = $ol.CreateItemFromTemplate("$($_.fullname)")
        $headers  = $msg.PropertyAccessor.GetProperty("http://schemas.microsoft.com/mapi/proptag/0x007D001E") -split "\n"
    }
    elseif($_.Extension -eq '.eml'){
        Write-Host "[*] EML file $($_.fullname)`n" -ForegroundColor Yellow
        $headers  = Get-Content $_.fullname
    }

    $headers = $headers -replace "\n^\s+"

    $sender_pattern = "^From: (.*)"
    $recipient_pattern = "^To: (.*)"
    $subject_pattern = "^Subject: (.*)"
    $Sender_data_pattern = "^Received: from (.*)"

    $sender    = ($headers | Select-String -Pattern $sender_pattern    -AllMatches).matches.Groups[1].Value
    $Recipient = ($headers | Select-String -Pattern $recipient_pattern -AllMatches).matches.Groups[1].Value
    $Subject   = ($headers | Select-String -Pattern $subject_pattern   -AllMatches).matches.Groups[1].Value
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