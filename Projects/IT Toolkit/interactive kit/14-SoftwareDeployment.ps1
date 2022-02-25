function MSI-Installer{

    Display -Header "MSI Installer" `
            -Footer "X to Return"   `
            -OptionList @("Enter computer name", "L] Load from file")

    $InvokeBlock = {
        $App_path = $args[0]
        $JobBlock = {
            $properties = @(
                'ComputerName'      ,
                'ApplicationPath'   ,
                'InstallationStatus'
            )

            $object = @{} | select -Property $properties

            $object.ComputerName    = $env:COMPUTERNAME
            $object.ApplicationPath = $args[0]

            if(!(Test-Path -Path $object.ApplicationPath)){
                $object.InstallationStatus = "Failure"
            }
            else{
                cmd /c "msiexec /i `"$App_path`" /qn"
                if($LASTEXITCODE -eq 0){
                    $object.InstallationStatus = "Success"
                }
                else{
                    $object.InstallationStatus = "Failure"
                }
            }

            Write-Output "║ "
            ($object | Format-Table -AutoSize | Out-String).Trim() -split "`n" | % {Write-Output "║ $_"}
            Write-Output "║ "

        }
        Start-Job $JobBlock -ArgumentList $App_path | Wait-Job | Receive-Job
    }
    Invoke-Command -ComputerName (Quick-ping -ComputerNames (Get-ComputerCriteria)) -ScriptBlock $InvokeBlock -ArgumentList (Read-Host "║`n║ [?] Enter application path [ex: c:\app.msi]")
    Divider
}