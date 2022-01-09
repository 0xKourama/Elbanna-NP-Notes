# Controls
1. Inventory and Control of Enterprise Assets
2. Inventory and Control of Software Assets
3. Data Protection
4. Secure Configuration of Enterprise Assets and Software
5. Account Management
6. Access Control Management
7. Continuious Vulnerability Management
8. Audit Log Management
9. Email and Web Browser Protections
10. Malware Defenses
11. Data Recovery
12. Network Infrastructure Management
13. Network Monitoring & Defense
14. Security Awareness & Skills Training
15. Service Provider Management
16. Application Software Security
17. Incident Response Management
18. Penetration Testing


# IG1
An IG1 enterprise is small to medium-sized with limited IT **AND** cybersecurity expertise to dedicate towards protecting IT assets **AND** personnel.
The principal concern of these enterprises is to keep the business operational,
- as they have a limited tolerance for downtime.
The sensitivity of the data that they are trying to protect is low **AND** principally surrounds employee **AND** financial information.

**what are the ideas?**
**what are the terms?**

----------------------------------------------------

Safeguards selected for IG1 should be implementable with limited cybersecurity expertise **AND** aimed to thwart general,
- non-targeted attacks.
These Safeguards will also typically be designed to work in conjunction with small **OR** home office commercial off- the-shelf (COTS) hardware **AND** software.

**what are the ideas?**
**what are the terms?**

----------------------------------------------------
# IG2
An IG2 enterprise employs individuals responsible for managing **AND** protecting IT infrastructure.
These enterprises support multiple departments with differing risk profiles based on job function **AND** mission.
Small enterprise units may have regulatory compliance burdens.
IG2 enterprises often store **AND** process sensitive client **OR** enterprise information **AND** **CAN** withstand short interruptions of service.
A major concern is loss of public confidence **IF** a breach occurs.

Safeguards selected for IG2 help security teams cope with increased operational complexity.
Some Safeguards will depend on enterprise-grade technology **AND** specialized expertise to properly install **AND** configure.


**what are the ideas?**
**what are the terms?**

----------------------------------------------------
# IG3
An IG3 enterprise employs security experts that specialize in the different facets of cybersecurity (e.g.,
- risk management,
- penetration testing,
- application security).
IG3 assets **AND** data contain sensitive information **OR** functions that are subject to regulatory **AND** compliance oversight.
An IG3 enterprise **MUST** address availability of services
and the confidentiality **AND** integrity of sensitive data.
Successful attacks **CAN** cause significant harm to the public welfare.

Safeguards selected for IG3 **MUST** abate targeted attacks from a sophisticated adversary **AND** reduce the impact of zero-day attacks.


**what are the ideas?**
**what are the terms?**

----------------------------------------------------
# Inventory and Control of Enterprise Assets
## overview:
Actively manage (inventory,
- track,
- **AND** correct) **ALL** enterprise assets (end-user devices,
- including portable **AND** mobile --> network devices --> non-computing/Internet of Things (IoT) devices --> **AND** servers) connected to the infrastructure physically,
- virtually,
- remotely,
- **AND** those within cloud environments,
- to accurately know the totality of assets that need to be monitored **AND** protected within the enterprise.
This will also support identifying unauthorized **AND** unmanaged assets to remove **OR** remediate

**what are the ideas?**
**what are the terms?**

----------------------------------------------------
## Why is this Control critical?
Enterprises cannot defend what they do **NOT** know they have.
Managed control of **ALL** enterprise assets also plays a critical role in security monitoring,
- incident response,
- system backup,
- **AND** recovery.
Enterprises should know what data is critical to them,
- **AND** proper asset management will help identify those enterprise assets that hold **OR** manage this critical data,
- so that appropriate security controls **CAN** be applied.

External attackers are continuously scanning the internet address space of target enterprises,
- premise-based **OR** in the cloud,
- identifying possibly unprotected assets attached to an enterprise’s network.
Attackers **CAN** take advantage of new assets that are installed,
- yet **NOT** securely configured **AND** patched.
Internally,
- unidentified assets **CAN** also have weak security configurations that **CAN** make them vulnerable to web- **OR** email-based malware --> and,
- adversaries **CAN** leverage weak security configurations for traversing the network,
- once they are inside.

Additional assets that connect to the enterprise’s network (e.g.,
- demonstration systems,
- temporary test systems,
- guest networks) should be identified and/or isolated in order to prevent adversarial access from affecting the security of enterprise operations.

Large,
- complex,
- dynamic enterprises understandably struggle with the challenge of managing intricate,
- fast-changing environments.
However,
- attackers have shown the ability,
- patience,
- **AND** willingness to “inventory **AND** control” our enterprise assets at very large scale in order to support their opportunities.

Another challenge is that portable end-user devices will periodically join a network **AND** then disappear,
- making the inventory of currently available assets very dynamic.
Likewise,
- cloud environments **AND** virtual machines **CAN** be difficult to track in asset inventories **WHEN** they are shut down **OR** paused.

Another benefit of complete enterprise asset management is supporting incident response,
- both **WHEN** investigating the origination of network traffic from an asset on the network **AND** **WHEN** identifying **ALL** potentially vulnerable,
- **OR** impacted,
- assets of similar type **OR** location during an incident.


