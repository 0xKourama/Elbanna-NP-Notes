# Brute Forcing Best Practices
1. Avoid lockout --> Don't brute, spray
2. generate a clever wordlist
	1. guess probable passwords
	2. try patterns
	3. try common usernames/passwords
	4. try default credentials
3. if you find passwords:
	- check for Uppercase variations
	- detect any patterns

# Pull Active directory password policy (requries a valid AD user)
`crackmapexes smb <TARGET IP> -d <DOMAIN> -u <USER> -p <PASSWORD> --pass-pol`