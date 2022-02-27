# mysql version
mysql  Ver 8.0.28-0ubuntu0.20.04.3 for Linux on x86_64 ((Ubuntu))

# maria db files
-rw------- 1 root root 317 Feb 17 12:39 /etc/mysql/debian.cnf

# mysql config
lrwxrwxrwx 1 root root 24 Feb 17 12:38 /etc/mysql/my.cnf -> /etc/alternatives/my.cnf
-rw-r--r-- 1 root root 81 Feb 17 12:39 /var/lib/dpkg/alternatives/my.cnf

# priv user
uid=1000(levi) gid=1000(levi) groups=1000(levi),4(adm),24(cdrom),30(dip),46(plugdev),116(lxd)

# bashrc
-rw-r--r-- 1 levi levi 3771 Feb 25  2020 /home/levi/.bashrc
-rw-r--r-- 1 levi levi 807 Feb 25  2020 /home/levi/.profile


# ssh root login enabled

# sshd config file
/usr/share/openssh/sshd_config

# FTP config
-rw-r--r-- 1 root root 69 Nov 25 23:16 /etc/php/7.4/mods-available/ftp.ini
-rw-r--r-- 1 root root 69 Nov 25 23:16 /usr/share/php7.4-common/common/ftp.ini

# unexpected in root
/ftp
/share
/swap.img


# what we want to do
1. skim all files properly
2. guess passwords based on findings --> use with levi
3. go through database searching for stuff
4. checking for db privesc to root
5. checking db version for privesc
6. checking that other sudo exploit
7. 