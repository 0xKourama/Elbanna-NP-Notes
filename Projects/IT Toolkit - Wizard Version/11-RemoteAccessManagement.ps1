function Manage-RemoteDesktopUsers{
    while($true){
        Display -Header "Manage Remote Access" `
                -Footer "X to Return"          `
                -OptionList @("Enter computer name", "L] Load from file")

        $InvokeBlock = {
            $ErrorActionPreference = 'SilentlyContinue'
            
            $underline = "╠═"
            @(1..$($env:COMPUTERNAME.length)) | % {$underline += "═"}

            Write-Host "║"
            Write-Host "║ $env:COMPUTERNAME"
            Write-Host $underline
            Write-Host '║'
            Write-Host "║ Remote Desktop Users:`n║"

            (net localgroup "Remote desktop users" | Select-String -Pattern "^$env:USERDOMAIN\\.*" | select -ExpandProperty matches | select -ExpandProperty value).trim() -split "`n" | % {Write-Host "║ $_"}

            Write-Host '║'
            Write-Host '║ 1] Add'
            Write-Host '║ 2] Remove'
            Write-Host '║ X] Cancel'
            Write-Host '║'
            Write-Host '╠═>> ' -NoNewline

            $choice = $Host.ui.ReadLine()

            Write-Host '║'

            switch($choice){
                1{
                    $user = Read-Host "║ [?] Enter username (without spaces)"
                    $out = net localgroup "Remote Desktop Users" $user /add
                    if(!$out){
                        Write-Host '║ ' -NoNewline
                        Write-Host '[-] An error occured. Make sure that the user is a valid one.' -ForegroundColor Red
                    }
                    elseif($out -eq 'The command completed successfully.'){
                        Write-Host '║ ' -NoNewline
                        Write-Host "[+] User $user was added to remote desktop users on $env:COMPUTERNAME" -ForegroundColor Green
                    }
                }
                2{
                    $user = Read-Host "║ [?] Enter username (without spaces)"
                    $out = net localgroup "Remote Desktop Users" $user /delete
                    if(!$out){
                        Write-Host '║ ' -NoNewline
                        Write-Host '[-] An error occured. Make sure that the user is a valid one.' -ForegroundColor Red
                    }
                    elseif($out -eq 'The command completed successfully.'){
                        Write-Host '║ ' -NoNewline
                        Write-Host "[+] User $user was removed from remote desktop users on $env:COMPUTERNAME" -ForegroundColor Green
                    }
                }
                x {}
                default{
                    write-host '║' -NoNewline
                    Write-Host '║ [-] Invalid choice' -ForegroundColor Red
                }
            }
            Write-Host '║'
        }

        $computers = Quick-ping -ComputerNames (Get-ComputerCriteria)

        Write-Host '║ ' -NoNewline
        Write-Host '[*] Collecting the needed information...' -ForegroundColor Cyan

        $computers | % {Invoke-Command -ComputerName $_ -ScriptBlock $InvokeBlock}
        Divider
    }
}