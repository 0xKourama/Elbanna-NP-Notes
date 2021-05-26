# Get the public IPs for VMs
```
Get-VM | Foreach-Object { $_.ExtensionData.summary.guest | Select-Object -Property hostname, IpAddress } | where-object {
		$_.hostname -and `
		$_.ipaddress -and `
		$_.ipaddress -notmatch '192.*|172.*|10.*|169\.254.*' -and `
		($_.ipaddress.length -le 15)
} | format-table -AutoSize
```