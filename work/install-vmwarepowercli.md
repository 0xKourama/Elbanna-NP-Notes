1. Download ZIP file (https://code.vmware.com/doc/preview?id=13693)
2. Extract Contents
3. Copy/Move contents to (C:\Windows\system32\WindowsPowerShell\v1.0\Modules)
4. Run the below powershell command:
	```
	cd "C:\Windows\system32\WindowsPowerShell\v1.0\Modules"
	get-childitem -recurse -force | unblock-file	
	```
5. Close and reopen powershell
5. Run the below powershell command:
	`Import-module vmware.powercli`