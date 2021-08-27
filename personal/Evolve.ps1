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

    #region manage records
    #get today and yesteday's dates
    $Today     = Get-Date
    $Yesterday = $Today.AddDays(-1)
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
    #endregion

    $Object | Export-Csv Tracker.csv -NoTypeInformation

    $hours = [int]$Object.Record / 2

    $Random_quote = $Quotes[(Get-Random -Maximum ($Quotes.Count))]

    $skill_rank = $skill_ranks[([math]::Floor($hours / 1000))]

    $Remaining_Minutes = $Work_duration_minutes
    0..($Work_duration_minutes - 1) | ForEach-Object {

        if ($Remaining_Minutes -eq $Buffer_duration_minutes){
            Start-Job -ScriptBlock {
                $Working_directory = $args[0]
                subl.exe "$Working_directory\five_mins_left.md"
            } -ArgumentList $Working_directory
        }

        #region update animation

        $width = [Math]::floor($Host.UI.RAWUI.MaxWindowSize.Width / 30)
        if($width -lt 1){
            $width = 1
        }

        $session_progress_unit = '/' * $width * $_

        $upper_border = '┏' + ('━' * $Work_duration_minutes * $width) + '┓'
        $middle_border = ' ' + ('━' * $Work_duration_minutes * $width) + ' '
        $lower_border = '┗' + ('━' * $Work_duration_minutes * $width) + '┛'


        $level_progress = (($hours % 1000)/1000)

        $progress_bars_number = [math]::Floor($level_progress * ($upper_border.Length - 2))

        $level_progress_unit = '\' * $progress_bars_number

        Clear-Host
        Write-Host $Random_quote -ForegroundColor Green
        Write-Host
        Write-Host " $level_progress_unit".PadRight($level_progress_unit.Length + (($upper_border.Length - 2) - $level_progress_unit.Length)) -ForegroundColor Green
        Write-Host $middle_border
        Write-Host " $session_progress_unit".PadRight($session_progress_unit.Length + (($middle_border.Length - 2) - $session_progress_unit.Length)) -ForegroundColor Green
        Write-Host

        Write-Host "Exp : $hours "           -NoNewline; write-host '>> ' -NoNewline -ForegroundColor Green; Write-Host $($hours + 0.5)
        Write-Host "Rnk : $skill_rank "      -NoNewline; Write-Host '>> ' -NoNewline -ForegroundColor Green; Write-Host "$($skill_ranks[([math]::Floor($hours / 1000)) + 1])"
        Write-Host "Chn : $($Object.Chain) " -NoNewline; Write-Host '>> ' -NoNewline -ForegroundColor Green; Write-Host "$([int]$Object.Chain + 1)"
        Write-Host "Strk: $($Object.Streak)"
        Write-Host "Prog: $(100 - (($Remaining_Minutes / $Work_duration_minutes) * 100 -as [int]))%"
        Write-Host "Mins: $Remaining_Minutes"
        #endregion

        Start-Sleep -Seconds 60
        $Remaining_Minutes--
    }

    [int]$Object.Record = [int]$Object.Record + 1
    [int]$Object.Chain  = [int]$Object.Chain  + 1

    #region display the finish screen
    $session_progress_unit = '/' * $width * 30

    $level_progress = ((($hours + 1) % 1000)/1000)

    $progress_bars_number = [math]::Floor($level_progress * ($upper_border.Length - 2))

    $level_progress_unit = '\' * $progress_bars_number

    Clear-Host
    Write-Host $Random_quote -ForegroundColor DarkGreen
    Write-Host
    Write-Host " $level_progress_unit".PadRight($level_progress_unit.Length + (($upper_border.Length - 2) - $level_progress_unit.Length)) -ForegroundColor DarkGreen
    Write-Host $middle_border
    Write-Host " $session_progress_unit".PadRight($session_progress_unit.Length + (($middle_border.Length - 2) - $session_progress_unit.Length)) -ForegroundColor DarkGreen
    Write-Host

    Write-Host "Exp : " -NoNewline; Write-Host $hours -ForegroundColor DarkGreen
    Write-Host "Rnk : $skill_rank"
    Write-Host "Chn : " -NoNewline; Write-Host $($Object.Chain) -ForegroundColor DarkGreen
    Write-Host "Strk: $($Object.Streak)"
    Write-Host "Prog: " -NoNewline; write-host "100%" -ForegroundColor DarkGreen
    Write-Host "Mins: $Remaining_Minutes"
    #endregion

    #if max chain is exceeded, celebrate!
    if([int]$object.Chain -gt $MaxChain){
        Write-Host "[+] Chain record passed!! $($Object.Chain)!!" -ForegroundColor DarkGreen
        [int]$Object.Chain > MaxChain.txt
    }
    
    $Object | Export-Csv Tracker.csv -NoTypeInformation


    #region commit charge, tracker, trail and max chain and push
    Start-Job -ScriptBlock {
        Set-Location $args[0]
        git add Tracker.csv
        git add MaxChain.txt
        git add Trail.csv
        git commit -m 'one step closer'
        git push
    } -ArgumentList $Working_directory | Wait-Job | Out-Null
    #endregion
     
    subl.exe finished.md

    Write-Host
    Pause
    Get-Job | Remove-Job
}