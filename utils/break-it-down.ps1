[String[]]$text = ((Get-Clipboard) -replace "\. ",".`n") -split '\n' | 
Foreach-Object {
    if($_ -match "^\S"){"## $_"}else{$_}
} | 
Foreach-Object {
    $_ -replace ', ',",`n- " `
       -replace '; ',' --> ' `
       -replace ' and,? ',' *AND* ' `
       -replace ' or,? ',' *OR* ' `
       -replace ' but,? ',' *BUT* ' `
       -replace ' which',' *WHICH*' `
       -replace ' only ',' *ONLY* ' `
       -replace ' except ',' *EXCEPT* ' `
       -replace ' either ',' *EITHER* ' `
       -replace ' neither ',' *NEITHER* ' `
       -replace ' nor ',' *NOR* ' `
       -replace ' not ',' *NOT* ' `
       -replace 'regardless','*REGARDLESS*' `
       -replace 'Specifically','*SPECIFICALLY*' `
       -replace 'until','*UNTILL*' `
       -replace 'unless','*UNLESS*' `
       -replace ' between ',' <- *BETWEEN* -> ' `
       -replace 'although','*ALTHOUGH*' `
       -replace ' by ', ' *BY* ' `
       -replace 'therefore','*THEREFORE*' `
       -replace 'at the same time','*AT THE SAME TIME*' `
       -replace 'always','*ALWAYS*' `
       -replace ' can ',' *CAN* ' `
       -replace 'if ','*IF* ' `
       -replace 'when', '*WHEN*' `
       -replace ' must ', ' *MUST* ' `
       -replace ' at least ', ' *AT LEAST* ' `
       -replace ' all ',' *ALL* ' `
       -replace '^all ','*ALL* '
} 
$text += ""
$text += "### why does this make sense?"
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
write-host -ForegroundColor Green "[+] Text broken down for EASE. FOCUS and understand EVERY sentence :D"