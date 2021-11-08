<#
$report = @()
foreach ($vm in Get-VM){
    $view = Get-View $vm
    if ($view.config.hardware.Device.Backing.ThinProvisioned -eq $true){
        
        [String[]]$VMDK_Array = $view.config.hardware.Device.Backing.Filename
        [String[]]$Prov_Array = $view.config.hardware.Device.Backing.ThinProvisioned

        $report += "<b>VM Name:</b>$($vm.Name)<br>"
        $report += "<b>Provisioned:</b>$([math]::round($vm.ProvisionedSpaceGB , 2))<br>"
        $report += "<b>Total:</b>$([math]::round(($view.config.hardware.Device | Measure-Object CapacityInKB -Sum).sum/1048576 , 2))<br>"
        $report += "<b>Used:</b>$([math]::round($vm.UsedSpaceGB , 2))<br>"
        $report += "<b>HD Information:</b>$(0..$($VMDK_Array.Count - 1) | ForEach-Object {
            "$($VMDK_Array[$_]) [$(if($Prov_Array[$_] -eq $true){'Thin'}else{'Thick'})]"
        } | 
                ForEach-Object -Begin {'<ol>'} -End {'</ol>'} -Process {
                    if($_ -match '\[Thin\]'){
                        "<li style='background-color:#0bde0f;'>$_</li>"
                    }
                    elseif($_ -match '\[Thick\]'){
                        "<li style='background-color:#c90c0c;'>$_</li>"
                    }
                    else{
                        "<li>$_</li>"
                    }
                })<br>"
        $report += '<hr>'

        Clear-Variable VMDK_Array, Prov_Array
    }
}
$report > Thin_Disks.html
#>


Get-Datastore | Get-VM | Get-HardDisk | Where {$_.storageformat -eq "Thick" } | Select Parent, Name, CapacityGB, storageformat | export-csv -NoTypeInformation thick_data.csv