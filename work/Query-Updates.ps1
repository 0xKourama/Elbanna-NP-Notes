param([String[]]$ComputerName)
$Script = {
    $Session = New-Object -ComObject Microsoft.Update.Session
    $Searcher = $Session.CreateUpdateSearcher()
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
Invoke-Command -ComputerName $ComputerName -ScriptBlock $Script