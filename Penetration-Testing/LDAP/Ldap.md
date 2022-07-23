# ldapdomaindump --> Nice HTML reports
```bash
ldapdomaindump -u '<DOMAIN_FQDN>\<USER>' -p '<PASSWORD>' --no-json --no-grep -m <HOST_FQDN>
```

# ldapsearch
```bash
ldapsearch -x -H ldap://<TARGET_IP> -D <USERNAME> -w <PASSWORD> -b 'DC=MEGABANK,DC=LOCAL'
```