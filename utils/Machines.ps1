﻿$List = @(
'bastard',
'october',
'kotarak',
'node',
'tally',
'valentine',
'bart',
'silo',
'tartarsauce',
'hawk',
'irked',
'postman',
'mango',
'forest',
'bitlab',
'bastion',
'frolic',
'blocky',
'lightweight',
'friendzone',
'lacasadepapel',
'jarvis',
'safe',
'networked'
)
Write-Host ($list[$(Get-Random($List.Count - 1))])