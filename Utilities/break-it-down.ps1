# https://stackedit.io/app#
clear-Host
[String[]]$text = ((Get-Clipboard) -replace "\. ",".`n") -split '\n' | <#
Foreach-Object {
    if($_ -match "^\S"){"## $_"}else{$_}
} | #>
Foreach-Object {
    $_ -replace ', ',",`n- " `
       -replace '; ',' --> ' `
       -replace ' and,? ',' **AND** ' `
       -replace ' or,? ',' **OR** ' `
       -replace ' but,? ',' **BUT** ' `
       -replace ' which',' **WHICH**' `
       -replace ' only ',' **ONLY** ' `
       -replace ' except ',' **EXCEPT** ' `
       -replace ' either ',' **EITHER** ' `
       -replace ' neither ',' **NEITHER** ' `
       -replace ' nor ',' **NOR** ' `
       -replace ' not ',' **NOT** ' `
       -replace 'regardless','**REGARDLESS**' `
       -replace 'Specifically','**SPECIFICALLY**' `
       -replace 'until','**UNTILL**' `
       -replace 'unless','**UNLESS**' `
       -replace 'Every','**EVERY**' `
       -replace 'between','**<-- BETWEEN -->**' `
       -replace 'although','**ALTHOUGH**' `
       -replace ' by ', ' **BY** ' `
       -replace 'therefore','*therefore*' `
       -replace 'at the same time','**AT THE SAME TIME**' `
       -replace 'always','**ALWAYS**' `
       -replace ' can ',' **CAN** ' `
       -replace ' if ',' **IF** ' `
       -replace ' when ', ' **WHEN** ' `
       -replace 'must', '**MUST**' `
       -replace 'at least', '**AT LEAST**' `
       -replace ' all ',' **ALL** ' `
       -replace ' while ', ' **WHILE** ' `
       -replace ' aim ' , ' **AIM** ' `
       -replace 'idea' , '*idea*' `
       -replace 'ideas' , '*ideas*' `
       -replace 'focus' , ' **FOCUS** ' `
       -replace ' research ' , ' **RESEARCH** ' `
       -replace ' skill ' , ' **SKILL** ' `
       -replace ' details ' , ' *details* ' `
       -replace ' knowledge ' , ' *knowledge* ' `
       -replace ' Depending ' , ' *Depending* ' `
       -replace ' experience ' , ' *experience* ' `
       -replace 'example' , '*example*' `
       -replace ' variations ' , ' *variations* ' `
       -replace ' intuitively ' , ' *intuitively* ' `
       -replace 'Essentially' , '*essentially*' `
       -replace ' alternative ' , ' *alternative* ' `
       -replace ' approach ' , ' *approach* ' `
       -replace ' explore ' , ' *explore* ' `
       -replace ' purpose ' , ' **PURPOSE** ' `
       -replace ' principle ' , ' **PRINCIPLE** ' `
       -replace ' principles ' , ' **PRINCIPLES** ' `
       -replace ' without ' , ' **WITHOUT** ' `
       -replace ' exploration ', ' *exploration* ' `
       -replace ' experimentation' , ' *experimentation* '`
       -replace ' learning' , ' *learning* '`
       -replace ' learn' , ' *learn* '`
       -replace ' reflection ', ' *reflection* ' `
       -replace ' theory ', ' *theory* ' `
       -replace 'theories', '*theories*' `
       -replace 'belief', '*belief*' `
       -replace 'beliefs', '*beliefs*' `
       -replace 'test', '*test*' `
       -replace 'analyze', '*analyze*' `
       -replace ' complex ', ' *complex* ' `
       -replace ' precise ', ' *precise* ' `
       -replace 'model', '*model*' `
       -replace 'models', '*models*' `
       -replace ' best practices ' , ' **BEST PRACTICES** ' `
       -replace ' best practice ' , ' **BEST PRACTICE** ' `
       -replace ' significantly ' , ' **SIGNFICANTLY** ' `
       -replace ' significant ' , ' **SIGNFICANT** ' `
       -replace ' never ' , ' **NEVER** ' `
       -replace ' very ' , ' **VERY** ' `
       -replace ' basics ' , ' **BASICS** ' `
       -replace ' lesson ' , ' **lesson** ' `
       -replace ' based on ' , ' **BASED ON** ' `
       -replace ' understand ' , ' *understand* ' `
       -replace ' understanding ' , ' *understanding* ' `
       -replace ' understands ' , ' *understands* ' `
       -replace ' both ' , ' **BOTH** ' `
       -replace ' techniques ' , ' *techniques* ' `
       -replace ' technique ' , ' *technique* ' `
       -replace 'however' , '*however*' `
       -replace 'Furthermore' , '*Furthermore*'
}
$text += '' 
$text += '----------------------------------------------------'
$text | Set-Clipboard
write-host -ForegroundColor Green "[+] Text broken down for EASE. FOCUS and understand EVERY sentence :D"
write-host -ForegroundColor Yellow "[!] what are the ideas?"
write-host -ForegroundColor Yellow "[!] what are the terms?"
write-host -ForegroundColor Yellow "[!] what is the purpose?"
write-host -ForegroundColor Yellow "[!] what would happen if that didn't exist?"