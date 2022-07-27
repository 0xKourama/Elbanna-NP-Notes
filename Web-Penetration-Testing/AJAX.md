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

# AJAX typical flow:
1. An **event** occurs in a web page (the page is loaded, a button is clicked)
2. An `XMLHttpRequest` object is created by **JavaScript**
3. The `XMLHttpRequest` object **sends a request to a web server**
4. The server processes the request
5. The server sends a response back to the web page
6. The response is read by **JavaScript**
7. Proper action (like page update) is performed by **JavaScript**

# Modern Browsers (Fetch API)
- Modern Browsers can use **Fetch API** instead of the `XMLHttpRequest` Object.
- The **Fetch API** interface allows web browser to make HTTP requests to web servers.
- If you use the `XMLHttpRequest` Object, **Fetch** can do the same in a *simpler* way.

# The keystone of AJAX is the `XMLHttpRequest` object.
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

# Access Across Domains
- *For security reasons,*  
	modern browsers do not allow access across domains.
- This means that both:  
	1. the web page
	2. and the XML file
	*it tries to load,*   
	**must be located on the same server.**

# XMLHttpRequest Object Methods
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

# XMLHttpRequest Object Properties
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