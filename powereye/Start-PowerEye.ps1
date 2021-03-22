$ErrorActionPreference = 'continue'

#intialize Module manifest
$Manifest_path = 'C:\users\gabrurgent\powereye\Manifest.ps1'
Get-Content -Raw $Manifest_path | Invoke-Expression

$Original_Manifest_hash = Get-FileHash -Path $Manifest_path | Select-Object -ExpandProperty Hash

while($true){

    #region check for configuration changes
    $current_Manifest_hash = Get-FileHash -Path $Manifest_path | Select-Object -ExpandProperty Hash

    if($current_Manifest_hash -ne $Original_Manifest_hash){
        Write-Host -ForegroundColor Yellow "[!] Config file changed. Updating the running configuration."
        Get-Content $Manifest_path -Raw | Invoke-Expression
    }
    #endregion
    
    #generating several computer criterias
    $Computers_with_ip = Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address} | Select-Object -ExpandProperty Name
    $Online = Test-Connection -ComputerName $Computers_with_ip -Count 1 -AsJob | Wait-Job | Receive-Job | Where-Object {$_.StatusCode -eq 0} | Select-Object -ExpandProperty address


    Write-Host -ForegroundColor Cyan "[*] Connectivity status: $($Online.count) computer(s) online"

    foreach($Module in ($Modules | Where-Object {$_.Enabled -eq $true} )){
        if($Module.MinutesTillNextRun -eq 0){
            if($Module.Remote -eq $true){
                
                Write-Host -ForegroundColor Cyan "[*] Module $($Module.Name) identified as Remote"

                Write-Host -ForegroundColor Cyan "[*] Control session status: Starting PSSessions"
                $sessions = New-PSSession -ComputerName $Online -ErrorAction SilentlyContinue | Where-Object {$_.state -eq 'opened' -and $_.Availability -eq 'Available'}
                Write-Host -ForegroundColor Green "[+] Control session status: $($Sessions.count) PSSessions are open and available"

                Write-Host -ForegroundColor Cyan "[*] Running $($Module.Name)"

                $Result = Invoke-Command -Session $sessions -FilePath $Module.ScriptPath -ErrorAction SilentlyContinue |
                Select-Object -Property * -ExcludeProperty RunSpaceID, PSShowComputerName |
                Sort-Object -Property PSComputerName            
            }
            elseif($Module.Remote -eq $false){
                Write-Host -ForegroundColor Cyan "[*] Module $($Module.Name) identified as local"
                Write-Host $Module.ScriptPath -ForegroundColor Magenta
                pause
                $Result = Invoke-Expression "$($Module.ScriptPath) -SMTPServer $General_SMTPServer -Sender $General_Sender -Recipient $General_Recipient -Subject $($Module.MailSubject)" # -OutputPath $($Module.OutputPath)"
            }

            Write-Host -ForegroundColor Green "[+] $($Module.Name) Ran successfully."
            Write-Host -ForegroundColor Green "[+] $($Module.Name) Results exported to $($module.OutputPath)."

            $Module.MinutesTillNextRun = $Module.RunIntervalMinutes
        }
        else{
            Write-Host -ForegroundColor Cyan "[*] $($Module.MinutesTillNextRun) minute(s) till $($Module.Name) module's next run"
            $Module.MinutesTillNextRun--
        }
    }
    Get-PSSession | Remove-PSSession
    Write-Host -ForegroundColor Cyan "[*] Sleeping for a minute"
    Start-Sleep -Seconds 60
}