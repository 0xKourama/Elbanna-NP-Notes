$Work_duration_minutes = 29
$Remaining_Minutes = $Work_duration_minutes
0..$Work_duration_minutes | % {

    $m_tens = [math]::Floor($Remaining_Minutes / 10) -as [int]
    $m_ones = $Remaining_Minutes % 10

    switch($m_tens){
        0{$m1a = '-';$m1b = '|';$m1c = '|';$m1d = ' ';$m1e = '|';$m1f = '|';$m1g = '-'}
        1{$m1a = ' ';$m1b = ' ';$m1c = '|';$m1d = ' ';$m1e = ' ';$m1f = '|';$m1g = ' '}
        2{$m1a = '-';$m1b = ' ';$m1c = '|';$m1d = '-';$m1e = '|';$m1f = ' ';$m1g = '-'}
        3{$m1a = '-';$m1b = ' ';$m1c = '|';$m1d = '-';$m1e = ' ';$m1f = '|';$m1g = '-'}
        4{$m1a = ' ';$m1b = '|';$m1c = '|';$m1d = '-';$m1e = ' ';$m1f = '|';$m1g = ' '}
        5{$m1a = '-';$m1b = '|';$m1c = ' ';$m1d = '-';$m1e = ' ';$m1f = '|';$m1g = '-'}
        6{$m1a = '-';$m1b = '|';$m1c = ' ';$m1d = '-';$m1e = '|';$m1f = '|';$m1g = '-'}
        7{$m1a = '-';$m1b = ' ';$m1c = '|';$m1d = ' ';$m1e = ' ';$m1f = '|';$m1g = ' '}
        8{$m1a = '-';$m1b = '|';$m1c = '|';$m1d = '-';$m1e = '|';$m1f = '|';$m1g = '-'}
        9{$m1a = '-';$m1b = '|';$m1c = '|';$m1d = '-';$m1e = ' ';$m1f = '|';$m1g = '-'}
    }
    
    switch($m_ones){
        0{$m2a = '-';$m2b = '|';$m2c = '|';$m2d = ' ';$m2e = '|';$m2f = '|';$m2g = '-'}
        1{$m2a = ' ';$m2b = ' ';$m2c = '|';$m2d = ' ';$m2e = ' ';$m2f = '|';$m2g = ' '}
        2{$m2a = '-';$m2b = ' ';$m2c = '|';$m2d = '-';$m2e = '|';$m2f = ' ';$m2g = '-'}
        3{$m2a = '-';$m2b = ' ';$m2c = '|';$m2d = '-';$m2e = ' ';$m2f = '|';$m2g = '-'}
        4{$m2a = ' ';$m2b = '|';$m2c = '|';$m2d = '-';$m2e = ' ';$m2f = '|';$m2g = ' '}
        5{$m2a = '-';$m2b = '|';$m2c = ' ';$m2d = '-';$m2e = ' ';$m2f = '|';$m2g = '-'}
        6{$m2a = '-';$m2b = '|';$m2c = ' ';$m2d = '-';$m2e = '|';$m2f = '|';$m2g = '-'}
        7{$m2a = '-';$m2b = ' ';$m2c = '|';$m2d = ' ';$m2e = ' ';$m2f = '|';$m2g = ' '}
        8{$m2a = '-';$m2b = '|';$m2c = '|';$m2d = '-';$m2e = '|';$m2f = '|';$m2g = '-'}
        9{$m2a = '-';$m2b = '|';$m2c = '|';$m2d = '-';$m2e = ' ';$m2f = '|';$m2g = '-'}
    }

    $Remaining_Seconds = 59

    0..59 | % {

        $s_tens = [math]::Floor($Remaining_Seconds / 10) -as [int]
        $s_ones = $Remaining_seconds % 10

        switch($s_tens){
            0{$s1a = '-';$s1b = '|';$s1c = '|';$s1d = ' ';$s1e = '|';$s1f = '|';$s1g = '-'}
            1{$s1a = ' ';$s1b = ' ';$s1c = '|';$s1d = ' ';$s1e = ' ';$s1f = '|';$s1g = ' '}
            2{$s1a = '-';$s1b = ' ';$s1c = '|';$s1d = '-';$s1e = '|';$s1f = ' ';$s1g = '-'}
            3{$s1a = '-';$s1b = ' ';$s1c = '|';$s1d = '-';$s1e = ' ';$s1f = '|';$s1g = '-'}
            4{$s1a = ' ';$s1b = '|';$s1c = '|';$s1d = '-';$s1e = ' ';$s1f = '|';$s1g = ' '}
            5{$s1a = '-';$s1b = '|';$s1c = ' ';$s1d = '-';$s1e = ' ';$s1f = '|';$s1g = '-'}
            6{$s1a = '-';$s1b = '|';$s1c = ' ';$s1d = '-';$s1e = '|';$s1f = '|';$s1g = '-'}
            7{$s1a = '-';$s1b = ' ';$s1c = '|';$s1d = ' ';$s1e = ' ';$s1f = '|';$s1g = ' '}
            8{$s1a = '-';$s1b = '|';$s1c = '|';$s1d = '-';$s1e = '|';$s1f = '|';$s1g = '-'}
            9{$s1a = '-';$s1b = '|';$s1c = '|';$s1d = '-';$s1e = ' ';$s1f = '|';$s1g = '-'}
        }

        switch($s_ones){
            0{$s2a = '-';$s2b = '|';$s2c = '|';$s2d = ' ';$s2e = '|';$s2f = '|';$s2g = '-'}
            1{$s2a = ' ';$s2b = ' ';$s2c = '|';$s2d = ' ';$s2e = ' ';$s2f = '|';$s2g = ' '}
            2{$s2a = '-';$s2b = ' ';$s2c = '|';$s2d = '-';$s2e = '|';$s2f = ' ';$s2g = '-'}
            3{$s2a = '-';$s2b = ' ';$s2c = '|';$s2d = '-';$s2e = ' ';$s2f = '|';$s2g = '-'}
            4{$s2a = ' ';$s2b = '|';$s2c = '|';$s2d = '-';$s2e = ' ';$s2f = '|';$s2g = ' '}
            5{$s2a = '-';$s2b = '|';$s2c = ' ';$s2d = '-';$s2e = ' ';$s2f = '|';$s2g = '-'}
            6{$s2a = '-';$s2b = '|';$s2c = ' ';$s2d = '-';$s2e = '|';$s2f = '|';$s2g = '-'}
            7{$s2a = '-';$s2b = ' ';$s2c = '|';$s2d = ' ';$s2e = ' ';$s2f = '|';$s2g = ' '}
            8{$s2a = '-';$s2b = '|';$s2c = '|';$s2d = '-';$s2e = '|';$s2f = '|';$s2g = '-'}
            9{$s2a = '-';$s2b = '|';$s2c = '|';$s2d = '-';$s2e = ' ';$s2f = '|';$s2g = '-'}
        }
        $Remaining_Seconds--


$display = @"
+-------------+
| $m1a  $m2a   $s1a  $s2a |
|$m1b $m1c$m2b $m2c.$s1b $s1c$s2b $s2c|
| $m1d  $m2d   $s1d  $s2d |
|$m1e $m1f$m2e $m2f.$s1e $s1f$s2e $s2f|
| $m1g  $m2g   $s1g  $s2g |
+-------------+
"@
        Clear-Host
        Write-Host $display -ForegroundColor Green -BackgroundColor Black
        Start-Sleep -Milliseconds 1000
    }

    $Remaining_Minutes--
}