# To-do
# 1. customize output to match password length and complexity requirements
# 2. look at the generated wordlist and analyze it
# 3. analyse more wordlists and password dumps (categorize them)
# 4. add l33tsp3@k support

# General Guidlines:
# People use methods to make things easy
## 1.  using first characters as capital to be fit password complexity guidelines
## 2.  using keyboard walks
## 3.  using special characters as separators between words or at the end
## 4.  using numbers as replacement for characters
## 5.  using memorable numbers as birthdays (the person or his kids or sometimes an important event) (birthday backwards)
## 6.  using subject-related words to match (department, technology or company name)
## 7.  using numbers at the end of the password
## 8.  using their favorite player, team, artist, band, car, food, day in their passwords
## 9.  using a boyish, girlish, curseword or whatever is on their mind as a password (as long as it's short) (we can enumerate the namespace of their interests)
## 10. using their own name or nickname in the password and mangling it using 133t$p3@k
## 11. using their pet's name

# The arrays below are split into
## 1. base passwords (used at the start)
## 2. common endings

# the full name, abbreviation or first couple of letters
$Company_Name_Variants = @()

# common words that employees think of to make passwords easier to remember
$Work_related = @(
	'Access'
	'access'
	'Admin'
	'admin'
	'dev'
	'Dev'
	'Mail'
	'mail'
	'Manager'
	'manager'
	'Office'
	'office'
	'Sec'
	'sec'
	'security'
	'Security'
	'Tech'
	'tech'
	'test'
	'Test'
	'Testing'
	'testing'
	'web'
	'Web'
)

# Department-based
$Department_Related = @(
	'Cs'
	'cs'
	'CS'
	'hr'
	'Hr'
	'HR'
	'inv'
	'Inv'
	'INV'
	'INVENTORY'
	'Inventory'
	'inventory'
	'IT'
	'it'
	'It'
	'PMO'
	'pmo'
	'Pmo'
	'sales'
	'Sales'
	'SALES'
	'Tr'
	'tr'
	'TR'
	'TRAIN'
	'Train'
	'train'
	'Training'
	'training'
	'TRAINING'
    'Treasury'
    'TREASURY'
    'Business'
    'business'
)

# Technology-named
$Tech_Related = @(
	'App'
	'app'
	'DB'
	'db'
	'Forti'
	'forti'
	'FORTI'
	'hotmail'
	'Hotmail'
	'KAS'
	'kasper'
	'Kasper'
	'LINUX'
	'Linux'
	'linux'
	'Microsoft'
	'MICROSOFT'
	'microsoft'
	'Oracle'
	'oracle'
	'PaloAlto'
	'paloalto'
	'Redhat'
	'redhat'
	'Sophos'
	'SOPHOS'
	'sophos'
	'Windows'
	'windows'
)

# typical bad ones
$Known_Bad_Passwords = @(
	'password'
	'P@ssw0rd'
	'P@$$w0rd'
	'P@ssword'
	'mypassword'
	'MyP@ssw0rd'
	'myP@ssw0rd'
	'Sunshine'
	'sunshine'
	'Money'
	'money'
)

# sentences used in social norms
$Social_Sentences = @(
    <#
	'Welcome'
	'welcome'
	'Hello'
	'hello'
	'Letmein'
	'letmein'
	'Iloveyou'
	'iloveyou'
	'ILoveYou'
	'Thankyou'
	'ThankYou'
	'thankyou'
    'ByeBye'
    'byebye'
    'Goodbye'
    'Goodbye'
    #>
    'GoodMorning'
    'goodmorning'
    'GoodAfternoon'
    'goodafternoon'
    'GoodEvening'
    'GoodEvening'
    'goodevening'
    'GoodNight'
    'goodnight'
)

