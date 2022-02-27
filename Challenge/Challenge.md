# Port 21: FTP
secret.txt --> this is important do not share
Port 80: http --> pharmacy system
username/password ---> admin/admin

RHOST: 192.168.56.101

product import_xls.php

<b>Exception:</b> #0 /var/www/html/product/vendor/SpreadsheetReader.php(169): SpreadsheetReader::Load()
#1 /var/www/html/product/import_xls.php(34): SpreadsheetReader->__construct()
#2 {main}



# supported content types:
application/vnd.ms-excel
application/vnd.openxmlformats-officedocument.spreadsheetml.sheet

## Directories
js
product
src


# upload path
http://192.168.56.101/product/uploads/rev.php


/var/www/html/product/uploads/rev.php
/var/www/html/product/uploads/rev.xls.php



# backup.php
backup_tables('127.0.0.1','DBUSER','p@ssw0rd','pharmacy');