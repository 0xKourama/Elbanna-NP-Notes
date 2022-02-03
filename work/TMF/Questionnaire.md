# Questionnaire

# Network Penetration Test
1. get scope
	- what will be tested?
	- what IP ranges are in scope for the engagement?
	- IP addresses, network ranges, or domain names
	- Cloud instances? like AWS?
2. what's allowed? and what's not?
3. timing. are there any upgrades or project implementations taking place?
	- what the preferred time to conduct the testing?
		1. During business hours?
		2. After business hours?
		3. On the weekends?
4. list of contacts for: downtime, critical vuln
5. do you prefer testing identification and response? Purple team exercise?
	- Ability to detect and respond to
	 	1. information gathering
		2. foot printing
		3. scanning and vuln analysis
		4. infiltration (attacks)
		5. data aggregation
		6. data ex-filtration
6. In the case that a system is penetrated, how should the testing team proceed?
	1. Perform a local vulnerability assessment on the compromised machine?
	2. Attempt to gain the highest privileges (root on Unix machines, SYSTEM or Administrator on Windows machines) on the compromised machine?
	3. Perform no, minimal, dictionary, or exhaustive password attacks against local password hashes obtained (for example, /etc/shadow on Unix machines)?

# Web Application Penetration Test
1. How many web applications are being assessed?
2. How many login systems are being assessed?
3. How many static pages are being assessed? (approximate)
4. How many dynamic pages are being assessed? (approximate)
5. Will the source code be available?
6. Will there be any kind of documentation? If yes, what kind of documentation?
7. Will static analysis be performed on this application?
8. Does the client want fuzzing performed against this application?
9. Does the client want role-based testing performed against this application?
10. Does the client want credentialed scans of web applications performed?

# Wireless Network Penetration Test
1. How many wireless networks are in place?
2. Is a guest wireless network used?
	1. Does the guest network require authentication?
	2. What type of encryption is used on the wireless networks? (WPA/WPA2 PSK) Frequency 2.4 GHz
	3. What is the square footage of coverage?
	4. Will enumeration of rogue devices be necessary?
	5. Will the team be assessing wireless attacks against clients?
	6. Approximately how many clients will be using the wireless network?

# Social Engineering
1. Does the client have a list of email addresses they would like a Social Engineering attack to be performed against?
2. Does the client have a list of phone numbers they would like a Social Engineering attack to be performed against?
3. Is Social Engineering for the purpose of gaining unauthorized physical access approved? If so:
	1. How many people will be targeted?
4. testing:
	1. ability to trust
	2. low perception of threat
	3. response to authority
	4. susceptibility to react with fear or excitement in different situations

# Physical Penetration Test
1. How many locations are being assessed?
2. Are there any security guards that will need to be bypassed?
	1. Are the security guards employed through a 3rd party?
	2. Are they armed?
	3. Are they allowed to use force?
3. How many entrances are there into the building?
4. Is the use of lock picks or bump keys allowed? (also consider local laws)
5. Is the purpose of this test to verify compliance with existing policies and procedures or for performing an audit?
6. What is the square footage of the area in scope?
7. Are all physical security measures documented?
8. Should the team attempt to gain access to where the video camera data is stored?
9. Is there an armed alarm system being used?
	1. Is the alarm a silent alarm?
	2. Is the alarm triggered by motion?
	3. Is the alarm triggered by opening of doors and windows?

# Business Unit Managers
1. Is the manager aware that a test is about to be performed?
2. What is the data that would create the greatest risk to the organization if exposed, corrupted, or deleted?
3. Are testing and validation procedures to verify that business applications are functioning properly in place?
4. Will the testers have access to the Quality Assurance testing procedures from when the application was first developed?
5. Are Disaster Recovery Procedures in place for the application data?

# Systems Administrators
1. Are there any systems which could be characterized as fragile? (systems with tendencies to crash, older operating systems, or which are unpatched)
2. Are Change Management procedures in place?
3. What is the mean time to repair systems outages?
4. Is any system monitoring software in place?
5. What are the most critical servers and applications?
6. Are backups tested on a regular basis?
7. When was the last time the backups were restored?