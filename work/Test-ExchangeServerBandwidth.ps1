param(
    [switch]$WriteOutputToPipeline
)

$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Inquire'

$source_executable_folder = 'C:\Users\GabrUrgent\iperf\*'
$Destination_executable_folder = 'C:\Users\GabrUrgent\iperf\'

ipconfig /flushdns | Out-Null

if($?){Write-Host -ForeGroundColor Green '[+] DNS Cache Cleared'}

class Node{
    [String]$Name
    [string]$Subnet
}

$Target_Nodes = @(
    [Node]@{Name = 'FRANK-MBX02'   ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'FRANK-EX1-X04' ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'FRANK-FEM-F02' ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'FRANK-FEM-F01' ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'FRANK-MBX'     ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'FRANK-FEM-F03' ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'FRANK-FEM-F04' ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'FRANK-MBM-902' ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'STRAS-FEM-FS1' ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'STRAS-FEM-FS2' ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'FRANK-SMT-P01' ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'FRANK-SMT-P02' ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'FRANK-MBM-D35' ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'FRANK-MBM-911' ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'FRANK-FEM-F05' ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'Frank-MBM-912' ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'FRANK-MBM-901' ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'EU1MB9903'     ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'EU1FE3112'     ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'EU1FE3110'     ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'EU1FE3111'     ; Subnet = '192.168.3.0/24'}
    [Node]@{Name = 'EU1FE3113'     ; Subnet = '192.168.3.0/24'}
)

Write-Host  -ForegroundColor Cyan "[*] Attempting to start PowerShell sessions with [$($Target_Nodes.Name -join '][')]"

$Sessions = New-PSSession -ComputerName $Target_Nodes.Name -ErrorAction SilentlyContinue

Write-Host  -ForegroundColor Green "[+] $($Sessions.Count) PowerShell sessions are now active"

$Computers_without_Executable = Invoke-Command -Session ($Sessions | Where-Object {$_.State -eq 'Opened' -and $_.Availability -eq 'Available' }) -ScriptBlock {
    $Check = ((Test-Path "C:\users\gabrurgent\iperf\iperf3.exe") -or (Test-Path "C:\users\gabrurgent\iperf\cygwin1.dll"))
    Write-Output $Check
} | Where-Object {$_.Check -eq $false} | Select-Object -ExpandProperty PSComputerName

if($Computers_without_Executable){
    Write-Host -ForegroundColor Cyan "[+] $($Computers_without_Executable.count) computers were found missing the necessary executables. Starting copy."

    foreach($ActiveSession in (Get-PSSession | Where-Object {$Computers_without_Executable -contains $_.ComputerName})){
        Copy-Item $source_executable_folder -ToSession $ActiveSession `
                                            -Destination $destination_executable_folder `
                                            -Recurse -ErrorAction SilentlyContinue
        if($?){Write-Host -ForegroundColor Green "[+] [COPY SUCCESS] $($ActiveSession.ComputerName)"}
        else{
            Write-Host -ForegroundColor Red "[-] [COPY FAILURE] $($ActiveSession.ComputerName)"
            Remove-PSSession -ComputerName $ActiveSession.ComputerName
        }
    }
}

$Test_Segment_list = @()

$Sessions = Get-PSSession

Write-Host -ForegroundColor Cyan "[*] Populating test segment list for $($Sessions.Count) computers`n"

$counter = 1

foreach($Source in $Sessions.ComputerName){
    foreach($Destination in $Sessions.ComputerName){
        if($Source -ne $Destination -and `
           $Test_Segment_list -notcontains "$Source<-->$Destination" -and `
           $Test_Segment_list -notcontains "$Destination<-->$Source"
        ){
            Write-Host -NoNewline '[ '
            write-Host -NoNewLine "#$counter".PadRight(3)
            Write-Host -NoNewLine ' ] [ '
            Write-Host -NoNewline -ForegroundColor Cyan $Source.PadRight(15)
            Write-Host -NoNewline ' ]'
            Write-Host -NoNewline ' <--> '
            Write-Host -NoNewline '[ '
            Write-Host -NoNewline -ForegroundColor Green $Destination.PadRight(15)
            Write-Host ' ]'

            $counter++

            $Test_Segment_list += "$Source<-->$Destination"
        }
    }
}

Write-Host -ForegroundColor Cyan "`n[*] $($Test_Segment_list.count) unique network segment(s) calculated`n"

Switch(Read-Host "[?] Continue? [Y/N]"){
    'N'{
        Write-Host -ForegroundColor Cyan '[*] Terminating running sessions'
        $Sessions | Remove-PSSession
        if($?){
            Write-Host -ForegroundColor Green '[+] Sessions terminated'
        }
        else{
            Write-Host -ForegroundColor Yellow "[!] An error occured $_"   
        }
    }
    'Y'{}
    default{pause}
}
Write-Host

