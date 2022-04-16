```
    __             __               __     
   / /_____  _____/ /_  _______  __/ /____ 
  / //_/ _ \/ ___/ __ \/ ___/ / / / __/ _ \
 / ,< /  __/ /  / /_/ / /  / /_/ / /_/  __/
/_/|_|\___/_/  /_.___/_/   \__,_/\__/\___/                                        

Version: v1.0.3 (9dad6e1) - 04/16/22 - Ronnie Flathers @ropnop

This tool is designed to assist in quickly bruteforcing valid Active Directory accounts through Kerberos Pre-Authentication.
It is designed to be used on an internal Windows domain with access to one of the Domain Controllers.
Warning: failed Kerberos Pre-Auth counts as a failed login and WILL lock out accounts

Usage:
  kerbrute [command]
```
```
Available Commands:
  bruteforce    Bruteforce username:password combos, from a file or stdin
  bruteuser     Bruteforce a single user's password from a wordlist
  help          Help about any command
  passwordspray Test a single password against a list of users
  userenum      Enumerate valid domain usernames via Kerberos
  version       Display version info and quit
```
```
Flags:
      --dc string       The location of the Domain Controller (KDC) to target. If blank, will lookup via DNS                                                                                                                        
      --delay int       Delay in millisecond between each attempt. Will always use single thread if set                                                                                                                             
  -d, --domain string   The full domain to use (e.g. contoso.com)                                                                                                                                                                   
  -h, --help            help for kerbrute                                                                                                                                                                                           
  -o, --output string   File to write logs to. Optional.                                                                                                                                                                            
      --safe            Safe mode. Will abort if any user comes back as locked out. Default: FALSE                                                                                                                                  
  -t, --threads int     Threads to use (default 10)                                                                                                                                                                                 
  -v, --verbose         Log failures and errors                                                                                                                                                                                     
                                                                                                                                                                                                                                    
Use "kerbrute [command] --help" for more information about a command. 
```
## Userenum
`kerbrute userenum [flags] <username_wordlist>`

## Passwordspray
`kerbrute passwordspray [flags] <username_wordlist> <password>`
```
      --user-as-pass   Spray every account with the username as the password
```
## Bruteuser
`kerbrute bruteuser [flags] <password_list> username`

## Bruteforce
`kerbrute bruteforce [flags] <user_pw_file>`