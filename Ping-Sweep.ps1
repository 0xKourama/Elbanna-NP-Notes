$list = @(); 1..254 | % {$list += "192.168.1.$_"}; Test-Connection -ComputerName $list -Count 1 -AsJob | Wait-Job | Receive-Job | ? {$null -ne $_.responsetime -or $null -ne $_.ipv4address} | Select -ExpandProperty Address