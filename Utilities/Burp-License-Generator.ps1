$array = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'.TOCHARARRAY()
$license = @()
1..8|%{
    $row = @()
    1..6|%{
        $row += "$($array[$(Get-Random 36)])$($array[$(Get-Random 36)])$($array[$(Get-Random 36)])$($array[$(Get-Random 36)])$($array[$(Get-Random 36)])"
    }
    $license += ($row -join '-')
}
$license | Set-Clipboard
Write-Host -ForegroundColor Green "[+] New license generated"
$license
