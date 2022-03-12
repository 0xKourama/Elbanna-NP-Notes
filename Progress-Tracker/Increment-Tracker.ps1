$Tracker = Import-Csv Tracker.csv
$Tracker.Record = [int]$Tracker.Record + 1
$Tracker.Chain = [int]$Tracker.Chain + 1
$Tracker | Export-Csv Tracker.csv
Write-Host -ForegroundColor Green "[+] Tracker updated for $($Tracker.Day)/$($Tracker.Month)/$($Tracker.Year) at $((get-date).toShortTimeString())"
Write-Host -ForegroundColor Green "[+] Record: $($Tracker.Record) ($($Tracker.Record/2) hrs)"
Write-Host -ForegroundColor Green "[+] Chain : $($Tracker.Chain)"
Write-Host -ForegroundColor Green "[+] Streak: $($Tracker.Streak)"