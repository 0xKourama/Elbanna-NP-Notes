Set-Content -Path charge.txt -Value (((Get-Content charge.txt) -as [int]) + 1)
