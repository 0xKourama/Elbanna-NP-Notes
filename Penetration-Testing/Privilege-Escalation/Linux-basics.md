# What's the OS? What version? What architecture?
```
cat /etc/*-release
uname -i
lsb_release -a (Debian based OSs)
```
# Who are we? Where are we?
```
id
pwd
```
# Who uses the box? What users? (And which ones have a valid shell)
```
cat /etc/passwd
grep -vE "nologin|false" /etc/passwd
```
# What's currently running on the box? What active network services are there?
```
ps aux
netstat -antup
```
# What's installed? What kernel is being used?
```
dpkg -l (Debian based OSs)
rpm -qa (CentOS / openSUSE )
uname -a
```

# Then using this information, we can help answer the following:
1. What user files do we have access to?
2. What configurations do we have access to?
3. Any incorrect file permissions?
4. What programs are custom? Any SUID? SGID?
5. What's scheduled to run?
6. Any hardcoded credentials? Where are credentials kept?
7. what's running on the box?
8. what ports are listening? internally?

*...and many many other questions*