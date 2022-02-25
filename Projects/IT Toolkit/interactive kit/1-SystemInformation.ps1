function Collect-SystemInformation{
    while($true){

        Display -Header "System Information" `
                -Footer "X to Return"        `
                -OptionList @(
                    "Enter computer name",
                    "L] Load from file"
                )
        
        $ADComputers = Get-ADComputer -Filter * -Properties MemberOf, LastLogonDate, CanonicalName

        $InvokeBlock = {

            Invoke-Expression $args[0]

            $ErrorActionPreference = 'stop'

            $PropertyList = @(
                'Username' ,
                'Status'   ,
                'ID'       ,
                'Logontime'
            )

            $User_list = @()

            try{
                Quser | % {
                    if($_ -eq " USERNAME              SESSIONNAME        ID  STATE   IDLE TIME  LOGON TIME"){}
                    else{

                        $User = @{} | Select-Object -Property $PropertyList

                        $User.username     = $_.Substring(0 , 23).Trim().toUpper()
                        $User.ID           = $_.Substring(42, 4 ).Trim()
                        $state             = $_.Substring(46, 8 ).Trim().toUpper()

                        if($state -eq 'Disc'){
                            $User.status = '[INACTIVE]'
                        }
                        else{
                            $session = $_.Substring(22, 20).Trim().toUpper()
                            if($session -like 'RDP*'){
                                $session = 'RDP'
                            }
                            else{
                                $session = 'LOCAL'
                            }
                            $User.status = "[ACTIVE - $session]"
                        }
                        $User.logontime    = $_.Substring(65, ($_.Length - 65)).Trim().toUpper()

                        $User_list += $User
                    }    
                }
            }
            catch{
                $User = @{} | Select-Object -Property $PropertyList
                $User.Username     = "NONE"
                $User_list        += $User
            }

            $Object_properties = @(
                'ComputerName'    ,
                'ADLocation'     ,
                'LastLogonDate'   ,
                'MemberOf'
                'Username'        ,
                'Screen'          ,
                'Manufacturer'    ,
                'Model'           ,
                'GraphicsCard'    ,
                'IPV4'            ,
                'MAC'             ,
                'Processor'       ,
                'RAM'             ,
                'MemoryUsage'     ,
                'OperatingSystem' ,
                'LastDeployed'    ,
                'Uptime'          ,
                'FreeDiskSpace'
            )

            $Object = @{} | Select-Object -Property $Object_properties

            $LockProcess = Get-WmiObject -Query "SELECT * FROM Win32_Process WHERE Name = 'logonui.exe'"

            if(!$LockProcess){
                $Object.Screen = 'Unlocked'
            }
            else{
                foreach($element in $User_list){
                    if($element.Username -eq 'NONE'){
                        $Object.Screen = 'Locked'
                    }
                    elseif($element.status -eq '[ACTIVE - LOCAL]' -or $element.status -eq '[ACTIVE - RDP]'){
                        if(($LockProcess | ? {$_.SessionID -eq ($element.ID)} | select -ExpandProperty name) -notcontains 'LogonUI.exe'){
                            $Object.Screen = 'Unlocked'
                        }
                        else{
                            $Object.Screen = 'Locked'
                        }
                    }
                    else{
                        $Object.Screen = 'Locked'
                    }
                }
            }

            $CS       = Get-WmiObject -Query "SELECT Manufacturer, Username, Name FROM Win32_ComputerSystem"
            $MODEL    = Get-WmiObject -Query "SELECT Name, Version                                                                                                 FROM Win32_ComputerSystemProduct"
            $OS       = Get-WmiObject -Query "SELECT FreePhysicalMemory, TotalVisibleMemorySize, InstallDate, Caption, LastBootUpTime, BuildNumber, OSarchitecture FROM Win32_OperatingSystem"
            $PROC     = Get-WmiObject -Query "SELECT Name, NumberOfCores                                                                                           FROM Win32_Processor"
            $Uptime   = New-TimeSpan -Start ([Management.ManagementDatetimeConverter]::ToDateTime($OS.LastBootupTime)) -End (get-date)
            $ADObject = $args[1] | ? {$_.name -eq $env:COMPUTERNAME} | Select -Property MemberOf, LastLogonDate, CanonicalName

            $Object.ComputerName    = ($CS.Name).ToUpper()
            $Object.ADLocation      = ($ADObject | select -ExpandProperty canonicalname) -replace ('/', ' > ') -replace (" > $env:COMPUTERNAME",'')
            $Object.LastLogonDate   = $ADObject.LastLogonDate
            $Object.MemberOf        = $ADObject.MemberOf | % {"[$($_.split(',')[0] -replace ('CN=',''))]"}
            $Object.Manufacturer    = $CS.Manufacturer
            $Object.Model           = "$($MODEL.Version)$($MODEL.Name)".TrimStart()
            $Object.GraphicsCard    = Get-WmiObject Win32_VideoController | Select -ExpandProperty description
            $Object.IPV4            = ((Test-Connection -ComputerName $env:COMPUTERNAME -Count 1).IPV4Address).ipaddresstoString
            $Object.MAC             = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration | ? {$_.ipenabled -match "True"}).MACAddress | % {"[$_]"}
            $Object.Processor       = "$(($PROC.name).replace('     ','').replace('  ',' ')) [$($PROC.NumberOfCores) cores]"
            $Object.RAM             = "$([Math]::Round(($OS.TotalVisibleMemorySize / 1MB),1)) GB"
            $Object.MemoryUsage     = "$((100 - (($OS.FreePhysicalMemory / $OS.TotalVisibleMemorySize)* 100)) -as [int])%"
            $Object.OperatingSystem = "$($OS.Caption.trim()) [$($OS.OSArchitecture)] build $($OS.BuildNumber)"
            $Object.LastDeployed    = ([Management.ManagementDatetimeConverter]::ToDateTime($OS.installdate)).toshortDatestring()
            $Object.Uptime          = "$($Uptime.Days) Days $($Uptime.Hours) Hours $($Uptime.Minutes) Minutes"
            $Object.FreeDiskSpace   = "$(((Get-WmiObject -Query "SELECT FreeSpace FROM Win32_LogicalDisk WHERE DeviceID = 'C:'").FreeSpace / 1GB) -as [int]) GB" 

            $output = [System.Collections.ArrayList]@()

            $output += "Computer name       : $($Object.ComputerName)"
            $output += "AD Location         : $($Object.ADLocation)"
            $output += "Last Logon Date     : $($Object.LastLogonDate)"
            $Output += "Member of           : $($Object.MemberOf)"
            $output += "IPV4 address        : $($Object.IPV4)"
            $output += "MAC address         : $($Object.MAC)"

            $max1 = ($User_list | % {$_.username.length} | measure -Maximum).Maximum
            $max2 = ($User_list | % {$_.status.length  } | measure -Maximum).Maximum

            $step = 1

            $User_list | % {
                if($_.username -ne 'NONE'){
                    $output += "User #$step             : $($_.username.padright($max1,' ')) $($_.status.padright($max2,' ')) logged in at $($_.logontime)"
                    $step += 1
                }
                else{
                    $output += "User                : NONE"
                }
            }
                
            $output += "Screen              : $($Object.Screen)"
            $output += "Manufacturer        : $($Object.Manufacturer)"
            $output += "Model               : $($Object.Model)"
            $output += "Processor           : $($Object.Processor)"
            $output += "Graphics card       : $($Object.GraphicsCard)"
            $output += "RAM                 : $($Object.RAM)"
            $output += "Memory Usage        : $($object.MemoryUsage)"
            $output += "Operating system    : $($Object.OperatingSystem)"
            $output += "Last deployed       : $($Object.LastDeployed)"
            $output += "Uptime              : $($Object.Uptime)"
            $output += "Free disk space [C] : $($Object.FreeDiskSpace)"

            Display -OptionList $output
        }

        $computers = Quick-ping -ComputerNames (Get-ComputerCriteria)

        Invoke-Command -ComputerName $computers -ScriptBlock $InvokeBlock -ArgumentList $UtilityFunctions, $ADComputers
    }
}