# teenage boy passwords
$Boyish_words = @(
	'Ninja'
	'ninja'
	'Killer'
	'killer'
	'Master'
	'master'
	'Dragon'
	'dragon'
	'Shadow'
	'shadow'
	'Assassin'
	'assassin'
	'Demon'
	'demon'
	'batman'
	'Batman'
	'B@tman'
	'superman'
	'Superman'
	'Spiderman'
	'spiderman'
	'Badboy'
	'badboy'
	'Lion'
	'lion'
	'Ranger'
	'ranger'
	'Spider'
	'spider'
	'Hunter'
	'hunter'
	'Tiger'
	'tiger'
	'Wolf'
	'wolf'
	'Rocky'
	'rocky'
	'Rock'
	'rock'
	'Legend'
	'legend'
	'Star'
	'star'
	'Wizard'
	'wizard'
	'King'
	'king'
	'Thunder'
	'thunder'
	'Magic'
	'magic'
	'Monster'
	'monster'
	'Eagle'
	'eagle'
	'Fire'
	'fire'
	'Knight'
	'knight'
	'Slayer'
	'slayer'
	'Hacker'
	'hacker'
	'Bulldog'
	'bulldog'
	'Cool'
	'cool'
	'Danger'
	'danger'
	'Dark'
	'dark'
	'Diesel'
	'diesel'
	'Dog'
	'dog'
	'falcon'
	'Falcon'
	'figter'
	'Fighter'
	'flash'
	'Flash'
	'Sniper'
	'sniper'
	'Vampire'
	'vampire'
	'viking'
	'Viking'
	'Wolverine'
	'wolverine'
)

# cute girly passwords
$Girly_words = @(
	'angel'
	'Angel'
	'Baby'
	'baby'
	'Barbie'
	'barbie'
	'Beautiful'
	'beautiful'
	'beauty'
	'Beauty'
	'betterfly'
	'Bubble'
	'Bubble'
	'Bubbles'
	'bubbles'
	'Butteryfly'
	'Cat'
	'cat'
	'Crystal'
	'crystal'
	'Cute'
	'cute'
	'Cutie'
	'cutie'
	'Diamond'
	'diamond'
	'Flower'
	'flower'
	'fluffy'
	'Fluffy'
	'forever'
	'Forever'
	'Gold'
	'gold'
	'Happy'
	'happy'
	'Honey'
	'honey'
	'Jasmine'
	'jasmine'
	'Kitty'
	'kitty'
	'Perfect'
	'perfect'
	'Princess'
	'princess'
	'pumpkin'
	'Pumpkin'
	'Rainbow'
	'rainbow'
	'silver'
	'Silver'
	'special'
	'Special'
	'sunflower'
	'Sunflower'
	'sweet'
	'Sweet'
	'sweetie'
	'Sweetie'
	'Teddy'
	'teddy'
)

# favorite bands, artists etc.
$Music_related = @(
	'50Cent'
	'50cent'
	'cairokee'
	'Cairokee'
	'dogg'
	'Dogg'
	'Drake'
	'drake'
	'eminem'
	'Eminem'
	'Metallica'
	'metallica'
	'snoop'
	'Snoop'
	'snoopdogg'
	'Snoopdogg'
    'Taylor'
    'taylor'
    'Ariana'
    'ariana'
    'Bieber'
    'bieber'
    'Selena'
    'Selena'
    'Gaga'
    'gaga'
    'Adele'
    'adele'
    'Rihanna'
    'rihanna'
    'Weeknd'
    'weeknd'
    'Bruno'
    'bruno'
    'Rock'
    'rock'
    'Pop'
    'pop'
)

# movies/series related
$Movie_related = @(
    'matrix'
    'avengers'
    'johnwick'
    'psycho'
    'residentevil'
    'braveheart'
    'gladiator'
    'titanic'
)

# sports cars and the like
$Car_related = @(
	'BMW'
	'bmw'
	'camaro'
	'ferari'
	'hammer'
	'Harly'
	'harly'
	'lambo'
	'mercedes'
	'Mercedes'
    'toyota'
    'Toyota'
)

