## laws summary
1.  nobody believes anything bad can happen to them, until it does
2.  security only works if the secure way also happens to be the easy way
3.  if you don't keep up with security fixes, your network won't be yours for long
4.  it doesn't do much good to install security fixes on a computer that was never secured to begin with
5.  eternal vigilance is the price of security
6.  there really is someone out there trying to guess your passwords
7.  the most secure network is a well-administered one
8.  the difficulty of defending a network is directly proportional to its complexity
9.  security isn't about risk avoidance; it's about risk management
10. technology is not a panacea

## law #1: nobody believes anything bad can happen to them, until it does

many people are unwilling partners in computer security.
this isn't because they're deliberately trying to endanger the network—they simply have a different agenda than you do.
the reason your company has a network is because it lets your company conduct business,and your users are focused on your company's business rather than on the vagaries of computer security.
many users can't conceive why someone might ever go to the trouble of sending them a malicious email or trying to crack their password,but an attacker only needs to find one weak link in order to penetrate your network.

as a result,relying on voluntary measures to keep your network secure is likely to be a non-starter.
you need the authority to mandate security on the network.
work with your company's management team to develop a security policy that spells out specifically what the value of the information on your network is,and what steps the company is willing to take to protect it.
then develop and implement security measures on the network that reflect this policy.

----------------------------------------------------

## law #2: security only works if the secure way also happens to be the easy way

as we discussed in law #1,you need the authority to mandate security on the network.
however,the flip side is that if you turn the network into a police state,you're likely to face an uprising.
if your security measures obstruct the business processes of your company,your users may flout them.
again,this isn't because they're malicious—it's because they have jobs to do.
the result could be that the overall security of your network would actually be lower after you implemented more stringent policies.

there are three key things you can do to prevent your users from becoming hackers' unwitting accomplices.

make sure your company's security policy is reasonable,and strikes a balance <- between -> security and productivity.
security is important,but if your network is so secure that nobody can get any work done,you haven't really performed a service for your company.

look for ways to make your security processes have value to your users.
for instance,if you have a security policy that calls for virus signatures to be updated once a week,don't expect your users to do the updates manually.
instead,consider using a "push" mechanism to do it automatically.
your users will like the idea of having up to date virus scanners,and the fact that they didn't have to do anything makes it doubly popular.

in cases where you must impose a restrictive security measure,explain to your users why it's necessary.
it's amazing what people will put up with when they know it's for a good cause.

----------------------------------------------------

## law #3: if you don't keep up with security fixes, your network won't be yours for long

it's a fact of life: software contains bugs.
some of these bugs involve security,and there's a huge number of disreputable people actively searching for them in the hope of using them against you.
no matter how secure your network is today,it could all change overnight if a particularly serious vulnerability is discovered.
it could even happen if a series of less-serious vulnerabilities are discovered that can be used in tandem,in an attack that's greater than the sum of its parts.
it's vital that you stay on top of the tactical world of security,and plug the holes in your armor whenever you find one.

the good news is that there are a lot of tools to help you do this.
security mailing lists like ntbugtraq,bugtraq and win2ksecadvice are a great way to learn about the latest attacks.
in addition,many software vendors (including microsoft) have developed security response processes to investigate and fix vulnerabilities.
make sure you check for new bulletins frequently.
(microsoft provides a notification service that enables subscribers to receive all security bulletins via email within minutes of publication,and also has developed a tool that lets iis 5.0 servers constantly verify that the latest patches are installed).
and don't forget service packs—they're one of the best ways to ensure that you're as secure as possible.

----------------------------------------------------

## law #4: it doesn't do much good to install security fixes on a computer that was never secured to begin with

imagine you're a visigoth and you're reconnoitering a castle that you and the rest of the horde plan to sack and pillage.
from your hideout in the woods,you see that there's a veritable army of serfs performing maintenance on the castle's defenses—they're patching chinks in the mortar,sharpening the points on the chevaux-de-frise,and refilling the vats of boiling oil.
now you sneak around to the back of the castle and discover—that there is no back of the castle! they never built it! how much good is all that maintenance on the front of the castle going to do when you and the horde attack from the rear?

