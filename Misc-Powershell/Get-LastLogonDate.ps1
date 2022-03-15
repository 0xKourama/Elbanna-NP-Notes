$PropertyList = @(
    'Created'
	'Enabled'
	'LastLogonDate'
	'mail'
	'UserPrincipalName'
	'msExchWhenMailboxCreated'
	'proxyAddresses'
)
$DCs = (Get-ADDomainController -Filter *).Name
$CompleteList = @()
foreach($DC in $DCs){
    $CompleteList += Get-ADUser -Server $DC -Filter * -Properties $PropertyList | Where-Object {$_.LastLogonDate -ne $null}
}