# soccer fans
$Soccer_related = @(
	'Ahli'
	'ahli'
	'Ahly'
	'ahly'
	'arsenal'
	'Arsenal'
	'Barcelona'
	'barcelona'
	'beckham'
	'Beckham'
	'Chelsea'
	'chelsea'
	'chelsi'
	'Chelsi'
	'christiano'
	'Christiano'
	'Football'
	'liverpool'
	'Liverpool'
	'madrid'
	'Madrid'
	'Manchester'
	'manchester'
	'Maradona'
	'maradona'
	'messi'
	'Messi'
	'Neymar'
	'neymar'
	'RealMadrid'
	'realmadrid'
	'Ronaldo'
	'ronaldo'
	'Salah'
    'Mosalah'
	'salah'
	'zamalek'
	'Zamalek'
    'Ahlawy'
)

# curse words
$Inappropriate_words = @(
	'Bitch'
	'bitch'
	'fuck'
	'Fuck'
	'fuckyou'
	'Fuckyou'
	'Sex'
	'sex'
	'Sexy'
	'sexy'
	'Shit'
	'shit'
)

# popular cities
$Cities = @(
	'Alex'
	'alex'
	'Cairo'
	'cairo'
)

# days of the week specially Friday! :D
$Days = @(
	'FRI'
	'fri'
	'Fri'
	'Friday'
	'friday'
	'Mon'
	'mon'
	'MON'
	'Monday'
	'monday'
	'SAT'
	'saturday'
	'Saturday'
	'sun'
	'Sun'
	'SUN'
	'Sunday'
	'sunday'
	'THU'
	'Thu'
	'thu'
	'Thursday'
	'thursday'
	'TUE'
	'tue'
	'Tue'
	'Tuesday'
	'tuesday'
	'Wed'
	'WED'
	'wed'
	'wednesday'
	'Wednesday'
)

# Months
$Months = @(
	'april'
	'April'
	'August'
	'august'
	'december'
	'December'
	'February'
	'february'
	'january'
	'January'
	'July'
	'july'
	'june'
	'June'
	'march'
	'March'
	'May'
	'may'
	'november'
	'November'
	'October'
	'october'
	'September'
	'september'
)

# seasons are popular because of frequent password changes
$Seasons = @(
	'Autumn'
	'autumn'
	'Spring'
	'spring'
	'summer'
	'Summer'
	'winter'
	'Winter'
)

# common popular foods
$Foods = @(
	'Candy'
	'Chocolate'
	'Coffee'
	'ICE'
	'Ice'
	'Pizza'
	'Sugar'
	'Tea'
	'TEA'
    'Icecream'
    'Cookies'
    'Cake'
)

# common arabic first names (statistics)
$Common_Male_Names_Arabic = @(
	'Abdo'
	'abdo'
	'ahmad'
	'Ahmad'
	'ahmed'
	'Ahmed'
	'Mahmoud'
	'mahmoud'
	'mohamed'
	'Mohamed'
)

