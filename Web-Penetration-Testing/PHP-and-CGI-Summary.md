This might give you a broader understanding of their difference:

**CGI:** (common gateway interface) It is a specification "protocol" for transferring information between a Web server and a CGI program.

A CGI program is any program designed to accept and return data that conforms to the CGI specification.

Basically it's a way to run a server side script (PHP, Perl, Python,...) when a HTTP request comes.

CGI is very slow in comparison to other alternatives.

---

**FastCGI:** is a better CGI.

Fast CGI is a different approach with much faster results.

It is a CGI with only a few extensions.

FastCGI implementation isn’t available anymore, in favor of the PHP-FPM.

---

**PHP-FPM:** (FastCGI Process Manager), it's a better FastCGI implementation than the old FastCGI.

It runs as a standalone FastCGI server.

In general it's a PHP interface for the web servers (Apache, Nginx..) to allows Web Server to interact with PHP.

Unlike the **PHP-CLI** which is a command line interface for PHP to allows Users to interact with PHP via terminal.

---

**mod_php:** an Apache module to run PHP.

It execute PHP scripts inside the Web Server directly as part of the web server without communicating with a CGI program.

---

**mod_SuPHP:** is similar to mod_php but can change the user/group that the process runs under.

Basically it address some problems of mod_php related to permissions