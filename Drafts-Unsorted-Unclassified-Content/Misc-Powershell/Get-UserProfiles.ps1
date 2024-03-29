$profile_script = {$obj = @{} | Select-Object -Property ComputerName, Profiles; $obj.ComputerName = $env:COMPUTERNAME; $obj.Profiles = Get-WmiObject -Class Win32_UserProfile | Where-Object {$_.Special -eq $false} | Select-Object -ExpandProperty LocalPath; $obj}

Invoke-Command -ComputerName $online -ScriptBlock $profile_script -ErrorAction SilentlyContinue | select -Property * -ExcludeProperty RunSpaceID, PSShowComputerName | Export-Csv profiles_result.csv -NoTypeInformation
