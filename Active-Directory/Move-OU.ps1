#make the OU unprotected from accidential deletion
Get-ADOrganizationalUnit -Identity "OU=Regions,OU=Managers,DC=Enterprise,DC=Com" | Set-ADObject -ProtectedFromAccidentalDeletion $False
#move it
Move-ADObject -Identity "OU=Regions,OU=Managers,DC=Enterprise,DC=Com" -TargetPath "OU=IT,DC=Enterprise,DC=Com"