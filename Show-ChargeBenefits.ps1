$Charge_benefits = @(
    'Win [Gods approval]'
    'Development of [male growth] and [masculine characteristics]'
    'Healthy [heart] and [blood]'
    '[Less fat], [more muscle] and a [deeper voice]'
    '[Stronger bones]'
    'Better [verbal memory], [spatial abilities] and [mathematical reasoning]'
    'Better [libido]'
    'Improved [mood]'
)
$Charge_benefits | ForEach-Object {Write-Host -ForegroundColor DarkGreen "[+] $_"}