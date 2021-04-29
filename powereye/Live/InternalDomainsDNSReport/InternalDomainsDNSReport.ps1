Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$ErrorActionPreference = 'Stop'

$Result_list = @()

class DNSData {
    [String]$Domain
    [Bool]$MX1
    [Bool]$MX2
    [Bool]$MX3
    [Bool]$MX4
    [String]$MXConfiguration = 'N/A'
    [Bool]$SRVConfigured
    [Bool]$SPFConfigured
    [Bool]$DKIMConfigured
    [Bool]$DMARCConfigured
    [String]$Error = 'N/A'
}

$Csv = Import-Csv 'WorldPostaDomains.csv' | Sort-Object -Property Domain

$Index = 0

#iterating over the name property in the input excel sheet
$Csv.Domain | ForEach-Object {

    $Index++
    $Domain = $_

    Write-Host -ForegroundColor Cyan "[$Index/$($Csv.Count)] [*] Quering $Domain"

    $Obj = New-Object -TypeName DNSData
    $Obj.Domain = $Domain

    try{
        #get MX records
        $MX_Query  = Resolve-DnsName -Type MX -Name $Domain | Select-Object -Property Name, NameExchange

        if($MX_Query.NameExchange){
            foreach($MX_Result in $MX_Query){
                switch -Regex ($MX_Result.NameExchange){
                    'wp-secure-cloudmail01.worldposta.com'{$Obj.MX1 = $true}
                    'wp-secure-cloudmail02.worldposta.com'{$Obj.MX2 = $true}
                    'wp-secure-cloudmail03.worldposta.com'{$Obj.MX3 = $true}
                    'wp-secure-cloudmail04.worldposta.com'{$Obj.MX4 = $true}
                    Default{$Obj.MXConfiguration = 'Different MX Present'}
                }
            }
            if($Obj.MX1 -and $Obj.MX2 -and $Obj.MX3 -and $Obj.MX4 -and ($Obj.MXConfiguration -ne 'DifferentMXPresent')){
                $Obj.MXConfiguration = 'Fully Configured'
            }
            elseif($Obj.MX1 -or $Obj.MX2 -or $Obj.MX3 -or $Obj.MX4){
                $Obj.MXConfiguration = 'Partially Configured'
            }
        }
        else{
            $Obj.MXConfiguration = 'Not Configured'
        }

        #get TXT records
        $TXT_Query  = Resolve-DnsName -Type TXT -Name $Domain | Select-Object -Property Name, Strings

        if($TXT_Query){
            foreach($TXT_Result in $TXT_Query){
                Switch -Regex (($TXT_Result.strings | Out-String).trim()){
                    'v=spf1 mx include:_spf.worldposta.com -all'{$Obj.SPFConfigured = $true}
                    'WorldPosta-verification=.*'{$Obj.DKIMConfigured = $true}
                    'v=DMARC1; p=none; rua=mailto:report@worldposta.com; ruf=mailto:report@worldposta.com; sp=none;'{$Obj.DMARCConfigured = $true}
                }
            }
        }
        #get SRV records
        $SRV_Query = Resolve-DnsName -Name "_autodiscover._tcp.$Domain" -Type SRV | Select-Object -Property NameTarget

        if($SRV_Query){
            foreach($SRV_Result in $SRV_Query){
                if($SRV_Result.NameTarget -eq 'autodiscover.worldposta.com'){
                    $Obj.SRVConfigured = $true
                }
            }
        }
    }
    catch{
        $Obj.Error  = $_
    }
    $Result_list += $Obj
}

$Report_items = @(
    'MXConfiguration'
    'SRVConfigured'
    'SPFConfigured'
    'DKIMConfigured'
    'DMARCConfigured'
)

$Report_items | ForEach-Object {

$body += @"
<h3>$($_ -replace 'Config.*') Configuration Summary</h3>
$($Result_list | Group-Object -Property $_ |
Select-Object -Property @{n='State';e={$_.Name}}, Count,@{n='Domains';e={$_.Group.Domain -join ' | '}} |
Sort-Object -Property Value -Descending | ConvertTo-Html -Fragment)
"@

}

Write-Output $Result_list

Send-MailMessage @MailSettings -BodyAsHtml "$Style $body"