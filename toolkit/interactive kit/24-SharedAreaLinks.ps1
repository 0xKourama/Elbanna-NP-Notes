function Show-ImportantLinks{
    do{
        $exit = $false

        $optionlist = @(
            "1] All applications and tools",
            "2] Developer applications"    ,
            "3] Winchester shared area"    ,
            "4] Drivers"                   ,
            "5] Certificates"              ,
            "6] Printer server"            ,
            "7] IT Scripts"                ,
            "8] Kaspersky"
        )

        Display -Header "Important links" `
                -Footer "X to Return"     `
                -OptionList $optionlist

        switch($Host.UI.ReadLine()){
            1      {explorer.exe "\\192.168.15.6\it\All applications and tools" }
            2      {explorer.exe "\\192.168.15.10\Developers Applications"      }
            3      {explorer.exe "\\10.98.15.30"                                }
            4      {explorer.exe "\\192.168.15.6\it\Drivers"                    }
            5      {explorer.exe "\\192.168.15.6\it\Cert"                       }
            6      {explorer.exe "\\192.168.15.11"                              }
            7      {explorer.exe "\\192.168.15.6\it\IT scripts"                 }
            8      {explorer.exe "\\192.168.15.15\klshare"                      }
            X      {$exit = $true                                               }
            default{
                Write-Host "║ " -NoNewline
                Write-Host "[!] Invalid choice" -ForegroundColor Yellow
            }
        }
    }while($exit -ne $true)
}