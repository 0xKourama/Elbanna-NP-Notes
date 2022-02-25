function Remove-JunkDevices{
    while($true){    
        Display -Header "Remove Junk Devices" `
                -Footer "X to Return"         `
                -OptionList @("Enter computer name", "L] Load from file")

        $Computers = Quick-ping -Computernames (Get-ComputerCriteria)

        Write-Host "║ " 
        Write-Host "║ " -NoNewline
        Write-Host "[*] Copying necessary files..." -ForegroundColor Cyan

        foreach($comp in $Computers){
            if(!(Test-Path "\\$comp\c$\windows\system32\Devcon.exe")){
                try  {Copy-Item "\\192.168.15.6\it\IT scripts\Devcon.exe" "\\$comp\c$\windows\system32"}
                catch{
                    Write-Host "║ " -NoNewline
                    Write-Host "[!] Copy failed to $comp" -ForegroundColor Yellow
                }
            }
        }
        $InvokeBlock = {
            $JobBlock = {
                $All      = devcon findall *usb*
                $Attached = devcon find    *usb*
                $Junk     = @()

                $properties = @(
                    'ComputerName',
                    'JunkDevicesFound',
                    'JunkDevicesCleared'
                )

                $Result = @{} | Select -Property $properties
                $Result.ComputerName = $env:COMPUTERNAME

                $All | % {if($Attached -notcontains $_ -and $_ -notlike "*$($all.Count - 1) matching device(s) found*"){$Junk += $_}}
                if(!$Junk){
                    $Result.JunkDevicesFound   = 0
                    $Result.JunkDevicesCleared = 0
                }
                else{
                    $Result.JunkDevicesFound = $Junk.count
                    $Junk | % {
                        if($_ -like "*:*"){
                            devcon remove "@$($_.Substring(0, $_.IndexOf(':')).Replace(' ',''))" | Out-Null
                            $Result.JunkDevicesCleared++
                        }
                        else{
                            devcon remove "@$($_.Replace(' ',''))"                               | Out-Null
                            $Result.JunkDevicesCleared++
                        }
                    }
                }
                ($Result | Format-Table -Property @{n='ComputerName'       ; e='ComputerName'        ; width = 12},
                                                  @{n='JunkDevicesFound'   ; e='JunkDevicesFound'    ; width = 16},
                                                  @{n='JunkDevicesCleared' ; e='JunkDevicesCleared'  ; width = 18} | Out-String).trim() -split "`n" | % {Write-Output "║ $_"}
                Write-Output "║ "
            }
            Start-Job -ScriptBlock $JobBlock | Wait-Job | Receive-Job
        }
        Write-Host '║ ' -NoNewline
        Write-Host '[*] Removing junk devices...' -ForegroundColor Cyan
        Write-Host '║ ' -NoNewline
        Write-Host '[*] Execution in progress...' -ForegroundColor Cyan
        Write-Output '║'
        Invoke-Command -ComputerName $Computers -ScriptBlock $InvokeBlock -ErrorAction SilentlyContinue
    }
}