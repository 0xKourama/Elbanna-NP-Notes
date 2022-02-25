function Mass-copy{
    while($true){
        $Succeeded = @()
        $Failed = @()

        Display -Header "Mass Copy"    `
                -Footer "X to Return" `
                -OptionList @("Enter computer name", "L] Load from file")

        $Computers = Quick-ping -Computernames (Get-ComputerCriteria)

        $src_item   = Read-Host "║ [?] Enter item name"
        $src_folder = Read-Host "║ [?] Enter source folder"

        if(!(Test-Path $src_folder\$src_item)){
            Write-Host '║ ' -NoNewline
            Write-Host "[-] Source item not found" -ForegroundColor Red
            Divider
            continue
        }

        $remote_dest = (Read-Host "║ [?] Enter destination folder").Replace(":","$")

        foreach($computer_FQDN in $Computers){
            try{
                if(Test-Path \\$computer_FQDN\$remote_dest){
                    Write-Host '║ ' -NoNewline
                    Write-Host "[*] Copying to $computer_FQDN... " -ForegroundColor Cyan
                    robocopy.exe $src_folder \\$computer_FQDN\$remote_dest $src_item
                    Write-Host '║ ' -NoNewline
                    Write-Host "[+] Copy finished" -ForegroundColor Green
                    $Succeeded += $computer_FQDN
                }
                else{$Failed += $computer_FQDN}
            }
            catch {
                Show-Error
                $Failed += $computer_FQDN
            }
        }
        if($Failed){
            Write-Host '║ Failed devices:'
            $Failed | Format-Table
        }
        Write-Host '║'
        Divider
    }
}