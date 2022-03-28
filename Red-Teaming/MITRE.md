1. **Reconnaissance**
	1. Active Scanning
		1. Scanning IP Blocks
		2. Vulnerability Scanning
	2. Gather Victim Host Information
		1. Hardware
		2. Software
		3. Firmware
		4. Client Configuration
	3. Gather Victim Identity Information
		1. Credentials
		2. Email Addresses
		3. Employee Names
	4. Gather Victim Network Information
		1. Domain Properties
		2. DNS
		3. Network Trust Dependencies
		4. Network Topology
		5. IP Addresses
		6. Network Security Appliances
	5. Gather Victim Org Information
		1. Business Relationships
		2. Determine Physical Locations
		3. Identify Business Tempo
		4. Identify Roles
	6. Phishing for information
		1. Spearphishing Service
		2. Spearphishing Attachment
		3. Spearphishing Link
	7. Search Closed Sources
		1. Threat Intel Vendor
		2. Purchase Technical Data
	8. Search Open Technical Databases
		1. WHOIS
		2. DNS/Passive DNS
		3. Digital Certificates
		4. CDNs
		5. Scan Databases
	9. Search open Websites/Domains
		1. Social Media
		2. Search Engines
	10. Search Victim-Owned Websites
2. **Resource Development**
	1. Acquire Infrastructure
		1. Domains
		2. DNS Server
		3. Virtual Private Server
		4. Server
		5. Botnet
		6. Web Services
	2. Compromise Accounts
		1. Social Media Accounts
		2. Email Accounts
	3. Compromise Infrastructure
		1. Domains
		2. DNS Server
		3. Virtual Private Server
		4. Server
		5. Botnet
		6. Web Services
	4. Develop Capabilities
		1. Malware
		2. Code Signing Certificates
		3. Digital Certificates
		4. Exploits
	5. Establish Accounts
		1. Social Media Accounts
		2. Email Accounts
	6. Obtain Capabilities
		1. Malware
		2. Tool
		3. Code Signing Certificates
		4. Digital Certificates
		5. Exploits
		6. Vulnerabilities
	7. Stage Capabilities
		1. Upload Malware
		2. Upload Tool
		3. Install Digital Certificate
		4. Drive-by Target
		5. Link Target
3. **Initial Access**
	1. Drive-by Compromise
	2. Exploit Public-Facing Application
	3. External Remote Services
	4. Hardware Additions
	5. Phishing
		1. Spearphishing Attachment
		2. Spearphishing Link
		3. Spearphishing via Service
	6. Replication Through Removable Media
	7. Supply Chain Compromise
		1. Compromise Software Dependencies and Development Tools
		2. Compromise Software Supply Chain
		3. Compromise Hardware Supply Chain
	8. Trust Relationship
	9. Valid Accounts
		1. Default Accounts
		2. Domain Accounts
		3. Local Accounts
		4. Cloud Accounts
4. **Execution**
	1. Command and Scripting Interpreter
		1. PowerShell
		2. AppleScript
		3. Windows Command Shell
		4. Unix Shell
		5. Visual Basic
		6. Python
		7. JavaScript
		8. Network Device CLI
	2. Container Administration Command
	3. Deploy Container
	4. Exploitation for Client Execution
	5. Inter-Process Communication
		1. Component Object Model
		2. Dynamic Data Exchange
	6. Native API
	7. Schedules Task/Job
		1. At (Windows)
		2. Scheduled Task
		3. At (Linux)
		4. Cron
		5. Systemd Timers
		6. Container Orchestration Job
	8. Shared Modules
	9. Software Deployment Tools
	10. System Services
		1. launchctl
		2. Service Execution
	11. User Execution
		1. Malicious ink
		2. Malicious File
		3. Malicious Image
	12. Windows Management Instrumentation
