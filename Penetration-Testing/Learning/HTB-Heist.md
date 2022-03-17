# Heist

# Port 80
1. login page 
2. login as guest -->
# conversation:
- hazard: Hi, I've been experiencing problems with my cisco router. Here's a part of the configuration the previous admin had been using. I'm new to this and don't know how to fix it. :( 
http://10.10.10.149/attachments/config.txt
```
version 12.2
no service pad
service password-encryption
!
isdn switch-type basic-5ess
!
hostname ios-1
!
security passwords min-length 12
enable secret 5 $1$pdQG$o8nrSzsGXeaduXrjlvKc91
!
username rout3r password 7 0242114B0E143F015F5D1E161713
username admin privilege 15 password 7 02375012182C1A1D751618034F36415408
!
!
ip ssh authentication-retries 5
ip ssh version 2
!
!
router bgp 100
 synchronization
 bgp log-neighbor-changes
 bgp dampening
 network 192.168.0.0Â mask 300.255.255.0
 timers bgp 3 9
 redistribute connected
!
ip classless
ip route 0.0.0.0 0.0.0.0 192.168.0.1
!
!
access-list 101 permit ip any any
dialer-list 1 protocol ip list 101
!
no ip http server
no ip http secure-server
!
line vty 0 4
 session-timeout 600
 authorization exec SSH
 transport input ssh


```
# support admin:
Hi, thanks for posting the issue here. We provide fast support and help. Let me take a look and get back to you!

# hazard:
Thanks a lot. Also, please create an account for me on the windows server as I need to access the files. 

# enable secret hash cracked!
stealth1agent

# logged in!
user: SupportDesk\hazard
password: stealth1agent

# computer name
SupportDesk

# nmap
PORT      STATE SERVICE       VERSION
80/tcp    open  http          Microsoft IIS httpd 10.0
135/tcp   open  msrpc         Microsoft Windows RPC
445/tcp   open  microsoft-ds?
5985/tcp  open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
49669/tcp open  msrpc         Microsoft Windows RPC
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

# web page params:
## /login.php
1. login_username
2. login_password
3. remember

## /issues.php
1. login_username
2. login_password

# check
1. we have a username and a password on the server (not local admin)
# user 1
user: SupportDesk\hazard
password: stealth1agent
# user 2 --->> HAS WINRM ACCESS BABYEEE! :D :D <3
user: chase
password: Q4)sJu\Y8qz\*A3?d

2. we have a logon page
it takes emails as the username
3. we have parameters in some webpages: 
4. directory bruteforce the /attachments directory
5. we know server is IIS 10 --> server 2016
6. we know server uses PHP
7. we can read IPC$ Share
8. Windows 10.0 Build 17763 x64
9. users:
support
Chase
Jason

# what we tried
1. executing commands:
    1. cme (smb and winrm modules)
    2. impacket
    3. evil-winrm
2. logging in as the administrator with password variants:
stealth<0-10>agent
3. looking for other txt files in the attachments directory

# to try:
- [ ] brute force? --> sqli?
- [X] check and see to alter cookies
- [ ] maybe we can infer the password scheme?
- [X] we have other passwords we havent tried cracking:
username rout3r password 7 0242114B0E143F015F5D1E161713 --> `$uperP@ssword`
username admin privilege 15 password 7 02375012182C1A1D751618034F36415408 --> Q4)sJu\Y8qz*A3?d
- [ ] bruteforce for PHP files
- [X] look for hidden parameters
- [ ] source code
- [ ] guess different usernames
    1. administrator
        - stealth1agent
        - stealth0agent
        - $uperP@ssword
        - Q4)sJu\Y8qz\*A3?d
    2. adminsupport
        - stealth1agent
        - stealth0agent
        - $uperP@ssword
        - Q4)sJu\Y8qz\*A3?d        
    1. admin
        - stealth1agent
        - stealth0agent
        - $uperP@ssword
        - Q4)sJu\Y8qz\*A3?d





# flow
# user 2 --->> HAS WINRM ACCESS BABYEEE! :D :D <3
user: chase
password: Q4)sJu\Y8qz\*A3?d

# local administrators:
administrator

# chase downloads: vmware tools


# processes
Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
    467      18     2236       5388               372   0 csrss
    290      13     2280       5216               484   1 csrss
    357      15     3488      14524              4720   1 ctfmon
    254      14     3952      13372              3532   0 dllhost
    166       9     1816       9736       0.05   6156   1 dllhost
    618      32    29200      57092               984   1 dwm
   1489      57    23804      79048              5068   1 explorer
    347      20    10220      36788       0.23    632   1 firefox --------> interesting
   1057      69   138244     215184       6.75   5324   1 firefox
    401      33    31216      90748       1.11   5840   1 firefox
    378      28    22472      59124       0.97   6360   1 firefox
    355      25    16532      39176       0.08   6680   1 firefox
     49       6     1516       3932               764   0 fontdrvhost
     49       6     1800       4712               768   1 fontdrvhost
      0       0       56          8                 0   0 Idle
    966      23     5504      14692               636   0 lsass
    223      13     2948      10288              3820   0 msdtc
    124      13     6488      13536              1960   0 php-cgi --------> interesting
      0      12      512      15176                88   0 Registry
    275      14     3056      15064              4108   1 RuntimeBroker
    304      16     5424      16956              5328   1 RuntimeBroker
    145       8     1620       7556              5384   1 RuntimeBroker
    676      32    19768      61256              5180   1 SearchUI
    526      11     4820       9404               616   0 services
    692      28    15092      51144              3692   1 ShellExperienceHost
    439      17     4936      23844              4372   1 sihost
     53       3      532       1204               264   0 smss
    469      23     5760      16276              2296   0 spoolsv --------> interesting
   1874       0      188        132                 4   0 System
    210      20     3964      12440              4476   1 taskhostw
    167      11     2908      10932              2544   0 VGAuthService
    142       8     1704       6928              2612   0 vm3dservice
    136       9     1820       7452              2860   1 vm3dservice
    386      22    10564      21860              2596   0 vmtoolsd
    236      18     5092      15344              5568   1 vmtoolsd
    259      21     6576      15444              6256   0 w3wp --------> interesting
    171      11     1460       6896               476   0 wininit
    280      13     2824      12980               548   1 winlogon
    345      16     9016      18556              3704   0 WmiPrvSE
   1278      29    68932      89592       1.53   3492   0 wsmprovhost


# to-do:
1. try get a reverse shell as hazard and check his loot
2. run winpeas
3. check firefox process
4. check webserver root directory
    1. if we can get a reverse shell as IISAppPool --> maybe we can do impersonation attacks