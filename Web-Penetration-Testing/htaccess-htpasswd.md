# protecting access to certain web directories on Apache2
### Step #1: create a directory where you want authentication and a basic `index.html` file
```bash
cd /var/www/html
mkdir special-area
cd special-area
nano index.html
```
### Step #2: create an `.htpasswd` file using the `htpasswd` command-line utility built into apache by default. The `username` field isn't required to be on the system
### Note: you will prompted to enter the password for the user
```bash
htpasswd -c /path/to/.htpasswd <USERNAME>
# to add a new user to an existing file
htpasswd /path/to/.htpasswd <USERNAME>
```
### Step #3: edit the apache2 configuration file and insert the below details
```bash
nano /etc/apache2/apache2.conf
```
```
<Directory "/var/www/html/special-area">
	AuthType Basic                      # basic auth: username and password
	AuthName "Restricted Content"       # message to show on the authentication pop-up
	AuthUserFile /path/to/.htpasswd   # location of the .htpasswd file
	Require valid-user
</Directory>
```
### Step #4: restart apache
```bash
systemctl restart apache2
```

---

## Alternative way: using a local `.htaccess` within the target web directory
### Step #1: change the settings for the `/var/www` directory in the `apache2.conf` file to `AllowOverride All`
```
<Directory /var/www/>
        Options Indexes FollowSymLinks
        AllowOverride All      # here
        Require all granted
</Directory>
```
### Step #2: create the `.htaccess` file within the folder you want to protect
```bash
cd /var/www/html/sepcial-area
nano .htaccess
```
### Step #3: paste the contents similar to above minus the `<Directory>` tags (since it would be inferred from the location of the file)
```
AuthType Basic                  # basic auth: username and password
AuthName "Restricted Content"   # message to show on the authentication pop-up
AuthUserFile /path/to/.htpasswd # location of the .htpasswd file
Require valid-user
```
### Step #4: restart apache
```bash
systemctl restart apache2
```

---

## Demo
### failed authorization
![unauthorized](/Assets/htaccess-htpasswd/unauthorized.jpg)

### succes authorization
![authorized](/Assets/htaccess-htpasswd/authorized-1.jpg)


![authorized](/Assets/htaccess-htpasswd/authorized-2.jpg)