**what are the ideas?**
**what are the terms?**

----------------------------------------------------
## Procedures and tools
This CIS Control requires both technical **AND** procedural actions,
- united in a process that accounts for,
- **AND** manages the inventory of,
- enterprise assets **AND** **ALL** associated data throughout its life cycle.
It also links to business governance through establishing data/asset owners who are responsible for each component of a business process.
Enterprises **CAN** use large-scale,
- comprehensive enterprise products to maintain IT asset inventories.
Smaller enterprises **CAN** leverage security tools already installed on enterprise assets **OR** used on the network to collect this data.
This includes doing a discovery scan of the network with a vulnerability scanner --> reviewing anti-malware logs,
- logs from endpoint security portals,
- network logs from switches,
- **OR** authentication logs --> **AND** managing the results in a spreadsheet **OR** database.
Maintaining a current **AND** accurate view of enterprise assets is an ongoing **AND** dynamic process.
Even for enterprises,
- there is rarely a single source of truth,
- as enterprise assets are **NOT** **ALWAYS** provisioned **OR** installed **BY** the IT department.
The reality is that a variety of sources need to be “crowd-sourced” to determine a high- confidence count of enterprise assets.
Enterprises **CAN** actively scan on a regular basis,
- sending a variety of different packet types to identify assets connected to the network.
In addition to asset sources mentioned above for small enterprises,
- larger
enterprises **CAN** collect data from cloud portals **AND** logs from enterprise platforms such as: Active Directory (AD),
- Single Sign-On (SSO),
- Multi-Factor Authentication (MFA),
- Virtual Private Network (VPN),
- Intrusion Detection Systems (IDS) **OR** Deep Packet Inspection (DPI),
- Mobile Device Management (MDM),
- **AND** vulnerability scanning
tools.
Property inventory databases,
- purchase order tracking,
- **AND** local inventory lists are other sources of data to determine **WHICH** devices are connected.
There are tools **AND** methods that normalize this data to identify devices that are unique among these sources.


**what are the ideas?**
**what are the terms?**

----------------------------------------------------
## Safeguards
### Establish and Maintain Detailed Enterprise Asset Inventory
Establish **AND** maintain an accurate,
- detailed,
- **AND** up-to-date inventory of **ALL** enterprise assets with the potential to store **OR** process data,
- to include: end-user devices (including portable **AND** mobile),
- network devices,
- non-
computing/IoT devices,
- **AND** servers.
Ensure the inventory records the network address (if static),
- hardware address,
- machine name,
- enterprise asset owner,
- department for each asset,
- **AND** whether the asset has been approved to connect to the network.
For mobile end-user devices,
- MDM type tools **CAN** support this process,
- where appropriate.
This inventory includes assets connected to the infrastructure physically,
- virtually,
- remotely,
- **AND** those within cloud environments.
Additionally,
- it includes assets that are regularly connected to the enterprise’s network infrastructure,
- even **IF** they are **NOT** under control of the enterprise.
Review **AND** update the inventory of **ALL** enterprise assets
bi-annually,
- **OR** more frequently.


**what are the ideas?**
**what are the terms?**

----------------------------------------------------
### Address Unauthorized Assets
Ensure that a process exists to address unauthorized assets on a weekly basis.
The enterprise may choose to remove the asset from the network,
- deny the asset from connecting remotely to the network,
- **OR** quarantine the asset.

**what are the ideas?**
**what are the terms?**

----------------------------------------------------
### Utilize an Active Discovery Tool

Utilize an active discovery tool to identify assets connected to the enterprise’s network.
Configure the active discovery tool to execute daily,
- **OR** more frequently

**what are the ideas?**
**what are the terms?**

----------------------------------------------------
### Use Dynamic Host Configuration Protocol (DHCP) Logging to Update Enterprise Asset Inventory
Use DHCP logging on **ALL** DHCP servers **OR** Internet Protocol (IP) address management tools to update the enterprise’s asset inventory.
Review **AND** use logs to update the enterprise’s asset inventory weekly,
- **OR** more frequently.

**what are the ideas?**
**what are the terms?**

----------------------------------------------------
### Use a Passive Asset Discovery Tool
Use a passive discovery tool to identify assets connected to the enterprise’s network.
Review **AND** use scans to update the enterprise’s asset inventory **AT LEAST** weekly,
- **OR** more frequently.


**what are the ideas?**
**what are the terms?**

----------------------------------------------------
# Control 02: Inventory and Control of Software Assets
## overview
Actively manage (inventory,
- track,
- **AND** correct) **ALL** software (operating systems **AND** applications) on the network so that **ONLY** authorized software is installed **AND** **CAN** execute,
- **AND** that unauthorized **AND** unmanaged software is found **AND** prevented from installation **OR** execution.

**what are the ideas?**
**what are the terms?**

----------------------------------------------------
## Why is this Control critical?
A complete software inventory is a critical foundation for preventing attacks.
Attackers continuously scan target enterprises looking for vulnerable versions of software
that **CAN** be remotely exploited.
For example,
- **IF** a user opens a malicious website **OR** attachment with a vulnerable browser,
- an attacker **CAN** often install backdoor programs **AND** bots that give the attacker long-term control of the system.
Attackers **CAN** also
use this access to move laterally through the network.
One of the key defenses against these attacks is updating **AND** patching software.
However,
- without a complete inventory of software assets,
- an enterprise cannot determine **IF** they have vulnerable software,
- **OR** **IF** there are potential licensing violations.

