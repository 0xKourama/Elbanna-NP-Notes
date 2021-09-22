((Get-Clipboard) -replace "\. ",".`n") -split '\n' | % {
    $_ -replace ', ',":`n- " -replace '; ',' --> ' -replace ' and,? ',' *AND* ' -replace ' or,? ',' *OR* ' -replace ' but,? ',' *BUT* '
} | % {
    if($_ -match "^\S"){"# $_"}else{$_}
} | Set-Clipboard