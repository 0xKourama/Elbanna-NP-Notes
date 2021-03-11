$ErrorActionPreference = 'stop'
$ProgressPreference = 'SilentlyContinue'

#bypass cert checks
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

ipconfig /flushdns | Out-Null
Write-Host '[+] Local DNS Cache flushed' -ForegroundColor Green

$IPAddresses = Resolve-DnsName -Name "mail.worldposta.com" | Select-Object -ExpandProperty IPAddress
foreach ($IPAddress in $IPAddresses) {
    try{
        $Response    = Invoke-WebRequest "https://$IPAddress/owa/healthcheck.htm"
        $server      = $Response | Select-Object -ExpandProperty Headers | Select-Object -ExpandProperty values | Select-Object -First 1
        $status_code = $Response | Select-Object -ExpandProperty StatusCode
        $status_desc = $Response | Select-Object -ExpandProperty StatusDescription
        if($status_code -eq 200){
            $color = 'Green'
        }
        else{
            $color = 'Red'
        }
        Write-Host "$server [" -NoNewline
        Write-Host "$IPAddress" -ForegroundColor Cyan -NoNewline
        write-host "]: " -NoNewline
        write-host "$status_code $status_desc" -ForegroundColor $color
    }
    catch{
        Write-Host "[!] An error occured $_" -ForegroundColor Yellow
    }
}