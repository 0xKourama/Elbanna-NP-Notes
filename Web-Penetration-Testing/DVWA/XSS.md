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
Cookie: security=low; PHPSESSID=d269b3e8858ed43dd8502b2538bf533e
Upgrade-Insecure-Requests: 1

txtName=test2&mtxMessage=test2&btnSign=Sign+Guestbook
```