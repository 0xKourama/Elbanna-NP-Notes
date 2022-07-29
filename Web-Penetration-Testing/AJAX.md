# Example: the below example shows a page that changes itself on the click of a button.
- once clicked, a web request is done in the background to fetch the `ajax_info.txt` file
```html
 <!DOCTYPE html>
<script>
	function loadDoc() {
		const xhttp = new XMLHttpRequest();
		xhttp.onload = function() {
			document.getElementById("demo").innerHTML = this.responseText;
		}
		xhttp.open("GET", "ajax_info.txt", true);
		xhttp.send();
	}
</script>
<html>
	<body>
	<div id="demo">
		<h2>Let AJAX change this text</h2>
		<button type="button" onclick="loadDoc()">Change Content</button>
	</div>
	</body>
</html> 
```

## AJAX typical flow:
1. An **event** occurs in a web page (the page is loaded, a button is clicked)
2. An `XMLHttpRequest` object is created by **JavaScript**
3. The `XMLHttpRequest` object **sends a request to a web server**
4. The server processes the request
5. The server sends a response back to the web page
6. The response is read by **JavaScript**
7. Proper action (like page update) is performed by **JavaScript**

## Modern Browsers (Fetch API)
- Modern Browsers can use **Fetch API** instead of the `XMLHttpRequest` Object.
- The **Fetch API** interface allows web browser to make HTTP requests to web servers.
- If you use the `XMLHttpRequest` Object, **Fetch** can do the same in a *simpler* way.

## The keystone of AJAX is the `XMLHttpRequest` object.
1. **Create** an `XMLHttpRequest` object
```javascript
var xhttp = new XMLHttpRequest();
```
2. **Define** a **callback function**
A callback function is a function passed as a parameter to another function.
```javascript
xhttp.onload = function() {
  // What to do when the response is ready
}
```
3. **Open** the `XMLHttpRequest` object
4. **Send** a Request to a server
```javascript
xhttp.open("GET", "ajax_info.txt");
xhttp.send(); 
```

## Access Across Domains
- *For security reasons,*  
	modern browsers do not allow access across domains.
- This means that both:  
	1. the web page
	2. and the XML file
	*it tries to load,*   
	**must be located on the same server.**

## XMLHttpRequest Object Methods
| Method | Description |
| --- | --- |
| new XMLHttpRequest() | Creates a new XMLHttpRequest object |
| abort() | Cancels the current request |
| getAllResponseHeaders() | Returns header information |
| getResponseHeader() | Returns specific header information |
| open(method, url, async, user, psw) | Specifies the request |
| | method: the request type GET or POST |
| | url: the file location |
| | async: true (asynchronous) or false (synchronous) |
| | user: optional user name |
| | psw: optional password |
| send() | Sends the request to the server |
| | Used for GET requests |
| send(string) | Sends the request to the server. |
| | Used for POST requests |
| setRequestHeader() | Adds a label/value pair to the header to be sent |

## XMLHttpRequest Object Properties
| Property | Description |
| --- | --- |
| onload | Defines a function to be called when the request is recieved (loaded) |
| onreadystatechange | Defines a function to be called when the readyState property changes |
| readyState | Holds the status of the XMLHttpRequest. |
| | 0: request not initialized |
| | 1: server connection established |
| | 2: request received |
| | 3: processing request |
| | 4: request finished and response is ready |
| responseText | Returns the response data as a string |
| responseXML | Returns the response data as XML data |
| status | Returns the status-number of a request |
| | 200: "OK" |
| | 403: "Forbidden" |
| | 404: "Not Found" |
| | For a complete list go to the Http Messages Reference |
| statusText | Returns the status-text (e.g. "OK" or "Not Found") |

## The `onreadystatechange` Property
- The onreadystatechange function is called **every time** the readyState changes.
- *When `readyState` is 4 and `status` is 200,*
	the response is ready
```html
<!DOCTYPE html>
<html>
<body>

<div id="demo">
<h2>The XMLHttpRequest Object</h2>
<button type="button" onclick="loadDoc()">Change Content</button>
</div>

<script>
function loadDoc() {
  const xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      document.getElementById("demo").innerHTML =
      this.responseText;
    }
  };
  xhttp.open("GET", "ajax_info.txt");
  xhttp.send();
}
</script>

</body>
</html>

```
**Note:** The `onreadystatechange` event is triggered **four** times (1-4), **one time for each change in the readyState.**

