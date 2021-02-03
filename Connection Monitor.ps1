$ErrorActionPreference = 'Stop'

Clear-Host

$dest = Read-Host "[?] Destination"

if($dest -eq ''){
    $dest = 'google.com'
    Write-Host '[*] Blank destination entered. Using google.com' -ForegroundColor Cyan
}

$prevping                    = 0
$total_packets               = 0
$latency_sum                 = 0
$packets_lost                = 0
$packetloss_reset_threshold  = 60

$prevping = (Test-Connection $dest -Count 1 -ErrorAction SilentlyContinue).ResponseTime

while($true){

    if($total_packets -eq $packetloss_reset_threshold){
        $total_packets = 0
        $packets_lost  = 0
        $latency_sum   = 0
    }

    $total_packets += 1

    try{

        $ping               = Test-Connection $dest -Count 1

        if    ($ping.ResponseTime -lt 100){$pingcolor        = 'Green' ; $sign = '[+]'}
        elseif($ping.ResponseTime -lt 200){$pingcolor        = 'Yellow'; $sign = '[!]'}
        else                              {$pingcolor        = 'Red'   ; $sign = '[-]'}

        $jitter             = [math]::abs($prevping - $ping.ResponseTime)

        if    ($jitter -lt 10)            {$jitcolor         = 'Green'                }
        elseif($jitter -lt 20)            {$jitcolor         = 'Yellow'               }
        else                              {$jitcolor         = 'Red'                  }

        $average_latency    = $latency_sum/$total_packets          -as [int]

        if    ($average_latency -lt 100)  {$avgcolor         = 'Green'                }
        elseif($average_latency -lt 200)  {$avgcolor         = 'Yellow'               }
        else                              {$avgcolor         = 'Red'                  }

        $packetloss_percent = ($packets_lost/$total_packets) * 100 -as [int]

        if    ($packetloss_percent -lt 10){$packetloss_color = 'Green'                }
        elseif($packetloss_percent -lt 20){$packetloss_color = 'Yellow'               }
        else                              {$packetloss_color = 'Red'                  }

        $prevping = $ping.ResponseTime
        $latency_sum   += $ping.ResponseTime

        Write-Host "$sign "                                                   -NoNewline -ForegroundColor $pingcolor 
        Write-Host "IP Address: "                                             -NoNewline
        Write-Host "$($ping.ProtocolAddress) | ".PadRight(15,' ')             -NoNewline
        Write-Host "Bytes: $($ping.BufferSize) | "                            -NoNewline
        Write-Host "Latency: "                                                -NoNewline
        Write-Host "$($ping.ResponseTime)".PadRight(4,' ')                    -NoNewline -ForegroundColor $pingcolor 
        Write-Host " ms | "                                                   -NoNewline
        Write-Host "TTL: $($ping.ResponseTimeToLive) hops | "                 -NoNewline
        Write-Host "Jitter: "                                                 -NoNewline
        Write-Host "$jitter ".PadRight(4,' ')                                 -NoNewline -ForegroundColor $jitcolor 
        Write-Host "ms | "                                                    -NoNewline
        Write-Host "Average Latency: "                                        -NoNewline
        Write-Host "$average_latency".PadRight(4,' ')                         -NoNewline -ForegroundColor $avgcolor
        Write-Host "ms | "                                                    -NoNewline
        Write-Host "Packet Loss: "                                            -NoNewline
        Write-Host "$packetloss_percent".PadRight(3,' ')                      -NoNewline -ForegroundColor $packetloss_color
        Write-Host "%"
    }
    catch{
        $sign = '[x]'
        Write-Host "$sign Request timed out" -ForegroundColor Red
        $packets_lost += 1
    }

    sleep 1.12
}
