function Get-CDPInfo {
    while($true){
        $InvokeBlock = {
            $JobBlock = {
                $ErrorActionPreference = 'SilentlyContinue'

                $Properties = @(
                    'COMPUTERNAME',
                    'IPV4'        ,
                    'CORRECTNAME'
                )

                $CDPtoWMIPath = "$env:PUBLIC\CDPtoWMI.exe"

                $Result = @{} | Select-Object -Property $Properties

                $Result.COMPUTERNAME = $env:COMPUTERNAME
                $Result.IPV4         = ((Test-Connection -ComputerName $env:COMPUTERNAME -Count 1).IPV4Address).ipaddresstoString

                cmd /c "$env:PUBLIC\winpcap-nmap-4.13.exe /S"
                cmd /c $CDPtoWMIPath | Out-Null

                $CDPtoWMICommand = "Get-WmiObject -Class ninet_org_wmiCDP -ErrorAction Stop | Select-Object PortID, DeviceID"

                try{
                    $CDPinfo = Invoke-Expression $CDPtoWMICommand
                }
                catch{
                    cmd /c $CDPtoWMIPath | Out-Null
                    try{
                        $CDPinfo = Invoke-Expression $CDPtoWMICommand
                    }
                    catch{
                        cmd /c $CDPtoWMIPath | Out-Null
                        $CDPinfo = Get-WmiObject -Class ninet_org_wmiCDP | Select-Object PortID, DeviceID
                    }
                }

                $PORT = (($CDPinfo.PortID) -replace '\D+(\d+)','$1')

                switch($CDPinfo.DeviceID){
                    6c9cedfbec56{$Result.CORRECTNAME = "C6-A$PORT" }
                    24b65706c24d{$Result.CORRECTNAME = "C6-B$PORT" }
                    6c9cedfbeb24{$Result.CORRECTNAME = "C6-C$PORT" }
                    6c9cedf7b738{$Result.CORRECTNAME = "C6-D$PORT" }
                    24b657037be5{$Result.CORRECTNAME = "C6-E$PORT" }
                    24b657037b19{$Result.CORRECTNAME = "C6-F$PORT" }
                    24b65715865a{$Result.CORRECTNAME = "C6-G$PORT" }
                    0c27245d9ef6{$Result.CORRECTNAME = "C6-H$PORT" }
                    
                    04DAD2380200{$Result.CORRECTNAME = "C8-A$PORT" }
                    6886A787F400{$Result.CORRECTNAME = "C8-B$PORT" }
                    04DAD230D180{$Result.CORRECTNAME = "C8-C$PORT" }
                    0c27245d9f62{$Result.CORRECTNAME = "C8-D$PORT" }
                    0c27245d9b96{$Result.CORRECTNAME = "C8-E$PORT" }
                    0c27245d9d7c{$Result.CORRECTNAME = "C8-F$PORT" }
                    0c27245d9fce{$Result.CORRECTNAME = "C8-G$PORT" }
                    
                    0c27245d9e03{$Result.CORRECTNAME = "C10-A$PORT"}
                    0c27245da004{$Result.CORRECTNAME = "C10-B$PORT"}
                    0c27245d9e54{$Result.CORRECTNAME = "C10-C$PORT"}
                    0c27245d9f11{$Result.CORRECTNAME = "C10-D$PORT"}
                    0c27245da03a{$Result.CORRECTNAME = "C10-E$PORT"}
                    0c27245d9dcd{$Result.CORRECTNAME = "C10-F$PORT"}
                    0c27245d9cbf{$Result.CORRECTNAME = "C10-G$PORT"}
                    0c27245d9e39{$Result.CORRECTNAME = "C10-H$PORT"}
                    0c27245d9f2c{$Result.CORRECTNAME = "C10-I$PORT"}
                    0c27245d9ec0{$Result.CORRECTNAME = "C10-J$PORT"}
                    0c27245d9ca4{$Result.CORRECTNAME = "C10-K$PORT"}
                    0c27245d9c53{$Result.CORRECTNAME = "C10-L$PORT"}

                    Default     {$Result.CORRECTNAME = 'Unmapped switchport'}
                }

                Write-Output "║ "
                ($Result | Format-Table -AutoSize | Out-String).trim() -split "`n" | % {Write-Output "║ $_"}
                Write-Output "║ "
                Write-Output "╠═════════════════════════════════════════════════════════════════════════════════════════════════════════════"

                cmd /c "c:\users\public\uninstall.exe /S"

                Get-WmiObject -Class ninet_org_wmiCDP | Remove-WmiObject

                Remove-Item $CDPtoWMIPath, "$env:PUBLIC\winpcap-nmap-4.13.exe" -Force
            }
            Start-Job -ScriptBlock $JobBlock | Wait-Job | Receive-Job
        }

        ipconfig /flushdns | out-Null

        Display -Header 'Correct Name Finder' `
                -Footer 'X to Exit'           `
                -OptionList 'Enter computer name','L] Load from file'

        $PCs = Quick-ping -ComputerNames (Get-ComputerCriteria)

        Write-Host "║ "
        Write-Host "║ " -NoNewLine
        Write-Host "[*] Copying necessary files..." -ForegroundColor Cyan

        $PCs | % {
            try{
                Copy-Item -Path '\\192.168.15.6\it\IT scripts\CDPtoWMI\*' -Destination "\\$_\C$\Users\Public" -ErrorAction Stop
            }
            catch{
                Write-Host "║ " -NoNewLine
                write-host "[!] Copy failed to $_" -ForegroundColor Yellow
            }
        }
        Write-Host "║ " -NoNewLine
        write-host "[*] Collecting information..." -ForegroundColor Cyan
        Invoke-Command -ComputerName $PCs -ScriptBlock $InvokeBlock
    }
}