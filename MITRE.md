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
		3. Virtual Private Server (?)
		4. Server
		5. Botnet (?)
		6. Web Services
	4. Develop Capabilities
		1. Malware
		2. Code Signing Certificates (?)
		3. Digital Certificates (?)
		4. Exploits
	5. Establish Accounts
		1. Social Media Accounts
		2. Email Accounts
	6. Obtain Capabilities
		1. Malware
		2. Tool
		3. Code Signing Certificates (?)
		4. Digital Certificates (?)
		5. Exploits
		6. Vulnerabilities (?)
	7. Stage Capabilities
		1. Upload Malware
		2. Upload Tool
		3. Install Digital Certificate (?)
		4. Drive-by Target (?)
		5. Link Target (?)
3. **Initial Access**
	1. Drive-by Compromise (?)
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
	4. Exploitation for Client Execution (?)
	5. Inter-Process Communication
		1. Component Object Model
		2. Dynamic Data Exchange (?)
	6. Native API
	7. Schedules Task/Job
		1. At (Windows) (?)
		2. Scheduled Task
		3. At (Linux) (?)
		4. Cron
		5. Systemd Timers (?)
		6. Container Orchestration Job
	8. Shared Modules
	9. Software Deployment Tools
	10. System Services
		1. launchctl (?)
		2. Service Execution
	11. User Execution
		1. Malicious ink
		2. Malicious File
		3. Malicious Image
	12. Windows Management Instrumentation
5. **Persistence**
	1. Account Manipulation
		1. Additional Cloud Credentials (?)
		2. Exhcnage Email Delegate Permissions (?)
		3. Add Office 365 Global Administrator Role (?)
		4. SSH Authorized Keys
	2. BITS Jobs
	3. Boot or Logon Autostart Execution
		1. Registry Run Keys / Startup Folder
		2. Authentication Package (?)
		3. Time Providers (?)
		4. Winlogon Helper DLL (?)
		5. Security Support Provider (?)
		6. Kernel Modules and Extensions (?)
		7. Re-opened Applications (?)
		8. LSASS Driver (?)
		9. Shorcut Modification (?)
		10. Port Monitors (?)
		11. Plist Modification (?)
		12. Print Processors (?)
		13. XDG Autostart Entries (?)
		14. Active Setup (?)
		15. Login Items (?)
	4. Boot or Logon Initialization Scripts
		1. Logon Script (Windows)
		2. Logon Script (Mac) (?)
		3. Network Logon Scripts (?)
		4. RC Scripts (?)
		5. Startup Items
	5. Browser Extensions
	6. Compromise Client Software Binary
	7. Create Account
		1. Local Account
		2. Domain Account
		3. Cloud Account
	8. Create or Modify System Processes
		1. Launch Agent (?)
		2. Systemd Service (?)
		3. Windows Service
		4. Launch Daemon
	9. Event Triggered Execution
		1. Change Default File Association (?)
		2. Screensaver (?)
		3. Windows Management Instrumentation Event Subscription (?)
		4. Unix Shell Configuration Modification (?)
		5. Trap (?)
		6. LC_LOAD_DYLIB Addition (?)
		7. Netsh Helper DLL (?)
		8. Accessiblity Features (?)
		9. AppCert DLLs (?)
		10. AppInit DLLs (?)
		11. Application Shimming (?)
		12. Image File Execution Options Injection (?)
		13. PowerShell Profile
		14. Emond (?)
		15. Component Object Model Hijacking (?)
	10. External Remote Service
	11. Hijack Execution Flow
		1. Services File Permissions Weakness
		2. Executable Installer File Permissions Weakness
		3. Services Registry Permissions Weakness
		4. Path Interception by Unquoted Path
		5. Path Interception by PATH Environment Variable
		6. Path interception by Search Order Hijacking (?)
		7. DLL Search Order Hijacking (?)
		8. DLL Side-Loading (?)
		9. Dynamic Linker Hijacking (?)
		10. Dylib Hijacking (?)
		11. COR_PROFILER (?)
	12. Implant Internal Image (?)
	13. Modfiy Authentication Process
		1. Domain Controller Authentication (?)
		2. Password Filter DLL (?)
		3. Pluggable Authentication Modules (?)
		4. Network Device Authentication (?)
	14. Office Application Startup
		1. Add-ins (?)
		2. Office Template Macros (?)
		3. Outlook Forms (?)
		4. Outlook Rules
		5. Outlook Home Page (?)
		6. Office Test (?)
	15. Pre-OS Boot
		1. System Firmware (?)
		2. Component Firmware (?)
		3. Bootkit (?)
		4. ROMMONkit (?)
		5. TFTP Boot (?)
	16. Schedules Task/Job
		1. At (Windows) (?)
		2. Scheduled Task
		3. At (Linux) (?)
		4. Cron
		5. Systemd Timers (?)
		6. Container Orchestration Job (?)
	17. Server Software Component
		1. SQL Stored Procedures (?)
		2. Transport Agent (?)
		3. Web Shell
		4. IIS Components (?)
	18. Traffic Signaling
		1. Port Knocking
	19. Valid Accounts
		1. Default Accounts
		2. Domain Accounts
		3. Local Accounts
		4. Cloud Accounts
6. **Privilege Escalation**
	1. Abuse Elevation Control Mechanism
	2. Access Token Manipulation
	3. Boot or Logon Autostart Execution
	4. Boot or Logon Initialization Scripts
	5. Create or Modify System Process
	6. Domain Policy Modification
	7. Escape to Host
	8. Event Triggered Execution
	9. Exploitation for Privilege Escalation
	10. Hijack Execution Flow
	11. Process Injection
	12. Scheduled Task/Job
	13. Valid Accounts