5. **Persistence**
	1. Account Manipulation
		1. Additional Cloud Credentials
		2. Exhcnage Email Delegate Permissions
		3. Add Office 365 Global Administrator Role
		4. SSH Authorized Keys
	2. BITS Jobs
	3. Boot or Logon Autostart Execution
		1. Registry Run Keys / Startup Folder
		2. Authentication Package
		3. Time Providers
		4. Winlogon Helper DLL
		5. Security Support Provider
		6. Kernel Modules and Extensions
		7. Re-opened Applications
		8. LSASS Driver
		9. Shorcut Modification
		10. Port Monitors
		11. Plist Modification
		12. Print Processors
		13. XDG Autostart Entries
		14. Active Setup
		15. Login Items
	4. Boot or Logon Initialization Scripts
		1. Logon Script (Windows)
		2. Logon Script (Mac)
		3. Network Logon Scripts
		4. RC Scripts
		5. Startup Items
	5. Browser Extensions
	6. Compromise Client Software Binary
	7. Create Account
		1. Local Account
		2. Domain Account
		3. Cloud Account
	8. Create or Modify System Processes
		1. Launch Agent
		2. Systemd Service
		3. Windows Service
		4. Launch Daemon
	9. Event Triggered Execution
		1. Change Default File Association
		2. Screensaver
		3. Windows Management Instrumentation Event Subscription
		4. Unix Shell Configuration Modification
		5. Trap
		6. LC_LOAD_DYLIB Addition
		7. Netsh Helper DLL
		8. Accessiblity Features
		9. AppCert DLLs
		10. AppInit DLLs
		11. Application Shimming
		12. Image File Execution Options Injection
		13. PowerShell Profile
		14. Emond
		15. Component Object Model Hijacking
	10. External Remote Service
	11. Hijack Execution Flow
		1. Services File Permissions Weakness
		2. Executable Installer File Permissions Weakness
		3. Services Registry Permissions Weakness
		4. Path Interception by Unquoted Path
		5. Path Interception by PATH Environment Variable
		6. Path interception by Search Order Hijacking
		7. DLL Search Order Hijacking
		8. DLL Side-Loading
		9. Dynamic Linker Hijacking
		10. Dylib Hijacking
		11. COR_PROFILER
	12. Implant Internal Image
	13. Modfiy Authentication Process
		1. Domain Controller Authentication
		2. Password Filter DLL
		3. Pluggable Authentication Modules
		4. Network Device Authentication
	14. Office Application Startup
		1. Add-ins
		2. Office Template Macros
		3. Outlook Forms
		4. Outlook Rules
		5. Outlook Home Page
		6. Office Test
	15. Pre-OS Boot
		1. System Firmware
		2. Component Firmware
		3. Bootkit
		4. ROMMONkit
		5. TFTP Boot
	16. Schedules Task/Job
		1. At (Windows)
		2. Scheduled Task
		3. At (Linux)
		4. Cron
		5. Systemd Timers
		6. Container Orchestration Job
	17. Server Software Component
		1. SQL Stored Procedures
		2. Transport Agent
		3. Web Shell
		4. IIS Components
	18. Traffic Signaling
		1. Port Knocking
	19. Valid Accounts
		1. Default Accounts
		2. Domain Accounts
		3. Local Accounts
		4. Cloud Accounts
6. **Privilege Escalation**
	1. Abuse Elevation Control Mechanism
		1. Setuid and Setgid
		2. Bypass User Account Control
		3. Sudo and Sudo caching
		4. Elevated Execution with Prompt
	2. Access Token Manipulation
		1. Token Impersonation/Theft
		2. Create Process with Token
		3. Make and Impersonate Token
		4. Parent PID Spoofing
		5. SID-History Injection
	3. Boot or Logon Autostart Execution
		1. Registry Run Keys / Startup Folder
		2. Authentication Package
		3. Time Providers
		4. Winlogon Helper DLL
		5. Security Support Provider
		6. Kernel Modules and Extensions
		7. Re-opened Applications
		8. LSASS Driver
		9. Shortcut Modificaiton
		10. Port Monitors
		11. Plist Modification
		12. Print Processors
		13. XDG Autostart Entries
		14. Active Setup
		15. Login Items
	4. Boot or Logon Initialization Scripts
		1. Logon Script (windows)
		2. Logon Script (Mac)
		3. Netwokr Logon Script
		4. RC Scripts
		5. Startup Items
	5. Create or Modify System Process
		1. Launch Agent
		2. Systemd Service
		3. Windows Service
		4. Launch Daemon
	6. Domain Policy Modification
		1. Group Policy Modification
		2. Domain Trust Modification
	7. Escape to Host
	8. Event Triggered Execution
		1. Change Default File Association
		2. Screensaver
		3. Windows Management Instrumentation Event Subscription
		4. Unix Shell Configuration Modification
		5. Trap
		6. LC_LOAD_DYLIB Addition
		7. Netsh Helper DLL
		8. Accessiblity Features
		9. AppCert DLLs
		10. AppInit DLLs
		11. Application Shimming
		12. Image File Execution Options Injection
		13. PowerShell Profile
		14. Emond
		15. Component Object Model Hijacking
	9. Exploitation for Privilege Escalation
	10. Hijack Execution Flow
		1. Services File Permissions Weakness
		2. Executable Installer File Permissions Weakness
		3. Services Registry Permissions Weakness
		4. Path Interception by Unquoted Path
		5. Path Interception by PATH Environment Variable
		6. Path interception by Search Order Hijacking
		7. DLL Search Order Hijacking
		8. DLL Side-Loading
		9. Dynamic Linker Hijacking
		10. Dylib Hijacking
		11. COR_PROFILER
	11. Process Injection
		1. Dynamic-link Library Injection
		2. Portable Executable Injection
		3. Thread Execution Hijacking
		4. Asynchronous Procedure Call
		5. Thread Local Storage
		6. Ptrace System Calls
		7. Proc Memory
		8. Extra Window Memory Injection
		9. Process Doppelganging
		10. Process Hollowing
		11. VDSO Hijacking
	12. Scheduled Task/Job
		1. At (Windows)
		2. Scheduled Task
		3. At (Linux)
		4. Cron
		5. Systemd Timers
		6. Container Orchestration Job		
	13. Valid Accounts
		1. Default Accounts
		2. Domain Accounts
		3. Local Accounts
		4. Cloud Accounts
