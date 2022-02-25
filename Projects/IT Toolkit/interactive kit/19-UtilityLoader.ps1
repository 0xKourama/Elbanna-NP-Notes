function Load-CMD {
    while($true){
        Display -Header "Load items"  `
                -Footer "X to Return" `
                -OptionList @("Enter computer name", "L] Load from file")

        [string]$Criteria = ($Host.UI.ReadLine()).replace(" ","")
        if(!$Criteria){continue}
        elseif($Criteria -eq 'X'){break}
        try{$Computer = (Get-ADComputer -Server $Domain -Filter "Name -eq '$Criteria'" -Properties DNSHostname).DNSHostname}catch{}
        if($Computer){
            if(Test-Connection -ComputerName $computer -Count 1 -Quiet){
                do{
                    $exit = $false
                    $optionlist = @(
                        " 1]  Task manager          13] Powershell"          ,
                        " 2]  Services              14] Event viewer"        ,
                        " 3]  System properties     15] Reliability monitor" ,
                        " 4]  System configuration  16] Registry"            ,
                        " 5]  Programs              17] Device manager"      ,
                        " 6]  Control panel         18] Folder options"      ,
                        " 7]  Devices and printers  19] Print management"    ,
                        " 8]  Network connections   20] Display options"     ,
                        " 9]  Language              21] Desktop properties"  ,
                        "10]  Sound                 22] Chkdsk Utility"      ,
                        "11]  Disk cleanup          23] System file checker" ,
                        "12]  Command line          24] Resource monitor"
                    )

                    Display -Header "Item list"   `
                            -Footer "X to Return" `
                            -OptionList $optionlist
                    try{
                        Get-Service -ComputerName $Computer | Out-Null
                        switch($Host.UI.ReadLine()){
                            1 {psexec -accepteula -nobanner -i -s -d \\$Computer taskmgr                 }
                            2 {psexec -accepteula -nobanner -i -s -d \\$Computer mmc services.msc        }
                            3 {psexec -accepteula -nobanner -i -s -d \\$Computer control sysdm.cpl       }
                            4 {psexec -accepteula -nobanner -i -s -d \\$Computer msconfig                }
                            5 {psexec -accepteula -nobanner -i -s -d \\$Computer control appwiz.cpl      }
                            6 {psexec -accepteula -nobanner -i -s -d \\$Computer control                 }
                            7 {psexec -accepteula -nobanner -i -s -d \\$Computer control printers        }
                            8 {psexec -accepteula -nobanner -i -s -d \\$Computer control ncpa.cpl        }
                            9 {psexec -accepteula -nobanner -i -s -d \\$Computer control intl.cpl        }
                            10{psexec -accepteula -nobanner -i -s -d \\$Computer control mmsys.cpl       }
                            11{psexec -accepteula -nobanner -i -s -d \\$Computer cleanmgr /lowdisk       }
                            12{psexec -accepteula -nobanner -i -s -d \\$Computer cmd                     }
                            13{psexec -accepteula -nobanner -i -s -d \\$Computer powershell              }
                            14{psexec -accepteula -nobanner -i -s -d \\$Computer Eventvwr                }
                            15{psexec -accepteula -nobanner -i -s -d \\$Computer perfmon /rel            }
                            16{psexec -accepteula -nobanner -i -s -d \\$Computer regedit                 }
                            17{psexec -accepteula -nobanner -i -s -d \\$Computer mmc devmgmt.msc         }
                            18{psexec -accepteula -nobanner -i -s -d \\$Computer control folders         }
                            19{psexec -accepteula -nobanner -i -s -d \\$Computer mmc printmanagement.msc }
                            20{psexec -accepteula -nobanner -i -s -d \\$Computer control desk.cpl        }
                            21{psexec -accepteula -nobanner -i -s -d \\$Computer control desktop         }
                            22{psexec -accepteula -nobanner -i -s -d \\$Computer chkdsk                  }
                            23{psexec -accepteula -nobanner -i -s -d \\$Computer sfc /scannow            }
                            24{psexec -accepteula -nobanner -i -s -d \\$Computer resmon                  }
                            X {$exit = $true; break}
                            default{Write-Host "Invalid choice" -ForegroundColor Red}
                        }
                    }
                    catch [System.InvalidOperationException]{
                        Write-Host "║ " -NoNewline
                        write-host "[-] Access denied" -ForegroundColor Red
                        break
                    }
                    catch [System.Management.Automation.RemoteException]{
                        Write-Host "║ " -NoNewline
                        Write-Host "[+] Item Loaded" -ForegroundColor Green
                    }
                }while($exit -ne $true)
            }
            else{
                Write-Host "[-] Offline"
            }
        }
        else{
            Write-Host "No valid device found"
            Divider
            continue
        }
    }
}