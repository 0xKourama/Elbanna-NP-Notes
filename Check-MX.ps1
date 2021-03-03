Param(
    $InputCsv,
    $OutputCsv,
    $ShowProgress
)

$ErrorActionPreference = 'Stop'
try{
    $InCsv = Import-Csv $InputCsv
    $Result_list = @()
    $InCsv.Name | ForEach-Object {
        $obj = @{} | Select-Object -Property Domain,MX
        $Record = $_
        try{
            if($ShowProgress -eq $true){Write-Host "[*] Querying MX record for $Record" -ForegroundColor Cyan}
            $Res = Resolve-DnsName -Type MX -Name $Record | Select-Object -Property Name, NameExchange
            $obj.Domain = $Record
            $obj.MX     = $Res.NameExchange -join ';'
        }
        catch{
            if($ShowProgress -eq $true){Write-Host "[!] An error occured with $_" -ForegroundColor Yellow}
            $obj.Domain = $Record
            $obj.MX     = 'Error'
        }
        $Result_list += $obj
    }
    $Result_list | Export-Csv -NoTypeInformation $OutputCsv    
    Write-Host "[+] Results exported to $OutputCsv" -ForegroundColor Green
}
catch{
    Write-Host "[!] An error occured: $_" -ForegroundColor Yellow
}