$body = ''
foreach($datastore in (Get-Datastore)){
    $body += "<h1>$($datastore.name)</h1>"
    $body += ($datastore |Get-VM).name | ForEach-Object -Begin {'<ol>'} -Process {"<li><b>$_</b></li>"} -End {'</ol>'}
}
$body > result.html