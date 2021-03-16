$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Inquire'

$source_executable_folder = 'C:\Users\GabrUrgent\iperf\*'
$Destination_executable_folder = 'C:\Users\GabrUrgent\iperf\'

ipconfig /flushdns | Out-Null

if($?){Write-Host -ForeGroundColor Green '[+] DNS Cache Cleared'}

$ADComputers = Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address} | Select-Object -ExpandProperty Name

Write-Host  -ForegroundColor Cyan "[*] Attempting to start PowerShell sessions with $($ADComputers.Count) AD Computers.."

$Sessions = New-PSSession -ComputerName $ADComputers -ErrorAction SilentlyContinue

Write-Host  -ForegroundColor Green "[+] $($Sessions.Count) PowerShell sessions are now active"

Write-Host  -ForegroundColor Cyan "[*] Starting copy to computers in session"

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

pause

#populating test segments
$Test_Segment_list = @()

$ActiveSessions = Get-PSSession

Write-Host -ForegroundColor Cyan "[*] Populating test segment list for $($ActiveSessions.Count) computers"

$side_width = 0

foreach($Source in $Sessions.ComputerName){
    foreach($Destination in $Sessions.ComputerName){
        if($Source -ne $Destination -and `
           $Test_Segment_list -notcontains "$Source<-->$Destination" -and `
           $Test_Segment_list -notcontains "$Destination<-->$Source"
        ){
            Write-Host -NoNewline '['
            Write-Host -NoNewline -ForegroundColor Green "$Source"
            Write-Host -NoNewline ']'
            Write-Host -NoNewline ' <--> '
            Write-Host -NoNewline '['
            Write-Host -NoNewline -ForegroundColor Red "$Destination"

            if($side_width -eq 3){
                Write-Host ']'
                $side_width = 0
            }
            else{
                Write-Host -NoNewline '] '
                $side_width++
            }

            $Test_Segment_list += "$Source<-->$Destination"
        }
    }
}

Write-Host -ForegroundColor Cyan "[*] $($Test_Segment_list.count) unique network segments found"

pause

$Test_Segments = @()

foreach($entry in $Test_Segment_list){
    $Obj = @{} | Select-Object -Property Source, Destination
    $Obj.Source = ($entry -split '<-->')[0]
    $Obj.Destination = ($entry -split '<-->')[1]
    $Test_Segments += $Obj
}

$Test_Segments | Format-Table -AutoSize

$Connector_Code = {
    $Server = $args[0]

    $result = c:\users\gabrurgent\iperf\iperf3.exe -c $Server |
    Select-Object -Skip 3 -First 10 |
    Select-String -Pattern '(\d{1,3}.\d) MBytes' -AllMatches |
    Select-Object -ExpandProperty matches |
    Select-Object -ExpandProperty groups |
    Where-Object {$_.name -eq 1} |
    Select-Object -ExpandProperty value |
    Measure-Object -Average |
    Select-Object -ExpandProperty average

    Write-Host -NoNewline '['
    Write-Host -NoNewline -ForegroundColor Cyan $env:COMPUTERNAME
    Write-Host -NoNewline '] <---'
    Write-Host -NoNewline "[$result MBytes/Second]"
    Write-Host -NoNewline '---> ['
    Write-Host -NoNewline -ForegroundColor Red $Server
    Write-Host ']'

    Write-Output $result
}

$ResultArray = @()

<#
foreach($Host1 in $Online_Hosts){

    try{
        $Listener_Session = New-PSSession -ComputerName $Host1
        Invoke-Command -Session $Listener_Session -ScriptBlock {Write-Host "[*] Listener started on $env:COMPUTERNAME" -ForegroundColor Cyan}
        $Listener_job = Invoke-Command -Session $Listener_Session -ScriptBlock {\\frank-rodc-01\c$\users\gabrurgent\iperf\iperf3.exe -s} -AsJob

        foreach($Host2 in $Online_Hosts){
            if($Host2 -ne $Host1){
                $obj = @{} | Select-Object -Property Source, Destination, AverageTransferSpeedMB

                $obj.Source      = $Host2
                $obj.Destination = $Host1
                $obj.AverageTransferSpeedMB = Invoke-Command -ComputerName $Host2 -ScriptBlock $Connector_Code

                $ResultArray += $obj
                Write-Output $obj | Format-Table -AutoSize
            }
        }

        Write-Host "[*] Stopping Listener on $Host1" -ForegroundColor Cyan
        $Listener_Job | Stop-Job
        $Listener_Job | Remove-Job
        $Listener_Session | Remove-PSSession
        Write-Host "[+] Listener stopped on $Host1" -ForegroundColor Green
    }
    catch{
        Write-Host "[-] An error has occured: $_" -ForegroundColor Red
    }
}
$ResultArray | Format-Table -AutoSize
#>