## call a file on the server
- The `url` parameter of the `open()` method, is an address to a file on a server:
```javascript
xhttp.open("GET", "ajax_test.asp", true);
```
**Note:** The file can be **any** kind of file, like:
- .txt and .xml,  
or **server scripting files** like:
- .asp and .php  
*(which can perform actions on the server before sending the response back).*

# GET or POST?
`GET` is simpler and faster than `POST`, and can be used in most cases.  
*However,* always use `POST` requests when:
- A cached file is not an option (update a file or database on the server).
- Sending a large amount of data to the server (POST has no size limitations).
- Sending user input (which can contain unknown characters), POST is more robust and secure than GET.

## GET Request (we add a `math.random()` call to avoid hitting the cache)
```html
<!DOCTYPE html>
<html>
<body>

<h2>The XMLHttpRequest Object</h2>
<button type="button" onclick="loadDoc()">Request data</button>

<p id="demo"></p>

<script>
function loadDoc() {
  const xhttp = new XMLHttpRequest();
  xhttp.onload = function() {
    document.getElementById("demo").innerHTML = this.responseText;
  }
  xhttp.open("GET", "demo_get.asp?t=" + Math.random());
  xhttp.send();
}
</script>

</body>
</html>

```

## POST Request with headers
```html
<!DOCTYPE html>
<html>
<body>

<h2>The XMLHttpRequest Object</h2>
<button type="button" onclick="loadDoc()">Request data</button>

<p id="demo"></p>

<script>
function loadDoc() {
  const xhttp = new XMLHttpRequest();
  xhttp.onload = function() {
    document.getElementById("demo").innerHTML = this.responseText;
  }
  xhttp.open("GET", "demo_get2.asp?fname=Henry&lname=Ford");
  xhttp.send();
}
</script>
 
</body>
</html>

```

## Server Response Properties
| Property | Description |
| --- | --- |
| responseText | get the response data as a string |
| responseXML | get the response data as XML data |

## The `responseText` Property
The `responseText` property returns the server response as a JavaScript string, and you can use it accordingly:
```javascript
document.getElementById("demo").innerHTML = xhttp.responseText; 
```

## The `responseXML` Property
The `XMLHttpRequest` object has an in-built XML parser.  
The `responseXML` property returns the server response as an **XML DOM object**.  
*Using this property,* you can parse the response as an **XML DOM object**:
```html
<!DOCTYPE html>
<html>
<body>
<h2>My CD Collection:</h2>

<button type="button" onclick="loadXMLDoc()">
Get my CD collection</button>

<p id="demo"></p>

<script>
function loadXMLDoc() {
  var xmlhttp = new XMLHttpRequest();
  xmlhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      myFunction(this);
    }
  };
  xmlhttp.open("GET", "cd_catalog.xml", true);
  xmlhttp.send();
}

function myFunction(xml) {
  var x, i, xmlDoc, txt;
  xmlDoc = xml.responseXML;
  txt = "";
  x = xmlDoc.getElementsByTagName("ARTIST");
  for (i = 0; i< x.length; i++) {
    txt += x[i].childNodes[0].nodeValue + "<br>";
  }
  document.getElementById("demo").innerHTML = txt;
}
</script>

</body>
</html>
```
### the XML document `cd_catalog.xml`: the ARTIST tag is capital since it's case sensitive
```xml
<?xml version="1.0" encoding="UTF-8"?>
<artists>
	<ARTIST>JayZ</ARTIST>
	<ARTIST>Nas</ARTIST>
</artists>
```

## Server Response Methods
| Method | Description |
| --- | --- |
| getResponseHeader() | Returns specific header information from the server resource |
| getAllResponseHeaders()	| Returns all the header information from the server resource |

## The `getAllResponseHeaders()` and the `getResponseHeader()` methods
returns all header information from the server response.

