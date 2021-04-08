Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

#flushing DNS to make sure all host names are up-to-date
ipconfig /flushdns | Out-Null

#nodes list
$Target_Nodes = @(
    [PSCustomObject][Ordered]@{Name = 'EU1FE3110'     ; Subnet = '10.1.1.0/24'   }
    [PSCustomObject][Ordered]@{Name = 'EU1FE3111'     ; Subnet = '10.1.1.0/24'   }
    [PSCustomObject][Ordered]@{Name = 'EU1FE3112'     ; Subnet = '10.1.1.0/24'   }
    [PSCustomObject][Ordered]@{Name = 'EU1FE3113'     ; Subnet = '10.1.1.0/24'   }
    [PSCustomObject][Ordered]@{Name = 'EU1FE9111'     ; Subnet = '10.1.1.0/24'   }
    [PSCustomObject][Ordered]@{Name = 'EU1FE9222'     ; Subnet = '10.1.1.0/24'   }
    [PSCustomObject][Ordered]@{Name = 'EU1MB9901'     ; Subnet = '192.168.3.0/24'}
    [PSCustomObject][Ordered]@{Name = 'EU1MB9902'     ; Subnet = '192.168.3.0/24'}
    [PSCustomObject][Ordered]@{Name = 'EU1MB9903'     ; Subnet = '192.168.3.0/24'}
    [PSCustomObject][Ordered]@{Name = 'FRANK-FEM-F01' ; Subnet = '10.1.1.0/24'   }
    [PSCustomObject][Ordered]@{Name = 'FRANK-FEM-F02' ; Subnet = '192.168.2.0/24'}
    [PSCustomObject][Ordered]@{Name = 'FRANK-FEM-F03' ; Subnet = '10.1.1.0/24'   }
    [PSCustomObject][Ordered]@{Name = 'FRANK-FEM-F04' ; Subnet = '10.1.1.0/24'   }
    [PSCustomObject][Ordered]@{Name = 'FRANK-MBM-D35' ; Subnet = '192.168.3.0/24'}
)

$stopwatch = [system.diagnostics.stopwatch]::StartNew()

#region testing for session availability and generating segment list
$PSSessions = New-PSSession -ComputerName $Target_Nodes.Name -ErrorAction SilentlyContinue

$Test_Segment_list = @()
foreach($Source in $PSSessions.ComputerName){
    foreach($Destination in $PSSessions.ComputerName){
        if($Source -ne $Destination -and `
            $Test_Segment_list -notcontains "$Source<->$Destination" -and `
            $Test_Segment_list -notcontains "$Destination<->$Source"
        ){
            $Test_Segment_list += "$Source<->$Destination"
        }
    }
}

Remove-PSSession -Session $PSSessions
#endregion

#region code to run on destination node
$Connector_Code = {
    $Server            = $args[0]
    $DestinationSubnet = $args[1]
    $SourceSubnet      = $args[2]
    $Segment           = $args[3]
    $total_segments    = $args[4]

    #region testing bandwidth for 5 seconds and calculating the average speed
    [single]$result = (c:\users\gabrurgent\iperf\iperf3.exe -c $Server -t 5 |
                      Select-Object -Skip 3 -First 5 |
                      Select-String -Pattern '(\d{1,3}.\d) MBytes' -AllMatches).matches.groups |
                      Where-Object {$_.name -eq 1} | Select-Object -ExpandProperty value |
                      Measure-Object -Average | Select-Object -ExpandProperty average

    #round the result to 2 decimal places
    $result = [math]::Round($result,2)
    #endregion


    #region verbose output
    #color the output based on link speed
    if    ($result -lt 100){$color = 'Red'   }
    elseif($result -lt 300){$color = 'Yellow'}
    else                   {$color = 'Green' }

    Write-Host -NoNewline "$Segment/$total_segments".PadRight(7)
    Write-Host -NoNewline ' [ '
    Write-Host -NoNewline -ForegroundColor Green $DestinationSubnet.PadRight(18)
    Write-Host -NoNewline ' | '
    Write-Host -NoNewline -ForegroundColor Green $Server.PadRight(15)
    Write-Host -NoNewline '] < [ '
    Write-Host -NoNewline -ForegroundColor $color "$result".PadRight(6)
    Write-Host -NoNewline ' MBps'
    Write-Host -NoNewline ' ] > [ '
    Write-Host -NoNewline -ForegroundColor Cyan $env:COMPUTERNAME.PadRight(15)
    Write-Host -NoNewline ' | '
    Write-Host -NoNewline -ForegroundColor Cyan $SourceSubnet.PadRight(18)
    Write-Host -NoNewline ' ] '
    Write-Output $result
    #endregion
}
#endregion

