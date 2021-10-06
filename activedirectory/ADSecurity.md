# Points to cover
*microsoft docs*
- AD DS
- security related
- ecryption
- authentication protocols (RC4 vs Encryption)


## This document provides a practitioner's perspective *AND* contains a set of practical techniques to help IT executives protect an enterprise Active Directory environment.
## Active Directory plays a critical role in the IT infrastructure,
- *AND* ensures the harmony *AND* security of different network resources in a global,
- interconnected environment.
## The methods discussed are based largely on the Microsoft Information Security *AND* Risk Management (ISRM) organization's experience,
- *WHICH* is accountable for protecting the assets of Microsoft IT *AND* other Microsoft Business Divisions,
- in addition to advising a selected number of Microsoft Global 500 customers.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Executive Summary

## No organization with an information technology (IT) infrastructure is immune from attack,
- *BUT* *IF* appropriate policies,
- processes,
- *AND* controls are implemented to protect key segments of an organization's computing infrastructure,
- it might be possible to prevent a breach event from growing to a wholesale compromise of the computing environment.

## This executive summary is intended to be useful as a standalone document summarizing the content of the document,
- *WHICH* contains recommendations that will assist organizations in enhancing the security of their Active Directory installations.
## By implementing these recommendations,
- organizations will be able to identify *AND* prioritize security activities,
- protect key segments of their organization's computing infrastructure,
- *AND* create controls that significantly decrease the likelihood of successful attacks against critical components of the IT environment.

## *ALTHOUGH* this document discusses the most common attacks against Active Directory *AND* countermeasures to reduce the attack surface,
- it also contains recommendations for recovery in the event of complete compromise.
## The *ONLY* sure way to recover in the event of a complete compromise of Active Directory is to be prepared for the compromise before it happens.

## The major sections of this document are:

## Avenues to Compromise

## Reducing the Active Directory Attack Surface

## Monitoring Active Directory for Signs of Compromise

## Planning for Compromise

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Avenues to Compromise

## This section provides information about some of the most commonly leveraged vulnerabilities used *BY* attackers to compromise customers' infrastructures.
## It contains general categories of vulnerabilities *AND* how they're used to initially penetrate customers' infrastructures,
- propagate compromise across additional systems,
- *AND* eventually target Active Directory *AND* domain controllers to obtain complete control of the organizations' forests.
## It does *NOT* provide detailed recommendations about addressing each type of vulnerability,
- particularly in the areas in *WHICH* the vulnerabilities are *NOT* used to directly target Active Directory.
## However,
- for each type of vulnerability,
- we have provided links to additional information to use to develop countermeasures *AND* reduce the organization's attack surface.

## Included are the following subjects:

## Initial breach targets - Most information security breaches start with the compromise of small pieces of an organization's infrastructure-often one *OR* two systems at a time.
## These initial events,
- *OR* entry points into the network,
- often exploit vulnerabilities that could have been fixed,
- *BUT* weren't.
## Commonly seen vulnerabilities are:

## Gaps in antivirus *AND* antimalware deployments
## Incomplete patching
## Outdated applications *AND* operating systems
## Misconfiguration
## Lack of secure application development practices
## Attractive Accounts for Credential Theft - Credential theft attacks are those in *WHICH* an attacker initially gains privileged access to a computer on a network *AND* then uses freely available tooling to extract credentials from the sessions of other logged-on accounts.
## Included in this section are the following:

## Activities that Increase the Likelihood of Compromise - Because the target of credential theft is usually highly privileged domain accounts *AND* "very important person" (VIP) accounts,
- it is important for administrators to be conscious of activities that increase the likelihood of a success of a credential-theft attack.
## These activities are:

## Logging on to unsecured computers with privileged accounts

## Browsing the Internet with a highly privileged account

## Configuring local privileged accounts with the same credentials across systems

## Overpopulation *AND* overuse of privileged domain groups

## Insufficient management of the security of domain controllers.

## Privilege Elevation *AND* Propagation - Specific accounts,
- servers,
- *AND* infrastructure components are usually the primary targets of attacks against Active Directory.
## These accounts are:

## Permanently privileged accounts

## VIP accounts

## "Privilege-Attached" Active Directory accounts

## Domain controllers

