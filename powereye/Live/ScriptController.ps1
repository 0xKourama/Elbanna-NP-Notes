#region set paths for working directory and manifest file
$ScriptRoot = 'C:\Users\Zen\PowerShell\powereye\'
$Manifest_path = "$ScriptRoot\Manifest.ps1"
#end region

#load configuration from manifest
Invoke-Expression -Command (Get-Content -Raw $Manifest_path)

#calculate file hash to detect changes to configuration during runtime
$Original_Manifest_hash = (Get-FileHash -Path $Manifest_path).Hash

#get enabled modules
$Enabled_modules = $Modules | Where-Object {$_.Enabled -eq $true}


while($true){

    #region check for configuration changes
    $current_Manifest_hash = (Get-FileHash -Path $Manifest_path).Hash

    if($current_Manifest_hash -ne $Original_Manifest_hash){
        Write-Host -ForegroundColor Yellow "[!] Configuration file changed. Updating the running configuration."
        #load new configuration
        Invoke-Expression -Command (Get-Content -Raw $Manifest_path)
        #update original hash to detect further changes
        $Original_Manifest_hash = $current_Manifest_hash
        #update enabled modules
        $Enabled_modules = $Modules | Where-Object {$_.Enabled -eq $true}
    }
    #endregion

    #display summary of running modules and the time for their next run
    Write-Host -ForegroundColor Cyan '[*] Displaying current module summary:'
    Format-Table -InputObject $Modules -AutoSize -Wrap

    #region loop over all enabled modules
    foreach($Module in $Enabled_modules){
        #run the module if it reaches 0 minutes till run
        if($Module.MinutesTillNextRun -eq 0){

            Write-Host -ForegroundColor Cyan "[*] $($Module.Name) now running"
            Start-Process PowerShell.exe -ArgumentList $($Module.ScriptPath)

            #reset its run interval
            $Module.MinutesTillNextRun = $Module.RunIntervalMinutes
        }
        else{
            #decrement the minutes on every loop iteration
            $Module.MinutesTillNextRun--
        }
    }
    #endregion

    #export state file to allow the controller to resume if stopped
    Export-Clixml -InputObject $Modules -Path "$ScriptRoot\State.xml"

    #standing by for 1 minute
    Write-Host -ForegroundColor Cyan "[*] Standing by for 1 minute"
    Start-Sleep -Seconds 60
}