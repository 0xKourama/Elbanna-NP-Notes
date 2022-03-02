$Folder = 'D:\Courses\PowerShell Masterclass'
Dir $folder | % {
    $File         = "$($_.name)"
    $LengthColumn = 27
    $objShell     = New-Object -ComObject Shell.Application 
    $objFolder    = $objShell.Namespace($Folder)
    $objFile      = $objFolder.ParseName($File)
    $Length       = $objFolder.GetDetailsOf($objFile, $LengthColumn)
    [int]$TotalHours += (($Length | Select-String -Pattern '(?<hours>\d{2}):\d{2}:\d{2}').matches.groups | ? {$_.name -eq 'hours'}).Value
    [int]$TotalMinutes += (($Length | Select-String -Pattern '\d{2}:(?<minutes>\d{2}):\d{2}').matches.groups | ? {$_.name -eq 'minutes'}).Value
    [int]$TotalSeconds += (($Length | Select-String -Pattern '\d{2}:\d{2}:(?<seconds>\d{2})').matches.groups | ? {$_.name -eq 'seconds'}).Value
}
$Span = new-timespan -Hours $TotalHours -Minutes $TotalMinutes -Seconds $TotalSeconds
Write-host "Total hours is $($Span.TotalHours)"