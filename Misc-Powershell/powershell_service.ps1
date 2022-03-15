$nssm = "c:\powereye\nssm.exe"
$serviceName = 'PowerEye'
$powershell = (Get-Command powershell).Source
$scriptPath = 'C:/PowerEye/ScriptController.ps1'
$arguments = '-ExecutionPolicy Bypass -NoProfile -File "{0}"' -f $scriptPath
& $nssm install $serviceName $powershell $arguments
& $nssm status $serviceName
Start-Service $serviceName
Get-Service $serviceName