Even **IF** a patch is **NOT** yet available,
- a complete software inventory list allows an enterprise to guard against known attacks **UNTILL** the patch is released.
Some
sophisticated attackers use “zero-day exploits,” **WHICH** take advantage of previously unknown vulnerabilities that have yet to have a patch released from the software vendor.
Depending on the severity of the exploit,
- an enterprise **CAN** implement temporary mitigation measures to guard against attacks **UNTILL** the patch is released.

Management of software assets is also important to identify unnecessary security risks.
An enterprise should review its software inventory to identify any enterprise assets running software that is **NOT** needed for business purposes.
For example,
- an enterprise asset may come installed with default software that creates a potential security risk **AND** provides no benefit to the enterprise.
It is critical to inventory,
- understand,
- assess,
- **AND** manage **ALL** software connected to an enterprise’s infrastructure.


**what are the ideas?**
**what are the terms?**

----------------------------------------------------
## Procedures and tools
Allowlisting **CAN** be implemented using a combination of commercial allowlisting tools,
- policies,
- **OR** application execution tools that come with anti-malware suites **AND** popular operating systems.
Commercial software inventory tools are widely available **AND** used in many enterprises today.
The best of these tools provides an inventory check of hundreds of common software used in enterprises.
The tools pull information about the patch level of each installed program to ensure that it is the latest version **AND** leverage standardized application names,
- such as those found in the Common Platform Enumeration (CPE) specification.
One example of a method that **CAN** be used is the Security Content Automation Protocol (SCAP).
Additional information on SCAP **CAN** be found here: https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.
SP.800-126r3.pdf

Features that implement allowlists are included in many modern endpoint security suites **AND** even natively implemented in certain versions of major operating systems.
Moreover,
- commercial solutions are increasingly bundling together anti-malware,
- anti- spyware,
- personal firewall,
- **AND** host-based IDS **AND** Intrusion Prevention System (IPS),
- along with application allow **AND** block listing.
In particular,
- most endpoint security solutions **CAN** look at the name,
- file system location,
- and/or cryptographic hash of a given executable to determine whether the application should be allowed to run on the protected machine.
The most effective of these tools offer custom allowlists based on executable path,
- hash,
- **OR** regular expression matching.
Some even include a non- malicious,
- yet unapproved,
- applications function that allows administrators to define rules for execution of specific software for certain users **AND** at certain times of the day.


**what are the ideas?**
**what are the terms?**

----------------------------------------------------
## Safeguards
### Establish and Maintain a Software Inventory
Establish **AND** maintain a detailed inventory of **ALL** licensed software installed on enterprise assets.
The software inventory **MUST** document the title,
- publisher,
- initial install/use date,
- **AND** business purpose for each entry --> where appropriate,
- include the Uniform Resource Locator (URL),
- app store(s),
- version(s),
- deployment mechanism,
- **AND** decommission date.
Review **AND** update the software inventory bi-annually,
- **OR** more frequently.


**what are the ideas?**
**what are the terms?**

----------------------------------------------------
### Ensure Authorized Software is Currently Supported
Ensure that **ONLY** currently supported software is designated as authorized in the software inventory for enterprise assets.
If software is unsupported,
- yet necessary for the fulfillment of the enterprise’s mission,
- document an exception detailing mitigating controls **AND** residual risk acceptance.
For any unsupported software without an exception documentation,
- designate as unauthorized.
Review the software list to verify software support **AT LEAST** monthly,
- **OR** more frequently.

**what are the ideas?**
**what are the terms?**

----------------------------------------------------
### Address Unauthorized Software
Ensure that unauthorized software is **EITHER** removed from use on enterprise assets **OR** receives a documented exception.
Review monthly,
- **OR** more frequently.

**what are the ideas?**
**what are the terms?**

----------------------------------------------------
### Utilize Automated Software Inventory Tools
Utilize software inventory tools,
- **WHEN** possible,
- throughout the enterprise to automate the discovery **AND** documentation of installed software.

**what are the ideas?**
**what are the terms?**

----------------------------------------------------
### Allowlist Authorized Software
Use technical controls,
- such as application allowlisting,
- to ensure that **ONLY** authorized software **CAN** execute **OR** be accessed.
Reassess bi-annually,
- **OR** more frequently.


**what are the ideas?**
**what are the terms?**

----------------------------------------------------
### Allowlist Authorized Libraries
Use technical controls to ensure that **ONLY** authorized software libraries,
- such as specific .dll,
- .ocx,
- .so,
- etc.,
- files are allowed to load into a system process.
Block unauthorized libraries from loading into a system process.
Reassess bi-annually,
- **OR** more frequently.


**what are the ideas?**
**what are the terms?**

----------------------------------------------------
### Allowlist Authorized Scripts
Use technical controls,
- such as digital signatures **AND** version control,
- to ensure that **ONLY** authorized scripts,
- such as specific .ps1,
- .py,
- etc.,
- files are allowed to execute.
Block unauthorized scripts from executing.
Reassess bi-annually,
- **OR** more frequently.


**what are the ideas?**
**what are the terms?**

----------------------------------------------------


