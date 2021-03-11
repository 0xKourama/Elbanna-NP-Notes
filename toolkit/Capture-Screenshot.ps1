function Take-Screenshot{
    while($true){
        Display -Header "Take Screenshot" `
                -Footer "X to Return"     `
                -OptionList @("Enter computer name", "L] Load from file")

        $local_screenshot_path = "C:\users\$env:USERNAME\Desktop\RSCFolder"
        $nircmd_path           = '\\192.168.15.6\it\IT scripts\PSTools\nircmd.exe'
        $psexec_path           = '\\192.168.15.6\it\IT scripts\PSTools\psexec.exe'

        mkdir -Path $local_screenshot_path -ErrorAction SilentlyContinue | Out-Null

        $InvokeBlock = {
            $JobBlock = {

                $temp_path = "c:\users\public"

                $ErrorActionPreference = 'stop'

                $PropertyList = @(
                    'Username' ,
                    'ID'       ,
                    'Status'
                )

                $User_list = @()

                try{
                    Quser | % {
                        if($_ -eq " USERNAME              SESSIONNAME        ID  STATE   IDLE TIME  LOGON TIME"){
                            
                        }
                        else{
                            $User = @{} | Select-Object -Property $PropertyList
                            $User.username     = $_.Substring(0 , 23).Trim().toUpper()
                            $User.ID           = $_.Substring(42, 4 ).Trim()
                            $state             = $_.Substring(46, 8 ).Trim().toUpper()

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
                            $User_list += $User
                        }    
                    }
                }
                catch{
                    $User = @{} | Select-Object -Property $PropertyList
                    $User.Username     = 'NONE'

                    $User_list        += $User
                }

                $Result_Properties = @(
                    'ComputerName'     ,
                    'Username'         ,
                    'Status'           ,
                    'Screen'           ,
                    'CaptureSucceeded' ,
                    'Filename'
                )

                $Result = @{} | Select -Property $Result_Properties

                $Result.ComputerName = $env:COMPUTERNAME

                $procs = Get-WmiObject -Class win32_process

                foreach($element in $User_list){
                    if($element.username -eq 'NONE'){
                        $Result.Username         = 'NONE'
                        $Result.Status           = 'N/A'
                        $Result.Screen           = 'Locked'
                        $Result.CaptureSucceeded = 'No'
                        $Result.Filename         = 'N/A'
                    }
                    elseif($element.status -eq '[ACTIVE - LOCAL]' -or $element.status -eq '[ACTIVE - RDP]'){

                        if(($procs | ? {$_.sessionid -eq ($element.ID)} | select -ExpandProperty name) -contains 'LogonUI.exe'){
                            $Result.Username         = $element.username
                            $Result.Status           = $element.Status
                            $Result.Screen           = 'Locked'
                            $Result.CaptureSucceeded = 'No'
                            $Result.Filename         = 'N/A'
                        }
                        else{
                            $status_for_file_name = $element.status -replace ('[\[\] ]', '') -replace ('-', '_')
                            $filename = "$env:COMPUTERNAME`_$($element.username)_$($status_for_file_name)_$(Get-Date -Format "dd-MMM-yyyy_hh.mm.tt").png"
                            try{
                                c:\users\public\psexec.exe -accepteula -s -i $($element.ID) c:\users\public\nircmd.exe savescreenshotfull "c:\users\public\$filename" | Out-Null
                            }
                            catch{}
                            $Result.Username         = $element.username
                            $Result.Status           = $element.Status
                            $Result.Screen           = 'Unlocked'
                            $Result.CaptureSucceeded = 'Yes'
                            $Result.Filename         = "$filename"
                        }

                    }
                    else{
                        $Result.Username         = 'INACTIVE'
                        $Result.Status           = 'INACTIVE'
                        $Result.Screen           = 'Locked'
                        $Result.CaptureSucceeded = 'NO'
                        $Result.Filename         = 'N/A'
                    }
                }

                ($Result | Format-Table -Property @{n = 'ComputerName'     ; e = 'ComputerName'     ; width = 15 },
                                                  @{n = 'Username'         ; e = 'Username'         ; width = 20 },
                                                  @{n = 'Status'           ; e = 'Status'           ; width = 16 },
                                                  @{n = 'Screen'           ; e = 'Screen'           ; width =  8 },
                                                  @{n = 'CaptureSucceeded' ; e = 'CaptureSucceeded' ; width = 16 },
                                                  @{n = 'Filename'         ; e = 'Filename'         ; width = 100} | Out-String).Trim()  -split "`n" | % {Write-Host "║ $_"}

                Write-Host '║'

                Write-Output $Result
            }
            Start-Job $JobBlock -ArgumentList $env:COMPUTERNAME, $env:USERNAME | Wait-Job | Receive-Job
        }

        $computers = Quick-ping -ComputerNames (Get-ComputerCriteria)

        Write-Host '║ ' -NoNewline
        Write-Host '[*] Copying necessary files...' -ForegroundColor Cyan

        foreach($computer in $computers){
            try{
                Copy-Item $nircmd_path, $psexec_path "\\$computer\c$\Users\Public" -Force
            }
            catch{
                Write-Host '║ ' -NoNewline
                Write-Host "[!] Copy failed to $computer" -ForegroundColor Yellow
            }
        }

        Write-Host '║ ' -NoNewline
        Write-Host '[*] Execution in progress...' -ForegroundColor Cyan

        Write-Host '║'

        $results = Invoke-Command -ComputerName $computers -ScriptBlock $InvokeBlock -ErrorAction SilentlyContinue
            
        Write-Host '║ ' -NoNewline
        Write-Host '[*] Retrieving screenshots...' -ForegroundColor Cyan

        $results | % {
            if($_.CaptureSucceeded -eq 'Yes'){
                Move-Item -Path "\\$($_.ComputerName)\c$\users\public\$($_.Filename)" -Destination "c:\users\$env:USERNAME\desktop\RSCFolder"
            }
        }

        Write-Host '║ ' -NoNewline
        Write-Host "[+] Screenshots moved to $local_screenshot_path" -ForegroundColor Green

        Write-Host '║ ' -NoNewline
        Write-Host '[*] Cleaning up used files...' -ForegroundColor Cyan

        foreach($computer in $computers){
            try{
                Remove-Item "\\$computer\c$\Users\Public\nircmd.exe", "\\$computer\c$\Users\Public\psexec.exe"
            }
            catch{
                Write-Host '║ ' -NoNewline
                Write-Host "[!] Cleanup failed on $computer" -ForegroundColor Yellow
            }
        }
    }
}