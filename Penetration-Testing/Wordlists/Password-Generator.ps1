# General Guidlines:
# People use methods to make things easy
## 1.  using first characters as capital to be fit password complexity guidelines
## 2.  using keyboard walks
## 3.  using special characters as separators between words or at the end
## 4.  using numbers as replacement for characters
## 5.  using memorable numbers as birthdays (the person or his kids or sometimes an important event)
## 6.  using subject-related words to match (department, technology or company name)
## 7.  using numbers at the end of the password
## 8.  using their favorite player, team, artist, band, car, food, day in their passwords
## 9.  using a boyish, girlish, curseword or whatever is on their mind as a password (as long as it's short)
## 10. using their own name or nickname in the password and mangling it using 133t$p3@k

# The arrays below are split into
## 1. base passwords (used at the start)
## 2. common endings

# they can be placed at the start, end or middle of combinations
$Special_Chars = @(
	'!'
	'#'
	'$'
	#'%'
	#'&'
	#'*'
	#'.'
	'@'
	#'^'
	'_'
    '-'
	#'~'
	#'+'
)

# the full name, abbreviation or first couple of letters
$Company_Name_Variants = @(
	#'T@M'
	#'t@mweeli'
	#'T@mweeli'
	#'T@mweely'
	#'t@mweely'
	'Tam'
	'TAM'
	#'Tamweel'
	#'tamweel'
	#'TAMWEELi'
	#'Tamweeli'
	'TAMWEELY'
	#'Tamweely'
    'Tamweelymf'
	#'tamweely'
	'TMF'
	#'Tmf'
	'tmf'
)

# common words that employees think of to make passwords easier to remember
$Work_related = @(
	#'Access'
	#'access'
	'Admin'
	#'admin'
	#'dev'
	#'Dev'
	#'Mail'
	#'mail'
	#'Manager'
	#'manager'
	#'Office'
	#'office'
	#'Sec'
	#'sec'
	#'security'
	#'Security'
	#'Tech'
	#'tech'
	#'test'
	'Test'
	#'Testing'
	#'testing'
	#'web'
	#'Web'
)

# Department-based
$Department_Related = @(
	#'Cs'
	#'cs'
	#'CS'
	#'hr'
	#'Hr'
	#'HR'
	#'inv'
	#'Inv'
	#'INV'
	#'INVENTORY'
	#'Inventory'
	#'inventory'
	#'IT'
	#'it'
	#'It'
	#'PMO'
	#'pmo'
	#'Pmo'
	#'sales'
	#'Sales'
	#'SALES'
	#'Tr'
	#'tr'
	#'TR'
	#'TRAIN'
	#'Train'
	#'train'
	#'Training'
	#'training'
	#'TRAINING'
    #'Treasury'
    #'TREASURY'
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
)

# soccer fans
$Soccer_related = @(
	#'Ahli'
	#'ahli'
	#'Ahly'
	#'ahly'
	#'arsenal'
	#'Arsenal'
	#'Barcelona'
	#'barcelona'
	#'beckham'
	#'Beckham'
	#'Chelsea'
	#'chelsea'
	#'chelsi'
	#'Chelsi'
	#'christiano'
	#'Christiano'
	#'Football'
	#'liverpool'
	#'Liverpool'
	#'madrid'
	#'Madrid'
	#'Manchester'
	#'manchester'
	#'Maradona'
	#'maradona'
	#'messi'
	#'Messi'
	#'Neymar'
	#'neymar'
	#'RealMadrid'
	#'realmadrid'
	#'Ronaldo'
	#'ronaldo'
	#'Salah'
    #'Mosalah'
	#'salah'
	#'zamalek'
	#'Zamalek'
    #'Ahlawy'
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

$Years_2010_2030 = @(
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
)

$Years_2020_2030 = @(
	'2020'
	'2021'
	'2022'
	#'2023'
	#'2024'
	#'2025'
	#'2026'
	#'2027'
	#'2028'
	#'2029'
	#'2030'
)

# letter-based keyboard walks
$Keyboard_Walks_Letters = @(
	'asd'
	'asdf'
    'asdfg'
	'qwe'
	'qwer'
	'qwerty'
)

# Common Number Endings (a short keyboard walk can be used as an ending too)
$Common_Endings_Numbers = @(
	'123'
	'456'
	'789'
)

# Common Character Endings
$Common_Endings_Letters = @(
	'ABC'
	'abc'
	'XYZ'
	'xyz'
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

$Included_Lists = @(
    $Company_Name_Variants
    $Work_related
    $Soccer_related
)

$List_Location = 'C:\Users\MGabr\Desktop\BannedPasswords2.txt'

Foreach($List in $Included_Lists){
    foreach($Item in $List){
        Write-Host -ForegroundColor Cyan "[*] Generating combinations for $Item"

        <#
        Write-Host -ForegroundColor Cyan "[*] Iterating years for $Item"
        foreach($Year in $Years_1950_2050){
            "$Item$Year" >> $List_Location
        }#>

        <#
        Write-Host -ForegroundColor Cyan "[*] Iterating years for $Item"
        foreach($Year in $Years_2010_2030){
            "$Item$Year" >> $List_Location
        }#>

        <#
        Write-Host -ForegroundColor Cyan "[*] Iterating Special Middle Char + Year for $Item"
        foreach($Char in $Special_Chars){
            foreach($Year in $Years_1950_2050){
                "$Item$Char$Year" >> $List_Location
            }
        }#>

        <#
        Write-Host -ForegroundColor Cyan "[*] Iterating Special Middle Char + Year for $Item"
        foreach($Char in $Special_Chars){
            foreach($Year in $Years_2020_2030){
                "$Item$Char$Year" >> $List_Location
            }
        }#>


        <#
        Write-Host -ForegroundColor Cyan "[*] Iterating Common Number Endings for $Item"
        foreach($C1 in $Common_Endings_Numbers){
            "$Item$C1" >> $List_Location
        }#>

        Write-Host -ForegroundColor Cyan "[*] Iterating Common Letter Endings for $Item"
        foreach($C2 in $Common_Endings_Letters){
            "$Item$C2" >> $List_Location
        }

        Write-Host -ForegroundColor Cyan "[*] Iterating Common Symbol/Walk Endings for $Item"
        foreach($C3 in $Common_Endings_Symbols){
            "$Item$C3" >> $List_Location
        }

        Write-Host -ForegroundColor Cyan "[*] Iterating Special Middle Char + Year for $Item"
        foreach($Char in $Special_Chars){
            foreach($C4 in $Common_Endings_Numbers){
                "$Item$Char$C4" >> $List_Location
            }
        }

        Write-Host -ForegroundColor Cyan "[*] Iterating Special Middle Char + Year for $Item"
        foreach($Char in $Special_Chars){
            foreach($C5 in $Common_Endings_Letters){
                "$Item$Char$C5" >> $List_Location
            }
        }
    }
}