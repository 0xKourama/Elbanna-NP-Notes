# SystemAdmins
1. Abdelrahman
2. Hussein

## privileges:
ALL -> RDP
Servers -> Power Users
`DCs -> Server Operators`
ALL -> Network configuration Operators
WSUS -> WSUS Administrators
PST + OOS > RDP + powerusers
### wp-syslog >> RDP + powerusers

---

# Exchange admins
1. nada
2. wahba

## privileges:
DCs + Exchange -> RDP
Exchange -> Power Users
`DCs -> Server Operators`
PST + Office Online -> RDP
PST + Office Online -> Power Users

---

# Developers
Dev sec group -> Local Admin

---

# Global Admins
All -> Local Admin

--------------------

# Generic Servers
Globaladmins   ---> local admin
Sysadmins      ---> RDP
Sysadmins      ---> Powerusers
Sysadmins      ---> network config operators

# Exchange Servers + PST server
Globaladmins   ---> local admin
Sysadmins      ---> RDP
exchangeadmins ---> RDP
exchangeadmins ---> power users

# Domain Controllers
Globaladmins   ---> local admin
Sysadmins      ---> RDP
Exchangeadmins ---> RDP

# Developer servers
Developers     ---> localadmin