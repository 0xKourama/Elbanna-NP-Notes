gwmi win32_process | ? {$_.name -like '*powershell*'} | select -Property name,processid, CommandLine