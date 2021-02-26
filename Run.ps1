Add-Type -AssemblyName PresentationFramework | Out-Null

$Working_directory = Get-Location | Select-Object -ExpandProperty Path

$skill_ranks = @(
    'Novice',
    'Apprentice',
    'Regular',
    'Expert',
    'Advanced Expert',
    'Master',
    'Advanced Master',
    'Grand Master',
    'Completer',
    'Transcender'
)

$Quotes = @(
    "Innna Allaha yo7ibbo itha 3amila a7adokom 3amalan an yotqenoh - Qoran",
	"Hal yastawi alla-theen ya3maloon walla-theen la ya3maloon? - Qoran",
	"Inna Allaha la yodi3o agra man a7sana 3amalan. - Qoran",
	"If you want something done, you got to do it yourself - Denzel Washington",
	"Happiness is inversely proprotional with pleasure. - Unknown",
	"The closest thing to perfection is progress - Unknown",
	"Reality is the collective of all views - Unknown",
	"Reality is learned best after overcoming a variety of challenges - Unknown",
	"People in the old ages didn't have nearly as much entertainment sources as we do now. And, they were OK with that. Why can't we? - Unknown",
	"The man who moves a mountain begins by carrying away small stones. - Unknown",
	"Hard work paying off is one of the greatest feelings ever. - Unknown",
	"The secret of getting ahead is getting started. - Mark Twain",
	"I've missed more than 9,000 shots in my career. I've lost almost 300 games. 26 times I've been trusted to take the game winning shot and missed. I've failed over and over and over again in my life and that is why I succeed. - Michael Jordan",
	"It's hard to beat a person who never gives up. - Babe Ruth",
	"If people are doubting how far you can go, go so far that you can't hear them anymore. - Michele Ruiz",
	"We need to accept that we won't always make the right decisions, that we'll screw up royally sometimes - understanding that failure is not the opposite of success, it's part of success. - Arianna Huffington",
	"Fairy tales are more than true: not because they tell us that dragons exist, but because they tell us that dragons can be beaten. - Neil Gaiman",
	"When one door of happiness closes, another opens; but often we look so long at the closed door that we do not see the one which has been opened for us. - Helen Keller",
	"Do one thing every day that scares you. - Eleanor Roosevelt",
	"It's no use going back to yesterday, because I was a different person then. - Lewis Carroll",
	"Smart people learn from everything and everyone, average people from their experiences, stupid people already have all the answers. - Socrates",
	"Do what you feel in your heart to be right - for you'll be criticized anyway. - Eleanor Roosevelt",
	"Happiness is not something ready made. It comes from your own actions. - Dalai Lama XIV",
	"The same boiling water that softens the potato hardens the egg. It's what you're made of. Not the circumstances. - Unknown",
	"You can either experience the pain of discipline or the pain of regret. The choice is yours. - Unknown",
	"Impossible is just an opinion. - Paulo Coelho",
	"Your passion is waiting for your courage to catch up. - Isabelle Lafleche",
	"The world ain't all sunshine and rainbows. It's a very mean and nasty place and I don't care how tough you are it will beat you to your knees and keep you there permanently if you let it. You, me, or nobody is gonna hit as hard as life. But it ain't about how hard ya hit. It's about how hard you can get hit and keep moving forward. How much you can take and keep moving forward. That's how winning is done! - Rocky IV",
	"Now if you know what you're worth then go out and get what you're worth. But ya gotta be willing to take the hits, and not pointing fingers saying you ain't where you wanna be because of him, or her, or anybody! Cowards do that and that ain't you! You're better than that! - Rocky IV",
	"If something is important enough, even if the odds are stacked against you, you should still do it. - Elon Musk",
	"Don't be afraid to give up the good to go for the great. - John D. Rockefeller",
	"People who wonder if the glass is half empty or full miss the point. The glass is refillable. - Unknown",
	"No one is to blame for your future situation but yourself. If you want to be successful, then become Successful.- Jaymin Shah",
	"Things may come to those who wait, but only the things left by those who hustle. - Abraham Lincoln",
	"Every sucessful person in the world is a hustler one way or another. We all hustle to get where we need to be. Only a fool would sit around and wait on another man to feed him. - K'wan",
	"Invest in your dreams. Grind now. Shine later. - Unknown",
	"Hustlers don't sleep, they nap. - Unknown",
	"Without hustle, talent will only carry you so far. - Gary Vaynerchuk",
	"Work like there is someone working twenty four hours a day to take it away from you. - Mark Cuban",
	"Hustle in silence and let your success make the noise. - Unknown",
	"We are what we repeatedly do. Excellence, then, is not an act, but a habit. - Aristotle",
	"I always did something I was a little not ready to do. I think that's how you grow. When there's that moment of 'Wow, I'm not really sure I can do this,' and you push through those moments, that's when you have a breakthrough. - Marissa Mayer",
	"If you hear a voice within you say 'you cannot paint,' then by all means paint and that voice will be silenced. - Vincent Van Gogh",
	"Some people want it to happen, some wish it would happen, others make it happen. - Michael Jordan",
	"Leaders can let you fail and yet not let you be a failure. - Stanley McChrystal",
	"It's not the load that breaks you down, it's the way you carry it. - Lou Holtz",
	"The hard days are what make you stronger. - Aly Raisman",
	"If you believe it'll work out, you'll see opportunities. If you don't believe it'll work out, you'll see obstacles. - Wayne Dyer",
	"Keep your eyes on the stars, and your feet on the ground. - Theodore Roosevelt",
	"You've got to get up every morning with determination if you're going to go to bed with satisfaction. - George Lorimer",
	"Don't be pushed around by the fears in your mind. Be led by the dreams in your heart. - Roy T. Bennett",
	"It isn't the mountains ahead that wear you out, it's the pebble in your shoe. - Muhammad Ali",
	"By the sword... - Unknown",
	"Work hard in silence, let your success be the noise. - Frank Ocean",
	"Don't say you don't have enough time. You have exactly the same number of hours per day that were given to Helen Keller, Pasteur, Michelangelo, Mother Teresa, Leonardo Da Vinci, Thomas Jefferson, and Albert Einstein. - H. Jackson Brown Jr.",
	"Hard work beats talent when talent doesn't work hard. - Tim Notke",
	"If everything seems to be under control, you're not going fast enough. - Mario Andretti",
	"Opportunity is missed by most people because it is dressed in overalls and looks like work. - Thomas Edison",
	"The best way to appreciate your job is to imagine yourself without one. - Oscar Wilde",
	"Unsuccessful people make their decisions based on their current situations. Successful people make their decisions based on where they want to be. - Benjamin Hardy",
	"Never stop doing your best just because someone doesn't give you credit. - Kamari aka Lyrikal",
	"Work hard for what you want because it won't come to you without a fight. You have to be strong and courageous and know that you can do anything you put your mind to. If somebody puts you down or criticizes you, just keep on believing in yourself and turn it into something positive. - Leah LaBelle",
	"Never give up on a dream just because of the time it will take to accomplish it. The time will pass anyway. - Earl Nightingale",
	"If you work on something a little bit every day, you end up with something that is massive. - Kenneth Goldsmith",
	"The big secret in life is that there is no secret. Whatever your goal, you can get there if you're willing to work. - Oprah Winfrey",
	"At any given moment you have the power to say: this is not how the story is going to end. - Unknown",
	"Nothing will work unless you do. - Maya Angelou",
	"Don't limit your challenges. Challenge your limits. - Unknown",
	"Whenever you find yourself doubting how far you can go, just remember how far you have come. - Unknown",
	"In the middle of every difficulty lies opportunity. - Albert Einstein",
	"What defines us is how well we rise after falling. - Lionel from Maid in Manhattan Movie",
	"Turn your wounds into wisdom - Oprah",
	"Would you like me to give you a formula for success? It's quite simple, really: Double your rate of failure. You are thinking of failure as the enemy of success. But it isn't at all. You can be discouraged by failure or you can learn from it, so go ahead and make mistakes. Make all you can. Because remember that's where you will find success. - Thomas J. Watson",
	"Every champion was once a contender that didn't give up. - Gabby Douglas",
	"The difference between successful people and very successful people is that very successful people say 'no' to almost everything. - Warren Buffett",
	"You can cry, scream, and bang your head in frustration but keep pushing forward. It's worth it. - Uknown",
	"I hated every minute of training, but I said, 'Don't quit. Suffer now and live the rest of your life as a champion. - Muhammad Ali",
	"If you want to fly give up everything that weighs you down. - Buddha",
	"Doubt kills more dreams than failure ever will. - Suzy Kassem",
	"I never lose. Either I win or learn. - Nelson Mandela",
	"Today is your opportunity to build the tomorrow you want. - Ken Poirot",
	"Getting over a painful experience is much like crossing the monkey bars. You have to let go at some point in order to move forward. - C.S. Lewis",
	"Focus on being productive instead of busy. - Tim Ferriss",
	"You don't need to see the whole staircase, just take the first step. - Martin Luther King Jr.",
	"I didn't get there by wishing for it, but by working for it. - Estee Lauder",
	"Be happy with what you have while working for what you want. - Helen Keller",
	"You're so much stronger than your excuses. - Unknown",
	"Don't compare yourself to others. Be like the sun and the moon and shine when it's your time. - Unknown",
	"Don't tell everyone your plans, instead show them your results. - Uknown",
	"Nothing can dim the light that shines from within. - Maya Angelou",
	"Take criticism seriously, but not personally. If there is truth or merit in the criticism, try to learn from it. Otherwise, let it roll right off you. - Hillary Clinton",
	"Do the best you can. No one can do more than that. - John Wooden",
	"Don't let what you can't do interfere with what you can do. - Unknown",
	"All we can do is the best we can do. - David Axelrod",
	"It's okay to outgrow people who don't grow. Grow tall anyways. - Unknown",
	"Try not to become a man of success, but rather become a man of value. - Albert Einstein",
	"I attribute my success to this: I never gave or took an excuse. - Florence",
	"A surplus of effort could overcome a deficit of confidence. - Sonia Sotomayer",
	"Oh yes, the past can hurt. But the way I see it, you can either run from it or learn from it. - The Lion King",
	"Spend a little more time trying to make something of yourself and a little less time trying to impress people. - The Breakfast Club",
	"The problem is not the problem. The problem is your attitude about the problem. - Pirates of the Caribbean",
	"Nothing is stronger than a broken man rebuilding himself. - Unknown",
	"A man is not finished when he is defeated. He is finished when he quits. - Richard Nixon",
	"The best way to predict your future is to create it. - Abraham Lincoln",
	"Don't watch the clock; do what it does. Keep going. - Sam Levenson",
	"Falling down is how we grow. Staying down is how we die. - Brian Vaszily",
	"Practice makes progress not perfect. - Unknown",
	"Failure is the tuition you pay for success. - Walter Brunell",
	"If there is no wind, row. - Latin Proverb",
	"Don't be upset when people reject you. Nice things are rejected all the time by people who can't afford them. - Unknown",
	"The secret of change is to focus all your energy, not on fighting the old, but on building the new. - Socrates",
	"Success is no accident. It is hard work, perseverance, learning, studying, sacrifice and most of all, love of what you are doing or learning to do  - Pele",
	"The greatest gift you could give someone is your time. Because when you give your time, you are giving a portion of your life you can't get back. - Unknown",
	"You can't let your failures define you. You have to let your failures teach you. - Barack Obama",
	"Success is a lousy teacher. It seduces smart people into thinking they can't lose. - Bill Gates",
	"Defeat is a state of mind; no one is ever defeated until defeat is accepted as a reality. - Bruce Lee",
	"Everything is hard before it is easy. - Goethe",
	"Life has many ways of testing a person's will, either by having nothing happen at all or by having everything happen all at once. - Paulo Coelho",
	"Do something today that your future self will thank you for. - Unknown",
	"The secret of your future is hidden in your daily routine. - Mike Murdock",
	"Don't stop when you are tired. Stop when you are done. - Unknown",
	"Motivation may be what starts you off, but it's habit that keeps you going back for more. - Miya Yamanouchi",
	"You will never always be motivated, so you must learn to be disciplined. - Unknown",
	"Without consistency, you will never finish! - Denzel Washington",
	"Every failed experiment is one step closer to success - Denzel Washington",
	"If you don't fail, you're not even trying. - Denzel Washington",
	"To get something you never had, you have to do something you never did. - Denzel Washington",
	"I would see jordan play. I would see magic play. And, I would wonder... Can I ever get to that level? ... Let's find out - Kobe Bryant",
	"You shot 5 airballs on a row. Nobody cares that much about you ... the world isn't about you man ... so get over yourself! - Kobe Bryant",
	"I never hung out on vacations. Because I didn't want to retire and say I could have done more - Kobe Bryant",
	"The dream is to be that strong and wise old guy. Netero, Zeno, Silver Fang, Genryuusai - Unknown",
	"Are the people around you that obsessed about what they do? Do they have that culture of obsessiveness? - Kobe Bryant",
	"The warrior is always alert. He is always awake. He is never sleeping through life. He knows how to focus his mind and his body. He is what the samurai called mindful. He is a hunter in the Native American tradition - Robert Moore & Gilette",
	"Never give up without even trying. Do what you can, no matter how small the effect it may have! - Onoki",
	"When people are protecting something truly precious to them. They truly can become…as strong as they need to be! - Haku",
	"Rejection is a part of any man's life. If you can't accept and move past rejection, or at least use it as writing material - you're not a real man. - Jiraiya",
	"All you do need, is the guts to never give up. - Jiraiya",
	"It's human nature not to realize the true value of something, unless they lose it. - Orochimaru",
	"Those who don't follow the rules are trash. But, those who abandon their friends are even worse than trash. - Obito Uchiha",
	"Difference between man and woman is that a man's brain would shift to finding a solution when a woman would stay stuck in experiencing their emotions - Unknown",
	"Arrogance destroys the footholds of victory. - Byakuya Kuchiki",
	"Do not live bowing down. You must die standing up. - Genryusai Yamamoto",
	"A true warrior would never beg someone for his life. - Izuru Kira",
	"In the hands of an incompetent, power brings nothing but ruin. - Mureum",
	"You should enjoy the little detours to the fullest. Because that's where you'll find things more important than what you want. - Ging Freecss",
	"It's easier to crush a dream than it is to realize One. — Gin Ichimaru",
	"You can't blame a lion for hunting. It's just what it does - Unknown"
)

