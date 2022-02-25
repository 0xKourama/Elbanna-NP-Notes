# Email addresses:
E-mail addresses provide a potential list of valid usernames and domain structure
E-mail addresses can be gathered from multiple sources including the organizations website.

# Technologies used:
OSINT searches through support forums, mailing lists and other resources can gather information of technologies used at the target
Use of Social engineering against the identified information technology organization
Use of social engineering against product vendors

# Remote access
Obtaining information on how employees and/or clients connect into the target for remote access provides a potential point of ingress.
Often times link to remote access portal are available off of the target's home page
How To documents reveal applications/procedures to connect for remote users

# Application usage
Gather a list of known application used by the target organization. This can often be achieved by extracting metadata from publicly accessible files (as discussed previously)

# Passive fingerprinting
Search forums and publicly accessible information where technicians of the target organisation may be discussing issues or asking for assistance on the technology in use
Search marketing information for the target organisation as well as popular technology vendors
Using Tin-eye (or another image matching tool) search for the target organisations logo to see if it is listed on vendor reference pages or marketing material

# Active fingerprinting
Send appropriate probe packets to the public facing systems to test patterns in blocking. Several tools exist for fingerprinting of specific WAF types.
Header information both in responses from the target website and within emails often show information not only on the systems in use, but also the specific protection mechanisms enabled (e.g. Email gateway Anti-virus scanners)

-------------------

# Port Scanning
# Banner Grabbing
# SNMP Sweep
# Zone Transfer
# SMTP Bounce Back (NDR)
# Forward/Reverse DNS