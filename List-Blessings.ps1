$blessings = @(
'Islam'
'Faith'
'A Good family (Specially mother)'
'Health'
'Intelligence and some wisdom'
'Good friends'
'Satr rabena'
'Good Career'
'Knowledge'
'Good focus (on the stuff that matter most)'
'Good looks'
'Having functioning senses and organs'
'Having ability to do many things'
'Being kind'
'Having options'
'Having some awareness'
'Happiness'
'The struggles that made me'
'Helping me always (I dont necessarily deserve it)'
'Giving me chances'
'Every success and every failure'
'Every good and bad thing to come. God is never unjust.'
)

Write-Host -ForegroundColor Yellow "[!] No matter what happens Mohammad, never forget God's blessings:`n"

foreach ($blessing in $blessings){
    Write-Host -ForegroundColor Green "[+] $blessing"
}