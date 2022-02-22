# C# compilers
Roslyn
GCC
MinGW
LLVM
TCC
MSBuild

# Subdomain enumeration
## we have to add a line in our /etc/hosts file for us to be able to fuzz subdomains
`10.200.111.33	holo.live`
## we then use gobuster with the `vhost` option and use the seclists wordlist 
`gobuster vhost -u http://holo.live -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt -t 2`
## or we use wfuzz
`wfuzz -u <URL> -w <wordlist> -H "Host: FUZZ.example.com" --hc <status codes to hide>`

