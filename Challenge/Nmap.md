# PORT    STATE SERVICE     VERSION
# 21/tcp  open  ftp         vsftpd 3.0.3
## ftp-anon: Anonymous FTP login allowed (FTP code 230)
## -rw-r--r--    1 0        0              31 Feb 17 13:14 secret.txt
## ftp-syst: 
### STAT: 
## FTP server status:
|      Connected to ::ffff:192.168.56.102
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 3
|      vsFTPd 3.0.3 - secure, fast, stable
## End of status

# 22/tcp  open  ssh         OpenSSH 8.2p1 Ubuntu 4ubuntu0.4 (Ubuntu Linux; protocol 2.0)
## ssh-hostkey: 
### 3072 c1:10:1e:30:31:c6:cb:d6:40:99:d0:b2:ac:a7:b0:52 (RSA)
### 256 1b:9e:d0:3b:fc:75:12:43:18:d1:06:2e:54:92:a5:cb (ECDSA)
### 256 77:f8:b6:29:58:b7:0a:04:30:30:56:76:32:df:4a:33 (ED25519)

# 80/tcp  open  http        Apache httpd 2.4.41 ((Ubuntu))
## http-server-header: Apache/2.4.41 (Ubuntu)
## http-title: POS SYSTEM
## http-cookie-flags: 
### /: 
|     PHPSESSID: 
|       httponly flag not set

# 139/tcp open  netbios-ssn Samba smbd 4.6.2

# 445/tcp open  netbios-ssn Samba smbd 4.6.2

------------------------------------------------------------------------

# MAC Address: 08:00:27:6B:41:43 (Oracle VirtualBox virtual NIC)
# Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

# Host script results:
## clock-skew: -1s
## smb2-time: 
### date: 2022-02-27T17:56:14
### start_date: N/A
## nbstat: NetBIOS name: UBUNTU, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
## smb2-security-mode: 
### 3.1.1: 
|     Message signing enabled but not required