## Other infrastructure services that affect identity,
- access,
- *AND* configuration management,
- such as public key infrastructure (PKI) servers *AND* systems management servers

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Reducing the Active Directory Attack Surface

## This section focuses on technical controls to reduce the attack surface of an Active Directory installation.
## Included in this section are the following subjects:

## The Privileged Accounts *AND* Groups in Active Directory section discusses the highest privileged accounts *AND* groups in Active Directory *AND* the mechanisms *BY* *WHICH* privileged accounts are protected.
## Within Active Directory,
- three built-in groups are the highest privilege groups in the directory (Enterprise Admins,
- Domain Admins,
- *AND* Administrators),
- *ALTHOUGH* a number of additional groups *AND* accounts should also be protected.

## The Implementing Least-Privilege Administrative Models section focuses on identifying the risk that the use of highly privileged accounts for day-to-day administration presents,
- in addition to providing recommendations to reduce that risk.

## Excessive privilege isn't *ONLY* found in Active Directory in compromised environments.
## *WHEN* an organization has developed the habit of granting more privilege than is required,
- it is typically found throughout the infrastructure:

## In Active Directory

## On member servers

## On workstations

## In applications

## In data repositories

## The Implementing Secure Administrative Hosts section describes secure administrative hosts,
- *WHICH* are computers that are configured to support administration of Active Directory *AND* connected systems.
## These hosts are dedicated to administrative functionality *AND* do *NOT* run software such as email applications,
- web browsers,
- *OR* productivity software (such as Microsoft Office).

## Included in this section are the following:

## Principles for Creating Secure Administrative Hosts - The general principles to keep in mind are:

## Never administer a trusted system from a less-trusted host.
## Do *NOT* rely on a single authentication factor *WHEN* performing privileged activities.
## Do *NOT* forget physical security *WHEN* designing *AND* implementing secure administrative hosts.
## Securing Domain Controllers Against Attack - *IF* a malicious user obtains privileged access to a domain controller,
- that user *CAN* modify,
- corrupt,
- *AND* destroy the Active Directory database,
- *AND* *BY* extension,
- *ALL* of the systems *AND* accounts that are managed *BY* Active Directory.

## Included in this section are the following subjects:

## Physical Security for Domain Controllers - Contains recommendations for providing physical security for domain controllers in datacenters,
- branch offices,
- *AND* remote locations.

## Domain Controller Operating Systems - Contains recommendations for securing the domain controller operating systems.

## Secure Configuration of Domain Controllers - Native *AND* freely available configuration tools *AND* settings *CAN* be used to create security configuration baselines for domain controllers that *CAN* subsequently be enforced *BY* Group Policy Objects (GPOs).

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Monitoring Active Directory for Signs of Compromise

## This section provides information about legacy audit categories *AND* audit policy subcategories ( *WHICH* were introduced in Windows Vista *AND* Windows Server 2008),
- *AND* Advanced Audit Policy ( *WHICH* was introduced in Windows Server 2008 R2).
## Also provided is information about events *AND* objects to monitor that *CAN* indicate attempts to compromise the environment *AND* some additional references that *CAN* be used to construct a comprehensive audit policy for Active Directory.

## Included in this section are the following subjects:

## Windows Audit Policy - Windows security event logs have categories *AND* subcategories that determine *WHICH* security events are tracked *AND* recorded.

## Audit Policy Recommendations - This section describes the Windows default audit policy settings,
- audit policy settings that are recommended *BY* Microsoft,
- *AND* more aggressive recommendations for organizations to use to audit critical servers *AND* workstations.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Planning for Compromise

## This section contains recommendations that will help organizations prepare for a compromise before it happens,
- implement controls that *CAN* detect a compromise event before a full breach has occurred,
- *AND* provide response *AND* recovery guidelines for cases in *WHICH* a complete compromise of the directory is achieved *BY* attackers.
## Included in this section are the following subjects:

## Rethinking the Approach - Contains principles *AND* guidelines to create secure environments into *WHICH* an organization *CAN* place their most critical assets.
## These guidelines are as follows:

## Identifying principles for segregating *AND* securing critical assets

## Defining a limited,
- risk-based migration plan

## Leveraging "nonmigratory" migrations where necessary

## Implementing "creative destruction"

## Isolating legacy systems *AND* applications

## Simplifying security for end users

