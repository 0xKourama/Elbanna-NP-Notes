$blessings = @(
    "Skills learned to find truth and be a more balanced person"
    "A good family: Geddo, Tattoo, K. Yasser, K. Abeer, Abdo"
    "Having a great mother"
    "All the strength and character that came from having a negligent father"
    "The struggles that made me"
    "Having a lot of people's love and respect"
    "Health (no diseases)"
    "Having functioning senses and organs"
    "The Warrior spirit"
    "Being intelligent and having some wisdom"
    "Having depth and introspection"
    "Having great friends: Gomgom, Hosam, Hisham, Chico, Mazen, Hamada, Mahmoud, Adham, Ramadan"
    "Satr rabena"
    "A Good Career and passion for it"
    "Broad Knowledge"
    "Being focused on the stuff that matter most"
    "Having good looks and appeal"
    "The ability to do many things"
    "Having options in life"
    "Having some awareness"
    "Happiness"
    "God for Helping me always & Giving me chances"
    "Every success and every failure"
    "Every good and bad thing to come. God is never unjust"
)


$blessings | ForEach-Object -Begin {
    Write-Host -ForegroundColor Yellow "[!] No matter what happens Mohammad, never forget God's blessings:`n"    
} -Process {
    Write-Host -ForegroundColor Green "[+] $_"
} -End {
    Write-Host -ForegroundColor Magenta "`n[~] And every forgotten or hidden blessing."
}