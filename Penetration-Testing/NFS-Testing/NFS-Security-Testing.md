# Root squash
Root squash is the removal of root privileges of the user mounting the share.
without root squashing, the user connecting from the network can have root access.

# How this can be exploited for privilege escalation
*if there's no root squashing:*
1. we can mount a NFS volume
2. copy a normal bash shell
3. change location to the mount directory
4. setuid for the bash shell
5. connect to the NFS host
6. execute the SUID bash shell and gain root access

*This happens because the chmod +s bash was done as root in the mount directory and was percieved by the system as done by its own root account*