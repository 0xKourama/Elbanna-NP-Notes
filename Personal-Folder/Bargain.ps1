Param(
    [int]$Final,
    [int]$Meters
)
Write-Host -NoNewline -ForegroundColor Green  ($Final*0.65 -as [int])
Write-Host -NoNewline ' > '
Write-Host -NoNewline -ForegroundColor Cyan   ($Final*0.85 -as [int])
Write-Host -NoNewline ' > '
Write-Host -NoNewline -ForegroundColor Yellow ($Final*0.95 -as [int])
Write-Host -NoNewline ' > '
Write-Host -ForegroundColor Red    ([math]::round($Final*0.98,2))
Write-Host "Per meter      : $([Math]::Round($Final/$Meters,2))"
Write-Host "Initial        : $($Final*0.2)"
Write-Host "Final          : $($Final*0.1)"
Write-Host "Monthly        : $([Math]::Round(($Final*0.7)/72,2))"
Write-Host "Before Discount: $($Final*1.08 -as [int])"