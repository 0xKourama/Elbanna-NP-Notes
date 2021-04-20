<#
 1]  Task manager > taskmgr
 2]  Services mmc > services.msc
 3]  System properties > control sysdm.cpl
 4]  System configuration > msconfig
 5]  Programs > control appwiz.cpl
 6]  Control panel > control
 7]  Devices and printers > control printers
 8]  Network connections > ncpa.cpl
 9]  Language > control intl.cpl
10]  Sound > control mmsys.cpl
11]  Disk cleanup > cleanmgr /lowdisk
12]  Command line > cmd
13] Powershell > powershell
14] Event viewer > Eventvwr
15] Reliability monitor > perfmon /rel
16] Registry > regedit
17] Device manager > mmc devmgmt.msc
18] Folder options > control folders
19] Print management > mmc printmanagement.msc
20] Display options > control desk.cpl
21] Desktop properties > control desktop
22] Chkdsk Utility > chkdsk
23] System file checker > sfc /scannow
24] Resource monitor > resmon
#>
psexec -accepteula -nobanner -i -s -d \\$Computer $Command