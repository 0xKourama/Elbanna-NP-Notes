Set-Content -Path charge.txt -Value (((Get-Content charge.txt) -as [int]) + 1)
git add charge.txt
git commit -m 'charge increase'
git push