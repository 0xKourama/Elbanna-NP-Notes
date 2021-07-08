# Hacking steps:
1. enumeration
2. exploitation
3. privilege escalation
4. persistence

# what are the most likely points of attack?
1. web applications (Tools, CloudSpace, MyCloud)

# what is proper security?
*ensuring that only the intended functions are carried out by the intended person*
_authentication & limitation_
- https://app.pluralsight.com/library/courses/security-engineering/table-of-contents

# What are the correct steps to apply the concept of least privilege?
1. collecting information about roles and access requirements
2. translating the roles to privileges
3. implementing the change without disrupting business (seamlessly)

# what are courses that have brief supporting material?
1. https://app.pluralsight.com/library/courses/cyber-security-executive-briefing/table-of-contents

# Cybersecurity roles:
- https://app.pluralsight.com/library/courses/cyber-security-careers-it-professionals/table-of-contents
## Understanding Cyber Security Job Roles
## Landing Your First Cyber Security Job

# what is done in exploitation?
1. what can we do with the functionality we have?
2. what are the changes we can do to our input to alter the intened function?
3. what safety measures are there to ensure only the intended function to be carried out?

# what do I need to do to properly measure risk?
1. measure probability of a bad event to happen

# what are the risk types?
1. data exposure
2. breach
3. outage

# what data is publicly accessible?
1. developers

# what are the factors to be considered when measuring risk?
1. What initial access is required to carry out the attack?
2. Exploitability
	1. exploit available online?
	2. exploit needs credentials?
	3. exploit detectable?
3. Impact (direct/indirect)
	1. Data
	2. service
4. Likelihood
5. Ransomwareable?

# Phases
1. External
	1. portscan DNatted IPs
	2. Misuse tools process for approval on mail access
	3. limit egypt for hamad environment
2. Internal
	1. portscan

*what's the point in choosing internal before external?*

# Risk assessment:
https://app.pluralsight.com/library/courses/security-risk-management-concepts-principles-cissp

# General guidelines:
1. Encryption strength --> protect against MiTM
2. Authentication      --> MFA and reducing impact of password attacks
3. Least privilege concept
4. Isolate management plane

# Protection against RansomWare:
- https://app.pluralsight.com/library/courses/advanced-malware-analysis-ransomware/table-of-contents

# Company Assets

## Employees
Increasing cybersecurity awareness
*demonstrations*
1. phishing (PDF attacks, Macro Attacks)
2. supply chain attacks
3. malicious links
4. emergency drill (what to do)
5. adware, scareware
- https://app.pluralsight.com/paths/skills/security-awareness-for-business-professionals-skill
- https://app.pluralsight.com/library/courses/end-user-security-awareness/table-of-contents

## Cloud Security (VCloud and Tennant Security):
- https://app.pluralsight.com/library/courses/cloud-computing-security-challenge/table-of-contents
- https://www.mcafee.com/enterprise/en-us/security-awareness/cloud/cloud-security-best-practices.html
- https://www.youtube.com/watch?v=2so9QONW75c

## Storage:
- Unisphere
- iDRAC
## Best practices article:
- https://cypressdatadefense.com/blog/data-storage-security-best-practices/
## iSCSI Security:
- Authenticaion: CHAP (weak)
- Authorization: Initiator Node names (spoof-able)
- Encryption - IPSec shared secret (deployment challenges)
## What makes iSCSI important?
- 1 iSCSI compromised = more than one operating system compromised
- full data store compromised is more dangerous than compromising accounts

## VCenter
- https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.security.doc/GUID-3F7F045A-C4E6-4891-9859-1FAC54E85E9D.html
- https://app.pluralsight.com/library/courses/vsphere-6-datacenter-security/table-of-contents
- https://app.pluralsight.com/library/courses/vsphere-6-5-foundations-perform-basic-monitoring/table-of-contents
- https://app.pluralsight.com/paths/skills/implementing-and-managing-vmware-vsphere

## ESXi/IPMI Security
- https://blog.netwrix.com/2020/01/16/vmware-security-best-practices/
### IP Spoofing Attack
- https://www.cloudflare.com/learning/ddos/glossary/ip-spoofing/
https://www.kaspersky.com/resource-center/threats/ip-spoofing

## NSX Security
- https://video.algosec.com/lesson-3-best-practices-for

## Active Directory
- https://adsecurity.org/
- https://www.pentesteracademy.com > Attacking and Defending Active Directory
- https://app.pluralsight.com/library/courses/troubleshooting-security-active-directory/table-of-contents

## Network security
- https://app.pluralsight.com/library/courses/maximizing-nmap-security-auditing/table-of-contents
- https://app.pluralsight.com/library/courses/network-security-fundamentals/table-of-contents
- https://app.pluralsight.com/library/courses/zero-trust-networking-big-picture/table-of-contents
1. DoS
2. MiTM --> improving encryption
3. removing unnecessary ports
### Palo Alto
- Optimization
### Network Monitoring:
- https://app.pluralsight.com/library/courses/monitoring-analysis-network-cnd/table-of-contents
- https://app.pluralsight.com/library/courses/security-onion-network-security-monitoring/table-of-contents

## Exchange Security:
- https://searchsecurity.techtarget.com/tip/12-Microsoft-Exchange-Server-security-best-practices
- https://app.pluralsight.com/library/courses/designing-deploying-exchange-2016-70-345-recipients/table-of-contents