$Connector_Code = {
    $Server = $args[0]
    $SourceSubnet = $args[1]
    $DestinationSubnet = $args[2]
    $Segment = $args[3]
    $total_segments = $args[4]

    [single]$result = c:\users\gabrurgent\iperf\iperf3.exe -c $Server |
    Select-Object -Skip 3 -First 10 |
    Select-String -Pattern '(\d{1,3}.\d) MBytes' -AllMatches |
    Select-Object -ExpandProperty matches |
    Select-Object -ExpandProperty groups |
    Where-Object {$_.name -eq 1} |
    Select-Object -ExpandProperty value |
    Measure-Object -Average |
    Select-Object -ExpandProperty average

    $result = [math]::Round($result,2)

    Write-Host -NoNewline '[ '
    Write-Host -NoNewline "$Segment/$total_segments".PadRight(7)
    Write-Host -NoNewline ' ] [ '
    Write-Host -NoNewline -ForegroundColor Cyan $env:COMPUTERNAME.PadRight(15)
    Write-Host -NoNewline ' ] [ '
    Write-Host -NoNewline -ForegroundColor Cyan $SourceSubnet.PadRight(18)
    Write-Host -NoNewline ' ] <--- [ '
    Write-Host -NoNewline -ForegroundColor Yellow "$result".PadRight(6)
    Write-Host -NoNewline -ForegroundColor Yellow ' MBytes/Second'
    Write-Host -NoNewline ' ] ---> [ '
    Write-Host -NoNewline -ForegroundColor Green $Server.PadRight(15)
    Write-Host -NoNewline ' ] [ '
    Write-Host -NoNewline -ForegroundColor Green $DestinationSubnet.PadRight(18)
    Write-Host ' ]'

    Write-Output $result
}

Write-Host -ForeGroundColor Cyan "[*] Starting bandwidth tests (10 seconds per network segment)`n"

$ResultArray = @()

$Test_Segment_list = $Test_Segment_list | Sort-Object

$Index = 1

foreach($entry in $Test_Segment_list){
    $Obj = @{} | Select-Object -Property Segment, Source, SourceSubnet, Destination, DestinationSubnet, AverageSpeedMBps

    $obj.Segment           = $Index
    $Obj.Source            = ($entry -split '<-->')[0]
    $Obj.Destination       = ($entry -split '<-->')[1]
    $Obj.SourceSubnet      = $Target_Nodes | Where-Object {$_.Name -eq $Obj.Source}      | Select-Object -ExpandProperty Subnet
    $Obj.DestinationSubnet = $Target_Nodes | Where-Object {$_.Name -eq $Obj.Destination} | Select-Object -ExpandProperty Subnet

    $Index += 1

    $Listener_Session  = $Sessions | Where-Object {$_.ComputerName -eq $Obj.Source}
    $Connector_Session = $Sessions | Where-Object {$_.ComputerName -eq $Obj.Destination}

    $Listener_Job = Invoke-Command -Session $Listener_Session -ScriptBlock {C:\users\gabrurgent\iperf\iperf3.exe -s} -AsJob
    Start-Sleep -Seconds 1

    $Obj.AverageSpeedMBps = Invoke-Command -Session $Connector_Session -ScriptBlock $Connector_Code -ArgumentList $Obj.Source,
                                                                                                                  $Obj.SourceSubnet,
                                                                                                                  $Obj.DestinationSubnet,
                                                                                                                  $Obj.Segment,
                                                                                                                  $Test_Segment_list.Count

    $Listener_Job | Stop-Job
    $Listener_Job | Remove-Job

    $ResultArray += $Obj
}

Write-Host
Write-Host -ForegroundColor Cyan '[*] Displaying results:'

$ResultArray | Format-Table -AutoSize

$measurements = $ResultArray | Measure-Object -Property AverageSpeedMBps -Average -Minimum -Maximum

Write-Host -ForegroundColor Cyan "Statistics:`n"

Write-Host -NoNewline "Minimum: "; Write-Host -NoNewline "$([math]::Round($measurements.Minimum,2))".PadRight(6); Write-Host " MBytes/Second"
Write-Host -NoNewline "Maximum: "; Write-Host -NoNewline "$([math]::Round($measurements.Maximum,2))".PadRight(6); Write-Host " MBytes/Second"
Write-Host -NoNewline "Average: "; Write-Host -NoNewline "$([math]::Round($measurements.Average,2))".PadRight(6); Write-Host " MBytes/Second"

Write-Host

Write-Host -ForegroundColor Cyan '[*] Terminating running sessions'

$Sessions | Remove-PSSession

if($?){
    Write-Host -ForegroundColor Green '[+] Sessions terminated'
}
else{
    Write-Host -ForegroundColor Yellow "[!] An error occured $_"
}