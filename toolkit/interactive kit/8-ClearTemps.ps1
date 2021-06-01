function Clear-Temps{
    while($true){
        Display -Header "Clear Temp/SQM Files" `
                -Footer "X to Return"           `
                -OptionList @("Enter computer name", "L] Load from file")

        $InvokeBlock = {
            $JobBlock = {
                $ErrorActionPreference = 'SilentlyContinue'

                #clearing SQM files
                Get-ChildItem C:\users\default\AppData\Local\*    -Include *.sqm `
                                                                  -Recurse       `
                                                                  -Force | Remove-Item

                #clearing user temps for all users
                Remove-Item -Path C:\users\*\AppData\Local\Temp\* -Recurse `
                                                                  -Force
            
                #clearing computer temps
                Remove-Item -Path C:\Windows\Temp\*               -Recurse `
                                                                  -Force
            
                Write-Host "║ " -NoNewline; Write-Host "[+] $($env:COMPUTERNAME) Cleared" -ForegroundColor Green            
            }
            Start-Job $JobBlock | Wait-Job | Receive-Job
        }
        
        $computers = Quick-ping -Computernames (Get-ComputerCriteria)

        Write-Host '║ ' -NoNewline
        Write-Host '[*] Execution in progress...' -ForegroundColor Cyan

        Invoke-command -ComputerName $computers -ScriptBlock $InvokeBlock -ErrorAction SilentlyContinue

        Write-Host '║'

        Divider
    }
}