## Maintaining a More Secure Environment - Contains high-level recommendations meant to be used as guidelines to use in developing *NOT* *ONLY* effective security,
- *BUT* effective lifecycle management.
## Included in this section are the following subjects:

## Creating Business-Centric Security Practices for Active Directory - To effectively manage the lifecycle of the users,
- data,
- applications *AND* systems managed *BY* Active Directory,
- follow these principles.

## Assign a Business Ownership to Active Directory Data - Assign ownership of infrastructure components to IT --> for data that is added to Active Directory Domain Services (AD DS) to support the business,
- for example,
- new employees,
- new applications,
- *AND* new information repositories,
- a designated business unit *OR* user should be associated with the data.

## Implement Business-Driven Lifecycle Management - Lifecycle management should be implemented for data in Active Directory.

## Classify *ALL* Active Directory Data - Business owners should provide classification for data in Active Directory.
## Within the data classification model,
- classification for the following Active Directory data should be included:

## Systems - Classify server populations,
- their operating system,
- their role,
- the applications running on them,
- *AND* the IT *AND* business owners of record.

## Applications - Classify applications *BY* functionality,
- user base,
- *AND* their operating system.

## Users - The accounts in the Active Directory installations that are most likely to be targeted *BY* attackers should be tagged *AND* monitored.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Introduction

## Attacks against computing infrastructures,
- whether simple *OR* complex,
- have existed as long as computers have.
## However,
- within the past decade,
- increasing numbers of organizations of *ALL* sizes,
- in *ALL* parts of the world have been attacked *AND* compromised in ways that have significantly changed the threat landscape.
## Cyber-warfare *AND* cybercrime have increased at record rates.
## "Hacktivism," in *WHICH* attacks are motivated *BY* activist positions,
- has been claimed as the motivation for a number of breaches intended to expose organizations' secret information,
- to create denials-of-service,
- *OR* even to destroy infrastructure.
## Attacks against public *AND* private institutions with the goal of exfiltrating the organizations' intellectual property (IP) have become ubiquitous.

## No organization with an information technology (IT) infrastructure is immune from attack,
- *BUT* *IF* appropriate policies,
- processes,
- *AND* controls are implemented to protect key segments of an organization's computing infrastructure,
- escalation of attacks from penetration to complete compromise might be preventable.
## Because the number *AND* scale of attacks originating from outside an organization has eclipsed insider threat in recent years,
- this document often discusses external attackers rather than misuse of the environment *BY* authorized users.
## Nonetheless,
- the principles *AND* recommendations provided in this document are intended to help secure your environment against external attackers *AND* misguided *OR* malicious insiders.

## The information *AND* recommendations provided in this document are drawn from a number of sources *AND* derived from practices designed to protect Active Directory installations against compromise.
## *ALTHOUGH* it is *NOT* possible to prevent attacks,
- it is possible to reduce the Active Directory attack surface *AND* to implement controls that make compromise of the directory much more difficult for attackers.
## This document presents the most common types of vulnerabilities we have observed in compromised environments *AND* the most common recommendations we have made to customers to improve the security of their Active Directory installations.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Account and Group Naming Conventions

## BA: Built-in administrators
## DA: Domain administrator
## EA: Enterprise admins

----------------------------------------------------

# About This Document

## The Microsoft Information Security *AND* Risk Management (ISRM) organization,
- *WHICH* is part of Microsoft Information Technology (MSIT),
- works with internal business units,
- external customers,
- *AND* industry peers to gather,
- disseminate,
- *AND* define policies,
- practices,
- *AND* controls.
## This information *CAN* be used *BY* Microsoft *AND* our customers to increase the security *AND* reduce the attack surface of their IT infrastructures.
## The recommendations provided in this document are based on a number of information sources *AND* practices used within MSIT *AND* ISRM.
## The following sections present more information about the origins of this document.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Microsoft IT and ISRM

## A number of practices *AND* controls have been developed within MSIT *AND* ISRM to secure the Microsoft AD DS forests *AND* domains.
## Where these controls are broadly applicable,
- they have been integrated into this document.
## SAFE-T (Solution Accelerators for Emerging Technologies) is a team within ISRM whose charter is to identify emerging technologies,
- *AND* to define security requirements *AND* controls to accelerate their adoption.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Active Directory Security Assessments

