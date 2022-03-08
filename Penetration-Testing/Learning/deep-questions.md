# Overall
1. deep technical knowledge and understanding of function
2. deadly enumeration skill
3. vulnerability and misconfiguration identification
4. wide arsenal of tricks
5. looting skill (configuration files, ssh keys, sticky notes, temps, recycle bin ...etc.)
6. situational awarness (logs, packet capture)

# what does every hack include?
1. enumerating all functionalities present on the victim and how to put them together to gain access

# what are my areas I need to expand on?
1. web pentesting
2. getting my shit down pat when it comes to
	1. network services pentesting
	2. web pentesting
	3. ad pentesting
	4. red teaming
	5. known vulnerabilities and exploits
3. configuring known services and playing with them
	1. FTP
	2. NFS
	3. SSH
	4. Databases (MySQL, MSSQL, MariaDB, PostgreSQL, MongoDB, GraphQL)
	5. Tomcat
	6. Wordpress, Joomla, Drupal
	7. AD
	8. apache, nginx, IIS
4. social engineering
5. learning some wireless pentesting
6. setting up vulnerable environments

# what is enumerated in a web application?
1. pages
2. parameters
3. technologies
4. 3rd party stuff
6. input methods
7. DB? DB type?
8. all functionalities

# what is my cycle?
1. ask all the questions
2. learn (read, listen and watch)
3. apply (configure -> attack -> defend)
4. play around and mess up
5. teach and write

# what made favor network pentesting over web?
1. owning the network has a much bigger network that owning a website
2. owning a website can lead to owning the network though. but that needs the guy to know how to own a network.

# what is a vulnerability?
1. a mistake in software that allows the user to alter the needed function

# what should be done to discover a vulnerability?
1. subject the input point of the system to different inputs

# what is needed in order to exploit a vulnerability?
1. a working exploit
2. a fairly well-explained use of the exploit
3. knowledge of the necessary conditions for the exploit to work
	1. victim system reponse
	2. victim system antivirus
	3. payloads available for exploitation

# what can be done to make sure an exploit is working?
1. checking its severity
2. checking for screenshots to validate the exploit
3. downloading the application and testing the exploit in a virtual environment
4. checking if the exploit is verified on EDB
5. checking the version it affects

# What are good sources for exploits?
1. metasploit
2. verified on EDB
3. starred on GH
4. exploits with POCs
5. older vulnerabilities that have been refined

# what is google dorking?

# What are the metrics in vulnerabilities?
1. difficulty of exploitation
	- known?
	- exploited before successfully?
2. Value
	- big if compromised
	- low hanging fruit
3. 

# what can be done to detect a honey pot?
1. obvious vulnerability that doesn't match the level of security the company is supposed to have

# what can be done to detect the level of security of company with OSINT?
1. how old is the company
2. company size
3. company's reliance on IT systems
4. linked info on the security staff
5. background of the IT Managment (if they have a security background -> they are likely to be concerned with security)
6. 


# Web pentesting
1. the unit for web pentesting is pages:
	each page has:
	1. certain functionality (based on authenticated user or not)
	2. certain vulnerabilities
	3. certain security configurations that can be exploited


# what's stopping you from learning new programming languages?
1. *in spanish* NADA


# what stops us from learning? what's difficult in learning?

# what skill areas do you want?
1. Network pentesting --> to the maaax
	1. configuring common network services to be familiar with their process
		- tomcat
		- mysql
		- apache
		- IIS
		- MSSQL
		- FTP
		- NFS
		- AD LAB (AD Monster)
		- Postfix
		- Exchange
2. privilege escalation monster (Good OS Knowledge)
	1. windows
	2. linux
3. Social Engineering & Client-side attacks
4. Network Exploit code easy-reading
	1. python
	2. ruby
5. Web penetration testing
6. Wireless porn
7. Antivirus Evasion
8. My own toolset
9. perfect methodology (very well-rounded pentester)

# what attack do I want to learn ASAP?
1. Responder & SMB Relay
2. Log4j ownage
3. Print Nightmare
4. get that HTB machine

# resources:
1. we got HTB
	[+] realworld
	[+] we got ippsec
	[+] we got subscription
	[-] remote
2. we got THM
	[+] walkthroughts and easy learning
	[+] fun
	[+] a lot of interesting topics
	[~] remote but gives a nice machine
3. we got vulnhub
	[+] local
4. we got them books
	[+] rounded knowledge
	[+] good for commuting
6. we got MITRE
	[+] seeing and learning from tactics
7. we got elearn courses
	[+] concise
8. we got pentester academy courses
	[+] very nice knowledge

# interview fails:
## knowing important config files
chaining exploits --> lfi --> WPconfig.php
# idenfying the DC:
	ports: 53, 88, 389, 138, 139, 445, 3268
	SRV Record.

# AD attacks
explaining technology behind responder
explaining pass the hash
explaining kerberos
explaining Kerberos delegation and non-contrained delegation
explaining kerberoast
explaining ASREProast
explaining golden and silver tickets
explaining what do in a red team engagement
explaining steps to be domain admin

# hacking resources
asking me about resources:
General:
1. hacktricks

AD:
1. hacktricks
2. hausec
3. ADSecurity

# attacking common network services
attacking SMB
attacking FTP


# where i failed (fixed solutions)
- what is selinux?
- what is kerberoast in depth?
- what is ASREPRoasing?
- SQL injection attack types
- what to do in a red teaming scenario?
- flask and python
- File inclusion exploitation and what can be done with this vuln

# where i failed (silicon experts)
- SSRF vulnerability

# where i failed (kpmg)
- Wirless pentesting
- Firewall audit tools
- File upload bypass
- Exploiting SMTP