# Data Protection
## overview
Develop processes **AND** technical controls to identify,
- classify,
- securely handle,
- retain,
- **AND** dispose of data.
## Why is this Control critical?
Data is no longer **ONLY** contained within an enterprise’s border --> it is in the cloud,
- on portable end-user devices where users work from home,
- **AND** is often shared with partners **OR** online services that might have it anywhere in the world.
In addition
to sensitive data an enterprise holds related to finances,
- intellectual property,
- **AND** customer data,
- there also might be numerous international regulations for protection of personal data.
Data privacy has become increasingly important,
- **AND** enterprises are learning that privacy is about the appropriate use **AND** management of data,
- **NOT** just encryption.
Data **MUST** be appropriately managed through its entire life cycle.
These privacy rules **CAN** be complicated for multi-national enterprises of any size --> however,
- there are fundamentals that **CAN** apply to all.
Once attackers have penetrated an enterprise’s infrastructure,
- one of their first tasks is to find **AND** exfiltrate data.
Enterprises might **NOT** be aware that sensitive data is leaving their environment because they are **NOT** monitoring data outflows.

While many attacks occur on the network,
- others involve physical theft of portable
end-user devices,
- attacks on service providers **OR** other partners holding sensitive data.
Other sensitive enterprise assets may also include non-computing devices that provide management **AND** control of physical systems,
- such as Supervisory Control **AND** Data Acquisition (SCADA) systems.

The enterprise’s loss of control over protected **OR** sensitive data is a serious **AND** often reportable business impact.
While some data is compromised **OR** lost as a result of theft **OR** espionage,
- the vast majority are a result of poorly understood data management rules,
- **AND** user error.
The adoption of data encryption,
- both in transit **AND** at rest,
can provide mitigation against data compromise,
- and,
- even more important,
- it is a regulatory requirement for most controlled data.

## Procedures and tools
It is important for an enterprise to develop a data management process that includes a data management framework,
- data classification guidelines,
- **AND** requirements
for protection,
- handling,
- retention,
- **AND** disposal of data.
There should also be a data breach process that plugs into the incident response plan,
- **AND** the compliance **AND** communication plans.
To derive data sensitivity levels,
- enterprises need to catalog their key types of data **AND** the overall criticality (impact to its loss **OR** corruption) to the enterprise.
This analysis would be used to create an overall data classification scheme for the enterprise.
Enterprises may use labels,
- such as “Sensitive,” “Confidential,” **AND** “Public,” **AND** classify their data according to those labels.

Once the sensitivity of the data has been defined,
- a data inventory **OR** mapping should be developed that identifies software accessing data at various sensitivity levels **AND** the enterprise assets that house those applications.
Ideally,
- the network would be separated so that enterprise assets of the same sensitivity level are on the same network **AND** separated from enterprise assets with different sensitivity levels.
If
possible,
- firewalls need to control access to each segment,
- **AND** have user access rules applied to **ONLY** allow those with a business need to access the data.

## Safeguards
### Establish and Maintain a Data Management Process
Establish **AND** maintain a data management process.
In the process,
- address data sensitivity,
- data owner,
- handling of data,
- data retention limits,
- **AND** disposal requirements,
- based on sensitivity **AND** retention standards for the enterprise.
Review **AND** update documentation annually,
- **OR** **WHEN** significant enterprise changes occur that could impact this Safeguard.
----------------------------------------------------
### Establish and Maintain a Data Inventory
Establish **AND** maintain a data inventory,
- based on the enterprise’s data management process.
Inventory sensitive data,
- at a minimum.
Review **AND** update inventory annually,
- at a minimum,
- with a priority on sensitive data.

----------------------------------------------------
### Configure Data Access Control Lists
Configure data access control lists based on a user’s need to know.
Apply data access control lists,
- also known as access permissions,
- to local **AND** remote file systems,
- databases,
- **AND** applications.

----------------------------------------------------
### Enforce Data Retention
Retain data according to the enterprise’s data management process.
Data retention **MUST** include both minimum **AND** maximum timelines.

----------------------------------------------------
### Securely Dispose of Data
Securely dispose of data as outlined in the enterprise’s data management process.
Ensure the disposal process **AND** method are commensurate with the data sensitivity.

----------------------------------------------------
### Encrypt Data on End-User Devices
Encrypt data on end-user devices containing sensitive data.
Example implementations **CAN** include: Windows BitLocker®,
- Apple FileVault®,
- Linux® dm-crypt.

----------------------------------------------------
### Establish and Maintain a Data Classification Scheme
Establish **AND** maintain an overall data classification scheme for the enterprise.
Enterprises may use labels,
- such as “Sensitive,” “Confidential,” **AND** “Public,” **AND** classify their data according to those labels.
Review **AND** update the classification scheme annually,
- **OR** **WHEN** significant enterprise changes occur that could impact this Safeguard.

----------------------------------------------------
### Document Data Flows
Document data flows.
Data flow documentation includes service provider data flows **AND** should be based on the enterprise’s data management process.
Review **AND** update documentation annually,
- **OR** **WHEN** significant enterprise changes occur that could impact this Safeguard.

----------------------------------------------------
### Encrypt Data on Removable Media
Encrypt data on removable media.

