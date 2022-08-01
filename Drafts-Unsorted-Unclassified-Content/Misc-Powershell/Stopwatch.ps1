#initialization
$stopwatch =  [system.diagnostics.stopwatch]::StartNew()

$elapsedseconds = $stopwatch.Elapsed.Seconds

#methods
$stopwatch.Start()
$stopwatch.Stop()
$stopwatch.Reset()
$stopwatch.Restart()