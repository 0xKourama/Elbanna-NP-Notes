$color = 'green'
write-host "feroxbuster usage:"
Write-Host "--url        " -NoNewline; Write-Host "URL" -ForegroundColor $color
Write-Host "-k           " -NoNewline; Write-Host "Disable TLS validation"              -ForegroundColor $color
Write-Host "-r           " -NoNewline; Write-Host "Follow redirects"                    -ForegroundColor $color
Write-Host "-d           " -NoNewline; Write-Host "Recursion depth [0 for infinite]"    -ForegroundColor $color
Write-Host "-w           " -NoNewline; Write-Host "Wordlist"                            -ForegroundColor $color
Write-Host "-x           " -NoNewline; Write-Host "Extensions [ex: html php txt]"       -ForegroundColor $color
Write-Host "-t           " -NoNewline; Write-Host "Threads"                             -ForegroundColor $color
Write-Host "--rate-limit " -NoNewline; Write-Host "limit number of requests per second" -ForegroundColor $color
Write-Host "-L           " -NoNewline; Write-Host "Number of concurrent scans"          -ForegroundColor $color
Write-Host "-T           " -NoNewline; Write-Host "Timeout duration"                    -ForegroundColor $color
Write-Host "-C           " -NoNewline; Write-Host "Filter status code"                  -ForegroundColor $color
Write-Host "-W           " -NoNewline; Write-Host "Filter words"                        -ForegroundColor $color
Write-Host "-s           " -NoNewline; Write-Host "Status codes to allow"               -ForegroundColor $color
Write-Host "-o           " -NoNewline; Write-Host "Output file"                         -ForegroundColor $color