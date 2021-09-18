# what does active directory do?
1. stores info about objects on the network
2. makes this info available to users and network admins
3. uses domain controllers to give network users access to permitted resources anywhere on the network through single logon process

# what are the best practices for kerberos TGS & TGT?
- 10 hours

# what are the AD database, log files and SYSVOL locations?
1. Database: C:\Windows\NTDS
2. Log files: C:\Windows\NTDS
3. SYSVOL: C:\Windows\SYSVOL

# what is sysvol?
1. contains group policy objects
2. contains logon scripts
3. replicated by FRS

# what are AD replication components/objects?
1. Connection object
2. KCC
3. Failover functionality
4. Subnet
5. Site
6. Site link
7. Site link bridge
8. Site link transitivity
9. Global catalog server
10. Universal group membership caching

*Problems with replication can lead to authentication problems and problems with accessing resources on the network.*