7. **Defense Evasion**
	1. Abuse Elevation Control Mechanism
		1. Setuid and Setgid
		2. Bypass User Account Control
		3. Sudo and Sudo Caching
		4. Elevated Execution with Prompt
	2. Access Token Manipulation
		1. Token Impersonation/Theft
		2. Create Process with Token
		3. Make and Impersonate Token
		4. Parent PID Spoofing
		5. SID-History Injection
	3. BITS Jobs
	4. Build Image on Host
	5. Deobfuscate/Decode Files or Information
	6. Deploy Container
	7. Direct Volume Access
	8. Domain Policy Modification
		1. Group Policy Modification
		2. Domain Trust Modification
	9. Execution Guardrails
		1. Environmental Keyed
	10. Exploitation for Defense Evasion
	11. File and Directory Premissions Modification
		1. Windows File and Directory Permissions Modification
		1. Linux and Mac File and Directory Permissions Modification
	12. Hide Artifacts
		1. Hidden Falies and Directories
		2. Hidden Users
		3. Hidden Window
		4. NTFS File Attributes
		5. Hidden File System
		6. Run Virtual Instance
		7. VBA Stomping
		8. Email Hiding Rules
		9. Resource Forking
	13. Hijack Execution Flow
		1. Services File Permissions Weakness
		2. Executable Installer File Permissions Weakness
		3. Services Registry Permissions Weakness
		4. Path Interception by Unquoted Path
		5. Path Interception by PATH Environment Variable
		6. Path interception by Search Order Hijacking
		7. DLL Search Order Hijacking
		8. DLL Side-Loading
		9. Dynamic Linker Hijacking
		10. Dylib Hijacking
		11. COR_PROFILER
	14. Impair Defenses
		1. Disable or Modify Tools
		2. Disable Windows Event Logging
		3. Impair Command History Loggin
		4. Disable or Modify System Firewall
		5. Indicator Blocking
		6. Disable or Modify Cloud Firewall
		7. Disable Cloud Logs
		8. Safe Mode Boot
		9. Downgrade Attack
	15. Indicator Removal on Host
		1. Clear Windows Event Logs
		2. Clear Linux or Mac System Logs
		3. Clear Command History
		4. File Deletion
		5. Network Share Connection Removal
		6. Timestomp
	16. Indirect Command Execution
	17. Masquerading
		1. Invalid Code Signature
		2. Right-to-Left Override
		3. Rename System Utilities
		4. Masquerade Task or Service
		5. Match Legitimate Name or Location
		6. Space after Filename
		7. Double File Extension
	18. Modfiy Authentication Process
		1. Domain Controller Authentication
		2. Password Filter DLL
		3. Pluggable Authentication Modules
		4. Network Device Authentication
	19. Modify Cloud Compute Infrastructure
		1. Create Snapshot
		2. Create Cloud Instance
		3. Delete Cloud Instance
		4. Rever Cloud Instance
	20. Modify Registry
	21. Modify Stem Image
		1. Patch System Image
		2. Downgrade System Image
	22. Network Boundary Bridging
		1. Network Address Translation Traversal
	23. Obfuscated Files or Information
		1. Binary Padding
		2. Software Packing
		3. Steganography
		4. Compile After Delivery
		5. Indicator Removal from Tools
		6. HTML Smuggling
	24. Pre-OS Boot
		1. System Firmware
		2. Component Firmware
		3. Bootkit
		4. ROMMONkit
		5. TFTP Boot
	25. Process Injection
		1. Dynamic-Link Library Injection
		2. Portable Executable Injection
		3. Thread Execution Hijacking
		4. Asynchronous Procedure Call
		5. Thread Local Storage
		6. Ptrace System Calls
		7. Proc Memory
		8. Extra Window Memory Injection
		9. Process Hollowing
		10. Process Doppelganging
		11. VDSO Hijacking
	26. Reflective Code Loading
	27. Rogue Domain Controller
	28. Rootkit
	29. Signed Binary Proxy Execution
		1. Compiled HTML File
		2. Control Panel
		3. CMSTP
		4. InstallUtil
		5. Mshta
		6. Msiexec
		7. Odbcconf
		8. Regsvc/Regasm
		9. Regsvr32
		10. Rundll32
		11. Verclsid
		12. Mavinject
		13. MMC
	30. Signed Script Proxy Execution
		1. PubPrn
	31. Subvert Trust Controls
		1. Gatekeeper Bypass
		2. Code Signing
		3. SIP and Trust Provider Hijacking
		4. Install Root Certificate
		5. Mark-of-the-Web Bypass
		6. Code Signing Policy Modification
	32. Template Injection
	33. Traffic Signaling
		1. Port Knocking
	34. Trusted Developer Utilities Proxy Execution
		1. MSBuild
	35. Use Alternate Authentication Material
		1. Application Access Token
		2. Pass the Hash
		3. Pass the Ticket
		4. Web Session Cookie
	36. Valid Accounts
		1. Default Accounts
		2. Domain Accounts
		3. Local Accounts
		4. Cloud Accounts
	37. Virtualization/Sandbox Evasion
		1. System Checks
		2. User Activity Based Checks
		3. Time Based Evasion
	38. Weaken Encryption
		1. Reduce Key Space
		2. Disable Crypto Hardware
	39. XSL Script Processing
