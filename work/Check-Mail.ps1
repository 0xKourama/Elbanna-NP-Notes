$Results = @()
foreach($mail in (Get-Clipboard)){
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
($Results | Format-Table -AutoSize -Wrap | Out-String).Trim()