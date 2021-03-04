$csv = Import-Csv C:\Users\admin\Desktop\result.csv

$domains = $csv.Domain | Sort-Object -Unique

$result_list = @()

foreach($domain in $domains){
    $obj = @{} | Select-Object -Property Domain, MX1, MX2, MX3, MX4, MXConfigured, MXFullyConfigured, DifferentMXPresent, SPFConfigured, DKIMConfigured, Error

    $obj.Domain = $domain

    $records    = $csv | Where-Object {$_.domain -eq $domain}

    if($records.Error -ne ''){
        $obj.Error = $records.Error
        $obj.MX1               = $false
        $obj.MX2               = $false
        $obj.MX3               = $false
        $obj.MX4               = $false
        $obj.MXConfigured      = $false
        $obj.MXFullyConfigured = $false
        $obj.SPFConfigured     = $false
        $obj.DKIMConfigured    = $false
    }
    else{
        $obj.Error = $false
        $MX_records  = $records | Select-Object -ExpandProperty MX

        if(!$MX_records){
            $obj.MX1               = $false
            $obj.MX2               = $false
            $obj.MX3               = $false
            $obj.MX4               = $false
            $obj.MXConfigured      = $false
            $obj.MXFullyConfigured = $false
        }
        else{
            foreach($MX_record in $MX_records){
                if    ($MX_record -match 'wp-secure-cloudmail01.worldposta.com'){$obj.MX1 = $true}
                elseif($MX_record -match 'wp-secure-cloudmail02.worldposta.com'){$obj.MX2 = $true}
                elseif($MX_record -match 'wp-secure-cloudmail03.worldposta.com'){$obj.MX3 = $true}
                elseif($MX_record -match 'wp-secure-cloudmail04.worldposta.com'){$obj.MX4 = $true}
                elseif($MX_record -eq ''){}
                else{$obj.DifferentMXPresent = $true}
            }

            if($obj.MX1 -and $obj.MX2 -and $obj.MX3 -and $obj.MX4){
                $obj.MXConfigured      = $true
                $obj.MXFullyConfigured = $true
            }
            else{
                $obj.MXConfigured      = $true
                $obj.MXFullyConfigured = $false
            }
        }

        $TXT_records = $records | Select-Object -ExpandProperty TXT

        if(!$TXT_records){
            $obj.SPFConfigured = $false
            $obj.DKIMConfigured = $false
        }
        else{
            if($TXT_records -contains "v=spf1 mx include:_spf.worldposta.com -all"){
                $obj.SPFConfigured = $true
            }
            else{
                $obj.SPFConfigured = $false
            }

            if($TXT_records -match "WorldPosta-verification="){
                $obj.DKIMConfigured = $true
            }
            else{
                $obj.DKIMConfigured = $false
            }
        }    
    }

    $result_list += $obj
}

$result_list | ft -AutoSize