----------------------------------------------------
### Encrypt Sensitive Data in Transit
Encrypt sensitive data in transit.
Example implementations **CAN** include: Transport Layer Security (TLS) **AND** Open Secure Shell (OpenSSH).

----------------------------------------------------
### Encrypt Sensitive Data at Rest
Encrypt sensitive data at rest on servers,
- applications,
- **AND** databases containing sensitive data.
Storage-layer encryption,
- also known as server-side encryption,
- meets the minimum requirement of this Safeguard.
Additional encryption methods may include application-layer encryption,
- also known as client-side encryption,
- where access to the data storage device(s) does **NOT** permit access to the plain-text data.

----------------------------------------------------
### Segment Data Processing and Storage Based on Sensitivity
Segment data processing **AND** storage based on the sensitivity of the data.
Do **NOT** process sensitive data on enterprise assets intended for lower sensitivity data.

----------------------------------------------------
### Deploy a Data Loss Prevention Solution
Implement an automated tool,
- such as a host-based Data Loss Prevention (DLP) tool to identify **ALL** sensitive data stored,
- processed,
- **OR** transmitted through enterprise assets,
- including those located onsite **OR** at a remote service provider,
- **AND** update the enterprise’s sensitive data inventory.

----------------------------------------------------
### Log Sensitive Data Access
Log sensitive data access,
- including modification **AND** disposal.

----------------------------------------------------
# 04 Secure Configuration of Enterprise Assets and Software
## overview
Establish **AND** maintain the secure configuration of enterprise assets (end-user devices,
- including portable **AND** mobile --> network devices --> non-computing/IoT devices --> **AND** servers) **AND** software (operating systems **AND** applications).
----------------------------------------------------
## Why is this Control critical?
As delivered from manufacturers **AND** resellers,
- the default configurations for enterprise assets **AND** software are normally geared towards ease-of-deployment **AND** ease-of- use rather than security.
Basic controls,
- open services **AND** ports,
- default accounts **OR** passwords,
- pre-configured Domain Name System (DNS) settings,
- older (vulnerable) protocols,
- **AND** pre-installation of unnecessary software **CAN** **ALL** be exploitable **IF** left in their default state.
Further,
- these security configuration updates need to be managed **AND** maintained over the life cycle of enterprise assets **AND** software.
Configuration
updates need to be tracked **AND** approved through configuration management workflow process to maintain a record that **CAN** be reviewed for compliance,
- leveraged for incident response,
- **AND** to support audits.
This CIS Control is important to on-premises devices,
- as well as remote devices,
- network devices,
- **AND** cloud environments.
Service providers play a key role in modern infrastructures,
- especially for smaller enterprises.
They often are **NOT** set up **BY** default in the most secure configuration to provide flexibility for their customers to apply their own security policies.
**THEREFORE**,
- the presence of default accounts **OR** passwords,
- excessive access,
- **OR** unnecessary
services are common in default configurations.
These could introduce weaknesses that are under the responsibility of the enterprise that is using the software,
- rather than the service provider.
This extends to ongoing management **AND** updates,
- as some Platform as a Service (PaaS) **ONLY** extend to the operating system,
- so patching **AND** updating hosted applications are under the responsibility of the enterprise.

Even after a strong initial configuration is developed **AND** applied,
- it **MUST** be continually managed to avoid degrading security as software is updated **OR** patched,
- new security vulnerabilities are reported,
- **AND** configurations are “tweaked,” to allow the installation of new software **OR** to support new operational requirements.

----------------------------------------------------
## Procedures and tools
There are many available security baselines for each system.
Enterprises should start with these publicly developed,
- vetted,
- **AND** supported security benchmarks,
- security guides,
- **OR** checklists.
Some resources include:

The CIS Benchmarks™ Program – http://www.cisecurity.org/cis-benchmarks/
The National Institute of Standards **AND** Technology (NIST®) National Checklist Program Repository – https://nvd.nist.gov/ncp/repository

Enterprises should augment **OR** adjust these baselines to satisfy enterprise security policies,
- **AND** industry **AND** government regulatory requirements.
Deviations of standard configurations **AND** rationale should be documented to facilitate future reviews **OR** audits.

For a larger **OR** more complex enterprise,
- there will be multiple security baseline configurations based on security requirements **OR** classification of the data on the enterprise asset.
Here is an example of the steps to build a secure baseline image:

⦁	Determine the risk classification of the data handled/stored on the enterprise asset (e.g.,
- high,
- moderate,
- low risk).
⦁	Create a security configuration script that sets system security settings to meet the requirements to protect the data used on the enterprise asset.
Use benchmarks,
- such as the ones described earlier in this section.
⦁	Install the base operating system software.
⦁	Apply appropriate operating system **AND** security patches.
⦁	Install appropriate application software packages,
- tool,
- **AND** utilities.
⦁	Apply appropriate updates to software installed in Step 4.
⦁	Install local customization scripts to this image.
⦁	Run the security script created in Step 2 to set the appropriate security level.
⦁	Run a SCAP compliant tool to record/score the system setting of the baseline image.
⦁	Perform a security quality assurance test.
⦁	Save this base image in a secure location.

