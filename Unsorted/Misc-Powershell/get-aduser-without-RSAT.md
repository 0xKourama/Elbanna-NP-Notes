$as = [adsisearcher]::new()
$as.SearchRoot = [ADSI]'LDAP://OU=MyOU,OU=MyParentOU,DC=MyDomain,DC=local'
$as.Filter = 'objectClass=user'
$as.FindAll() | % { $_.Properties.displayname }