# Reversible Encryption
1. it has to be enabled on an AD account
2. it has to be enabled on the password policy
3. the clear-text password can be retrieved in a DCSync attack when the below condition is also met.
4. the clear-text password would only be there in the dump if there was a password change done after the feature has been set. In other words, the DC won't be allowed to see the incoming clear-text password unless the feature is set beforehand.

# RDP Security: Network Level Authentication
This feature is handy because it would stop any computer non-joined to the domain from using RDP. even if he has a correct set of credentials.
Even with a network logon using runas:
```shell
runas.exe /netonly /user:lab.local\administrator mstsc.exe
```

# The use of kerberos pre-authentication
Without pre-auth, anyone could get a blob encrypted with a key derived from a client's password and would be able ot crack it offline --> ASREPRoast

# The method of kerberos preauthentication. The reason for adjusting clock skew.
To prevent relay attacks, the client performs preauth by encrypting a timestamp with their credentials --> this will prove to the KDC that they have the creds for the account. This is also why there can't be much clockskew

# Shadow Credentials are alternative credentials
Since: Shadow Creds --> TGT --> NTLM Hash 
The shadow creds would help the attacker persist even after the user/computer has changed their password

# Elicit machine account authentication
1. PetitPotam.py
2. Printerbug.py