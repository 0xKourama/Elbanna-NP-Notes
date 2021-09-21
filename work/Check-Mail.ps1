$Results = @()
foreach($mail in (Get-Clipboard | Sort-Object -Unique)){
    $mail = $mail.trim()
    $user = Get-ADUser -Filter {mail -eq $mail} -Properties Mail, DistinguishedName | Select-Object -Property Enabled, Name, Mail, @{n='OU';e={$_.DistinguishedName}}
    if($user){
        Write-Host -ForegroundColor Green "[+] Mail $mail found on AD"
        $Results += $user
        Clear-Variable -Name user
    }
    else{
        Write-Host -ForegroundColor Red "[-] Mail $mail not found on AD"
    }    
}
($Results | Format-Table | Out-String).Trim()
if($Results){
    $Results.Mail | Set-Clipboard
    Write-Host -ForegroundColor Green '[+] Existing mails sent to clipboard'
}
