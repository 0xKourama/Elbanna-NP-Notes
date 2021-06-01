function Search-Computer{
    while($true){
        Display -Header "Search Computer" `
                -Footer "X to Return"     `
                -OptionList @(
                    '1] Empty Computers'               ,
                    '2] Computers with RDP sessions'   ,
                    '3] Computers with Local sessions' ,
                    '4] Computers with Inactive users'
                )

        $choice = $Host.UI.ReadLine()

        switch($choice){
            1{$title = "Empty Computers"               }
            2{$title = "Computers with RDP sessions"   }
            3{$title = "Computers with Local sessions" }
            4{$title = "Computers with Inactive users" }
            x{}
            default{
                Write-Host "║ "
                Write-Host "║ " -NoNewline
                Write-Host '[-] Invalid answer' -ForegroundColor Red
                $bad = $true
            }
        }

        if    ($choice -eq 'X'){break   }
        elseif($bad -eq $true) {continue}

        Display -Header "$title"      `
                -Footer "X to Return" `
                -OptionList @("Enter computer name", "L] Load from file")

        $InvokeBlock = {

            $ErrorActionPreference = 'Stop'

            $PropertyList = @(
                'ComputerName' ,
                'Username'     ,
                'Status'
            )

            $User_list = @()

            try{
                Quser | % {
                    if($_ -eq " USERNAME              SESSIONNAME        ID  STATE   IDLE TIME  LOGON TIME"){}
                    else{
                        $User = @{} | Select-Object -Property $PropertyList
                        $User.Computername = $env:COMPUTERNAME
                        $User.username     = $_.Substring(0 , 23).Trim().toUpper()
                        $state             = $_.Substring(46, 8 ).Trim().toUpper()
                        if($state -eq 'Disc'){$User.status = '[INACTIVE]'}
                        else{
                            $session = $_.Substring(22, 20).Trim().toUpper()
                            if($session -like 'RDP*'){$session = 'RDP'  }
                            else                     {$session = 'LOCAL'}
                            $User.status = "[ACTIVE - $session]"
                        }
                        $User_list += $User
                    }    
                }
            }
            catch{
                $User = @{} | Select-Object -Property $PropertyList
                $User.Computername = $env:COMPUTERNAME
                $User.Username     = "NONE"
                $User_list        += $User
            }

            Write-Output $User_list
        }

        $computers = Quick-ping -Computernames (Get-ComputerCriteria)

        Write-Host "║ " -NoNewline
        Write-Host "[*] Searching for $title..." -ForegroundColor Cyan

        $Search = Invoke-Command -ComputerName $computers -ScriptBlock $InvokeBlock -ErrorAction SilentlyContinue

        switch($choice){
            1{
                $Result = $search | ? {$_.Username -eq 'NONE'         } | select -ExpandProperty ComputerName
                if($Result){
                    Write-Host '║ ' -NoNewline
                    Write-Host "[+] $($Result.count) empty computers were found:" -ForegroundColor Green
                    Write-Host '║ '
                    $Result | sort -Property Computername | % {Write-Host "║ $_"}
                }
                else{
                    Write-Host '║ ' -NoNewline
                    Write-Host "[-] No empty computers were found" -ForegroundColor Gray
                }
            }
            ##########################################################################################################################
            2{
                $Result = $search | ? {$_.Status -eq '[ACTIVE - RDP]'  } | select ComputerName, Username
                if($Result){
                    Write-Host '║ ' -NoNewline
                    Write-Host "[+] $($Result.count) Computers with RDP sessions were found:" -ForegroundColor Green
                    Write-Host '║ '
                    ($Result | sort -Property Computername | ft -AutoSize | Out-String).trim() -split "`n" | % {Write-Host "║ $_"}
                }
                else{
                    Write-Host '║ ' -NoNewline
                    Write-Host "[-] No computers with RDP sessions were found" -ForegroundColor Gray
                }
            }
            ##########################################################################################################################
            3{
                $Result = $search | ? {$_.Status -eq '[ACTIVE - LOCAL]'} | select ComputerName, Username
                if($Result){
                    Write-Host '║ ' -NoNewline
                    Write-Host "[+] $($Result.count) Computers with local sessions were found:" -ForegroundColor Green
                    Write-Host '║ '
                    ($Result | sort -Property Computername | ft -AutoSize | Out-String).trim() -split "`n" | % {Write-Host "║ $_"}
                }
                else{
                    Write-Host '║ ' -NoNewline
                    Write-Host "[-] No computers with local sessions were found" -ForegroundColor Gray
                }
            }
            ##########################################################################################################################
            4{
                $Result = $search | ? {$_.Status -eq '[INACTIVE]'      } | select ComputerName, Username
                if($Result){
                    Write-Host '║ ' -NoNewline
                    Write-Host "[+] Computers with inactive sessions were found:" -ForegroundColor Green
                    Write-Host '║ '
                    ($Result | sort -Property Computername | ft -AutoSize | Out-String).trim() -split "`n" | % {Write-Host "║ $_"}
                }
                else{
                    Write-Host '║ ' -NoNewline
                    Write-Host "[-] No computers with Inactive sessions were found" -ForegroundColor Gray
                }
            }
        }

        Write-Host "║"
        Divider
    }
}