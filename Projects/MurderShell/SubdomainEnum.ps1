Param(
    $Wordlist,
    $Domain
)

$Subdomains = Get-Content $Wordlist
$Found_Subdomains = @()

$ErrorActionPreference = 'SilentlyContinue'

$Index = 1
foreach($Subdomain in $Subdomains){
    Write-Progress -Activity "Found subdomains: $($Found_Subdomains -join ', ')" `
                   -Status "[$Index/$($Subdomains.count)] [$([Math]::Round(($Index/$Subdomains.Count)*100,2))%] Sending web request to $Subdomain.$Domain" `
                   -PercentComplete (($Index/$Subdomains.Count)*100)
    if((Invoke-WebRequest "https://$Subdomain.$Domain").StatusCode -eq 200){
        $Found_Subdomains += $Subdomain
    }
    $Index++
}