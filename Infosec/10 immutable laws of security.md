# Law #1: Nobody believes anything bad can happen to them, until it does

## Many people are unwilling partners in computer security.
## This isn't because they're deliberately trying to endanger the network—they simply have a different agenda than you do.
## The reason your company has a network is because it lets your company conduct business,
- *AND* your users are focused on your company's business rather than on the vagaries of computer security.
## Many users can't conceive why someone might ever go to the trouble of sending them a malicious email *OR* trying to crack their password,
- *BUT* an attacker *ONLY* needs to find one weak link in order to penetrate your network.

## As a result,
- relying on voluntary measures to keep your network secure is likely to be a non-starter.
## You need the authority to mandate security on the network.
## Work with your company's management team to develop a security policy that spells out *SPECIFICALLY* what the value of the information on your network is,
- *AND* what steps the company is willing to take to protect it.
## Then develop *AND* implement security measures on the network that reflect this policy.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
- a company's focus is on business ... not on what happens in the infosec world.
- people don't understand what could make a hacker want to go through all the trouble of hacking them. they just don't see it as possible. a hacker's nature is way too different.
- gaining authority is the way to mandate security actions
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Law #2: Security only works if the secure way also happens to be the easy way

## As we discussed in Law #1,
- you need the authority to mandate security on the network.
## However,
- the flip side is that *IF* you turn the network into a police state,
- you're likely to face an uprising.
## *IF* your security measures obstruct the business processes of your company,
- your users may flout them.
## Again,
- this isn't because they're malicious—it's because they have jobs to do.
## The result could be that the overall security of your network would actually be lower after you implemented more stringent policies.

## There are three key things you *CAN* do to prevent your users from becoming hackers' unwitting accomplices.

## Make sure your company's security policy is reasonable,
- *AND* strikes a balance <- *BETWEEN* -> security *AND* productivity.
## Security is important,
- *BUT* *IF* your network is so secure that nobody *CAN* get any work done,
- you haven't really performed a service for your company.

## Look for ways to make your security processes have value to your users.
## For instance,
- *IF* you have a security policy that calls for virus signatures to be updated once a week,
- don't expect your users to do the updates manually.
## Instead,
- consider using a "push" mechanism to do it automatically.
## Your users will like the idea of having up to date virus scanners,
- *AND* the fact that they didn't have to do anything makes it doubly popular.

## In cases where you *MUST* impose a restrictive security measure,
- explain to your users why it's necessary.
## It's amazing what people will put up with *WHEN* they know it's for a good cause.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
- balance is required between security and productivity
- explaining the reason behind an annoying security procedure can lighten the load
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Law #3: If you don't keep up with security fixes, your network won't be yours for long

## It's a fact of life: software contains bugs.
## Some of these bugs involve security,
- *AND* there's a huge number of disreputable people actively searching for them in the hope of using them against you.
## No matter how secure your network is today,
- it could *ALL* change overnight *IF* a particularly serious vulnerability is discovered.
## It could even happen *IF* a series of less-serious vulnerabilities are discovered that *CAN* be used in tandem,
- in an attack that's greater than the sum of its parts.
## It's vital that you stay on top of the tactical world of security,
- *AND* plug the holes in your armor whenever you find one.

## The good news is that there are a lot of tools to help you do this.
## Security mailing lists like NTBugTraq,
- BugTraq *AND* Win2kSecAdvice are a great way to learn about the latest attacks.
## In addition,
- many software vendors (including Microsoft) have developed security response processes to investigate *AND* fix vulnerabilities.
## Make sure you check for new bulletins frequently.
## (Microsoft provides a notification service that enables subscribers to receive *ALL* security bulletins via email within minutes of publication,
- *AND* also has developed a tool that lets IIS 5.0 servers constantly verify that the latest patches are installed).
## And don't forget service packs—they're one of the best ways to ensure that you're as secure as possible.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
- many people are looking for vulnerabilities. a number of small vulns can cause just as much damage as a big vuln
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Law #4: It doesn't do much good to install security fixes on a computer that was never secured to begin with

