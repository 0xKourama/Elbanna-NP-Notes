Another key component defeating scope creep is explicitly stating start and end dates. This allows the project to have definite end. One of the most common areas in which scope creep occurs is during retesting. Retesting always sounds like a good idea when going after a contract. It shows that the firm is caring and diligent, trying to make ensure that the customer is secure as possible. The problem begins when it is forgotten that the work is not paid for until it is completed. This includes retesting.

To mitigate this risk, add a simple statement to the contract which mentions that all retesting must be done within a certain timeframe after the final report delivery. It then becomes the responsibility of the testers to spearhead the retesting effort. If the customer requests an extension, always allow this with the condition that payment be fulfilled at the originally specified date. Finally, and most importantly, perform a quality retest. Remember, the best source for future work is your existing customer base.

# Specify IP Ranges and Domains

Before starting a penetration test, all targets must be identified. These targets should be obtained from the customer during the initial questionnaire phase. Targets can be given in the form of specific IP addresses, network ranges, or domain names by the customer. In some instances, the only target the customer provides is the name of the organization and expects the testers be able to identify the rest on their own. It is important to define if systems like firewalls and IDS/IPS or networking equipment that are between the tester and the final target are also part of the scope. Additional elements such as upstream providers, and other 3rd party providers should be identified and defined whether they are in scope or not.

# Validate Ranges

It is imperative that before you start to attack the targets you validate that they are in fact owned by the customer you are performing the test against. Think of the legal consequences you may run into if you start attacking a machine and successfully penetrate it only to find out later down the line that the machine actually belongs to another organization (such as a hospital or government agency).

# Dealing with Third Parties

There are a number of situations where an engagement will include testing a service or an application that is being hosted by a third party. This has become more prevalent in recent years as “cloud” services have become more popular. The most important thing to remember is that while permission may have been granted by the client, they do not speak for their third party providers. Thus, permission must be obtained from them as well in order to test the hosted systems. Failing to obtain the proper permissions brings with it, as always, the possibility of violating the law, which can cause endless headaches.

# Cloud Services

The single biggest issue with testing cloud service is there is data from multiple different organizations stored on one physical medium. Often the security between these different data domains is very lax. The cloud services provider needs to be alerted to the testing and needs to acknowledge that the test is occurring and grant the testing organization permission to test. Further, there needs to be a direct security contact within the cloud service provider that can be contacted in the event that a security vulnerability is discovered which may impact the other cloud customers. Some cloud providers have specific procedures for penetration testers to follow, and may require request forms, scheduling or explicit permission from them before testing can begin.

# ISP

Verify the ISP terms of service with the customer. In many commercial situations the ISP will have specific provisions for testing. Review these terms carefully before launching an attack. There are situations where ISPs will shun and block certain traffic which is considered malicious. The customer may approve this risk, but it must always be clearly communicated before beginning. Web Hosting As with all other third parties, the scope and timing of the test needs to be clearly communicated with the web hosting provider. Also, when communicating with the client, be sure to clearly articulate the test will only be in search of web vulnerabilities. The test will not uncover vulnerabilities in the underlying infrastructure which may still provide an avenue to compromise the application.

# MSSPs

Managed Security Service Providers also may need to be notified of testing. Specifically, they will need to be notified when the systems and services that they own are to be tested. However, there are circumstances under which the MSSP would not be notified. If determining the actual response time of the MSSP is part of the test, it is certainly not in the best interest of the integrity of the test for the MSSP to be notified. As a general rule of thumb, any time a device or service explicitly owned by the MSSP is being tested they will need to be notified.

# Define Acceptable Social Engineering Pretexts

Many organizations will want their security posture tested in a way which is aligned with current attacks. Social engineering and spear-phishing attacks are currently widely used by many attackers today. While most of the successful attacks use pretexts like sex, drugs, and rock and roll (porn, Viagra, and free iPods respectively) some of these pretexts may not be acceptable in a corporate environment. Be sure that any pretexts chosen for the test are approved in writing before testing is to begin.


# DoS Testing

Stress testing or Denial of Service testing should be discussed before the engagement begins. It can be a topic that many organizations are uncomfortable with due to the potentially damaging nature of the testing. If an organization is only worried about the confidentiality or integrity of their data, stress testing may not be necessary; however, if the organization is also worried about the availability of their services, then the stress testing should be conducted in a non-production environment which is identical to the production environment.

# Business Analysis

Before performing a penetration test it is beneficial to determine the maturity level of the client’s security posture. There are a number of organizations which choose to jump directly into a penetration test first assessing this maturity level. For customers with a very immature security program, it is often a good idea to perform a vulnerability analysis first.

Some testers believe there is a stigma surrounding Vulnerability Analysis (VA) work. Those testers have forgotten that the goal is to identify risks in the target organization, not about pursuing the so-called “rockstar” lifestyle. If a company is not ready for a full penetration test, they will get far more value out of a good VA than a penetration test.

Establish with the customer in advance what information about the systems they will be providing. It may also be helpful to ask for information about vulnerabilities which are already documented. This will save the testers time and save the client money by not overlapping testing discoveries with known issues. Likewise, a full or partial white-box test may bring the customer more value than a black-box test, if it isn't absolutely required by compliance.

# Establish Lines of Communication

