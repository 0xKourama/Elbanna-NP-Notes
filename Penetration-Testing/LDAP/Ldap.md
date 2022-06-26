# Enumerate LDAP without credentials
`ldapsearch -x -H ldap://10.10.10.161 -D '' -w '' -b 'dc=htb,dc=local'`

# After creds
`ldapdomaindump`