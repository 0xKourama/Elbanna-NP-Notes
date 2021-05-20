# ideas:
1. firewall
2. service not started/not enabled


1. need local admin access >> create local admin
2. disk space
3. restart for already pending updates
4. rerun windows updates
5. disconnect external hardware >> remove the ISO
	? i have an iso in my JUMP
6. update drivers
7. check device manager for errors

# to solve:
error code ---> run windows update troubleshooter
incomplete update ---> press 'check for updates again' or run windows update troubleshooter

# advanced:
1. Rename software distribution folders
```
net stop bits
net stop wuauserv
ren %systemroot%\softwaredistribution softwaredistribution.bak
ren %systemroot%\system32\catroot2 catroot2.bak
net start bits
net start wuauserv
```
2. Repair hard drive errors
```
chkdsk/f C:
```
3. Restore and repair system files
```
DISM.exe /Online /Cleanup-image /Restorehealth
sfc /scannow
```

# Finally: you can perform a clean install of windows