8. **Credential Access**
	1. Adversary-in-the-Middle
		1. LLMNR/NBT-NS Poisoning and SMB Relay
		2. ARP Cache Poisoning
	2. Brute Force
		1. Password Guessing
		2. Password Cracking
		3. Password Spraying
		4. Credential Stuffing
	3. Credentials from Password Stores
		1. Keychain
		2. Securityd Memory
		3. Credentials from Web Browsers
		4. Windows Credential Manager
		5. Password Managers
	4. Exploitation for Credential Access
	5. Forced Authentication
	6. Forge Web Credentials
		1. Web Cookies
		2. SAML Tokens
	7. Input Capture
		1. Keylogging
		2. GUI Input Capture
		3. Web Portal Capture
		4. Credential API Hooking
	8. Modify Authentication Process
		1. Domain Controller Authentication
		2. Password Filter DLL
		3. Pluggable Authentication Modules
		4. Network Device Authentication
	9. Network Sniffing
	10. OS Credential Dumping
		1. LSASS Memory
		2. Security Account Manager
		3. NTDS
		4. LSA Secrets
		5. Cached Domain Credentials
		6. DCSync
		7. Proc Filesystem
		8. /etc/passwd and /etc/shadow
	11. Steal Application Access Token
	12. Steal or Forge Kerberos Tickets
		1. Golden Ticket
		2. Silver Ticket
		3. Kerberoasting
		4. AS-REP Roasting
	13. Steal Web Session Cookie
	14. Two-Factor Authentication Interception
	15. Unsecured Credentials
		1. Credentials in Files
		2. Credentials in Registry
		3. Bash History
		4. Private Keys
		5. Cloud Instance Metadata API
		6. Group Policy Preferences
		7. Container API
9. **Discovery**
	1. Account Discovery
		1. Local Account
		2. Domain Account
		3. Email Account
		4. Cloud Account
	2. Application Window Discovery
	3. Browser Bookmark Discovery
	4. Cloud Infrastructure Discovery
	5. Cloud Service Dashboard
	6. Cloud Service Discovery
	7. Cloud Storage Object Discovery
	8. Container and Resource Discovery
	9. Domain Trust Discovery
	10. File and Directory Discovery
	11. Group Policy Discovery
	12. Network Service Scanning
	13. Network Share Discovery
	14. Network Sniffing
	15. Password Policy Discovery
	16. Peripheral Device Discovery
	17. Permissions Groups Discovery
		1. Local Groups
		2. Domain Groups
		3. Cloud Groups
	18. Process Discovery
	19. Query Registry
	20. Remote System Discovery
	21. Software Discovery
		1. Security Software Discovery
	22. System Information Discovery
	23. System Location Discovery
		1. System Language Discovery
	24. System Network Configuration Discovery
		1. internet connection discovery
	25. System Network Connections Discovery
	26. System Owner/User Discovery
	27. System Service Discovery
	28. System Time Discovery
	29. Virtualization/Sandbox Evasion
		1. System Checks
		2. User Activity Based Checks
		3. Time Based Evasion
10. **Lateral Movement**
	1. Exploitation of Remote Services
	2. Internal Spearphishing
	3. Lateral Tool Transfer
	4. Remote Service Session Hijacking
		1. SSH Hijacking
		2. RDP Hijacking
	5. Remote Services
		1. 