```html
<!DOCTYPE html>
<html>
<body>

<h2>The XMLHttpRequest Object</h2>
<p>The getAllResponseHeaders() function returns all the header information of a resource, like length, server-type, content-type, last-modified, etc:</p>

<p id="demo"></p>

<script>
const xhttp = new XMLHttpRequest();
xhttp.onload = function() {
  document.getElementById("demo").innerHTML =
  this.getAllResponseHeaders();
  // for getting a specific header
  //this.getResponseHeader("Last-Modified");
}
xhttp.open("GET", "ajax_info.txt");
xhttp.send();
</script>

</body>
</html>
```

## AJAX xml example
The xml looks like:
```xml
<CATALOG>
	<CD>
		<TITLE>Empire Burlesque</TITLE>
		<ARTIST>Bob Dylan</ARTIST>
		<COUNTRY>USA</COUNTRY>
		<COMPANY>Columbia</COMPANY>
		<PRICE>10.90</PRICE>
		<YEAR>1985</YEAR>
	</CD>
</CATALOG>
```
```html
<!DOCTYPE html>
<html>
<style>
table,th,td {
  border : 1px solid black;
  border-collapse: collapse;
}
th,td {
  padding: 5px;
}
</style>
<body>

<h2>The XMLHttpRequest Object</h2>

<button type="button" onclick="loadDoc()">Get my CD collection</button>
<br><br>
<table id="demo"></table>

<script>
function loadDoc() {
  const xhttp = new XMLHttpRequest();
  xhttp.onload = function() {
    myFunction(this);
  }
  xhttp.open("GET", "cd_catalog.xml");
  xhttp.send();
}
function myFunction(xml) {
  const xmlDoc = xml.responseXML;
  const x = xmlDoc.getElementsByTagName("CD");
  let table="<tr><th>Artist</th><th>Title</th></tr>";
  for (let i = 0; i <x.length; i++) { 
    table += "<tr><td>" +
    x[i].getElementsByTagName("ARTIST")[0].childNodes[0].nodeValue + 
    "</td><td>" +
    x[i].getElementsByTagName("TITLE")[0].childNodes[0].nodeValue +
    "</td></tr>";
  }
  document.getElementById("demo").innerHTML = table;
}
</script>

</body>
</html>
```

## AJAX PHP Example: the use gets a hint for a name based on his inpurt: (if the user inputs the character 'A', he will get a suggestion for "Anna")
a function called `showHint()` is executed when The function is triggered by the `onkeyup` event and sends a GET request back to the server-side PHP code with the `q` parameter
### HTML page
```html
<!DOCTYPE html>
<html>
<body>

<h2>The XMLHttpRequest Object</h2>
<h3>Start typing a name in the input field below:</h3>

<p>Suggestions: <span id="txtHint"></span></p> 
<p>First name: <input type="text" id="txt1" onkeyup="showHint(this.value)"></p>

<script>
function showHint(str) {
  if (str.length == 0) { 
    document.getElementById("txtHint").innerHTML = "";
    return;
  }
  const xhttp = new XMLHttpRequest();
  xhttp.onload = function() {
    document.getElementById("txtHint").innerHTML =
    this.responseText;
  }
  xhttp.open("GET", "gethint.php?q="+str);
  xhttp.send();   
}
</script>

</body>
</html>
```
### PHP Code
```php
<?php
// Array with names
$a[] = "Anna";
$a[] = "Brittany";
$a[] = "Cinderella";
$a[] = "Diana";
$a[] = "Eva";

// get the q parameter from URL
$q = $_REQUEST["q"];

$hint = "";

// lookup all hints from array if $q is different from ""
if ($q !== "") {
  $q = strtolower($q);
  $len = strlen($q);
  foreach($a as $name) {
    if (stristr($q, substr($name, 0, $len))) {
      if ($hint === "") {
        $hint = $name;
      } else {
        $hint .= ", $name";
      }
    }
  }
}

// Output "no suggestion" if no hint was found or output correct values
echo $hint === "" ? "no suggestion" : $hint;
?> 
```

