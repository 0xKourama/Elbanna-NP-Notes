[Enum]::GetValues([ConsoleColor]) | ForEach-Object {write-host $_ -ForegroundColor $_}