$Work_duration_minutes   = 30
$Buffer_duration_minutes = 5

While($true){

    <#
    Start-Job -ScriptBlock {
        Set-Location $args[0]
        git pull
    } -ArgumentList $Working_directory | Wait-Job | Out-Null
    #>

    #get today and yesteday's dates
    $Today     = Get-Date
    $Yesterday = $Today.AddDays(-1)
    $Charge    = Get-Content Charge.txt
    
    $Last_record = Import-Csv Tracker.csv

    #yesterday's record is there
    #reset chain
    #add streak
    if  ($Yesterday.Day   -eq [int]$Last_record.Day   `
    -and $Yesterday.Month -eq [int]$Last_record.Month `
    -and $Yesterday.Year  -eq [int]$Last_record.Year){
        $Object = [PSCustomObject]@{
            Day    = $Today.Day
            Month  = $Today.Month
            Year   = $Today.Year
            Record = $Last_record.Record
            Chain  = 0
            Streak = ([int]$Last_record.Streak + 1)
        }
    }#today's record is there
    #initiate object
    elseif($Today.Day   -eq [int]$Last_record.Day   `
    -and   $Today.Month -eq [int]$Last_record.Month `
    -and   $Today.Year  -eq [int]$Last_record.Year){
        $Object = [PSCustomObject]@{
            Day    = $Today.Day
            Month  = $Today.Month
            Year   = $Today.Year
            Record = $Last_record.Record
            Chain  = $Last_record.Chain
            Streak = $Last_record.Streak
        }        
    }
    #neither yesterday's record nor today's record is there
    #reset chain
    #reset streak
    else{
        $Object = [PSCustomObject]@{
            Day    = $Today.Day
            Month  = $Today.Month
            Year   = $Today.Year
            Record = $Last_record.Record
            Chain  = 0
            Streak = 0
        }
    }

    $Object | Export-Csv Tracker.csv -NoTypeInformation

    $hours = [int]$Object.Record / 2

    $Random_quote = $Quotes[(Get-Random -Maximum ($Quotes.Count))]

    $skill_rank = $skill_ranks[([math]::Floor($hours / 1000))]

    if    ($hours -lt 3333){$skill_color = 'Gray'  }
    elseif($hours -lt 6666){$skill_color = 'Yellow'}
    elseif($hours -lt 9999){$skill_color = 'Green' }
    else                   {$skill_color = 'Cyan'  }

    $Remaining_Minutes = $Work_duration_minutes - 1
    1..$Work_duration_minutes | ForEach-Object {
        #Clear-Host

        if ($Remaining_Minutes -eq $Buffer_duration_minutes){
            Start-Job -ScriptBlock {
                $Buffer_duration_minutes = $args[0]
                Add-Type -AssemblyName PresentationFramework
                [System.Windows.MessageBox]::Show("$Buffer_duration_minutes minutes left.") | Out-Null
            } -ArgumentList $Buffer_duration_minutes | Out-Null
        }

        $upper = '\\' * $_
        $lower = '//' * $_
        $border = '+' + ('-' * $Work_duration_minutes * 2) + '+'

        if    ($_ -le 10){$Progress_color = 'Red'   }
        elseif($_ -le 20){$Progress_color = 'Yellow'}
        else             {$Progress_color = 'Green' }

        $Remaining_Seconds = 59

        0..$Remaining_Seconds | ForEach-Object {
            Clear-Host

            if($Remaining_Seconds -lt 10){$seconds_display = "0$Remaining_Seconds"}
            else                         {$seconds_display = $Remaining_Seconds   }

            Write-Host $Random_quote -ForegroundColor Cyan
            Write-Host
            Write-Host $border
            Write-Host ' \' -NoNewline; Write-Host $upper.PadRight($upper.Length + (($border.Length - 2) - $upper.Length)) -ForegroundColor $Progress_color -NoNewline; Write-Host '\'
            Write-Host ' /' -NoNewline; Write-Host $lower.PadRight($lower.Length + (($border.Length - 2) - $lower.Length)) -ForegroundColor $Progress_color -NoNewline; Write-Host '/'
            Write-Host $border
            Write-Host
            Write-Host "Exp : " -NoNewline; Write-host "$hours"      -ForegroundColor $skill_color
            Write-Host "Rnk : " -NoNewline; Write-Host "$skill_rank" -ForegroundColor $skill_color
            Write-Host "Chn : $($Object.Chain)"
            Write-Host "Strk: $($Object.Streak)"
            Write-Host "Chrg: $Charge"
            Write-Host "Prog: $(100 - (($Remaining_Minutes / $Work_duration_minutes) * 100 -as [int]))%"
            Write-Host "Time: $Remaining_Minutes`:$seconds_display"

            Start-Sleep -Seconds 1
            $Remaining_Seconds--
        }

        $Remaining_Minutes--
    }

    [int]$Object.Record = [int]$Object.Record + 1
    [int]$Object.Chain  = [int]$Object.Chain  + 1

    $Object | Export-Csv Tracker.csv -NoTypeInformation
    <#
    Start-Job -ScriptBlock {
        Set-Location $args[0]
        git add Charge.txt
        git add Tracker.csv
        git commit -m 'one step closer'
        git push
    } -ArgumentList $Working_directory | Wait-Job | Out-Null
    #>

    [System.Windows.MessageBox]::Show('Finished. Press OK to start next session.') | Out-Null
    
    Pause
    Get-Job | Remove-Job
}