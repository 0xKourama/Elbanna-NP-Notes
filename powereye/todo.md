# what differentiates local from domain users?
get-local user command
- if user returns >> local
- if not >> domain

# what disables a local/domain user?
Disable-LocalUser -Name <LOCALUSER>
Get-ADUSer -Filter {Name -eq '<LOCALUSER>'} | Disable-ADAccount 

# what changes the password for local/domain user?
fine-grained password policy