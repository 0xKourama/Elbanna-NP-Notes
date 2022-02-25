function Service-Control{
    while($true){
        Display -Header "Service Control" `
                -Footer "X to Return"     `
                -OptionList @("Enter computer name", "L] Load from file")
        $Computers = Quick-ping -Computernames (Get-ComputerCriteria)
        $Desired_service_name = Read-Host "Enter service name [Ex: 'Windows Update']"
        ##############################################################################################################################
        do{
            $invalid = $false
            $Desired_service_startup_type = Read-Host "Enter desired startup type [A for Automatic / M for Manual / D for Disabled]"
            switch($Desired_service_startup_type){
                'A'{$Desired_service_startup_type = 'Automatic'} 'M'{$Desired_service_startup_type = 'Manual'} 'D'{$Desired_service_startup_type = 'Disabled'}
                default{Write-Host "Invalid choice" -ForegroundColor Red; $invalid = $true}
            }
        }while($invalid -eq $true)
        ##############################################################################################################################>
        do{
            $invalid = $false
            $Desired_service_status = Read-Host "Enter desired status [R for 'running' / S for 'stopped']"
            switch($Desired_service_status){
                'R'{$Desired_service_status = 'Running'}'S'{$Desired_service_status = 'Stopped'}
                default{Write-Host "Invalid choice" -ForegroundColor Red; $invalid = $true}
            }
        }while($invalid -eq $true)
        ##############################################################################################################################>
        
        foreach($computer_fqdn in $Computers){
            Write-Host "$computer_fqdn`: "
            try{
                $current_service = Get-Service -DisplayName $Desired_service_name -ComputerName $computer_fqdn
                if(!$current_service){Write-Host "$Desired_service_name not found" -ForegroundColor Red; continue}
                else{
                    $current_service_name = $current_service.Name
                    $current_service_startup_type = $current_service.StartType
                    $current_service_status = $current_service.Status
                    $current_service_canstop = $current_service.CanStop
                    $current_service_dependentServices = @($current_service.DependentServices)
                    if($current_service_dependentServices -and (($Desired_service_status -eq 'Stopped') -or ($Desired_service_startup_type -eq 'Disabled'))){
                        Write-Host "$Desired_service_name dependent services:"
                        foreach($serv in $current_service_dependentServices){Write-Host $serv.displayname}
                        $prompt = Read-Host "Continue? [Y/N]"
                        if($prompt -eq 'N'){Divider; break}
                    }
                    ##############################################################################################################################
                    Write-Host "Startup type >> " -NoNewline
                    if($Desired_service_startup_type -ne $current_service_startup_type){
                        Write-Host $current_service_startup_type -ForegroundColor Red -NoNewline
                        if($Desired_service_startup_type -eq "Disabled" -and $cant_be_stopped){Write-Host " [Can not be disabled]" -ForegroundColor Yellow; $cant_be_disabled = $true; Divider; break}
                        else{
                            Set-Service -ComputerName $computer_fqdn -Name $current_service_name -StartupType $Desired_service_startup_type
                            write-host " >> " -NoNewline ; Write-Host "[$Desired_service_startup_type]" -ForegroundColor Green
                        }
                    }
                    else{Write-Host "$[current_service_startup_type]" -ForegroundColor Green}
                    ##############################################################################################################################
                    Write-Host "Status >> " -NoNewline
                    if($Desired_service_status -ne $current_service_status){
                        Write-Host "[$current_service_status]" -ForegroundColor Red -NoNewline
                        if($Desired_service_status -eq 'Running'){Start-Service -InputObject $current_service; Write-Host " >> " -NoNewline ; Write-Host "[Running]" -ForegroundColor Green}
                        else{
                            if($current_service_canstop){Stop-Service -InputObject $current_service; write-host " >> " -NoNewline ; Write-Host "[Stopped]" -ForegroundColor Green}
                            else{write-host " >> " -NoNewline ; Write-Host " [Can not be stopped]" -ForegroundColor Yellow; $cant_be_stopped = $true}
                        }
                    }
                    else{Write-Host "[$current_service_status]" -ForegroundColor Green}
                }
            }
            catch{Show-Error}
            Divider
        }
    }
}