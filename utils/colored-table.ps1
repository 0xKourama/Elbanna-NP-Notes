$NumberofColumns = 5
$ColumnCounter = $NumberofColumns
Get-VM | Sort-Object -Property PowerState -Descending | ForEach-Object {
    #Start new row if counter is equal to number of columns
    if($ColumnCounter -eq $NumberofColumns){
        '<TR>'
        if($_.PowerState -eq 'PoweredOn'){
            "<TD style=`"background-color:#0bde0f;`">$($_.Name)</TD>"
        }
        elseif($_.PowerState -eq 'Suspended'){
            "<TD style=`"background-color:#4520b3;`">$($_.Name)</TD>"
        }
        else{
            "<TD style=`"background-color:#a3a0a0;`">$($_.Name)</TD>"
        }
        $ColumnCounter--
    }
    #End row if counter is equal to 1
    elseif($ColumnCounter -eq 1){
        if($_.PowerState -eq 'PoweredOn'){
            "<TD style=`"background-color:#0bde0f;`">$($_.Name)</TD>"
        }
        elseif($_.PowerState -eq 'Suspended'){
            "<TD style=`"background-color:#4520b3;`">$($_.Name)</TD>"
        }
        else{
            "<TD style=`"background-color:#a3a0a0;`">$($_.Name)</TD>"
        }
        '</TR>'
        $ColumnCounter = $NumberofColumns
    }
    #write a normal table data otherwise
    else{
        if($_.PowerState -eq 'PoweredOn'){
            "<TD style=`"background-color:#0bde0f;`">$($_.Name)</TD>"
        }
        elseif($_.PowerState -eq 'Suspended'){
            "<TD style=`"background-color:#4520b3;`">$($_.Name)</TD>"
        }
        else{
            "<TD style=`"background-color:#a3a0a0;`">$($_.Name)</TD>"
        }
        $ColumnCounter--
    }
}