## AJAX Database Example:
AJAX can be used for interactive communication with a database.  
In the below example, on customer selection change, a request is sent to back to the server-side PHP code to select the required data from the database
### HTML page
```html
<!DOCTYPE html>
<html>
<style>
th,td {
  padding: 5px;
}
</style>
<body>

<h2>The XMLHttpRequest Object</h2>

<form action=""> 
  <select name="customers" onchange="showCustomer(this.value)">
    <option value="">Select a customer:</option>
    <option value="ALFKI">Alfreds Futterkiste</option>
    <option value="NORTS ">North/South</option>
    <option value="WOLZA">Wolski Zajazd</option>
  </select>
</form>
<br>
<div id="txtHint">Customer info will be listed here...</div>

<script>
function showCustomer(str) {
  if (str == "") {
    document.getElementById("txtHint").innerHTML = "";
    return;
  }
  const xhttp = new XMLHttpRequest();
  xhttp.onload = function() {
    document.getElementById("txtHint").innerHTML = this.responseText;
  }
  xhttp.open("GET", "getcustomer.php?q="+str);
  xhttp.send();
}
</script>
</body>
</html>
```
### PHP server-side code
```php
<?php
$mysqli = new mysqli("servername", "username", "password", "dbname");
if($mysqli->connect_error) {
  exit('Could not connect');
}

$sql = "SELECT customerid, companyname, contactname, address, city, postalcode, country FROM customers WHERE customerid = ?";

$stmt = $mysqli->prepare($sql);
$stmt->bind_param("s", $_GET['q']);
$stmt->execute();
$stmt->store_result();
$stmt->bind_result($cid, $cname, $name, $adr, $city, $pcode, $country);
$stmt->fetch();
$stmt->close();

echo "<table>";
echo "<tr>";
echo "<th>CustomerID</th>";
echo "<td>" . $cid . "</td>";
echo "<th>CompanyName</th>";
echo "<td>" . $cname . "</td>";
echo "<th>ContactName</th>";
echo "<td>" . $name . "</td>";
echo "<th>Address</th>";
echo "<td>" . $adr . "</td>";
echo "<th>City</th>";
echo "<td>" . $city . "</td>";
echo "<th>PostalCode</th>";
echo "<td>" . $pcode . "</td>";
echo "<th>Country</th>";
echo "<td>" . $country . "</td>";
echo "</tr>";
echo "</table>";
?>
```

### AJAX App: navigation between XML data
```html
<!DOCTYPE html>
<html>
<body>

<div id='showCD'></div><br>
<input type="button" onclick="previous()" value="<<">
<input type="button" onclick="next()" value=">>">

<script>
let i = 0;
let len;
let cd;

const xhttp = new XMLHttpRequest();
xhttp.onload = function() {
  const xmlDoc = xhttp.responseXML;
  cd = xmlDoc.getElementsByTagName("CD");
  len = cd.length;
  displayCD(i);
}
xhttp.open("GET", "cd_catalog.xml");
xhttp.send();

function displayCD(i) {
  document.getElementById("showCD").innerHTML =
  "Artist: " +
  cd[i].getElementsByTagName("ARTIST")[0].childNodes[0].nodeValue +
  "<br>Title: " +
  cd[i].getElementsByTagName("TITLE")[0].childNodes[0].nodeValue +
  "<br>Year: " + 
  cd[i].getElementsByTagName("YEAR")[0].childNodes[0].nodeValue;
}

function next() {
  if (i < len-1) {
    i++;
    displayCD(i);
  }
}

function previous() {
  if (i > 0) {
    i--;
    displayCD(i);
  }
}
</script>

</body>
</html>
```
The XML:
```xml
<CATALOG>
	<CD>
		<TITLE>Empire Burlesque</TITLE>
		<ARTIST>Bob Dylan</ARTIST>
		<COUNTRY>USA</COUNTRY>
		<COMPANY>Columbia</COMPANY>
		<PRICE>10.90</PRICE>
		<YEAR>1985</YEAR>
	</CD>
	<CD>
		<TITLE>Hide your heart</TITLE>
		<ARTIST>Bonnie Tyler</ARTIST>
		<COUNTRY>UK</COUNTRY>
		<COMPANY>CBS Records</COMPANY>
		<PRICE>9.90</PRICE>
		<YEAR>1988</YEAR>
	</CD>
	<CD>
		<TITLE>Greatest Hits</TITLE>
		<ARTIST>Dolly Parton</ARTIST>
		<COUNTRY>USA</COUNTRY>
		<COMPANY>RCA</COMPANY>
		<PRICE>9.90</PRICE>
		<YEAR>1982</YEAR>
	</CD>
</CATALOG>
```