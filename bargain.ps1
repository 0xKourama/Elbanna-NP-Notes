Param([int]$Final)
Write-Host -ForegroundColor Green   "[1] $($Final*0.65 -as [int])"
Write-Host -ForegroundColor Yellow  "[2] $($Final*0.85 -as [int])"
Write-Host -ForegroundColor Red     "[3] $($Final*0.95 -as [int])"
Write-Host -ForegroundColor Magenta "[*] $([math]::round($Final*0.98,2))"