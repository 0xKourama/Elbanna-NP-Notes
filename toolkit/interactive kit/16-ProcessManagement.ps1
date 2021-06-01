function Control-Process{
    while($true){
        Display -Header "View/Kill Process" `
                -Footer "X to Return"       `
                -OptionList @("Enter computer name", "L] Load from file")

        $Computers = Quick-ping -Computernames (Get-ComputerCriteria)

        [String]$Filter = Read-Host "║ [?] Enter process name or part of its name to filter"

        $Computers | % {
            
            $underline = '╠═'
            @(1..$($_.length)) | % {$underline += "═"}

            Write-Host '║'
            Write-Host "║ $_"
            Write-Host $underline
            Write-Host '║'

            $process = Get-WmiObject -ComputerName $_ -Query “Select * from win32_Process where name like '%$Filter%'”

            if(!$process){
                Write-Host '║ ' -NoNewline
                Write-Host "[-] No processes found" -NoNewline
                #Divider
                #continue
            }
            else{
                ($process | Select-Object -Property @{n='ProcessName'  ;e={$_.name}},
                                                    @{n='WorkingSet(K)';e={$_.WS / 1KB -as [int]}} |
                            Sort-Object   -Property  WorkingSet`(K`) -Descending |
                            Format-Table |
                            Out-String).trim() -split "`n" | % {Write-Host "║ $_"}

                Write-Host '║'

                $choice = Read-Host "║ [?] Terminate? [Y/N]"

                if($choice -eq 'Y'){
                    Write-Host '║ ' -NoNewline
                    Write-Host '[*] Terminating process...' -ForegroundColor Cyan

                    [void]$process.Terminate()

                    if($LASTEXITCODE -eq 0){
                        Write-Host '║ ' -NoNewline
                        Write-Host "[+] Process terminated" -ForegroundColor Green                    
                    }
                    else{
                        Write-Host '║ ' -NoNewline
                        Write-Host "[-] An error occured" -ForegroundColor Red
                    }

                }
                elseif($choice -eq 'N'){}
                else{
                    Write-Host '║ ' -NoNewline
                    Write-Host '[-] Invalid choice' -ForegroundColor Red
                }
            }
            Write-Host '║'
            Divider
        }
    }
}