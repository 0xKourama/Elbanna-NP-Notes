##errors:
0x8024402C --->
```
netsh winhttp reset proxy
net stop wuauserv
net start wuauserv
```
0x80244022 ---> connectivity issue
---
## service-related: 
```
gsv wuauserv | ? {$_.starttype -ne 'Automatic'}
set-service -name wuauserv -starttype automatic
```
---
## get which computers are subscribed to WSUS:
```
$serviceManager = new-object -Com 'Microsoft.Update.ServiceManager'
$servicemanager.Services | Select-Object Name, ISManaged, IsDefaultService, ServiceUrl
```
---
## list the pending/missing Windows updates:
```
$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateupdateSearcher()
$Updates = @($UpdateSearcher.Search("IsHidden=0 and IsInstalled=0").Updates)
$Updates | Select-Object Title
```