$All_Male_First_Names = @(
    'Abdallah'
	'AbdAlRahman'
	'AbdelAziz'
	'Adam'
	'Adel'
	'Adham'
	'Ahmad'
	'Ahmed'
	'Akram'
	'Alaa'
	'Ali'
	'Aly'
	'Amgad'
	'Ammar'
	'Amr'
	'Anas'
	'Andrew'
	'Ashraf'
	'Atef'
	'Atif'
	'Ayman'
	'Bahaa'
	'Baher'
	'Basem'
	'Bassem'
	'Bialy'
	'Bilal'
	'Belal'
	'Botros'
	'Boules'
	'Diaa'
	'Diab'
	'Ebrahem'
	'Ebrahim'
	'Ehab'
	'Emad'
	'Eslam'
	'Essam'
	'Ezz'
	'Ezzat'
	'Fareed'
	'Fares'
	'Farid'
	'Galal'
	'Gamal'
	'Gehad'
	'Haitham'
	'Hani'
	'Hany'
	'Hashem'
	'Hashim'
	'Hassan'
	'Hatem'
	'Haytham'
	'Hazem'
	'Hesham'
	'Hisham'
	'Hosam'
	'Hossam'
	'Hussein'
	'Ibrahim'
	'Ihab'
	'islam'
	'Ismail'
	'Kamal'
	'Kamel'
	'Kareem'
	'Karem'
	'Karim'
	'Khaled'
	'Loay'
	'Maged'
	'Maher'
	'mahmoud'
	'Malek'
	'Mamdouh'
	'Marwan'
	'Moaaz'
	'Moatassem'
	'Moaz'
	'Moemen'
	'mohab'
	'Mohamed'
	'Mohammad'
	'Mohannad'
	'Mohsen'
	'Moneim'
	'Mosa'
	'Mosalam'
	'Mostafa'
	'Mounir'
	'Mourad'
	'Moustafa'
	'Mubarak'
	'Muhamed'
	'Muhammad'
	'Muhammed'
	'Muharram'
	'Mustafa'
	'Nabih'
	'Nabil'
	'Nadeem'
	'Nader'
	'Nadir'
	'Nageeb'
	'Nagm'
	'Naguib'
	'Naif'
	'Naser'
	'Nashaat'
	'Nasim'
	'Nasir'
	'Nasr'
	'Nasrallah'
	'Nasser'
	'Nassif'
	'Nazif'
	'Nazim'
	'Nazmi'
	'Nazmy'
	'Negm'
	'Nooh'
	'Noor'
	'Nour'
	'Nourhan'
	'Nyazi'
	'Omar'
	'osama'
	'osman'
	'ossama'
	'Othman'
	'Qotb'
	'Raafat'
	'Rabea'
	'raddad'
	'Radwan'
	'Raed'
	'Ragab'
	'Rahim'
	'Rahman'
	'Ramadan'
	'Ramez'
	'Ramiz'
	'Ramy'
	'Ramzy'
	'Raouf'
	'Rashad'
	'Rashed'
	'Rashid'
	'Rashidi'
	'Rashidy'
	'Rashwan'
	'Rayan'
	'Rifaat'
	'Rushdi'
	'Rushdy'
	'saad'
	'Saadallah'
	'Saber'
	'Sabri'
	'Sabry'
	'Sadek'
	'Sadik'
	'SadralDin'
	'Saed'
	'Saeed'
	'Safaan'
	'Safiullah'
	'Safwan'
	'Safwat'
	'Saher'
	'Sahir'
	'Said'
	'Saied'
	'Saif'
	'Salah'
	'Saleh'
	'Salem'
	'Salim'
	'Sameh'
	'Samer'
	'Sami'
	'Samir'
	'Samy'
	'Sayed'
	'seada'
	'Selim'
	'Seoud'
	'Shaaban'
	'Shaban'
	'Shadi'
	'Shady'
	'Shahin'
	'Shaker'
	'Shams'
	'Sharaf'
	'Sharara'
	'Sharf'
	'Shawkat'
	'Shawki'
	'Shawky'
	'Shazly'
	'Shehab'
	'Sherif'
	'Shokry'
	'souhaib'
	'Suhail'
	'Suleiman'
	'Suliman'
	'Sultan'
	'Taghreed'
	'Taghreid'
	'Taghrid'
	'Taha'
	'Taher'
	'Takla'
	'Talaat'
	'Tamer'
	'Tarek'
	'Tariq'
	'Tawfik'
	'Tharwat'
	'Tijani'
	'Torky'
	'Wael'
	'Wafi'
	'Wafy'
	'Wagdy'
	'Wahba'
	'wahby'
	'Waheed'
	'Wahid'
	'Waked'
	'Waleed'
	'Wasim'
	'Wesam'
	'Yahia'
	'Yahya'
	'Yaseen'
	'Yasin'
	'yasser'
	'Yehia'
	'Yosssef'
	'Younes'
	'Yousef'
	'Yousry'
	'Youssef'
	'Yunus'
	'Yusuf'
	'Zaid'
	'Zaim'
	'ZainalAbidin'
	'Zakareya'
	'Zakaria'
	'Zakariya'
	'Zaki'
	'Zaky'
	'zayn'
	'Zein'
	'Zeyad'
)

