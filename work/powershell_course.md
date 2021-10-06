# what do you know about powershell?
# what makes you want to learn powershell?
# what do you expect from this course?
# what would you do after you have learned powershell?

# what's the difference between powershell/cmd/bash?
1. format (powershell follows the verb-noun convention)
2. powershell is object oriented (allows for filtering and selection) and not plain text
3. using the .NET framework, PowerShell has soo many functionalities (math operations, GUI, date operations etc.)

# what are the steps of writing a script?
1. breaking down the task into the smallest steps
2. finding as much as we can about the details
3. finding the errors (what could go wrong)
4. testing, testing & then more testing :D

# what is execution policy?
1. it defines the policy on which powershell runs (restricted, unrestricted, remotesigned)

# what are the main concepts of powershell?
1. the pipeline --> (multiple operations in a single line of code)
2. dealing with objects --> (exploring attributes and functionalities)
3. filtering --> (limiting the objects to just what we need)
4. sorting --> (highlighing the needed data)
5. selection --> (getting just the data that we need) (expanding and excluding) (first, last, skipping) (finding property names with either get-member or select -first 1 -property *)
6. formatting --> (viewing data on the console)
7. exporting --> (saving output to files)
8. looping --> (operating on multiple objects) (less code repitition)
9. flow-control --> (writing smart scripts) (using break & continue)
10. variables --> (storing and working with data)
11. operators --> (comparison)
12. Switches & Parameters --> (command diverse functionality)
13. powershell remoting

# what makes want to teach this course?
1. Passing knowledge
4. supplying need for the marketplace
2. Improving productivity
3. Helping create more skilled system admins

# what does a command do?
1. create something
2. read something
3. update something
4. delete something

# what would help you understand powershell easier?
1. asking me all the questions you can
2. understanding commands, the pipeline, filtering, selection, formatting & exporting
3. using the get-help command well and using the examples switch

# what makes powershell easy?
1. standard format for commands (VERB + NOUN)
2. objects (easily filter)
3. once understood, your IT life will be a LOT easier

# what do I do for a living?
1. Penetration Testing
2. Incident Response
3. Risk Assessment
4. Network Administration
5. Security Admnistration
6. Automation

# what makes me qualified to teach this course?
1. learned from the best (MVP Don Jones, Jeff Hicks)
2. written PowerShell for 2+ years (almost daily) (tens of thousands in lines of code)
3. two major projects (IT Toolkit, PowerEye)
4. teaching PowerShell on a dialy basis
5. In-depth knowledge
6. programming experience

# what should you expect from this course?
1. having skill to handle ANY task on windows using powershell
2. having skill to be more productive and efficient at work
3. having skill to automate tasks like a BOSS

# what makes powershell important?
0. complete windows environment management
1. automation (speed) (efficiency with bulk operations)
2. reporting
3. analysis
4. integrates with everything (PowerCLI, Active Directory ... etc)
5. Many modules
6. constantly improved and developed by the PowerShell Team
7. moving to linux
8. its installed by default on every computer starting windows 7
9. gives complete control of domain servers/computers
10. opens the door for many fields in IT

# what can powershell do?
1. collect information from computers
2. execute actions in bulk
3. anything

# what makes discovering commands important?
1. finding functionality
2. more room for creativity

# what do we do to discover commands?
1. get-command
2. google

# what makes powershell filtering important?
1. narrowing down the data produced from commands
2. finding only interesting information

# what do we do to filter the data we get with powershell?
1. use operators

# what are the operators used in powershell?
1. eq/ne (exact)
2. like/notlike (approximation)
3. contains/notcontains (arrays/blacklists)
4. match/notmatch (patterns)
5. boolean operators (AND/OR etc.)
6. replacement operators (regular expressions)

# what's the source of computer related information?
1. WMI (WMI Explorer)
2. CIM

# what makes variables important?
1. keeping data for later use
2. storing data in correct format
3. processing data correctly

# what can you interact with using powershell?
1. processes
2. services
3. scheduled tasks
4. the eventlog
5. files
6. disks
7. Registry
8. VMs (Hyper-V/VMWare)
9. DNS/DHCP
10. WSUS
11. Exchange
12. active directory
13. Azure
14. sharepoint
## inshort: all windows/server components & other items

# what are the variable types in powershell?
1. integers
2. strings
3. hashtables

# what makes a script?
1. a series of commands
2. a single scope for variables

# what can we do to make our script smart?
1. if conditionals
2. switch statments

# what's so good about objects?
1. attributes (filtering and selection)
2. methods

# what do we do to select certain data?
1. looking at the object properties (get-member, select all, what's the difference? (methods))
2. selection (unique)
3. sorting (ascending/descending)

# what do we do when we want to find how many objects returned? max, min, average?
1. measure command

# what does the pipeline do? what makes it work?
1. PSItem variable
2. input-(command)-output --> input-(command)-output
3. StdIn, StdOut, StdErr

# what do we do when processing text (logs)?
1. regular expressions
2. select-string command
3. groups
4. context

# what makes remoting important?
1. powerful administration
2. speed and efficiency
3. decreasing load on local computer and passing it to remote hosts

# what we do to run powershell on remote computer?
1. Invoke-command (one-time)
2. powershell sessions (persistent)

# what do we do to store remoting data?
1. adding collected data into an object
2. taking the results into variables

# what are tricks to increase remoting speed?
1. parallel remoting

# what do we do to pass data into scripts?
1. argumentlist
2. finding arguments in the remote scope

# what can we do to improve powershell everyday?
1. check a random command everyday

# what are objects?
1. a collection of attributes/methods regarding a specific entity

# what are the components of powershell help?
1. parameter sets
2. input types

# what are the steps of using powershell?
1. the command (its parameters)
2. filtering
3. selection
4. formatting / exporting

# what are handy stuff we can do?
1. get online computers
2. get disk space
3. get RAM percent
4. get CPU percent
5. deploy software
6. uninstall software
7. restart computers
8. automate active directory operations (user creation, security groups, OUs, group policies etc.)

# what's important about powershell background jobs?
1. some tasks need to run in parallel

# what can we do to push powershell tasks into the background?
1. start-job

# what are the uses of interactive scripts?
1. user-friendliness

# what are the uses of functions?
1. repeated use of commands

# what do we do about errors?
1. try/catch (erroraction preference) (which errors can be caught?)
2. ErrorAction parameter
3. the error object and the $error array

# what do we do with complex object heirarchies?
1. xml format

# what do we do to present data in the console?
1. format-list
2. format-table
3. out-gridview
4. more

# what do we do to save the results to files?
1. export-csv
2. converto-html

# what are handy tricks to help your powershell life?
1. using pause
2. using the clipboard
3. learning regular expressions
4. compare-object
5. group-object
6. splatting
7. timespans
8. splits, joins & replaces
9. sleep
10. colored output
11. sub-expressions

# what makes us use custom objects?
1. collections of data from multiple sources
2. clean output and meaningful reports

# what about sending mails?
1. requirements
2. HTML format and styling
3. attachments

# what do we do when we want to loop over data?
1. loops (do-while, while, foreach, for-loops)

# what do we do to modify stuff in the pipeline?
1. @{n='';e={}}

# what are modules and what makes them cool?
1. added functionality

# what are some important math operations?
1. rounding
2. power
3. approximation
4. absolute

# what confirms if a command succeeded or not?
1. the $? variable
2. error handling
3. the -passthru switch