similarly,what good are security patches if you've got a weak administrator password on your domain controller? or if you've shared out your web server's hard drive to the world? or if you've enabled the guest account on your company's payroll server? the time to lock down a machine is before it's ever connected to the network.
if this sounds like too much work,consider that,if a bad guy compromises the machine,you're going to need to rebuild it anyway.
microsoft provides security checklists that make it easy to lock down your machines,as well as a security lockdown tool that you can use to automatically secure iis 5.0 web servers.
it doesn't get much easier than that.

----------------------------------------------------

## law #5: eternal vigilance is the price of security

ok,so you read laws 3 and 4 and patted yourself on the back.
you've done everything right—you secured your machines before putting them into production,you've got the latest service pack installed,and you've been diligently applying security patches.
you must be secure,right? well,maybe,but maybe not.
even under these conditions,a malicious user could attack your network.
for instance,he could mount flooding attacks,and simply send huge numbers of legitimate requests to a server in order to use all of its resources.
or he could conduct brute-force password-guessing attacks.
neither security patches nor machine configurations can totally prevent attacks like these,because the bad guy's activities,although malicious,aren't invalid.

you do have a weapon,though—the event logs.
they'll give you information about who's using system resources,what they're doing,and whether the operation succeeded or failed.
once you know who's doing what,you can take appropriate action.
if someone is flooding your system,you can block requests from their ip addresses.
if someone is trying to brute-force your accounts,you can disable ones that are at risk,set up "honey traps" to catch him,or increase the lockout interval on the accounts.
in sum,the event log lets you gauge the health of your systems,and determine the right course of action to keep them safe.

be careful when configuring the event logs—you can easily audit so many events that you'll exceed your ability to analyze the data.
carefully plan what events you need to log,and whether you need to audit only successes,failures or both.
the security checklists include suggested settings in this regard.
finally,keep in mind that the data won't do any good unless you use it.
establish procedures for regularly checking the logs.
if you've got too many machines to check them all yourself,consider buying a third-party data mining tool that will automatically parse the logs for known indicators that your system is under attack.

----------------------------------------------------

## law #6: there really is someone out there trying to guess your passwords

passwords are a classic example of the truism that your system is only as secure as the weakest part of your defenses.
one of the first things an attacker may test is the strength of your passwords,for two reasons:

they're extraordinarily valuable.
regardless of the other security practices you follow,if a bad guy can learn just one user's password,he can gain access to your network.
from there,he has a perfect position from which to mount additional attacks.

passwords are "low-hanging fruit".
most people pick lousy passwords.
they'll pick an easily guessed word,and never change it.
if forced to pick a more-difficult password,many users will write it down.
(this is also known as the "yellow sticky pad" vulnerability).
you don't have to be technical whiz to crack someone's account if you already know their password.

unless you can enforce a strong password policy,you'll never secure your network.
establish minimum password length,password complexity,and password expiration policies on your network.
(windows 2000,for instance,will let you set these as part of group policy).
also,use account lockout,and make sure you audit for failed logon attempts.
finally,make sure that your users understand why it's a bad practice to write their passwords down.
if you need a demonstration,get management approval to periodically walk through your users' offices,and check for the dreaded sticky note with a password written on it.
don't do an intrusive search,just check the top desk drawer,the underside of the keyboard,and the pull-out writing table that's found on many desks.
if your company is like most,you'll be amazed how many you'll find.

in addition to strengthening the passwords on your system,you may also want to consider using a stronger form of authentication than passwords.
for instance,smart cards can significantly improve the security of your network,because the person must have both a pin and physical possession of the card in order to log on.
biometric authentication takes this security to an even higher level,because the item that's used to log on – your fingerprint,retina,voice,etc.
– is part of you and can't ever be lost.
whatever you choose,make sure that your authentication process provides a level of security commensurate with the rest of your network's security measures.

----------------------------------------------------

## law #7: the most secure network is a well-administered one

