Set-Content -Path charge.txt -Value (((Get-Content charge.txt) -as [int]) + 1)
Write-Host -ForegroundColor Green "[+] Charge increased to $(Get-Content charge.txt) days :D"