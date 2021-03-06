$Charge_benefits = @(
    'Development of male growth and masculine characteristics',
    'Healthy heart and blood',
    'Less fat, more muscle, deeper voice',
    'Stronger bones',
    'Better verbal memory, spatial abilities, or mathematical reasoning',
    'Better libido',
    'Improved mood'
)
$Charge_benefits | ForEach-Object {
    Write-Host "[+] $_" -ForegroundColor Green
}