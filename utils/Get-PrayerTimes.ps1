$ProgressPreference = 'SilentlyContinue'
$url = 'https://www.islamicfinder.org/world/egypt/360630/cairo-prayer-times/'
$response = Invoke-WebRequest $url
$matches = $response.content | Select-String -Pattern "prayername.*>(.*)<.*`n.*prayertime.*>(.*)<" -AllMatches | Select-Object -ExpandProperty matches
class PrayerObject {
    [string]$Prayer
    #[datetime]$Time
    [string]$Time
}
$PrayerTimes = @()
0..5 | ForEach-Object {
    $PrayerTimes += [prayerObject]@{
        Prayer = $matches[$_].Groups[1]
        #Time   = [datetime]::parseexact($matches[$_].Groups[2], 'hh:mm tt', $null)
        Time   = $matches[$_].Groups[2]
    }
}
$PrayerTimes