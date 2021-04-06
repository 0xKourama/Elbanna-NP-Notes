$ScriptRoot = 'C:\Users\Zen\PowerShell\powereye\development'

$Manifest_path = "$ScriptRoot\0 - Manifest.ps1"

Invoke-Expression -Command (Get-Content -Raw $Manifest_path)

$Original_Manifest_hash = Get-FileHash -Path $Manifest_path | Select-Object -ExpandProperty Hash

$Enabled_modules = $Modules | Where-Object {$_.Enabled -eq $true}

while($true){

    #region check for configuration changes
    $current_Manifest_hash = Get-FileHash -Path $Manifest_path | Select-Object -ExpandProperty Hash

    if($current_Manifest_hash -ne $Original_Manifest_hash){
        Write-Host -ForegroundColor Yellow "[!] Configuration file changed. Updating the running configuration."

        Invoke-Expression -Command (Get-Content -Raw $Manifest_path)

        $Original_Manifest_hash = $current_Manifest_hash

        $Enabled_modules = $Modules | Where-Object {$_.Enabled -eq $true}
    }
    #endregion

    Write-Host -ForegroundColor Cyan '[*] Displaying current module summary:'

    Format-Table -InputObject $Modules -AutoSize -Wrap

    foreach($Module in $Enabled_modules){
        if($Module.MinutesTillNextRun -eq 0){

            Write-Host -ForegroundColor Cyan "[*] $($Module.Name) now running"

            #Start-Process PowerShell.exe -ArgumentList $($Module.ScriptPath)

            $Module.MinutesTillNextRun = $Module.RunIntervalMinutes
        }
        else{
            $Module.MinutesTillNextRun--
        }
    }

    Export-Clixml -InputObject $Modules -Path "$ScriptRoot\State.xml"

    [GC]::Collect()

    Write-Host -ForegroundColor Cyan "[*] Going on standby for 1 minute"
    Start-Sleep -Seconds 60
}