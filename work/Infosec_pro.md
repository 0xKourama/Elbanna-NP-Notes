# What are the correct steps to apply the concept of least privilege?
1. collecting information about roles and access requirements
2. translating the roles to privileges
3. implementing the change without disrupting business (seamlessly)

# what are courses that have brief supporting material?
1. https://app.pluralsight.com/library/courses/cyber-security-executive-briefing/table-of-contents


# Cybersecurity roles:
https://app.pluralsight.com/library/courses/cyber-security-careers-it-professionals/table-of-contents
## Understanding Cyber Security Job Roles
## Landing Your First Cyber Security Job

# what is proper security?
*ensuring that only the intended function is carried out by the intended person*

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
1. Exploitability
	1. exploit available online?
	2. exploit needs credentials?
	3. exploit detectable?
2. Impact (direct/indirect)
	1. Data
	2. service
3. Likelihood

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

# Company Assets

## Employees
Increasing cybersecurity awareness
1. phishing
2. supply chain attacks
3. malicious links
4. emergency drill (what to do)
5. adware, scareware

## Firewalls
Palo Alto

## Mail Gateway
IMSVA

## Cloud Security (VCloud):
https://www.mcafee.com/enterprise/en-us/security-awareness/cloud/cloud-security-best-practices.html

## Storage:
Unisphere
iDRAC
Best practices article:
https://cypressdatadefense.com/blog/data-storage-security-best-practices/

## Vcenter
https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.security.doc/GUID-3F7F045A-C4E6-4891-9859-1FAC54E85E9D.html

## ESXi/IPMI Security
https://blog.netwrix.com/2020/01/16/vmware-security-best-practices/

## NSX Security


## Active Directory
https://adsecurity.org/
https://www.pentesteracademy.com > Attacking and Defending Active Directory

## Network security
https://app.pluralsight.com/library/courses/network-security-fundamentals/table-of-contents
1. DoS
2. MiTM --> improving encryption
3. removing unnecessary ports
### Network Monitoring:
https://app.pluralsight.com/library/courses/security-onion-network-security-monitoring/table-of-contents

## Exchange Security:
https://searchsecurity.techtarget.com/tip/12-Microsoft-Exchange-Server-security-best-practices

## Linux Host Security:
https://app.pluralsight.com/library/courses/security-network-host-lfce/table-of-contents

## Windows Host Security:
- https://app.pluralsight.com/library/courses/windows-server-2016-security-hardening/table-of-contents
- https://app.pluralsight.com/library/courses/windows-10-internals-threads-memory-security/table-of-contents

## Web Application Security:
- .NET security best practices (https://www.syncfusion.com/blogs/post/10-practices-secure-asp-net-core-mvc-app.aspx) (https://docs.microsoft.com/en-us/dotnet/standard/security/)
- Source Code review
- SDL
(https://app.pluralsight.com/library/courses/security-hackers-developers/table-of-contents)

## Webserver Security (Apache/IIS/NginX):
- https://www.upguard.com/blog/10-steps-for-improving-iis-security

## AWS S3 Storage
- https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html

## Mobile devices security
- https://app.pluralsight.com/library/courses/security-awareness-mobile-devices/table-of-contents

## Backup Security
*backups are equal in importance to the real data. securing backups is equally important*

## Achieving Security Compliance with worldwide standards
### Big picture
- https://app.pluralsight.com/library/courses/security-compliance-big-picture/table-of-contents

1. GDPR (https://gdpr.eu/checklist/) (https://app.pluralsight.com/library/courses/gdpr-big-picture)
2. ISO 27001 (https://app.pluralsight.com/library/courses/iso-iec-27001-information-security/table-of-contents)
3. CIS Controls (https://app.pluralsight.com/library/courses/implementing-cis-critical-security-controls/table-of-contents)

### Resources:
- https://app.pluralsight.com/paths/skill/survey-of-information-security-skill

# NIST Framework:
1. Identify --> data collection
2. Protect  --> try all known attacks --> apply best practices
3. Detect   --> logs
4. Respond  --> attack pattern identificaion (Incident response)
	https://app.pluralsight.com/library/courses/security-event-triage-operationalizing-security-analysis/table-of-contents
5. Recover  --> backup strategy