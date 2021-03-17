$ErrorActionPreference = 'Stop'

Clear-Host

$dest = Read-Host "[?] Destination"

if($dest -eq ''){
    $dest = '1.1.1.1'
    Write-Host '[*] Blank destination entered. Using CloudFlare DNS' -ForegroundColor DarkCyan
}

$List = New-Object -TypeName "System.Collections.ArrayList"

$time_between_pings_milliseconds = 1000

$ping_properties = @(
    'Latency'
    'LostPacket'
)

$Results_to_keep = 60

while($true){

    if($List.Count -ge $Results_to_keep){
        $List.Remove($list[0])
    }

    $ping_object = @{} | Select-Object -Property $ping_properties

    try{

        $ping = Test-Connection $dest -Count 1 | Select-Object -Property ProtocolAddress, ResponseTime, ResponseTimeToLive
        $ping_object.LostPacket = $false
        $ping_object.Latency = $ping.ResponseTime
        $List.Add($ping_object) | Out-Null
        if($List.Count -eq 0 -or ($List[$List.Count - 2]).LostPacket){
            $Jitter = '-'
            $JitColor = 'DarkRed'
            $LastPacketLost = $true
        }
        else{
            $prev_ping_latency = ($List[$List.Count - 2]).Latency
            $LastPacketLost = $false
            $Jitter  = [math]::abs($prev_ping_latency - $ping_object.Latency)
        }

        if($ping_object.Latency  -lt 100){
            $pingColor = 'DarkGreen'
            $Sign = '[+]'
        }
        elseif($ping_object.Latency  -lt 200){
            $PingColor = 'Yellow'
            $Sign = '[!]'
        }
        else{
            $PingColor = 'DarkRed'
            $Sign = '[-]'
        }

        if    ($Jitter -lt 10 -and $LastPacketLost -eq $false){$JitColor = 'DarkGreen' }
        elseif($Jitter -lt 20 ){$JitColor = 'Yellow'}
        else                   {$JitColor = 'DarkRed'   }

        $average_latency = ($List.Latency | Measure-Object -Average | Select-Object -ExpandProperty Average) -as [int]

        if    ($average_latency    -lt 100){$avgcolor = 'DarkGreen'                }
        elseif($average_latency    -lt 200){$avgcolor = 'Yellow'               }
        else                               {$avgcolor = 'DarkRed'                  }

        $packetloss_percent = (($List | Where-Object {$_.LostPacket -eq $true} | Measure-Object | Select-Object -ExpandProperty count)/$List.count) * 100 -as [int]

        if    ($packetloss_percent -lt 10 ){$packetloss_color = 'DarkGreen'                }
        elseif($packetloss_percent -lt 20 ){$packetloss_color = 'Yellow'               }
        else                               {$packetloss_color = 'DarkRed'                  }

        $date = Get-Date

        Write-Host "$sign "                                       -NoNewline -ForegroundColor $pingcolor 
        Write-Host "$date | " -NoNewline
        Write-Host "IP: "                                         -NoNewline
        Write-Host "$($ping.ProtocolAddress) | ".PadLeft(15,' ')  -NoNewline
        Write-Host "LAT: "                                        -NoNewline
        Write-Host "$($ping.ResponseTime)".PadRight(4,' ')        -NoNewline -ForegroundColor $pingcolor 
        Write-Host " ms | "                                       -NoNewline
        Write-Host "TTL: $($ping.ResponseTimeToLive) | "          -NoNewline
        Write-Host "JITT: "                                       -NoNewline
        Write-Host "$jitter ".PadRight(4,' ')                     -NoNewline -ForegroundColor $jitcolor 
        Write-Host "ms | "                                        -NoNewline
        Write-Host "AVG: "                                        -NoNewline
        Write-Host "$average_latency".PadRight(4,' ')             -NoNewline -ForegroundColor $avgcolor
        Write-Host " ms | "                                        -NoNewline
        Write-Host "LOSS: "                                       -NoNewline
        Write-Host "$packetloss_percent".PadRight(3,' ')          -NoNewline -ForegroundColor $packetloss_color
        Write-Host "%"
    }
    catch{
        $ping_object.LostPacket = $true
        $List.Add($ping_object) | Out-Null
        $Sign = '[x]'
        Write-Host "$sign Request timed out" -ForegroundColor Red
    }

    Start-Sleep -Milliseconds $time_between_pings_milliseconds
}
