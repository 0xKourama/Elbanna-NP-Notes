$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

$url = 'https://www.islamicfinder.org/world/egypt/360630/cairo-prayer-times/'

try{
    $response = Invoke-WebRequest $url

    $matches = $response.content | Select-String -Pattern "prayername.*>(.*)<.*`n.*prayertime.*>(.*)<" -AllMatches | Select-Object -ExpandProperty matches

    class PrayerObject {
        [string]$Prayer
        [string]$Time
        #[datetime]$Time
    }

    $PrayerTimes = @()

    0..5 | ForEach-Object {
        $PrayerTimes += [prayerObject]@{
            Prayer = $matches[$_].Groups[1].Value.trim()
            Time   = $matches[$_].Groups[2].Value.trim()
            #Time   = [datetime]::parseexact($matches[$_].Groups[2], 'hh:mm tt', $null)
        }
    }

    Write-Output $PrayerTimes
}
catch{
    Write-Host "[!] An error occured: $_" -ForegroundColor Yellow
}