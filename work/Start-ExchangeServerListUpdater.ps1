$UserCredential = Get-Credential
$Exchange_Server = 'EU1MB9903.roaya.loc'
while($true){
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange `
                             -ConnectionUri http://$Exchange_Server/PowerShell/ `
                             -Authentication Kerberos `
                             -Credential $UserCredential

    if($Session){
        Import-PSSession $Session -DisableNameChecking
        Invoke-Command $Session -ScriptBlock {Get-ExchangeServer | Select-Object -ExpandProperty Name} > .\full-exch-serverlist.txt
        if($? -eq $true){
            Write-Host "[+] Exchange Servers List Updated from $Exchange_Server at $(Get-Date)" -ForegroundColor Green
        }
        else{
            Write-Host "[+] Exchange Servers List Failed Update from $Exchange_Server" -ForegroundColor Red
        }
        Remove-PSSession $Session
    }
    else{
        Write-Host "[+] Failed to start session with $Exchange_Server" -ForegroundColor Red
    }
    Start-Sleep -Seconds 600
}