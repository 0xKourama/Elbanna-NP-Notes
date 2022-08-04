## locations writable by non-admin users in Windows (Windows 10)

### default folders
```
C:\$Recycle.Bin\<USER SID> (whoami /user)
C:\Users\All Users (links to C:\ProgramData)
C:\PerfLogs
C:\ProgramData
C:\Windows\Tasks 
C:\Windows\tracing 
C:\Windows\PCHEALTH\ERRORREP\QHEADLES
C:\Windows\PCHEALTH\ERRORREP\QSIGNOFF
C:\Windows\PLA\Reports 
C:\Windows\PLA\Rules 
C:\Windows\PLA\Templates 
C:\Windows\PLA\Reports\en-US 
C:\Windows\PLA\Rules\en-US 
C:\Windows\Registration\CRMLog 
C:\Windows\System32\FxsTmp 
C:\Windows\System32\LogFiles\WMI 
C:\Windows\System32\Microsoft\Crypto\RSA\MachineKeys 
C:\Windows\System32\spool\drivers\color 
C:\Windows\System32\spool\drivers\x64\*
C:\Windows\SysWOW64\FxsTmp
C:\Users\%USERNAME%\*
C:\Users\Public\AccountPictures 
C:\Users\Public\Documents 
C:\Users\Public\Downloads 
C:\Users\Public\Libraries 
C:\Users\Public\Music 
C:\Users\Public\Pictures 
C:\Users\Public\Videos 
```

## common non-default folders

```
C:\TEMP
```

## if SCCM is in use:
```
C:\Windows\CCM\Logs (very noisy)
C:\Windows\CCM\Temp 
C:\Windows\CCM\Inventory\idmifs 
C:\Windows\CCM\Inventory\noidmifs 
C:\Windows\CCM\Inventory\noidmifs\badmifs 
C:\Windows\CCM\SystemTemp\AppVTempData\AppVCommandOutput
```

## if SQL Management Studio is installed:
```
C:\Program Files (x86)\Microsoft SQL Server\<VER>\DTS\DataDumps
```

## locations writable by non-admin users in Windows Server 2019 (Build 17744)
```
C:\$Recycle.Bin\<USER SID> (whoami /user)
C:\Users\All Users (links to C:\ProgramData)
C:\Users\%USERNAME%\*
C:\Users\Public\AccountPictures 
C:\Users\Public\Documents 
C:\Users\Public\Downloads 
C:\Users\Public\Libraries 
C:\Users\Public\Music 
C:\Users\Public\Pictures 
C:\Users\Public\Videos
C:\Windows\Tasks
C:\Windows\Tracing
C:\Windows\Registration\CRMLog
C:\Windows\System32\spool\drivers\color
```