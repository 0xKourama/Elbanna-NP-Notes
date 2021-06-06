# AD users with last logon date
`Get-ADUser -Filter * -Properties Mail,LastLogonDate |?{$_.lastlogondate} | Where-Object {(New-TimeSpan -Start $_.Lastlogondate -End (get-date)).Days -lt 90} | select name,mail,lastlogondate,@{n='Domain';e={$_.mail -replace '.*@'}} | select -Property domain -unique`

`CanonicalName: Roaya.loc/WP Admins/Gabr Urgent`