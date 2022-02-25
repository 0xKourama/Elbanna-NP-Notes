function IPtools{
    while($true){
        Display -Header "IP tools"    `
                -Footer "X to Return" `
                -OptionList @(
                    "1] IP Config"                 ,
                    "2] IP Renew"                  ,
                    "3] Flush DNS"                 ,
                    "4] Register DNS"              ,
                    "5] Netstat"                   ,
                    "6] Remote Ping"
        )
        $tool = $Host.ui.ReadLine()
        $bad = $false
        switch($tool){
            1      {$title = 'IP Config'                     }
            2      {$title = 'IP Renew'                      }
            3      {$title = 'Flush DNS'                     }
            4      {$title = 'Register DNS'                  }
            5      {$title = 'Netstat'                       }
            6      {$title = 'Remote Ping'                   }
            x      {                                         }
            default{
                Write-Host "║ "
                Write-Host "║ " -NoNewline
                Write-Host '[-] Invalid answer' -ForegroundColor Red
                $bad = $true
            }
        }
        if    ($tool -eq 'X') {break   }
        elseif($bad -eq $true){continue}

        Display -Header $title        `
                -footer "X to Cancel" `
                -optionlist @("Enter computer name", "L] Load from file")

        $Computers = Quick-ping -Computernames (Get-ComputerCriteria)

        Write-Host '║ ' -NoNewline
        Write-Host '[*] Flushing local DNS cache...' -ForegroundColor Cyan

        ipconfig /flushdns | Out-Null

        switch($tool){
            1{
                Write-Host '║ ' -NoNewline
                Write-Host '[*] Collecting the needed information...' -ForegroundColor Cyan

                Invoke-Command -ComputerName $Computers -ScriptBlock {

                    $underline = "╠═"
                    @(1..$($env:COMPUTERNAME.length)) | % {$underline += "═"}

                    Write-Output "║"
                    Write-Output "║ $env:COMPUTERNAME"
                    Write-Output $underline

                    ipconfig /all | % {Write-Output "║ $_"}

                    Write-Output "║ "
                }
            }
            2{
                Write-Host '║ ' -NoNewline
                Write-Host '[*] Execution in progress...' -ForegroundColor Cyan

                Invoke-Command -ComputerName $Computers -ScriptBlock {
                    
                    $underline = "╠═"
                    @(1..$($env:COMPUTERNAME.length)) | % {$underline += "═"}

                    Write-Output "║"
                    Write-Output "║ $env:COMPUTERNAME"
                    Write-Output $underline

                    ipconfig /renew | % {Write-Output "║ $_"}

                    Write-Output "║ "
                }
            }
            3{
                Write-Host '║ ' -NoNewline
                Write-Host '[*] Execution in progress...' -ForegroundColor Cyan

                Invoke-Command -ComputerName $Computers -ScriptBlock {
                    
                    $underline = "╠═"
                    @(1..$($env:COMPUTERNAME.length)) | % {$underline += "═"}

                    Write-Output "║"
                    Write-Output "║ $env:COMPUTERNAME"
                    Write-Output $underline

                    ipconfig /flushdns | % {Write-Output "║ $_"}

                    Write-Output "║ "
                }
            }
            4{
                Write-Host '║ ' -NoNewline
                Write-Host '[*] Execution in progress...' -ForegroundColor Cyan

                Invoke-Command -ComputerName $Computers -ScriptBlock {

                    $underline = "╠═"
                    @(1..$($env:COMPUTERNAME.length)) | % {$underline += "═"}

                    Write-Output "║"
                    Write-Output "║ $env:COMPUTERNAME"
                    Write-Output $underline

                    ipconfig /registerdns | % {Write-Output "║ $_"}

                    Write-Output "║ "
                }
            }
            5{
                Write-Host '║ ' -NoNewline
                Write-Host '[*] Collecting the needed information...' -ForegroundColor Cyan

                Invoke-Command -ComputerName $Computers -ScriptBlock {
                    Start-Job {
                        $string = @()
                        $out = (netstat -no) -replace('Active Connections','') -replace('^  ','')
                        $out | % {
                            if($_ -ne ''){
                                $string += $(
                                    $_ -replace ('Proto','Protocol')                             `
                                       -replace ('Local Address','LocalAddress,LocalPort')       `
                                       -replace ('Foreign Address','ForeignAddress,ForeignPort') `
                                       -replace (':',',')                                        `
                                       -replace ('\s+',',')
                                )
                            }
                        }
                        $procs = Get-WmiObject -Class win32_process
                        $string = $string | ConvertFrom-Csv | sort -Property PID
                        foreach ($word in $string){
                            Add-Member -InputObject $word -NotePropertyName Process -NotePropertyValue ($procs | ? {$_.ProcessID -eq $word.PID} | select -ExpandProperty ProcessName)
                            Add-Member -InputObject $word -NotePropertyName User    -NotePropertyValue ($procs | ? {$_.ProcessID -eq $word.PID} | % {$_.getOwner().user})
                        }

                        $underline = "╠═"
                        @(1..$($env:COMPUTERNAME.length)) | % {$underline += "═"}

                        Write-Output "║"
                        Write-Output "║ $env:COMPUTERNAME"
                        Write-Output $underline

                        Write-Output "║ "
                        ($string | ft | Out-String).trim() -split "`n" | % {Write-Output "║ $_"}
                        Write-Output "║ "
                    } | Wait-Job | Receive-Job
                }
            }
            6{
                Write-Host '║ ' -NoNewline
                Write-Host '[*] Execution in progress...' -ForegroundColor Cyan

                Invoke-Command -ComputerName $Computers -ScriptBlock {

                    $underline = "╠═"
                    @(1..$($env:COMPUTERNAME.length)) | % {$underline += "═"}

                    Write-Output "║"
                    Write-Output "║ $env:COMPUTERNAME"
                    Write-Output $underline

                    ping $args[0] | % {Write-Output "║ $_"}

                } -ArgumentList (Read-Host "║ [?] Enter destination")
                Write-Host "║ " 
            }
            default{
                Write-Host "║ " -NoNewline
                Write-Host "[-] Invalid answer" -ForegroundColor Red
            }
        }
    }
}