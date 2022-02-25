function Logoff-User{
    while($true){
        Display -Header 'Logoff User' `
                -Footer 'X to Return' `
                -OptionList @("Enter computer name", "L] Load from file")
        
        $computers = Quick-ping -Computernames (Get-ComputerCriteria)

        Write-Host '║ ' -NoNewline
        Write-Host '[*] Collecting the needed information...' -ForegroundColor Cyan

        $computers | % {
            $InvokeBlock = {

                $ErrorActionPreference = 'stop'

                $PropertyList = @(
                                    'Username' ,
                                    'ID'       ,
                                    'Status'   ,
                                    'Logontime'
                )

                $underline = "╠═"
                @(1..$($env:COMPUTERNAME.length)) | % {$underline += "═"}

                Write-Host "║"
                Write-Host "║ $env:COMPUTERNAME"
                Write-Host $underline

                $User_list = @()
                try{
                    Quser | % {
                        if($_ -eq " USERNAME              SESSIONNAME        ID  STATE   IDLE TIME  LOGON TIME"){}
                        else{
                            $User = @{} | Select-Object -Property $PropertyList
                            $User.ID           = $_.Substring(42, 4 ).Trim();
                            $User.username     = $_.Substring(0 , 23).Trim().toUpper()
                            $state             = $_.Substring(46, 8 ).Trim().toUpper()
                            if($state -eq 'Disc'){$User.status = '[INACTIVE]'}
                            else{
                                $session = $_.Substring(22, 20).Trim().toUpper()
                                if($session -like 'RDP*'){$session = 'RDP'  }
                                else                     {$session = 'LOCAL'}
                                $User.status = "[ACTIVE - $session]"
                            }
                            $User.logontime    = $_.Substring(65, ($_.Length - 65)).Trim().toUpper()
                            $User_list += $User
                        }    
                    }

                    Write-Host '║'
                    (Write-Output $User_list | ft -AutoSize | Out-String).trim() -split "`n" | % {Write-Output "║ $_"}
                    Write-Host '║'

                    $SessionID = Read-Host "║ [?] Enter the ID for the user you want to log off [X to Cancel]"
                    
                    if($SessionID -eq 'X'){
                        Write-Host '║'
                        break
                    }
                    elseif($User_list.ID -notcontains $SessionID){
                        Write-Host '║ ' -NoNewline
                        Write-Host '[-] Invalid session ID' -ForegroundColor Red
                    }
                    else{
                        Write-Host '║ ' -NoNewline
                        Write-Host "[*] Logging off $($User_list | ? {$_.ID -eq $SessionID} | select -ExpandProperty username)..." -ForegroundColor Cyan
                        logoff $SessionID
                        if($LASTEXITCODE -eq 0){
                            Write-Host '║ ' -NoNewline
                            Write-Host '[+] User logged off'  -ForegroundColor Green
                        }
                        else{
                            Write-Host '║ ' -NoNewline
                            Write-Host '[-] An error occured' -ForegroundColor Red
                        }
                    }
                }
                catch{
                    $User = @{} | Select-Object -Property $PropertyList
                    $User.Username     = "NONE"

                    $User_list        += $User

                    (Write-Output $User_list | ft -AutoSize | Out-String).trim() -split "`n" | % {Write-Output "║ $_"}
                }
                Write-Host '║ ' 
            }
            Invoke-Command -ComputerName $_ -ScriptBlock $InvokeBlock
        }
    }
}