most successful attacks don't involve a flaw in the software.
instead,they exploit misconfigurations—for example,permissions that were lowered during troubleshooting but never reset,an account that was created for a temporary employee but never disabled when he left,a direct internet connection that someone set up without approval,and so forth.
if your procedures are sloppy,it can be difficult or impossible to keep track of these details,and the result will be more holes for a bad guy to slither through.

the most important tool here isn't a software tool—it's procedures.
having specific,documented procedures is an absolute necessity.
as usual,it starts with the corporate security policy,which it should spell out,at a broad level,who's responsible for each part of the network,and the overall philosophy governing deployment,management and operation of the network.
but don't stop with the high-level corporate policy.
each group should refine the policy and develop operating procedures for their area of responsibility.
the more specific these procedures are,the better.
and write them down! if your procedures exist only as oral tradition,they'll be lost as your it personnel changes.

next,consider setting up a "red team",whose only job is to scour the network for potential security problems.
red teams can immediately improve security by bringing a fresh set of eyes to the problem.
but there can be a secondary benefit as well.
network operators will be much more likely to think about security in the first place if there's a red team on the prowl—if only because nobody wants the red team showing up at their office to discuss the latest security problem they found.

----------------------------------------------------

## law #8: the difficulty of defending a network is directly proportional to its complexity

this law is related to law #7—more complex networks are certainly more difficult to administer—but it goes beyond just administering it.
the crucial point here is the architecture itself.
here are some questions to ask yourself:

what do the trust relationships <- between -> the domains in your network look like? are they straightforward and easily understood,or do they look like spaghetti? if it's the latter,there's a good chance that someone could abuse them to gain privileges you don't intend for them to have.

do you know all the points of access into your network? if one of the groups in your company has,for instance,set up a public ftp or web server,it might provide a back door onto your network.

do you have a partnership agreement with another company that allows their network users onto your network? if so,the security of your network is effectively the same as that of the partner network.

adopt the phrase "few and well-controlled" as your mantra for network administration.
trust relationships? few and well-controlled.
network access points? few and well-controlled.
users? few and well-controlled—just kidding! the point is that you can't defend a network you don't understand.

----------------------------------------------------

## law #9: security isn't about risk avoidance; it's about risk management

one of the most often-cited truisms in computer security is that the only truly secure computer is one buried in concrete,with the power turned off and the network cable cut.
it's true—anything less is a compromise.
however,a computer like that,although secure,doesn't help your company do business.
inevitably,the security of any useful network will be less than perfect,and you have to factor that into your planning.

your goal cannot be to avoid all risks to the network—that's simply unrealistic.
instead,accept and embrace these two undeniable truths:

there will be times when business imperatives conflict with security.
security is a supporting activity to your business rather than an end unto itself.
take considered risks,and then mitigate them to the greatest extent possible.

your network security will be compromised.
it may be a minor glitch or a bona fide disaster,it may be due to a human attacker or an act of god,but sooner or later your network will be compromised in some fashion.
make sure you have made contingency plans for detecting,investigating and recovering from the compromise.

the place to deal with both of these issues is in your security policy.
work with corporate management to set the overall guidelines regarding the risks you're willing to take and how you intend to manage them.
developing the policy will force you and your corporate management to consider scenarios that most people would rather not think about,but the benefit is that when one of these scenarios occurs,you'll already have an answer.

----------------------------------------------------

## law #10: technology is not a panacea

if you've read the 10 immutable laws of security,you'll recognize this law – it's the final law on that list as well.
the reason it's on both lists is because it applies equally well to both network users and administrators,and it's equally important for both to keep in mind.

technology by itself isn't enough to guarantee security.
that is,there will never be a product that you can simply unpackage,install on your network,and instantly gain perfect security.
instead,security is a result of both technology and policy—that is,it's how the technology is used that ultimately determines whether your network is secure.
microsoft delivers the technology,but only you and your corporate management can determine the right policies for your company.
plan for security early.
understand what you want to protect and what you're willing to do to protect it.
finally,develop contingency plans for emergencies before they happen.
couple thorough planning with solid technology,and you'll have great security.