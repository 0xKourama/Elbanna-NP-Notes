$list = @(
    'Injustice'
    'Corruption'
    'Disbeleif'
    'Treason'
    'Extravagance'
    'Arrogance'
    'Tyranny'
)
foreach($item in $list){
    Write-Host -ForegroundColor DarkRed "[x] $item"
}