$ResultArray = @()

$Index = 0

#properties per measurement object
$ObjectProperties = @(
    'SourceSubnet'
    'Source'
    'AverageSpeed`(MBps`)'
    'Destination'
    'DestinationSubnet'
    'Error'
)

#region loop over every segment and test connectivity
foreach($entry in $Test_Segment_list){

    $Obj = @{} | Select-Object -Property $ObjectProperties
    $Obj.Source            = ($entry -split '<->')[0]
    $Obj.SourceSubnet      = $Target_Nodes | Where-Object {$_.Name -eq $Obj.Source}      | Select-Object -ExpandProperty Subnet
    $Obj.Destination       = ($entry -split '<->')[1]
    $Obj.DestinationSubnet = $Target_Nodes | Where-Object {$_.Name -eq $Obj.Destination} | Select-Object -ExpandProperty Subnet

    $Index++

    try{
        #counting time elapsed for each measurement
        $SegmentStopwatch =  [system.diagnostics.stopwatch]::StartNew()

        #region starting listener on source machine
        $Listener_Job = Invoke-Command -ComputerName $Obj.Source `
                                       -ScriptBlock {C:\users\gabrurgent\iperf\iperf3.exe -s} `
                                       -AsJob `
                                       -ErrorAction Stop
        #endregion

        #region running the code on the destination machine
        $PassedArguments = @(
            $Obj.Source
            $Obj.SourceSubnet
            $Obj.DestinationSubnet
            $Index
            $Test_Segment_list.Count
        )
        $Obj.'AverageSpeed(MBps)' = Invoke-Command -ComputerName $Obj.Destination `
                                                   -ScriptBlock $Connector_Code   `
                                                   -ErrorAction Stop              `
                                                   -ArgumentList $PassedArguments
        #endregion
        
        #region stopping the timer and displaying time elapsed for each measurement
        $Segmentstopwatch.Stop()
        $ElapsedSeconds = [Math]::Round($SegmentStopwatch.Elapsed.TotalSeconds,2)
        
        if    ($ElapsedSeconds -lt 8 ){$TimeColor = 'Green' }
        elseif($ElapsedSeconds -lt 10){$TimeColor = 'Yellow'}
        else                          {$TimeColor = 'Red'   }

        Write-Host -NoNewline "Time elapsed: "
        Write-Host -NoNewline -ForegroundColor $TimeColor $ElapsedSeconds
        Write-Host ' seconds'
        #endregion

        #stopping the server listener
        $Listener_Job | Stop-Job
        $Listener_Job | Remove-Job
    }
    catch{
        $Obj.Error = $Error[0]
    }
    $ResultArray += $Obj
}
#endregion

$stopwatch.Stop()

#region HTML measurements
$Measurements = $ResultArray | Measure-Object -Property 'AverageSpeed(MBps)' -Minimum -Maximum -Average
$ResultHTML = $ResultArray | Sort-Object -Property 'AverageSpeed(MBps)' -Descending | ConvertTo-Html -Fragment | Out-String
$MeasurementsHTML = @"
<ul>
    <li><b>Minimum:</b> $([math]::Round($Measurements.Minimum,2)) MBps</li>
    <li><b>Maximum:</b> $([math]::Round($Measurements.Maximum,2)) MBps</li>
    <li><b>Average:</b> $([math]::Round($Measurements.Average,2)) MBps</li>
</ul>
"@
#endregion

Send-MailMessage @MailSettings -BodyAsHtml "$Style $header1 $measurementsHTML $Header2 $ResultHTML"