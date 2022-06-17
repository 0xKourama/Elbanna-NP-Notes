$command = 'JNckMHcZC4drSExtYJgOci4DPGA=&#10;'
$bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
$encodedCommand = [Convert]::ToBase64String($bytes)
Write-Host -ForegroundColor Green "[+] Encoded text`n$encodedCommand"
#powershell.exe -encodedCommand $encodedCommand -noprofile