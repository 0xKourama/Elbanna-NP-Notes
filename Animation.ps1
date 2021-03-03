$Work_duration_minutes = 30
$Remaining_Minutes = $Work_duration_minutes
1..$Work_duration_minutes | ForEach-Object {
    Clear-Host

    $border1 = '╭' + ('━' * $Work_duration_minutes * 2) + '╮'
    $border2 = '╰' + ('━' * $Work_duration_minutes * 2) + '╯'

    $upper = '\\' * $_

    $lower = '//' * $_
    Write-Host $border1
    if    ($_ -le 10){$color = 'Red'   }
    elseif($_ -le 20){$color = 'Yellow'}
    else             {$color = 'Green' }
    Write-Host '\' -NoNewline; Write-Host $upper.PadRight($upper.Length + (($border1.Length - 1) - $upper.Length)) -ForegroundColor $color -NoNewline; Write-Host '\'
    Write-Host '/' -NoNewline; Write-Host $lower.PadRight($upper.Length + (($border1.Length - 1) - $upper.Length)) -ForegroundColor $color -NoNewline; Write-Host '/'
    Write-Host $border2
    

    $Remaining_Minutes--
    Write-Host $Remaining_Minutes
    sleep -Milliseconds 250
}