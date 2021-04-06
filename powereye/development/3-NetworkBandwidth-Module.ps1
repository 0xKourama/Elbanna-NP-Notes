$MailSettings = @{
    SmtpServer = '192.168.3.202'
    From       = 'NetworkBandwidthReport@roaya.co'
    To         = 'Operation@roaya.co'
    #To         = 'mgabr@roaya.co'
    Subject    = 'Network Bandwidth Report'
}

$Style = @"
<style>
th, td {
    border: 2px solid black;
    text-align: center;
}
table{
    border-collapse: collapse;
    border: 2px solid black;
    width: 100%;
}
h3{
    color: white;
    background-color: #0000CD;
    padding: 3px;
    text-align: Center;
    border: 2px solid black;
}
</style>
"@

$Header1 = "<h3>Network Bandwidth Report</h3>"
$header2 = "<h3>Network Bandwidth Statistics</h3>"

$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Inquire'

ipconfig /flushdns | Out-Null

class Node{
    [String]$Name
    [string]$Subnet
}

$Target_Nodes = @(
    [Node]@{Name = 'EU1FE3110'     ; Subnet = '10.1.1.0/24'   }
    [Node]@{Name = 'EU1FE3111'     ; Subnet = '10.1.1.0/24'   }
    [Node]@{Name = 'EU1FE3112'     ; Subnet = '10.1.1.0/24'   }
    [Node]@{Name = 'EU1FE3113'     ; Subnet = '10.1.1.0/24'   }
    [Node]@{Name = 'EU1FE9111'     ; Subnet = '10.1.1.0/24'   }
    [Node]@{Name = 'EU1FE9222'     ; Subnet = '10.1.1.0/24'   }
    [Node]@{Name = 'EU1MB9901'     ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'EU1MB9902'     ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'EU1MB9903'     ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'FRANK-FEM-F01' ; Subnet = '10.1.1.0/24'   }
    [Node]@{Name = 'FRANK-FEM-F02' ; Subnet = '192.168.2.0/24'}
    [Node]@{Name = 'FRANK-FEM-F03' ; Subnet = '10.1.1.0/24'   }
    [Node]@{Name = 'FRANK-FEM-F04' ; Subnet = '10.1.1.0/24'   }
    [Node]@{Name = 'FRANK-MBM-D35' ; Subnet = '192.168.3.0/24'}
)

