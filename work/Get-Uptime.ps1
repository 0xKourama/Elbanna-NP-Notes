param($ComputerName)
Invoke-Command -ComputerName $ComputerName -ScriptBlock {
    $uptime = New-TimeSpan -Start ([Management.ManagementDatetimeConverter]::ToDateTime((Get-WmiObject -Query "SELECT LastBootUpTime FROM Win32_OperatingSystem").LastBootupTime)) -End (get-date)
    "$($env:computername): $($uptime.days) Days $($uptime.hours) hours $($uptime.minutes) minutes"
} -ErrorAction SilentlyContinue