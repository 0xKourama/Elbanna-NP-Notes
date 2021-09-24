[String[]]$text = ((Get-Clipboard) -replace "\. ",".`n") -split '\n' | % {
    $_ -replace ', ',",`n- " `
       -replace '; ',' --> ' `
       -replace ' and,? ',' *AND* ' `
       -replace ' or,? ?',' *OR* ' `
       -replace ' but,? ',' *BUT* ' `
       -replace ' ?which',' *WHICH*' `
       -replace ' ?only ',' *ONLY* ' `
       -replace ' ?except ',' *EXCEPT* ' `
       -replace ' ?either ',' *EITHER* ' `
       -replace ' not ',' *NOT* ' `
       -replace 'regardless','*REGARDLESS*' `
       -replace 'Specifically','*SPECIFICALLY*' `
       -replace 'until','*UNTILL*' `
       -replace 'unless','*UNLESS*' `
       -replace ' between ',' <-- *BETWEEN* --> ' `
       -replace 'although','*ALTHOUGH*' `
       -replace ' by ', ' *BY* ' `
       -replace 'therefore','*THEREFORE*' `
       -replace 'at the same time','*AT THE SAME TIME*' `
       -replace 'always','*ALWAYS*' `
       -replace ' can ',' *CAN* '
} | % {
    if($_ -match "^\S"){"## $_"}else{$_}
}
$text += ""
$text += "### what makes this important?"
$text += "### what are your questions?"
$text += "### what are the ideas?"
$text += "### what are the terms and meanings?"
$text += "### what did I learn? what is my paraphrase?"
$text += "### what connections can be made with previous knowledge?"
$text += "### what can be applied?"
$text += "### what areas made your mind wander? what areas you didn't understand?"
$text += ""
$text += "----------------------------------------------------"
$text | Set-Clipboard
write-host -ForegroundColor Green "[+] Text broken down. Enjoy :D"