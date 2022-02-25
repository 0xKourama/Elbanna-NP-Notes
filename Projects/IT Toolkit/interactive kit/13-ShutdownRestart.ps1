function Shutdown-Restart{
    while($true){
        Display -Header "Shutdown/Restart" `
                -Footer "X to Return"      `
                -OptionList @("Enter computer name", "L] Load from file")

        $Computers = Quick-ping -Computernames (Get-ComputerCriteria)
        Display -Header "Option list" `
                -Footer "X to Cancel" `
                -OptionList @("1] Shutdown", "2] Restart")
        try{
            $choice = $Host.ui.ReadLine()
            Write-Host '║'
            switch($choice){
                1{
                    Write-Host '║ ' -NoNewline
                    Write-Host "[*] Shutting down $Computers..." -ForegroundColor Cyan
                    Stop-Computer    -ComputerName $Computers -Force
                    Write-Host '║ ' -NoNewline
                    Write-Host "[+] Shutdown command issued" -ForegroundColor Green
                }
                2{
                    Write-Host '║ ' -NoNewline
                    Write-Host "[*] Restarting $Computers..." -ForegroundColor Cyan
                    Restart-Computer -ComputerName $Computers -Force
                    Write-Host '║ ' -NoNewline
                    Write-Host "[+] Restart command issued" -ForegroundColor Green
                }
                x{}
                default{
                    Write-Host '║ ' -NoNewline
                    Write-Host '[+] Invalid choice' -ForegroundColor Red
                }
            }
        }
        catch{
            Show-Error
        }
        Write-Host '║'
        Divider
    }
}