## Within Microsoft ISRM,
- the Assessment,
- Consulting,
- *AND* Engineering (ACE) Team works with internal Microsoft business units *AND* external customers to assess application *AND* infrastructure security *AND* to provide tactical *AND* strategic guidance to increase the organization's security posture.
## One ACE service offering is the Active Directory Security Assessment (ADSA),
- *WHICH* is a holistic assessment of an organization's AD DS environment that assesses people,
- process,
- *AND* technology *AND* produces customer-specific recommendations.
## Customers are provided with recommendations that are based on the organization's unique characteristics,
- practices,
- *AND* risk appetite.
## ADSAs have been performed for Active Directory installations at Microsoft in addition to those of our customers.
## Over time,
- a number of recommendations have been found to be applicable across customers of varying sizes *AND* industries.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Content Origin and Organization

## Much of the content of this document is derived from the ADSA *AND* other ACE Team assessments performed for compromised customers *AND* customers who have *NOT* experienced significant compromise.
## *ALTHOUGH* individual customer data was *NOT* used to create this document,
- we have collected the most commonly exploited vulnerabilities we have identified in our assessments *AND* the recommendations we have made to customers to improve the security of their AD DS installations.
## Not *ALL* vulnerabilities are applicable to *ALL* environments,
- nor are *ALL* recommendations feasible to implement in every organization.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Reducing the Active Directory Attack Surface

## This section begins *BY* providing background information about privileged accounts *AND* groups in Active Directory to provide the information that helps clarify the reasons for the subsequent recommendations for securing *AND* managing privileged groups *AND* accounts.
## We then discuss approaches to reduce the need to use highly privileged accounts for day-to-day administration,
- *WHICH* does *NOT* require the level of privilege that is granted to groups such as the Enterprise Admins (EA),
- Domain Admins (DA),
- *AND* Built-in Administrators (BA) groups in Active Directory.
## Next,
- we provide guidance for securing the privileged groups *AND* accounts *AND* for implementing secure administrative practices *AND* systems.

## *ALTHOUGH* this section provides detailed information about these configuration settings,
- we have also included appendices for each recommendation that provide step-by-step configuration instructions that *CAN* be used "as is" *OR* *CAN* be modified for the organization's needs.
## This section finishes *BY* providing information to securely deploy *AND* manage domain controllers,
- *WHICH* should be among the most stringently secured systems in the infrastructure.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Monitoring Active Directory for Signs of Compromise

## Whether you have implemented robust security information *AND* event monitoring (SIEM) in your environment *OR* are using other mechanisms to monitor the security of the infrastructure,
- this section provides information that *CAN* be used to identify events on Windows systems that may indicate that an organization is being attacked.
## We discuss traditional *AND* advanced audit policies,
- including effective configuration of audit subcategories in the Windows 7 *AND* Windows Vista operating systems.
## This section includes comprehensive lists of objects *AND* systems to audit,
- *AND* an associated appendix lists events for *WHICH* you should monitor *IF* the goal is to detect compromise attempts.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Planning for Compromise

## This section begins *BY* "stepping back" from technical detail to focus on principles *AND* processes that *CAN* be implemented to identify the users,
- applications,
- *AND* systems that are most critical *NOT* *ONLY* to the IT infrastructure,
- *BUT* to the business.
## After identifying what is most critical to the stability *AND* operations of your organization,
- you *CAN* focus on segregating *AND* securing these assets,
- whether they are intellectual property,
- people,
- *OR* systems.
## In some cases,
- segregating *AND* securing assets may be performed in your existing AD DS environment,
- while in other cases,
- you should consider implementing small,
- separate "cells" that allow you to establish a secure boundary around critical assets *AND* monitor those assets more stringently than less-critical components.
## A concept called "creative destruction," *WHICH* is a mechanism *BY* *WHICH* legacy applications *AND* systems *CAN* be eliminated *BY* creating new solutions is discussed,
- *AND* the section ends with recommendations that *CAN* help to maintain a more secure environment *BY* combining business *AND* IT information to construct a detailed picture of what is a normal operational state.
## By knowing what is normal for an organization,
- abnormalities that may indicate attacks *AND* compromises *CAN* be more easily identified.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/plan/security-best-practices/avenues-to-compromise

# Avenues to Compromise

