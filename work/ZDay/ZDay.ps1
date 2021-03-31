$Exchange_Servers = @(
    'frank-fem-f01.roaya.loc:8080'
    'frank-fem-f02.roaya.loc:8080'
    'frank-fem-f03.roaya.loc:8080'
    'frank-fem-f04.roaya.loc:8080'
)

$OutFolder_path  = 'C:\Users\gabrurgent\powereye\ZDay\Results'

$username = 'QueueMonitor'
$password = '97$p$*J5f7$#3$0DnA'

[securestring]$secStringPassword = ConvertTo-SecureString $password -AsPlainText -Force
[pscredential]$UserCredential = New-Object System.Management.Automation.PSCredential ($username, $secStringPassword)

while($true){

    foreach($Exchange_Server in $Exchange_Servers){
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange `
                                 -ConnectionUri "http://$Exchange_Server/PowerShell/" `
                                 -Authentication Kerberos `
                                 -Credential $UserCredential

        Import-PSSession $Session -DisableNameChecking -AllowClobber | Out-Null
        if($? -eq $true){
            Write-Host -ForegroundColor green "[+] Session established with $Exchange_Server"
            break
        }
    }

    Write-Host -ForegroundColor Cyan "[*] Running module at $(Get-Date)"

    Get-ExchangeServer | C:\Users\gabrurgent\powereye\ZDay\Test-ProxyLogon.ps1 -OutPath $OutFolder_path

    Remove-PSSession $Session

    $MailSettings = @{
        SMTPserver = '192.168.3.202'
        From       = 'ZDayWatchdog@worldposta.com'
        To         = 'Operation@roaya.co'
        Subject    = 'Exchange Z-Day Suspicious Activity Detected'    
    }

    $Old_threats = @(
        'FRANK-FEM-F01-Cve-2021-26855'
        'FRANK-FEM-F02-Cve-2021-26855'
        'FRANK-FEM-F03-Cve-2021-26855'
        'FRANK-FEM-F04-Cve-2021-26855'
        'STRAS-FEM-FS1-Cve-2021-26855'
        'STRAS-FEM-FS2-Cve-2021-26855'
    )

	Get-ChildItem $OutFolder_path |
    Where-Object {$_.basename -like '*cve*' -and $Old_threats -cnotcontains $_.basename} |
    ForEach-Object {Send-MailMessage @MailSettings -Body $_.fullname }
}