while($true){

    $stopwatch =  [system.diagnostics.stopwatch]::StartNew()
    
    $width = 3

    $Target_Nodes.name | ForEach-Object {
        if($width -eq 0 -or $_ -eq $Target_Nodes.Name[$Target_Nodes.Count - 1]){
            Write-Host "$_".PadRight(15)
            $width = 3
        }
        else{
            Write-Host -NoNewline "$_".PadRight(15)
            $width--
        }
    }

    $PSSessions = New-PSSession -ComputerName $Target_Nodes.Name -ErrorAction SilentlyContinue

    $Test_Segment_list = @()

    Write-Host -ForegroundColor Cyan "[*] Populating test segment list for $($PSSessions.Count) computers"

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

    Write-Host -ForegroundColor Cyan "[*] $($Test_Segment_list.count) unique network segment(s) calculated"

    $Connector_Code = {
        $Server            = $args[0]
        $DestinationSubnet = $args[1]
        $SourceSubnet      = $args[2]
        $Segment           = $args[3]
        $total_segments    = $args[4]

        [single]$result = (c:\users\gabrurgent\iperf\iperf3.exe -c $Server -t 5 -R |
        Select-Object -Skip 3 -First 5 |
        Select-String -Pattern '(\d{1,3}.\d) MBytes' -AllMatches).matches.groups |
        Where-Object {$_.name -eq 1} | Select-Object -ExpandProperty value |
        Measure-Object -Average | Select-Object -ExpandProperty average

        $result = [math]::Round($result,2)

        if    ($result -lt 100){$color = 'Red'   }
        elseif($result -lt 300){$color = 'Yellow'}
        else                   {$color = 'Green' }

        #region verbose output
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

    Write-Host -ForeGroundColor Cyan "[*] Starting bandwidth tests (5 seconds per network segment)"

    $ResultArray = @()

    $Test_Segment_list = $Test_Segment_list | Sort-Object

    $Index = 0

    foreach($entry in $Test_Segment_list){

        $Obj = @{} | Select-Object -Property SourceSubnet, Source, AverageSpeed`(MBps`), Destination, DestinationSubnet, Error

        $Obj.Source            = ($entry -split '<->')[0]
        $Obj.SourceSubnet      = $Target_Nodes | Where-Object {$_.Name -eq $Obj.Source}      | Select-Object -ExpandProperty Subnet

        $Obj.Destination       = ($entry -split '<->')[1]
        $Obj.DestinationSubnet = $Target_Nodes | Where-Object {$_.Name -eq $Obj.Destination} | Select-Object -ExpandProperty Subnet

        $Index++

        try{
            
            $SegmentStopwatch =  [system.diagnostics.stopwatch]::StartNew()

            $Listener_Job = Invoke-Command -ComputerName $Obj.Source -ScriptBlock {C:\users\gabrurgent\iperf\iperf3.exe -s} -AsJob -ErrorAction Stop

            $Obj.'AverageSpeed(MBps)' = Invoke-Command -ComputerName $Obj.Destination -ScriptBlock $Connector_Code -ErrorAction Stop -ArgumentList $Obj.Source,
                                                                                                                                               $Obj.SourceSubnet,
                                                                                                                                               $Obj.DestinationSubnet,
                                                                                                                                               $Index,
                                                                                                                                               $Test_Segment_list.Count
            $Segmentstopwatch.Stop()
            
            $ElapsedSeconds = [Math]::Round($SegmentStopwatch.Elapsed.TotalSeconds,2)

            if($ElapsedSeconds -lt 8){
                $TimeColor = 'Green'
            }
            elseif($ElapsedSeconds -lt 10){
                $TimeColor = 'Yellow'
            }
            else{
                $TimeColor = 'Red'
            }

            Write-Host -NoNewline "Time elapsed: "
            Write-Host -NoNewline -ForegroundColor $TimeColor $ElapsedSeconds
            Write-Host ' seconds'

            $Listener_Job | Stop-Job
            $Listener_Job | Remove-Job

        }catch{
            $Obj.Error = $Error[0]
        }

        $ResultArray += $Obj
    }

    $measurements = $ResultArray | Measure-Object -Property 'AverageSpeed(MBps)' -Average -Minimum -Maximum

    $ResultHTML = $ResultArray | Sort-Object -Property 'AverageSpeed(MBps)' -Descending | ConvertTo-Html -Fragment

    $stopwatch.Stop()

    Write-Host -ForegroundColor Cyan "[*] Total time elapsed: $($stopwatch.Elapsed.Hours) hours $($stopwatch.Elapsed.Minutes) minutes $($stopwatch.Elapsed.Seconds) seconds"

$MeasurementsHTML = @"
<ul>
    <li><b>Minimum:</b> $([math]::Round($measurements.Minimum,2)) MBps</li>
    <li><b>Maximum:</b> $([math]::Round($measurements.Maximum,2)) MBps</li>
    <li><b>Average:</b> $([math]::Round($measurements.Average,2)) MBps</li>
</ul>
"@
    try{
        Send-MailMessage @MailSettings -BodyAsHtml "$Style $header2 $measurementsHTML $Header1 $ResultHTML" -ErrorAction Stop
    }
    catch{
        Write-Host -ForegroundColor Yellow "[!] Failed to send report with SMTP Server 192.168.3.203"
    }
    [GC]::Collect()
    Write-Host -ForegroundColor Cyan '[*] Sleeping for 5 hours'
    start-sleep -Seconds (5 * 60 * 60)
}