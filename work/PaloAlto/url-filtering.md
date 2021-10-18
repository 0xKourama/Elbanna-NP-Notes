# About url filtering:

## Palo Alto Networks URL Filtering protects against web-based threats **BY** giving you a way to safely enable web access while controlling how your users interact with online content.
## You **CAN** create policy rules to limit access to sites based on URL categories,
- users,
- **AND** groups.
## (See URL Filtering Use Cases for different ways you **CAN** leverage URL Filtering to meet your organization’s web security needs.)
## With URL Filtering enabled,
- **ALL** web traffic (HTTP **AND** HTTPS) on any port is:
## Compared against the URL filtering database,
- **WHICH** contains millions of websites that have been categorized.
## You **CAN** use these URL categories in URL Filtering profiles **OR** as match criteria to enforce Security policy.
## You **CAN** also use URL filtering to enforce safe search settings for your users **AND** to prevent credential theft based on URL category.
## With the addition of an Advanced URL Filtering license,
- URLs exhibiting suspicious qualities are simultaneously analyzed in real-time using machine learning to provide protection against new **AND** unknown threats that do **NOT** currently exist in the URL filtering database.
## Inspected for phishing **AND** malicious JavaScript using inline machine learning (ML),
- a firewall-based analysis solution,
- **WHICH** **CAN** block unknown malicious web pages in real-time.
## The Palo Alto Networks URL filtering solution,
- PAN-DB,
- allows you to choose <- **BETWEEN** -> the PAN-DB Public Cloud **AND** the PAN-DB Private Cloud,
- use the public cloud solution**IF** the Palo Alto Networks next-generation firewalls on your network **CAN** directly access the Internet.
## **IF** the network security requirements in your enterprise prohibit the firewalls from directly accessing the Internet,
- you **CAN** deploy a PAN-DB private cloud on one **OR** more M-600 appliances that function as PAN-DB servers within your network.

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

# How URL Filtering Works

## PAN-DB—the URL Filtering cloud database—classifies websites based on site content,
- features,
- **AND** safety.
## A URL **CAN** have up to four URL categories,
- including risk categories (high,
- medium,
- **AND** low) that indicate the likelihood that the site will expose you to threats.
## As PAN-DB categorizes sites,
- firewalls with URL Filtering enabled **CAN** leverage that knowledge to enforce your organization’s security policies.
## In addition to the protection offered **BY** the PAN-DB database,
- Advanced URL Filtering provides real-time analysis using machine language to defend against new **AND** unknown threats.

## **WHEN** a user requests a web page,
- the firewall queries user-added exceptions **AND** PAN-DB for the site’s risk category.
## PAN-DB uses URL information from Unit 42,
- WildFire,
- passive DNS,
- Palo Alto Networks telemetry data,
- data from the Cyber Threat Alliance,
- **AND** applies various analyzers to determine the category.
## **IF** the URL displays risky **OR** malicious characteristics,
- it is also submitted to advanced URL filtering in the cloud for real-time analysis **AND** generates additional analysis data.
## The resulting risk category is then retrieved **BY** the firewall **AND** is used to enforce the web-access rules based on your policy configuration.
## Additionally,
- the firewall caches site categorization information for new entries to enable fast retrieval for subsequent requests,
- **WHILE** it removes URLs that users have **NOT** accessed recently so that it accurately reflects the traffic in your network.
## Additionally,
- checks built into PAN-DB cloud queries ensure that the firewall receives the latest URL categorization information.
## **IF** you do **NOT** have Internet connectivity **OR** an active PAN-DB URL filtering license,
- no queries are made to PAN-DB.

## The firewall determines a website’s URL category **BY** comparing it to entries in 1) custom URL categories,
- 2) external dynamic lists (EDLs),
- **AND** 3) predefined URL categories,
- in order of precedence.
## Firewalls configured to analyze URLs in real-time using machine learning on the dataplane provides an additional layer of security against phishing websites **AND** JavaScript exploits.
## The inline ML models used to identify these URL-based threats extend to currently unknown as well as future variants of threats that match characteristics that Palo Alto Networks has identified as malicious.
## To keep up with the latest changes in the threat landscape,
- inline ML models are added **OR** updated via content releases.
## **WHEN** the firewall checks PAN-DB for a URL,
- it also looks for critical updates,
- such as URLs that previously qualified as benign **BUT** are now malicious.
## **IF** you believe PAN-DB has incorrectly categorized a site,
- you **CAN** submit a URL category change request in your browser through Test A Site **OR** directly from the firewall logs.

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

## Technically,
- the firewall caches URLs on both the management plane **AND** the dataplane:
## PAN-OS 9.0 **AND** later releases do **NOT** download PAN-DB seed databases.
## Instead,
- upon activation of the URL filtering license,
- the firewall populates the cache as URL queries are made.
## The management plane holds more URLs **AND** communicates directly with PAN-DB.
## **WHEN** the firewall cannot find a URL’s category in the cache **AND** performs a lookup in PAN-DB,
- it caches the retrieved category information in the management plane.
## The management plane passes that information along to the dataplane,
- **WHICH** also caches it **AND** uses it to enforce policy.
## The dataplane holds fewer URLs **AND** receives information from the management plane.
## After the firewall checks URL category exception lists (custom URL categories **AND** external dynamic lists) for a URL,
- the next place it looks is the dataplane.
## **ONLY** **IF** the firewall cannot find the URL categorized in the dataplane does it check the management plane and,
- **IF** the category information is **NOT** there,
- PAN-DB.

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

# Multi-Category URL Filtering

## Every URL **CAN** have up to four categories,
- including a risk category that indicates the likelihood a site will expose you to threats.
## More granular URL categorizations means that you **CAN** move beyond a basic “block-or-allow” approach to web access.
## Instead,
- you **CAN** control how your users interact with online content that,
- **WHILE** necessary for business,
- is more likely to be used as part of a cyberattack.
## For instance,
- you might consider certain URL categories risky to your organization,
- **BUT** are hesitant to block them outright as they also provide valuable resources **OR** services (like cloud storage services **OR** blogs).
## Now,
- you **CAN** allow users to visit sites that fall into these types of URL categories **WHILE** you protect your network **BY** decrypting **AND** inspecting traffic **AND** enforcing read-only access to the content.
## For a URL category that you want to tightly control,
- set the URL Filtering profile action to alert as part of the steps to configure URL Filtering.
## Then continue to follow the URL Filtering best practices: decrypt the URL category,
- block dangerous file downloads,
- **AND** turn on credential phishing prevention.

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

# URL Filtering Profile Actions

## The URL Filtering profile specifies web access **AND** credential submission permissions for each URL category.
## **BY** default,
- site access for **ALL** URL categories is set to allow **WHEN** you create a new URL Filtering profile.
## This means that the users will be able to browse to **ALL** sites freely **AND** the traffic will **NOT** be logged.
## You **CAN** customize the URL Filtering profile with custom Site Access settings for each category,
- **OR** use the predefined default URL filtering profile on the firewall to allow access to **ALL** URL categories **EXCEPT** the following threat-prone categories,
- **WHICH** it blocks: abused-drugs,
- adult,
- gambling,
- hacking,
- malware,
- phishing,
- questionable,
- **AND** weapons.
## For each URL category,
- select the User Credential Submissions to allow **OR** disallow users from submitting valid corporate credentials to a URL in that category in order to prevent credential phishing.
## Managing the sites to **WHICH** users **CAN** submit credentials requires User-ID **AND** you **MUST** first set up credential phishing prevention.
## URL categories with the Site Access set to block are automatically set to also block user credential submissions.

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