## Imagine you're a Visigoth *AND* you're reconnoitering a castle that you *AND* the rest of the horde plan to sack *AND* pillage.
## From your hideout in the woods,
- you see that there's a veritable army of serfs performing maintenance on the castle's defenses—they're patching chinks in the mortar,
- sharpening the points on the chevaux-de-frise,
- *AND* refilling the vats of boiling oil.
## Now you sneak around to the back of the castle *AND* discover—that there is no back of the castle! They never built it! How much good is *ALL* that maintenance on the front of the castle going to do *WHEN* you *AND* the horde attack from the rear?

## Similarly,
- what good are security patches *IF* you've got a weak administrator password on your domain controller? *OR* *IF* you've shared out your web server's hard drive to the world? *OR* *IF* you've enabled the Guest account on your company's payroll server? The time to lock down a machine is before it's ever connected to the network.
## *IF* this sounds like too much work,
- consider that,
- *IF* a bad guy compromises the machine,
- you're going to need to rebuild it anyway.
## Microsoft provides security checklists that make it easy to lock down your machines,
- as well as a security lockdown tool that you *CAN* use to automatically secure IIS 5.0 Web servers.
## It doesn't get much easier than that.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
- ignoring the big holes in your network won't work. having a cutting-edge firewall won't help when you have weak passwords.
- secure your stuff before going out on the internet
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Law #5: Eternal vigilance is the price of security

## OK,
- so you read Laws 3 *AND* 4 *AND* patted yourself on the back.
## You've done everything right—you secured your machines before putting them into production,
- you've got the latest service pack installed,
- *AND* you've been diligently applying security patches.
## You *MUST* be secure,
- right? Well,
- maybe,
- *BUT* maybe not.
## Even under these conditions,
- a malicious user could attack your network.
## For instance,
- he could mount flooding attacks,
- *AND* simply send huge numbers of legitimate requests to a server in order to use *ALL* of its resources.
## *OR* he could conduct brute-force password-guessing attacks.
## *NEITHER* security patches nor machine configurations *CAN* totally prevent attacks like these,
- because the bad guy's activities,
- *ALTHOUGH* malicious,
- aren't invalid.

## You do have a weapon,
- though—the event logs.
## They'll give you information about who's using system resources,
- what they're doing,
- *AND* whether the operation succeeded *OR* failed.
## Once you know who's doing what,
- you *CAN* take appropriate action.
## *IF* someone is flooding your system,
- you *CAN* block requests from their IP addresses.
## *IF* someone is trying to brute-force your accounts,
- you *CAN* disable ones that are at risk,
- set up "honey traps" to catch him,
- *OR* increase the lockout interval on the accounts.
## In sum,
- the event log lets you gauge the health of your systems,
- *AND* determine the right course of action to keep them safe.

## Be careful *WHEN* configuring the event logs—you *CAN* easily audit so many events that you'll exceed your ability to analyze the data.
## Carefully plan what events you need to log,
- *AND* whether you need to audit *ONLY* successes,
- failures *OR* both.
## The security checklists include suggested settings in this regard.
## Finally,
- keep in mind that the data won't do any good *UNLESS* you use it.
## Establish procedures for regularly checking the logs.
## *IF* you've got too many machines to check them *ALL* yourself,
- consider buying a third-party data mining tool that will automatically parse the logs for known indicators that your system is under attack.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
- there are other attack types that use volume (DDoS) that can cause damage.
- tracking what happens to the system through event logs is the way to go. filtering only the important logs can help minimize the worlkload and make things trackable rather than overwhelming.
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Law #6: There really is someone out there trying to guess your passwords

## Passwords are a classic example of the truism that your system is *ONLY* as secure as the weakest part of your defenses.
## One of the first things an attacker may test is the strength of your passwords,
- for two reasons:

## They're extraordinarily valuable.
## *REGARDLESS* of the other security practices you follow,
- *IF* a bad guy *CAN* learn just one user's password,
- he *CAN* gain access to your network.
## From there,
- he has a perfect position from *WHICH* to mount additional attacks.

## Passwords are "low-hanging fruit".
## Most people pick lousy passwords.
## They'll pick an easily guessed word,
- *AND* never change it.
## *IF* forced to pick a more-difficult password,
- many users will write it down.
## (This is also known as the "yellow sticky pad" vulnerability).
## You don't have to be technical whiz to crack someone's account *IF* you already know their password.

## *UNLESS* you *CAN* enforce a strong password policy,
- you'll never secure your network.
## Establish minimum password length,
- password complexity,
- *AND* password expiration policies on your network.
## (Windows 2000,
- for instance,
- will let you set these as part of Group Policy).
## Also,
- use account lockout,
- *AND* make sure you audit for failed logon attempts.
## Finally,
- make sure that your users understand why it's a bad practice to write their passwords down.
## *IF* you need a demonstration,
- get management approval to periodically walk through your users' offices,
- *AND* check for the dreaded sticky note with a password written on it.
## Don't do an intrusive search,
- just check the top desk drawer,
- the underside of the keyboard,
- *AND* the pull-out writing table that's found on many desks.
## *IF* your company is like most,
- you'll be amazed how many you'll find.

## In addition to strengthening the passwords on your system,
- you may also want to consider using a stronger form of authentication than passwords.
## For instance,
- smart cards *CAN* significantly improve the security of your network,
- because the person *MUST* have both a PIN *AND* physical possession of the card in order to log on.
## Biometric authentication takes this security to an even higher level,
- because the item that's used to log on – your fingerprint,
- retina,
- voice,
- etc.
## – is part of you *AND* can't ever be lost.
## Whatever you choose,
- make sure that your authentication process provides a level of security commensurate with the rest of your network's security measures.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
- use a strong password and increase the factors of authentication
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Law #7: The most secure network is a well-administered one

## Most successful attacks don't involve a flaw in the software.
## Instead,
- they exploit misconfigurations—for example,
- permissions that were lowered during troubleshooting *BUT* never reset,
- an account that was created for a temporary employee *BUT* never disabled *WHEN* he left,
- a direct Internet connection that someone set up without approval,
- *AND* so forth.
## *IF* your procedures are sloppy,
- it *CAN* be difficult *OR* impossible to keep track of these details,
- *AND* the result will be more holes for a bad guy to slither through.

## The most important tool here isn't a software tool—it's procedures.
## Having specific,
- documented procedures is an absolute necessity.
## As usual,
- it starts with the corporate security policy,
- *WHICH* it should spell out,
- at a broad level,
- who's responsible for each part of the network,
- *AND* the overall philosophy governing deployment,
- management *AND* operation of the network.
## *BUT* don't stop with the high-level corporate policy.
## Each group should refine the policy *AND* develop operating procedures for their area of responsibility.
## The more specific these procedures are,
- the better.
## *AND* write them down! *IF* your procedures exist *ONLY* as oral tradition,
- they'll be lost as your IT personnel changes.

## Next,
- consider setting up a "Red Team",
- whose *ONLY* job is to scour the network for potential security problems.
## Red Teams *CAN* immediately improve security *BY* bringing a fresh set of eyes to the problem.
## *BUT* there *CAN* be a secondary benefit as well.
## Network operators will be much more likely to think about security in the first place *IF* there's a Red Team on the prowl—*IF* *ONLY* because nobody wants the Red Team showing up at their office to discuss the latest security problem they found.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
- having proper processes and controls is the way to go to make sure no loose configurations are there
- misconfigurations are just as dangerous as vulnerabilities ... if not more
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Law #8: The difficulty of defending a network is directly proportional to its complexity

