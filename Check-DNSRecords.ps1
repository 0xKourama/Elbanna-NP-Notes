Param(
    $InputCsv,
    $OutputCsv
)
$ErrorActionPreference = 'Stop'

$Result_list = @()

try{

    $InCsv = Import-Csv $InputCsv

    $InCsv.Name | ForEach-Object {

        $Domain = $_
        try{

            $MX_Query  = Resolve-DnsName -Type MX -Name $Domain | Select-Object -Property Name, NameExchange
            if($MX_Query){
                foreach($MX_Result in $MX_Query){
                    $obj = @{} | Select-Object -Property Domain, MX, TXT, Error
                    $obj.Domain = $MX_Result.Name
                    $obj.MX     = $MX_Result.NameExchange
                    $Result_list += $obj
                }
            }

            $TXT_Query  = Resolve-DnsName -Type TXT -Name $Domain | Select-Object -Property Name, Strings
            if($TXT_Query){
                foreach($TXT_Result in $TXT_Query){
                    $obj = @{} | Select-Object -Property Domain, MX, TXT, Error
                    $obj.Domain = $TXT_Result.Name
                    $obj.TXT    = ($TXT_Result.strings | Out-String).trim()
                    $Result_list += $obj
                }
            }

        }
        catch{
            $obj = @{} | Select-Object -Property Domain, MX, TXT, Error
            $obj.Domain = $Domain
            $obj.Error = $_
            $Result_list += $obj
        }

    }
    $Result_list | Export-Csv -NoTypeInformation $OutputCsv
}
catch{
    Write-Host "[!] An error occured: $_" -ForegroundColor Yellow
}