$text = ((Get-Clipboard) -replace "\. ",".`n") -split '\n' | % {
    $_ -replace ', ',":`n- " `
       -replace '; ',' --> ' `
       -replace ' and,? ',' *AND* ' `
       -replace ' or,? ',' *OR* ' `
       -replace ' but,? ',' *BUT* '
} | % {
    if($_ -match "^\S"){"## $_"}else{$_}
}
$text += ""
$text += "### what makes this important?"
$text += "### what are the ideas?"
$text += "### what are the terms and meanings?"
$text += "### what did I learn? what is my paraphrase?"
$text += "### what connections can be made with previous knowledge?"
$text += "### what can be applied?"
$text | Set-Clipboard