Commercial and/or free configuration management tools,
- such as the CIS Configuration Assessment Tool (CIS-CAT®) https://learn.cisecurity.org/cis-cat-lite,
- **CAN** be
deployed to measure the settings of operating systems **AND** applications of managed machines to look for deviations from the standard image configurations.
Commercial configuration management tools use some combination of an agent installed on each managed system,
- **OR** agentless inspection of systems through remotely logging into each enterprise asset using administrator credentials.
Additionally,
- a hybrid approach is sometimes used whereby a remote session is initiated,
- a temporary **OR** dynamic agent is deployed on the target system for the scan,
- **AND** then the agent is removed
----------------------------------------------------
# 05 Account management
## Overview
Use processes **AND** tools to assign **AND** manage authorization to credentials for user accounts,
- including administrator accounts,
- as well as service accounts,
- to enterprise assets **AND** software.
----------------------------------------------------
## Why is this Control critical?
It is easier for an external **OR** internal threat actor to gain unauthorized access to enterprise assets **OR** data through using valid user credentials than through “hacking” the environment.
There are many ways to covertly obtain access to user accounts,
- including: weak passwords,
- accounts still valid after a user leaves the enterprise,
- dormant **OR** lingering test accounts,
- shared accounts that have **NOT** been changed in months **OR** years,
- service accounts embedded in applications for scripts,
- a user having the same password as one they use for an online account that has been compromised (in a public password dump),
- social engineering a user to give their password,
- **OR** using malware to capture passwords **OR** tokens in memory **OR** over the network.

Administrative,
- **OR** highly privileged,
- accounts are a particular target,
- because they allow attackers to add other accounts,
- **OR** make changes to assets that could make them more vulnerable to other attacks.
Service accounts are also sensitive,
- as they are often shared among teams,
- internal **AND** external to the enterprise,
- **AND** sometimes **NOT** known about,
- **ONLY** to be revealed in standard account management audits.

Finally,
- account logging **AND** monitoring is a critical component of security operations.
While account logging **AND** monitoring are covered in CIS Control 8 (Audit Log Management),
- it is important in the development of a comprehensive Identity **AND** Access Management (IAM) program.

----------------------------------------------------
## Procedures and tools
Credentials are assets that **MUST** be inventoried **AND** tracked like enterprise assets **AND** software,
- as they are the primary entry point into the enterprise.
Appropriate password policies **AND** guidance **NOT** to reuse passwords should be developed.

→ For guidance on the creation **AND** use of passwords,
- reference the CIS Password Policy Guide – https://www.cisecurity.org/white-papers/cis- password-policy-guide/

Accounts **MUST** also be tracked --> any account that is dormant **MUST** be disabled **AND** eventually removed from the system.
There should be periodic audits to ensure **ALL** active accounts are traced back to authorized users of the enterprise asset.
Look for new accounts added since previous review,
- especially administrator **AND** service
accounts.
Close attention should be made to identify **AND** track administrative,
- **OR** high- privileged accounts **AND** service accounts.

Users with administrator **OR** other privileged access should have separate accounts for those higher authority tasks.
These accounts would **ONLY** be used **WHEN** performing those tasks **OR** accessing especially sensitive data,
- to reduce risk in case their normal user account is compromised.
For users with multiple accounts,
- their base user account,
- used day-to-day for non-administrative tasks,
- should **NOT** have any elevated privileges.

Single Sign-On (SSO) is convenient **AND** secure **WHEN** an enterprise has many applications,
- including cloud applications,
- **WHICH** helps reduce the number of passwords a user **MUST** manage.
Users are recommended to use password manager applications to securely store their passwords,
- **AND** should be instructed **NOT** to keep them in spreadsheets **OR** text files on their computers.
MFA is recommended for remote access.

Users **MUST** also be automatically logged out of the system after a period of inactivity,
- **AND** be trained to lock their screen **WHEN** they leave their device to minimize the possibility of someone else in physical proximity around the user accessing their system,
- applications,
- **OR** data.

→   An excellent resource is the NIST® Digital Identity Guidelines – https://pages.
nist.gov/800-63-3/

----------------------------------------------------

# 07 Continuous Vulnerability Management
## Overview
Develop a plan to continuously assess **AND** track vulnerabilities on **ALL** enterprise assets within the enterprise’s infrastructure,
- in order to remediate,
- **AND** minimize,
- the window of opportunity for attackers.
Monitor public **AND** private industry sources for new threat **AND** vulnerability information.

----------------------------------------------------
## Why is this Control critical?
Cyber defenders are constantly being challenged from attackers who are looking for vulnerabilities within their infrastructure to exploit **AND** gain access.
Defenders **MUST** have timely threat information available to them about: software updates,
- patches,
- security advisories,
- threat bulletins,
- etc.,
- **AND** they should regularly review their environment to identify these vulnerabilities before the attackers do.
Understanding **AND** managing vulnerabilities is a continuous activity,
- requiring focus of time,
- attention,
- **AND** resources.

Attackers have access to the same information **AND** **CAN** often take advantage of vulnerabilities more quickly than an enterprise **CAN** remediate.
While there is a gap in time from a vulnerability being known to **WHEN** it is patched,
- defenders **CAN** prioritize **WHICH** vulnerabilities are most impactful to the enterprise,
- **OR** likely to be exploited first due to ease of use.
For example,
- **WHEN** researchers **OR** the community report new
vulnerabilities,
- vendors have to develop **AND** deploy patches,
- indicators of compromise (IOCs),
- **AND** updates.
Defenders need to assess the risk of the new vulnerability to the enterprise,
- regression-test patches,
- **AND** install the patch.