$All_Female_First_names = @(
    'Abeer'
	'Amina'
	'Amira'
	'asmaa'
	'aya'
	'basma'
	'boshra'
	'bushra'
	'Dalal'
	'Dalia'
	'Dema'
	'Dina'
	'Doaa'
	'doha'
	'Ehsan'
	'Elham'
	'Enas'
	'Esraa'
	'Fadia'
	'Fatema'
	'Faten'
	'Fatima'
	'Fatin'
	'Fatma'
	'Gehan'
	'ghada'
	'Hadeer'
	'Hagar'
	'haidy'
	'hala'
	'hana'
	'hanan'
	'haneen'
	'hania'
	'hasnaa'
	'Hayam'
	'Heba'
	'Hemmat'
	'hend'
	'Hikmat'
	'hoda'
	'Ilham'
	'Israa'
	'kenzy'
	'Kholoud'
	'KHOLOUD'
	'Laila'
	'Lamiaa'
	'Lamya'
	'Lamyaa'
	'Layaly'
	'Maha'
	'Mahinor'
	'Mahitab'
	'mai'
	'malak'
	'Manar'
	'Mariam'
	'Marwa'
	'may'
	'Menna'
	'MennaAllah'
	'Mennatullah'
	'mona'
	'Monica'
	'Moshera'
	'nada'
	'Nagham'
	'Nagla'
	'Nagwa'
	'Nancy'
	'Nariman'
	'Neama'
	'Nelly'
	'nermeen'
	'Nesma'
	'nesreen'
	'Nessma'
	'Neveen'
	'Nevine'
	'Nihad'
	'noor'
	'nora'
	'Noran'
	'Nour'
	'Nourhan'
	'Radwa'
	'Rana'
	'Rasha'
	'Reham'
	'Riham'
	'roqaya'
	'sabreen'
	'Safi'
	'Safy'
	'salma'
	'salwa'
	'sama'
	'Samar'
	'Samirah'
	'sara'
	'sarah'
	'shaden'
	'shahd'
	'shahenaz'
	'shahenda'
	'shaimaa'
	'Shams'
	'shereen'
	'Shery'
	'shorouk'
	'shorouq'
	'Sohaila'
	'solwan'
	'tasneem'
	'yasmeen'
	'yasmin'
	'yasmine'
	'Zahra'
	'Zainab'
	'Zeinab'
	'Zinab'
)

# number-based keyboard walks
$Keyboard_Walks_Numbers = @(
	'11111111'
	'11112222'
	'123123123'
	'12345678'
	'123456789'
	'1234567890'
	'147258369'
	'22222222'
	'22223333'
	'33333333'
	'33334444'
	'44444444'
	'44445555'
	'456456456'
	'55555555'
	'55556666'
	'66666666'
	'66667777'
	'741852963'
	'77777777'
	'77778888'
	'789456123'
	'789789789'
	'88888888'
	'88889999'
	'987654321'
	'99999999'
)


####################################################################ENDINGS####################################################################

# they can be placed at the start, end or middle of combinations
$Special_Chars = @(
	'!'
	'#'
	'$'
	'%'
	'&'
	'*'
	'.'
	'@'
	'^'
	'_'
    '-'
	'~'
	'+'
)

