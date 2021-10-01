while($true){
	c:\users\zen\powershell\utils\EmptyStandbyList.exe standbylist
	Write-Host -ForegroundColor Green "[$((get-date).ToShortTimeString())] [+] Standby memory cleared."
	Start-Sleep -Seconds 300
}