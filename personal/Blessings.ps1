$blessings = @(
    "Islam as a religion"
    "Faith and Creed"
    "A good family: Geddo, Tattoo, K. Yasser, K. Abeer, Abdo"
    "Having inshallah a good wife Alyaa"
    "Having a great mother"
    "All the strength and character that came from having a bad father"
    "Having a lot of people's love"
    "Having a lot of people's respect"
    "Health (no diseases)"
    "The Warrior spirit"
    "Being intelligent and having some wisdom"
    "Being a deep person"
    "Having great friends: Gomgom, Hosam, Hisham, Chico, Mazen, Hamada, Mahmoud, Adham, Ramadan"
    "Satr rabena"
    "A Good Career and passion for it"
    "Broad Knowledge"
    "Being focused on the stuff that matter most"
    "Having good looks and appeal"
    "Having functioning senses and organs"
    "The ability to do many things"
    "Being a kind, warm and delicate person"
    "Having options in life"
    "Having some awareness"
    "Happiness"
    "The struggles that made me"
    "Helping me always (without deserving it)"
    "Giving me chances"
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