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
            $JitColor = 'Red'
            $LastPacketLost = $true
        }
        else{
            $prev_ping_latency = ($List[$List.Count - 2]).Latency
            $LastPacketLost = $false
            $Jitter  = [math]::abs($prev_ping_latency - $ping_object.Latency)
        }

        if($ping_object.Latency  -lt 100){
            $pingColor = 'Green'
            $Sign = '[+]'
        }
        elseif($ping_object.Latency  -lt 200){
            $PingColor = 'Yellow'
            $Sign = '[!]'
        }
        else{
            $PingColor = 'Red'
            $Sign = '[-]'
        }

        if    ($Jitter -lt 10 -and $LastPacketLost -eq $false){$JitColor = 'Green' }
        elseif($Jitter -lt 20 ){$JitColor = 'Yellow'}
        else                   {$JitColor = 'Red'   }

        $average_latency = ($List.Latency | Measure-Object -Average | Select-Object -ExpandProperty Average) -as [int]

        if    ($average_latency    -lt 100){$avgcolor = 'Green'                }
        elseif($average_latency    -lt 200){$avgcolor = 'Yellow'               }
        else                               {$avgcolor = 'Red'                  }

        $packetloss_percent = (($List | Where-Object {$_.LostPacket -eq $true} | Measure-Object | Select-Object -ExpandProperty count)/$List.count) * 100 -as [int]

        if    ($packetloss_percent -lt 10 ){$packetloss_color = 'Green'                }
        elseif($packetloss_percent -lt 20 ){$packetloss_color = 'Yellow'               }
        else                               {$packetloss_color = 'Red'                  }

        Write-Host -ForegroundColor $pingcolor -NoNewline "$sign "
        Write-Host -NoNewline "[ IP: "
        Write-Host -NoNewline "$($ping.ProtocolAddress)".PadRight(15,' ')
        Write-Host -NoNewline " | "
        Write-Host -NoNewline "LAT: "
        Write-Host -ForegroundColor $pingcolor -NoNewline "$($ping.ResponseTime)".PadRight(4)
        Write-Host -NoNewline " ms | "
        Write-Host -NoNewline "TTL: $($ping.ResponseTimeToLive) | "
        Write-Host -NoNewline "JITT: "
        Write-Host -ForegroundColor $jitcolor -NoNewline "$jitter ".PadRight(4)
        Write-Host -NoNewline "ms | "
        Write-Host -NoNewline "AVG: "
        Write-Host -ForegroundColor $avgcolor -NoNewline "$average_latency".PadRight(4)
        Write-Host -NoNewline " ms | "
        Write-Host -NoNewline "LOSS: "
        Write-Host -ForegroundColor $packetloss_color -NoNewline "$packetloss_percent".PadRight(3)
        Write-Host "% ]"
    }
    catch{
        $ping_object.LostPacket = $true
        $List.Add($ping_object) | Out-Null
        $Sign = '[x]'
        Write-Host "$sign Request timed out at $((get-date).ToShortTimeString())" -ForegroundColor Red
    }

    Start-Sleep -Milliseconds $time_between_pings_milliseconds
}
