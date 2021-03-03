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

Get-Content -Raw Quotes.txt | Invoke-Expression

$Work_duration_minutes   = 30
$Buffer_duration_minutes = 5

While($true){

    Start-Job -ScriptBlock {
        Set-Location $args[0]
        git pull
    } -ArgumentList $Working_directory | Wait-Job | Out-Null

    #get today and yesteday's dates
    $Today     = Get-Date
    $Yesterday = $Today.AddDays(-1)
    $Charge    = Get-Content Charge.txt
    $MaxChain  = Get-Content MaxChain.txt
    $Last_record = Import-Csv Tracker.csv

    #yesterday's record is there
    #reset chain
    #add streak
    #add to trail
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
        $Last_record | Export-Csv -Append -NoTypeInformation Trail.csv
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

    $Remaining_Minutes = $Work_duration_minutes
    0..($Work_duration_minutes - 1) | ForEach-Object {

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

        Clear-Host
        Write-Host $Random_quote -ForegroundColor Cyan
        Write-Host
        Write-Host $border
        Write-Host ' \' -NoNewline; Write-Host $upper.PadRight($upper.Length + (($border.Length - 2) - $upper.Length)) -ForegroundColor $Progress_color -NoNewline; Write-Host '\'
        Write-Host ' /' -NoNewline; Write-Host $lower.PadRight($lower.Length + (($border.Length - 2) - $lower.Length)) -ForegroundColor $Progress_color -NoNewline; Write-Host '/'
        Write-Host $border
        Write-Host
        Write-Host "Exp : " -NoNewline; Write-host "$hours"      -ForegroundColor $skill_color
        Write-Host "Rnk : " -NoNewline; Write-Host "$skill_rank" -ForegroundColor $skill_color
        Write-Host "Chn : $($Object.Chain) >> $([int]$Object.Chain + 1)"
        Write-Host "Strk: $($Object.Streak)"
        Write-Host "Chrg: $Charge"
        Write-Host "Prog: $(100 - (($Remaining_Minutes / $Work_duration_minutes) * 100 -as [int]))%"
        Write-Host "Mins: $Remaining_Minutes"

        Start-Sleep -Seconds 60
        $Remaining_Minutes--
    }

    [int]$Object.Record = [int]$Object.Record + 1
    [int]$Object.Chain  = [int]$Object.Chain  + 1

    #display the finish screen
    $upper = '\\' * 30
    $lower = '//' * 30
    Clear-Host
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
    Write-Host "Mins: $Remaining_Minutes"

    #if max chain is exceeded, celebrate!
    if([int]$object.Chain -gt $MaxChain){
        Write-Host "[+] Chain record passed!! $($Object.Chain)!!" -ForegroundColor Green
        [int]$Object.Chain > MaxChain.txt
    }
    
    $Object | Export-Csv Tracker.csv -NoTypeInformation


    #commit charge, tracker, trail and max chain and push
    Start-Job -ScriptBlock {
        Set-Location $args[0]
        git add Charge.txt
        git add Tracker.csv
        git add MaxChain.txt
        git add Trail.csv
        git commit -m 'one step closer'
        git push
    } -ArgumentList $Working_directory | Wait-Job | Out-Null

    [System.Windows.MessageBox]::Show('Finished. Press OK to start next session.') | Out-Null
    
    Write-Host
    Pause
    Get-Job | Remove-Job
}