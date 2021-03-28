$outlook = New-Object -comobject outlook.application
Get-ChildItem "C:\Users\admin\Desktop\Test Messages" -Filter *.msg |
    ForEach-Object {
        $msg = $outlook.Session.OpenSharedItem($_.FullName)
        $Sender = $msg.SenderEmailAddress
        $Subject = $msg.Subject
        $Recipient = $msg.to
        Write-Host -NoNewline "Sender      : "
        Write-Host -ForegroundColor Green $Sender
        #Write-Host -NoNewline "Sender Data : " 
        #Write-Host -ForegroundColor Cyan $SenderData
        Write-Host -NoNewline "Recipient   : "
        Write-Host -ForegroundColor Magenta $Recipient
        Write-Host -NoNewline "Subject     : "
        Write-Host -ForegroundColor Yellow $Subject
        Write-Host "-------------------------------------------------------------------------------"
        Read-Host
    }

$outlook.Quit()