One of the most important aspects of any penetration test is communication with the customer. How often you interact with the customer, and the manner in which you approach them, can make a huge difference in their feeling of satisfaction. Below is a communication framework that will aid in making the customer feel comfortable about the test activities.

# Emergency Contact Information

Obviously, being able to get in touch with the customer or target organization in an emergency is vital. Emergencies may arise, and a point of contact must have been established in order to handle them. Create an emergency contact list. This list should include contact information for all parties in the scope of testing. Once created, the emergency contact list should be shared with all those on the list. Keep in mind, the target organization may not be the customer.

Gather the following information about each emergency contact:

Full name
Title and operational responsibility
Authorization to discuss details of the testing activities, if not already specified
Two forms of 24/7 immediate contact, such as cell phone, pager, or home phone, if possible
One form of secure bulk data transfer, such as SFTP or encrypted email
Note: The number for a group such as the help desk or operations center can replace one emergency contact, but only if it is staffed 24/7. The nature of each penetration test influences who should be on the emergency contact list. Not only will contact information for the customer and targets need to be made available, but they may also need to contact the testers in an emergency. The list should preferably include the following people:

All penetration testers in the test group for the engagement
The manager of the test group
Two technical contacts at each target organization
Two technical contacts at the customer
One upper management or business contact at the customer
It is possible that there will be some overlap in the above list. For instance, the target organization may be the customer, the test group’s manager may also be performing the penetration test, or a customer’s technical contact may be in upper management. It is also recommended to define a single contact person per involved party who leads it and takes responsibility on behalf of it.

# Incident Reporting Process

Discussing the organization’s current incident response capabilities is important to do before an engagement for several reasons. Part of a penetration test is not only testing the security an organization has in place, but also their incident response capabilities.

If an entire engagement can be completed without the target’s internal security teams ever noticing, a major gap in security posture has been identified. It is also important to ensure that before testing begins, someone at the target organization is aware of when the tests are being conducted so the incident response team does not start to call every member of upper management in the middle of the night because they thought they were under attack or compromised.

# Incident Definition

The National Institute of Standards and Technology (NIST) defines an incident as follows: “a violation or imminent threat of violation of computer security policies, acceptable use policies, or standard security practices.” (Computer Security Incident Handling Guide - Special Publication 800-61 Rev 1). An incident can also occur on a physical level, wherein a person gain unauthorized physical access to an area by any means. The target organization should have different categories and levels for different types of incidents.

# Status Report Frequency

The frequency of status reporting can vary widely. Some factors which influence the reporting schedule include the overall length of the test, the test scope, and the target’s security maturity. An effective schedule allows the customer to feel engaged. An ignored customer is a former customer.

Once frequency and schedule of status reports has been set, it must be fulfilled. Postponing or delaying a status report may be necessary, but it should not become chronic. The client may be asked to agree to a new schedule if necessary. Skipping a status report altogether is unprofessional and should be avoided if at all possible.

# Timeline

A clear timeline should be established for the engagement. While scope defines the start and the end of an engagement, the rules of engagement define everything in between. It should be understood that the timeline will change as the test progresses. However, having a rigid timeline is not the goal of creating one. Rather, having a timeline in place at the beginning of a test will allow everyone involved to more clearly identify the work that is to be done and the people who will be responsible for said work. GANTT Charts and Work Breakdown Structures are often used to define the work and the amount of time that each specific piece of the work will take. Seeing the schedule broken down in this manner aids those involved in identifying where resources need to be applied and it helps the customer identify possible roadblocks which many be encountered during testing.

There are a number of free GANTT Chart tools available on the Internet. Many mangers identify closely with these tools. Because of this, they are an excellent medium for communicating with the upper management of a target organization

# Evidence Handling

When handling evidence of a test and the differing stages of the report it is incredibly important to take extreme care with the data. Always use encryption and sanitize your test machine between tests. Never hand out USB sticks with test reports out at security conferences. And whatever you do, don't re-use a report from another customer engagement as a template! It's very unprofessional to leave references to another organization in your document.

# Regular Status Meetings

Throughout the testing process it is critical to have regular meetings with the customer informing them of the overall progress of the test. These meetings should be held daily and should be as short as possible. Meetings should be kept to three concepts: plans, progress and problems.

Plans are generally discussed so that testing is not conducted during a major unscheduled change or an outage. Progress is simply an update to the customer on what has been completed so far. Problems should also be discussed in this meeting, but in the interest of brevity, conversations concerning solutions should almost always be taken offline.

# Dealing with Shunning

There are times where shunning is perfectly acceptable and there are times where it may not fit the spirit of the test. For example, if your test is to be a full black-box test where you are testing not only the technology, but the capabilities of the target organization’s security team, shunning would be perfectly fine. However, when you are testing a large number of systems in coordination with the target organization's security team it may not be in the best interests of the test to shun your attacks.

# Permission to Test

One of the most important documents which need to be obtained for a penetration test is the Permission to Test document. This document states the scope and contains a signature which acknowledges awareness of the activities of the testers. Further, it should clearly state that testing can lead to system instability and all due care will be given by the tester to not crash systems in the process. However, because testing can lead to instability the customer shall not hold the tester liable for any system instability or crashes. It is critical that testing does not begin until this document is signed by the customer.

In addition, some service providers require advance notice and/or separate permission prior to testing their systems. For example, Amazon has an online request form that must be completed, and the request must be approved before scanning any hosts on their cloud. If this is required, it should be part of the document.