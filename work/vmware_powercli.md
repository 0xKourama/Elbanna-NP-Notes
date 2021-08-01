# Get the public IPs for VMs
```
Get-VM | Foreach-Object { $_.ExtensionData.summary.guest | Select-Object -Property hostname, IpAddress } | where-object {
		$_.hostname -and `
		$_.ipaddress -and `
		$_.ipaddress -notmatch '192.*|172.*|10.*|169\.254.*' -and `
		($_.ipaddress.length -le 15)
} | format-table -AutoSize
```
# Get the Resource pools and all the VMs under them with their data
get-vm | select ResourcePool,Name,PowerState,NumCpu,MemoryGB,@{n='DiskSizeGB';e={$index=1;($_ |Get-HardDisk| select -ExpandProperty 
CapacityGB| % {"HD#$index`: $_ GB"; $index++}) -join ', '}} | Export-Csv -NoTypeInformation ResourcePoolData.csv
