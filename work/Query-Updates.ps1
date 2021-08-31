$Script = {
    $Session      = New-Object -ComObject Microsoft.Update.Session

    $Searcher     = $Session.CreateUpdateSearcher()

    $historyCount = $Searcher.GetTotalHistoryCount()

    $Searcher.QueryHistory(0, $historyCount) | Select-Object Date,@{
        Name = 'Operation'
        Expression = {
            switch($_.operation){
                1 {'Installation'}
                2 {'Uninstallation'}
                3 {'Other'}
            }
        }
    }, @{
        Name = 'Status'
        Expression = {
            switch($_.resultcode){
                1 {'In Progress'}
                2 {'Succeeded'}
                3 {'Succeeded With Errors'}
                4 {'Failed'}
                5 {'Aborted'}
            }
        }
    }, Title, @{
        Name = 'KBID'
        Expression = {
            ($_.Title | Select-String -Pattern "\((KB\d+)\)").Matches.Groups[1].Value
        }
    }, Description
}

$online_front_end_servers = (Get-ADComputer -Filter {name -like 'eu1fe*'}).Name | Where-Object {(Test-Connection -ComputerName $_ -Count 1 -Quiet) -eq $true}

$update_data = Invoke-Command -ComputerName $online_front_end_servers -ScriptBlock $Script