## This law is related to Law #7—more complex networks are certainly more difficult to administer—but it goes beyond just administering it.
## The crucial point here is the architecture itself.
## Here are some questions to ask yourself:

## What do the trust relationships <- *BETWEEN* -> the domains in your network look like? Are they straightforward *AND* easily understood,
- *OR* do they look like spaghetti? *IF* it's the latter,
- there's a good chance that someone could abuse them to gain privileges you don't intend for them to have.

## Do you know *ALL* the points of access into your network? *IF* one of the groups in your company has,
- for instance,
- set up a public FTP *OR* web server,
- it might provide a back door onto your network.

## Do you have a partnership agreement with another company that allows their network users onto your network? *IF* so,
- the security of your network is effectively the same as that of the partner network.

## Adopt the phrase "few *AND* well-controlled" as your mantra for network administration.
## Trust relationships? Few *AND* well-controlled.
## Network access points? Few *AND* well-controlled.
## Users? Few *AND* well-controlled—just kidding! The point is that you can't defend a network you don't understand.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
- complete understanding of your network is the way to go. keep everything simple and well-controlled.
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Law #9: Security isn't about risk avoidance; it's about risk management

## One of the most often-cited truisms in computer security is that the *ONLY* truly secure computer is one buried in concrete,
- with the power turned off *AND* the network cable cut.
## It's true—anything less is a compromise.
## However,
- a computer like that,
- *ALTHOUGH* secure,
- doesn't help your company do business.
## Inevitably,
- the security of any useful network will be less than perfect,
- *AND* you have to factor that into your planning.

## Your goal cannot be to avoid *ALL* risks to the network—that's simply unrealistic.
## Instead,
- accept *AND* embrace these two undeniable truths:

## There will be times *WHEN* business imperatives conflict with security.
## Security is a supporting activity to your business rather than an end unto itself.
## Take considered risks,
- *AND* then mitigate them to the greatest extent possible.

## Your network security will be compromised.
## It may be a minor glitch *OR* a bona fide disaster,
- it may be due to a human attacker *OR* an act of God,
- *BUT* sooner *OR* later your network will be compromised in some fashion.
## Make sure you have made contingency plans for detecting,
- investigating *AND* recovering from the compromise.

## The place to deal with both of these issues is in your security policy.
## Work with corporate management to set the overall guidelines regarding the risks you're willing to take *AND* how you intend to manage them.
## Developing the policy will force you *AND* your corporate management to consider scenarios that most people would rather *NOT* think about,
- *BUT* the benefit is that *WHEN* one of these scenarios occurs,
- you'll already have an answer.

### why does this make sense?
### what makes this important?
### what are your questions?
### what are the ideas?
- risk management comes with the risks you're willing to take. having an answer to what you will do in case of compromise is top priority then.
### what are the terms and meanings?
### what did I learn? what is my paraphrase?
### what connections can be made with previous knowledge?
### what can be applied?
### what areas made your mind wander? what areas you didn't understand?

----------------------------------------------------

# Law #10: Technology is not a panacea

## *IF* you've read The 10 Immutable Laws of Security,
- you'll recognize this law – it's the final law on that list as well.
## The reason it's on both lists is because it applies equally well to both network users *AND* administrators,
- *AND* it's equally important for both to keep in mind.

## Technology *BY* itself isn't enough to guarantee security.
## That is,
- there will never be a product that you *CAN* simply unpackage,
- install on your network,
- *AND* instantly gain perfect security.
## Instead,
- security is a result of both technology *AND* policy—that is,
- it's how the technology is used that ultimately determines whether your network is secure.
## Microsoft delivers the technology,
- *BUT* *ONLY* you *AND* your corporate management *CAN* determine the right policies for your company.
## Plan for security early.
## Understand what you want to protect *AND* what you're willing to do to protect it.
## Finally,
- develop contingency plans for emergencies before they happen.
## Couple thorough planning with solid technology,
- *AND* you'll have great security.

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