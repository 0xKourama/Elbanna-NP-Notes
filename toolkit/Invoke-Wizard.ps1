$UtilityFunctions = @'
    Function Display{
        param(
            [String]$Header,
            [String]$Footer,
            [string[]]$OptionList
        )

        $Max = ($OptionList | % {$_.Length} | measure -Maximum).Maximum

        if($Header -and $Footer){
            Write-Host '+---- ' -NoNewLine
            Write-Host $Header -ForegroundColor Cyan

            if($Header -eq 'Main Menu'){
                Write-Host '+---- Domain: ' -NoNewline
                Write-Host $Domain -ForegroundColor Yellow            
            }

            $OptionList | % {Write-Host "| $_"}
            Write-Host '+---- ' -NoNewline
            Write-Host $Footer -ForegroundColor Red
            Write-Host '+---> ' -NoNewline
        }
        else{
            $OutputString = [System.Collections.ArrayList]@()
            $OutputString += "+$('-' * ($Max + 2))"
            $OptionList | % {$OutputString += "| $_"}
            $OutputString += "+$('-' * ($Max + 2))"
            $OutputString
        }
    }
    ################################################################################################################
    Function Display-Prompt{
        param($Message)
        $input = Read-Host "[?] $Message"
        return $input
    }
    ################################################################################################################
    Function Display-Positive{
        param($Message)
        Write-Host "[+] $Message" -ForegroundColor Green
    }
    ################################################################################################################
    Function Display-Negative{
        param($Message)
        Write-Host "[-] $Message" -ForegroundColor Red
    }
    ################################################################################################################
    Function Display-Verbose{
        param($Message)
        Write-Host "[*] $Message" -ForegroundColor Cyan
    }
    ################################################################################################################
    Function Display-Warning{
        param($Message)
        Write-Host "[!] $Message" -ForegroundColor Yellow
    }
    ################################################################################################################
    Function Display-Error{
        Write-Host $Error[0] -ForegroundColor Yellow
    }
    ################################################################################################################
    Function Query-Session{
        $ErrorActionPreference = 'stop'

        $PropertyList = @(
            'Username' ,
            'Status'   ,
            'ID'       ,
            'Logontime'
        )

        $User_list = @()

        try{
            Quser | % {
                if($_ -eq " USERNAME              SESSIONNAME        ID  STATE   IDLE TIME  LOGON TIME"){}
                else{

                    $User = @{} | Select-Object -Property $PropertyList

                    $User.username = $_.Substring(0 , 23).Trim().toUpper()
                    $User.ID       = $_.Substring(42, 4 ).Trim()
                    $state         = $_.Substring(46, 8 ).Trim().toUpper()

                    if($state -eq 'Disc'){
                        $User.status = '[INACTIVE]'
                    }
                    else{
                        $session = $_.Substring(22, 20).Trim().toUpper()
                        if($session -like 'RDP*'){
                            $session = 'RDP'
                        }
                        else{
                            $session = 'LOCAL'
                        }
                        $User.status = "[ACTIVE - $session]"
                    }

                    $User.logontime = $_.Substring(65, ($_.Length - 65)).Trim().toUpper()

                    $User_list += $User
                }    
            }
        }
        catch{
            $User = @{} | Select-Object -Property $PropertyList
            $User.Username     = "NONE"
            $User_list        += $User
        }

        return $User_list
    }
'@

$ErrorActionPreference = "Stop"
$Domain = $env:USERDOMAIN

dir . | ? {$_.name -ne '0-Main.ps1'} | % {Import-Module $_.FullName -Force}

Invoke-Expression $UtilityFunctions

function Run-Toolkit{

    $firstrun = $true

    while($true){

        if($firstrun){
            $logo = 'POWERSHELL TOOLKIT V2.5'

            $logo_color = 'Magenta'

            $logo.ToCharArray() | % {
                Write-Host "$_" -ForegroundColor $logo_color -NoNewline
                sleep -Milliseconds 20
            }

            Write-Host "`n`nQuery/Execute on multiple devices remotely.`nCopyright (C) 2020 Mohammad Gabr. All rights reserved.`n"

            try{
                Import-Module ActiveDirectory -ErrorAction Stop
            }
            catch{
                Display-Negative "Active Directory module wasn't found. Please install it and rerun the toolkit.`n"               
                $Host.UI.ReadLine()
                exit
            }

            if(!(Test-Path -Path "C:\windows\system32\psexec.exe")){
                Display-Warning 'Sysinternals psexec was not found. Please add it to your System32 folder to able to use all features of this tool.'
            }
        }

        $firstrun = $false

        $menu = @(
                  " 0] Change Working Domain  13] Shutdown/Restart    " ,
                  " 1] System Information     14] MSI Installer       " ,
                  " 2] Installed Software     15] Computer Name Finder" ,
                  " 3] User Lookup            16] View/kill Processes " ,
                  " 4] Network Utilities      17] Screenshot          " ,
                  " 5] Service Control        18] Remove Junk Devices " ,
                  " 6] Rename Computer        19] Load Items          " ,
                  " 7] Access Admin Share     20] Reset Password      " ,
                  " 8] Clear Temp/SQM Files   21] Locate computer OU  " ,
                  " 9] Group Policy           22] Search User         " ,
                  "10] Logoff User            23] Search Computers    " ,
                  "11] Manage Remote Access   24] Show Important Links" ,
                  "12] Mass Copy              25]                     "
        )

        Display -Header 'Main Menu' `
                -Footer "X to Exit" `
                -OptionList $menu

        try{
            switch($Host.UI.ReadLine()){
                0 {
                    $Domain = Display-Prompt -Message 'Enter Domain'
                    Display-Positive "Domain changed to $Domain"
                }
                1 {Collect-SystemInformation }
                2 {Get-Insalltedsoftware     }
                3 {lookup-user               }
                4 {IPtools                   }
                5 {service-control           }
                6 {Rename-PC                 }
                7 {Access-HiddenShare        }
                8 {Clear-Temps               }
                9 {GP-Update                 }
                10{logoff-user               }
                11{Manage-Remotedesktopusers }
                12{Mass-copy                 }
                13{Shutdown-Restart          }
                14{MSI-Installer             }
                15{Get-CDPInfo               }
                16{Control-Process           }
                17{Take-Screenshot           }
                18{Remove-JunkDevices        }
                19{Load-CMD                  }
                20{Reset-Password            }
                21{Get-ComputerOU            }
                22{Search-User               }
                23{Search-Computer           }
                24{Show-ImportantLinks       }
                x {Exit                      }
                default{
                   Display-Negative 'Invalid choice'
                }
            }
        }
        catch{
            Display-Error
        }
    }
}

Run-Toolkit