There is never perfection in this process.
Attackers might be using an exploit to a vulnerability that is **NOT** known within the security community.
They might have
developed an exploit to this vulnerability referred to as a “zero-day” exploit.
Once the vulnerability is known in the community,
- the process mentioned above starts.
**THEREFORE**,
- defenders **MUST** keep in mind that an exploit might already exist **WHEN** the vulnerability is widely socialized.
Sometimes vulnerabilities might be known within
a closed community (e.g.,
- vendor still developing a fix) for weeks,
- months,
- **OR** years before it is disclosed publicly.
Defenders have to be aware that there might **ALWAYS** be vulnerabilities they cannot remediate,
- **AND** **THEREFORE** need to use other controls to mitigate.

Enterprises that do **NOT** assess their infrastructure for vulnerabilities **AND** proactively address discovered flaws face a significant likelihood of having their enterprise assets compromised.
Defenders face particular challenges in scaling remediation across an entire enterprise,
- **AND** prioritizing actions with conflicting priorities,
- **WHILE** **NOT** impacting the enterprise’s business **OR** mission.

----------------------------------------------------
## Procedures and tools
A large number of vulnerability scanning tools are available to evaluate the security configuration of enterprise assets.
Some enterprises have also found commercial services using remotely managed scanning appliances to be effective.
To help standardize the definitions of discovered vulnerabilities across an enterprise,
- it is preferable to use vulnerability scanning tools that map vulnerabilities to one **OR** more of the following industry-recognized vulnerability,
- configuration **AND** platform classification schemes **AND** languages: Common Vulnerabilities **AND** Exposures (CVE®),
- Common Configuration Enumeration (CCE),
- Open Vulnerability **AND** Assessment Language (OVAL®),
- Common Platform Enumeration (CPE),
- Common Vulnerability Scoring System (CVSS),
- and/or Extensible Configuration Checklist Description Format (XCCDF).
These schemes **AND** languages are components of SCAP.
→ More information on SCAP **CAN** be found here – https://nvlpubs.nist.gov/ nistpubs/SpecialPublications/NIST.SP.800-126r3.pdf
The frequency of scanning activities should increase as the diversity of an enterprise’s assets increases to account for the varying patch cycles of each vendor.
Advanced vulnerability scanning tools **CAN** be configured with user credentials to authenticate into enterprise assets **AND** perform more comprehensive assessments.
These are called “authenticated scans.”

In addition to the scanning tools that check for vulnerabilities **AND** misconfigurations across the network,
- various free **AND** commercial tools **CAN** evaluate security settings **AND** configurations of enterprise assets.
Such tools **CAN** provide fine-grained insight into unauthorized changes in configuration **OR** the inadvertent introduction of security weaknesses from administrators.

Effective enterprises link their vulnerability scanners with problem-ticketing systems that track **AND** report progress on fixing vulnerabilities.
This **CAN** help highlight unmitigated critical vulnerabilities to senior management to ensure they are resolved.
Enterprises **CAN** also track how long it took to remediate a vulnerability,
- after identified,
- **OR** a patch has been issued.
These **CAN** support internal **OR** industry compliance requirements.
Some mature enterprises will go over these reports in IT security steering committee meetings,
- **WHICH** bring leaders from IT **AND** the business together to prioritize remediation efforts based on business impact.

In selecting **WHICH** vulnerabilities to fix,
- **OR** patches to apply,
- an enterprise should augment NIST’s Common Vulnerability Scoring System (CVSS) with data concerning the likelihood of a threat actor using a vulnerability,
- **OR** potential impact of an exploit to the enterprise.
Information on the likelihood of exploitation should also be periodically updated based on the most current threat information.
For example,
- the release of
a new exploit,
- **OR** new intelligence relating to exploitation of the vulnerability,
- should change the priority through **WHICH** the vulnerability should be considered for patching.
Various commercial systems are available to allow an enterprise to automate **AND** maintain this process in a scalable manner.

The most effective vulnerability scanning tools compare the results of the current scan with previous scans to determine how the vulnerabilities in the environment have changed over time.
Security personnel use these features to conduct vulnerability trending from month to month.

Finally,
- there should be a quality assurance process to verify configuration updates,
- **OR** that patches are implemented correctly **AND** across **ALL** relevant enterprise assets
----------------------------------------------------
# 08 Audit Log Management
## Overview
Collect,
- alert,
- review,
- **AND** retain audit logs of events that could help detect,
- understand,
- **OR** recover from an attack
----------------------------------------------------
## Why is this Control critical?
Log collection **AND** analysis is critical for an enterprise’s ability to detect malicious activity quickly.
Sometimes audit records are the **ONLY** evidence of a successful attack.
Attackers know that many enterprises keep audit logs for compliance purposes,
- **BUT** rarely analyze them.
Attackers use this knowledge to hide their location,
- malicious software,
- **AND** activities on victim machines.
Due to poor **OR** nonexistent log analysis processes,
- attackers sometimes control victim machines for months **OR** years without anyone in the target enterprise knowing.

