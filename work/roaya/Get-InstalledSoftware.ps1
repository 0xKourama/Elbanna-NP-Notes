$all_ad_computers_with_ipv4_enabled = Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address -ne $null} | Select-Object -ExpandProperty Name

$online = Test-Connection -ComputerName $all_ad_computers_with_ipv4_enabled -Count 1 -AsJob | Wait-Job | Receive-Job | Where-Object {$_.StatusCode -eq 0} | Select-Object -ExpandProperty Address

$method_1_script = {Get-WmiObject -Class Win32_Product}

$method_2_script = {Get-ItemProperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Where-Object {$_.displayname -ne $null} | Select-Object -Property DisplayName,DisplayVersion,Publisher,InstallDate,UninstallString}

Invoke-Command -ComputerName $online -ScriptBlock $method_1_script -ErrorAction SilentlyContinue | Select-Object -Property * -ExcludeProperty RunSpaceID, PSShowComputerName | Export-Csv result1.csv -NoTypeInformation

Invoke-Command -ComputerName $online -ScriptBlock $method_2_script -ErrorAction SilentlyContinue | Select-Object -Property * -ExcludeProperty RunSpaceID, PSShowComputerName | Export-Csv result2.csv -NoTypeInformation