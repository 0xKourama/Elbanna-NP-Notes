#region set paths for working directory and manifest file
$ScriptRoot = 'C:\Users\Zen\powershell\powereye\live'
$Manifest_path = "$ScriptRoot\Manifest.ps1"
#end region

#load configuration from manifest
Invoke-Expression -Command (Get-Content -Raw $Manifest_path)

#calculate file hash to detect changes to configuration during runtime
$Original_Manifest_hash = (Get-FileHash -Path $Manifest_path).Hash

$Enabled_modules = $Modules | Where-Object {$_.Enabled -eq $true}

while($true){

    $Runtime_data = $Modules | Select-Object -Property Name, MinutesTillNextRun

    #region check for configuration changes
    $current_Manifest_hash = (Get-FileHash -Path $Manifest_path).Hash

    if($current_Manifest_hash -ne $Original_Manifest_hash){
        Write-Host -ForegroundColor Yellow "[!] Configuration file changed. Updating the running configuration."
        #load new configuration
        Invoke-Expression -Command (Get-Content -Raw $Manifest_path)

        $Enabled_modules = $Modules | Where-Object {$_.Enabled -eq $true}

        #update original hash to detect further changes
        $Original_Manifest_hash = $current_Manifest_hash
    }
    #endregion

    #region loop over all enabled modules
    foreach($Module in $Enabled_modules){

        #run the module if it reaches 0 minutes till run or if it is set to run on demand
        if(($Module.MinutesTillNextRun -eq 0) -or ($Module.RunOnDemand -eq $true)){

            Write-Host -ForegroundColor Cyan "[*] [$(Get-Date)] $($Module.Name) now running"
            #Start-Process PowerShell.exe -ArgumentList $($Module.ScriptPath)

            #reset its run interval
            $Module.MinutesTillNextRun = $Module.RunInterval.TotalMinutes
            #unset the run on demand property
            $Module.RunOnDemand = $false
        }
        else{
            #decrement the minutes on every loop iteration
            $Module.MinutesTillNextRun--
        }
    }
    #endregion

    #standing by for 1 minute
    Write-Host -ForegroundColor Cyan "[*] Standing by for 1 minute`n"
    $Modules | Select-Object -Property Enabled, Name, RunInterval, MinutesTillNextRun, RunOnDemand | Sort-Object -Property MinutesTillNextRun |  Format-Table -Wrap
    Start-Sleep -Seconds 60
}