# contain most birthdays of the generation + futuristic passwords
$Years_1950_2050 = @(
	'1950'
	'1951'
	'1952'
	'1953'
	'1954'
	'1955'
	'1956'
	'1957'
	'1958'
	'1959'
	'1960'
	'1961'
	'1962'
	'1963'
	'1964'
	'1965'
	'1966'
	'1967'
	'1968'
	'1969'
	'1970'
	'1971'
	'1972'
	'1973'
	'1974'
	'1975'
	'1976'
	'1977'
	'1978'
	'1979'
	'1980'
	'1981'
	'1982'
	'1983'
	'1984'
	'1985'
	'1986'
	'1987'
	'1988'
	'1989'
	'1990'
	'1991'
	'1992'
	'1993'
	'1994'
	'1995'
	'1996'
	'1997'
	'1998'
	'1999'
	'2000'
	'2001'
	'2002'
	'2003'
	'2004'
	'2005'
	'2006'
	'2007'
	'2008'
	'2009'
	'2010'
	'2011'
	'2012'
	'2013'
	'2014'
	'2015'
	'2016'
	'2017'
	'2018'
	'2019'
	'2020'
	'2021'
	'2022'
	'2023'
	'2024'
	'2025'
	'2026'
	'2027'
	'2028'
	'2029'
	'2030'
	'2031'
	'2032'
	'2033'
	'2034'
	'2035'
	'2036'
	'2037'
	'2038'
	'2039'
	'2040'
	'2041'
	'2042'
	'2043'
	'2044'
	'2045'
	'2046'
	'2047'
	'2048'
	'2049'
	'2050'
)

# letter-based keyboard walks
$Common_Walks_Endings_Letters = @(
	'asd'
	'asdf'
    'asdfg'
	'qwe'
	'qwer'
	'qwerty'
	'ABC'
	'abc'
	'XYZ'
	'xyz'
)

# Common Number Endings (a short keyboard walk can be used as an ending too)
$Common_Walks_Endings_Numbers = @(
	'123'
	'456'
	'789'
)

# common ending symbols (unlikely to be used when using a special middle char)
$Common_Endings_Symbols = @(
	'!'
	'!!'
	'!!!'
	'!@#'
	'!@#$'
	'!@#$%'
	'#'
	'##'
	'###'
	'$'
	'$$'
	'$$$'
	'%'
	'%%'
	'%%%'
	'@'
	'@@'
	'@@@'
)

####################################################################GENERATION####################################################################

$Included_Lists = @(
    $Company_Name_Variants
    $Work_related
    $Department_Related
    $Tech_Related
    $Known_Bad_Passwords
    $Social_Sentences    
    $Boyish_words
    $Girly_words
    $Music_related
    $Car_related
    $Soccer_related
    $Inappropriate_words
    $Cities
    $Days
    $Months
    $Seasons
    $Foods
    $Common_Male_Names_Arabic
    $All_Male_First_Names
    $All_Female_First_names
    $Keyboard_Walks_Numbers
)

$List_Location = '~\Desktop\BigOne.txt'
$Counter = 0
$ItemCount = $Included_Lists.Count

Foreach($List in $Included_Lists){
    $Counter++
    foreach($Item in $List){
        Write-Host -ForegroundColor Cyan "[*] [$Counter/$ItemCount] Generating combinations for $Item"

        # item + year
        foreach($C1 in $Years_1950_2050)                 {"$Item$C1" >> $List_Location}

        # item + common ending letter
        foreach($C2 in $Common_Walks_Endings_Letters)    {"$Item$C2" >> $List_Location}

        # item + common ending number
        foreach($C3 in $Common_Walks_Endings_Numbers)    {"$Item$C3" >> $List_Location}

        # item + common ending symbol
        foreach($C4 in $Common_Endings_Symbols)          {"$Item$C4" >> $List_Location}

        foreach($Char in $Special_Chars){
            # item + special char + year
            foreach($C5 in $Years_1950_2050)             {"$Item$Char$C5" >> $List_Location}

            # item + special char + common ending letter
            foreach($C6 in $Common_Walks_Endings_Letters){"$Item$Char$C6" >> $List_Location}

            # item + special char + common ending number
            foreach($C7 in $Common_Walks_Endings_Numbers){"$Item$Char$C7" >> $List_Location}
        }
    }
}
