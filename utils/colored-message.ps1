$Colors = @(
    'Green'
    'Cyan'
    'Red'
    'Magenta'
    'Yellow'
)
while($true){
    $Colors | foreach-object {
        Write-Host $string -ForegroundColor $_
        Start-Sleep -Milliseconds 500
        Clear-Host
    }
}