There are two types of logs that are generally treated **AND** often configured independently: system logs **AND** audit logs.
System logs typically provide system-level events that show various system process start/end times,
- crashes,
- etc.
These are native to systems,
- **AND** take less configuration to turn on.
Audit logs typically include user-level events—when a user logged in,
- accessed a file,
- etc.—and take more planning **AND** effort to set up.

Logging records are also critical for incident response.
After an attack has been detected,
- log analysis **CAN** help enterprises understand the extent of an attack.
Complete logging records **CAN** show,
- for example,
- **WHEN** **AND** how the attack occurred,
- what information was accessed,
- **AND** **IF** data was exfiltrated.
Retention of logs is also critical in case a follow-up investigation is required **OR** **IF** an attack remained undetected for a long period of time.

----------------------------------------------------
## Procedures and tools
Most enterprise assets **AND** software offer logging capabilities.
Such logging should be activated,
- with logs sent to centralized logging servers.
Firewalls,
- proxies,
- **AND** remote access systems (Virtual Private Network (VPN),
- dial-up,
- etc.) should **ALL** be configured for verbose logging where beneficial.
Retention of logging data is also important in the event an incident investigation is required.

Furthermore,
- **ALL** enterprise assets should be configured to create access control logs **WHEN** a user attempts to access resources without the appropriate privileges.
To evaluate whether such logging is in place,
- an enterprise should periodically scan through its logs **AND** compare them with the enterprise asset inventory assembled as part of CIS Control 1,
- in order to ensure that each managed asset actively connected to the network is periodically generating logs.

----------------------------------------------------
# 09 Email and web browser protections
## overview
Improve protections **AND** detections of threats from email **AND** web vectors,
- as these are opportunities for attackers to manipulate human behavior through direct engagement
----------------------------------------------------
## Why is this Control critical?
Web browsers **AND** email clients are very common points of entry for attackers because of their direct interaction with users inside an enterprise.
Content **CAN** be crafted to entice **OR** spoof users into disclosing credentials,
- providing sensitive data,
- **OR** providing an open channel to allow attackers to gain access,
- thus increasing risk to the enterprise.
Since email **AND** web are the main means that users interact with external
and untrusted users **AND** environments,
- these are prime targets for both malicious code **AND** social engineering.
Additionally,
- as enterprises move to web-based email,
- **OR** mobile email access,
- users no longer use traditional full-featured email clients,
- **WHICH** provide embedded security controls like connection encryption,
- strong authentication,
- **AND** phishing reporting buttons.

----------------------------------------------------
## Procedures and tools
### Web Browser
Cybercriminals **CAN** exploit web browsers in multiple ways.
If they have access to exploits of vulnerable browsers,
- they **CAN** craft malicious webpages that **CAN** exploit those vulnerabilities **WHEN** browsed with an insecure,
- **OR** unpatched,
- browser.
Alternatively,
- they **CAN** try to target any number of common web browser third- party plugins that may allow them to hook into the browser **OR** even directly into the operating system **OR** application.
These plugins,
- much like any other software
within an environment,
- need to be reviewed for vulnerabilities,
- kept up-to-date with latest patches **OR** versions,
- **AND** controlled.
Many come from untrusted sources,
- **AND** some are even written to be malicious.
**THEREFORE**,
- it is best to prevent users from intentionally **OR** unintentionally installing malware that might be hiding in some of these plugins,
- extensions,
- **AND** add-ons.
Simple configuration updates to the browser **CAN** make it much harder for malware to get installed through reducing the ability of installing add-ons/plugins/extensions **AND** preventing specific types of content from automatically executing.

Most popular browsers employ a database of phishing and/or malware sites to protect against the most common threats.
A best practice is to enable these content filters **AND** turn on the pop-up blockers.
Pop-ups are **NOT** **ONLY** annoying --> they **CAN** also host embedded malware directly **OR** lure users into clicking links using social
engineering tricks.
To help enforce blocking of known malicious domains,
- also consider subscribing to DNS filtering services to block attempts to access these websites at the network level.

----------------------------------------------------
### Email
Email represents one the most interactive ways humans work with enterprise assets --> training **AND** encouraging the right behavior is just as important as the technical settings.
Email is the most common threat vector against enterprises through tactics such as phishing **AND** Business Email Compromise (BEC).

Using a spam-filtering tool **AND** malware scanning at the email gateway reduces the number of malicious emails **AND** attachments that come into the enterprise’s network.
Initiating Domain-based Message Authentication,
- Reporting,
- **AND** Conformance (DMARC) helps reduce spam **AND** phishing activities.
Installing an encryption tool
to secure email **AND** communications adds another layer of user **AND** network-based security.
In addition to blocking based on the sender,
- it is also worthwhile to **ONLY** allow certain file types that users need for their jobs.
This will require coordination with different business units to understand what types of files they receive via email to ensure that there is **NOT** an interruption to their processes.

Since phishing email techniques are ever evolving to get past Something Posing as Mail (SPAM) filter rules,
- it is important to train users on how to identify phishing,
- **AND** to notify IT Security **WHEN** they see one.
There are many platforms that perform phishing tests against users to help educate them on different examples,
- **AND** track
their improvement over time.
Crowd-sourcing this knowledge into notifying IT Security teams of phishing helps improve the protections **AND** detections of email-based threats.

----------------------------------------------------