## Database Security:
- https://app.pluralsight.com/library/courses/sql-server-compliance-and-auditing/table-of-contents
- https://app.pluralsight.com/library/courses/software-development-security/table-of-contents

## Linux Security:
- https://app.pluralsight.com/library/courses/security-network-host-lfce/table-of-contents
- https://app.pluralsight.com/library/courses/security-network-host-lfce/table-of-contents

## Windows Security:
- https://app.pluralsight.com/library/courses/windows-server-2016-security-hardening/table-of-contents
- https://app.pluralsight.com/library/courses/windows-10-internals-threads-memory-security/table-of-contents
- https://app.pluralsight.com/library/courses/linux-system-security-lpic-2/table-of-contents
- https://app.pluralsight.com/library/courses/windows-server-2016-auditing-security-practices/table-of-contents
- https://app.pluralsight.com/library/courses/securing-windows-server-2019/table-of-contents
- https://app.pluralsight.com/library/courses/windows-server-2016-identity-federation-access-solutions/table-of-contents
- https://app.pluralsight.com/library/courses/windows-server-2019-efs-bitlocker-encryption/table-of-contents
- https://app.pluralsight.com/library/courses/managing-privileged-identities-windows-server-2016/table-of-contents

## Web Application Security:
- https://app.pluralsight.com/paths/skills/web-application-penetration-testing
- https://app.pluralsight.com/library/courses/downgrade-attacks-in-apps-stop-man-in-the-middle/table-of-contents
### scan automation:
- https://app.pluralsight.com/library/courses/automate-web-app-scans-owasp-zap-python/table-of-contents
### Security resources
- https://app.pluralsight.com/guides/must-known-web-security-risks-for-developers
- https://app.pluralsight.com/library/courses/secure-account-authentication-practices-asp-dot-net-core/table-of-contents
- .NET security best practices (https://www.syncfusion.com/blogs/post/10-practices-secure-asp-net-core-mvc-app.aspx) (https://docs.microsoft.com/en-us/dotnet/standard/security/)
- https://app.pluralsight.com/library/courses/securing-application-secrets-in-asp-net-core/table-of-contents
- https://app.pluralsight.com/library/courses/dotnet-cryptography-secure-applications/table-of-contents
- https://app.pluralsight.com/library/courses/aspdotnet-security-secrets-revealed/table-of-contents
- https://app.pluralsight.com/library/courses/asp-dot-net-and-core-configuring-security-headers/table-of-contents
- https://app.pluralsight.com/library/courses/securely-handling-errors-logging-events-aspdotnet-aspdotnet-core/table-of-contents
- https://app.pluralsight.com/library/courses/using-security-analysis-tools-protect-aspdotnet-core-applications/table-of-contents
- Source Code review
- SDL (https://app.pluralsight.com/library/courses/security-hackers-developers/table-of-contents)
- https://app.pluralsight.com/library/courses/software-development-security-cissp-cert/table-of-contents
- https://app.pluralsight.com/paths/skills/web-application-security
- https://app.pluralsight.com/library/courses/defeating-cross-site-scripting-content-security-policy/table-of-contents
- https://app.pluralsight.com/library/courses/php-web-application-security/table-of-contents
- https://app.pluralsight.com/library/courses/code-auditing-security-hackers-developers/table-of-contents

## Webserver Security (Apache/IIS/NginX):
- https://www.upguard.com/blog/10-steps-for-improving-iis-security
- https://app.pluralsight.com/library/courses/auditing-iis-web-servers-security-best-practices
- https://app.pluralsight.com/library/courses/securing-iis-websites/table-of-contents

## AWS S3 Storage
- https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html

## Mobile devices security
- https://app.pluralsight.com/library/courses/security-awareness-mobile-devices/table-of-contents

## Backup Security
*backups are equal in importance to the real data. securing backups is just as important*

## Mail Gateway
- IMSVA

## Achieving Security Compliance with worldwide standards
### Big Picture
- https://app.pluralsight.com/library/courses/security-compliance-big-picture/table-of-contents

1. GDPR (https://gdpr.eu/checklist/) (https://app.pluralsight.com/library/courses/gdpr-big-picture)
2. ISO 27001 (https://app.pluralsight.com/library/courses/iso-iec-27001-information-security/table-of-contents) (https://app.pluralsight.com/library/courses/information-security-threats-risks-iso-iec-27002/table-of-contents) (https://app.pluralsight.com/library/courses/preparing-organization-iso-27001-2013-certification/table-of-contents)
3. CIS Controls (https://app.pluralsight.com/library/courses/implementing-cis-critical-security-controls/table-of-contents)

### Resources:
- https://app.pluralsight.com/library/courses/manage-security-privacy-risk-nist-risk-management-framework/table-of-contents
- https://app.pluralsight.com/library/courses/security-control-assessment/table-of-contents
- https://app.pluralsight.com/library/courses/security-operations/table-of-contents
- https://app.pluralsight.com/paths/skill/survey-of-information-security-skill
- https://app.pluralsight.com/library/courses/security-risks-assessing-mitigating/table-of-contents
- https://app.pluralsight.com/library/courses/risk-assessment-management/table-of-contents

# NIST Framework:
1. Identify --> data collection
2. Protect  --> try all known attacks --> apply best practices
3. Detect   --> logs
4. Respond  --> attack pattern identificaion (Incident response)
	- https://app.pluralsight.com/paths/skills/security-event-triage-skill
	- https://app.pluralsight.com/library/courses/hands-on-incident-response-fundamentals/table-of-contents
5. Recover  --> backup strategy