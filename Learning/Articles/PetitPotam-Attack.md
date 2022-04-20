# Introduction
The **PetitPotam attack** is a technique where we abuse the **printer bug** to make a **domain controller** authenticate to our **kali machine**.
*Relaying the captured authentication* to the **web interface of AD Certificate services (ADCS)** allows us to get the **certificate of the domain controller computer account**.
*Having this certificate* can let us **request a TGT for the computer account**.
*With a TGT of a Domain Controller's machine account,* we can abuse its **DCSync right** on the domain to retrieve **a full dump containing all domain users' NTLM hashes**.
*Having all user hashes and using them with a simple Pass-the-Hash attack,* we can obtain **code execution as a Domain Admin**.
**Persistence** can also be established with a **golden ticket** since the `krbtgt` account hash would be compromised.

# Lab Setup and conditions
1. Server #1: Any server with Active Directory Certificate Services Web Enrollment enabled
2. Server #2: A Domain Controller (PrintSpooler Service must be running)
3. Kali Machine: for triggering authentication and relaying to ADCS Web UI
4. Windows Machine: for requesting a TGT and doing the DCSync attack (Shouldn't be in the domain, but should have the DC as its DNS)

# Steps to Create
1. Set up NTLM Relay on our attacker host
2. Use PetitPotam to force authentication from a domain controller back to kali machine
3. Relay authentication to ADCS Web UI
4. Recieve base64 certificate for the domain controller's computer account
5. use Rubeus.exe to request a TGT for that account using the certificate
6. *Having the TGT in memory,* use Mimikatz.exe to do a DCSync attack
7. Grab any domain admin's hash to have code execution
8. create a golden ticket for persistence

# 1. Setting up NTLM Relay on our attacker host
