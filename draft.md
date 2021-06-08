# AD users with last logon date
`Get-ADUser -Filter * -Properties Mail,LastLogonDate |?{$_.lastlogondate} | Where-Object {(New-TimeSpan -Start $_.Lastlogondate -End (get-date)).Days -lt 90} | select name,mail,lastlogondate,@{n='Domain';e={$_.mail -replace '.*@'}} | select -Property domain -unique`

`CanonicalName: Roaya.loc/WP Admins/Gabr Urgent`

---

`ssh root@146.0.237.169`

- $$WorldPosta$$123
- $$WorldPosta@@123
- WorldPosta
- worldposta

```
systemctl -l status httpd.service
journalctl -xe
apachectl configtest
systemctl stop httpd.service
systemctl start httpd.service
systemctl restart httpd.service

ss -antp | grep ":80"
```

# pem files
/etc/pki/ca-trust/extracted/pem/email-ca-bundle.pem
/etc/pki/ca-trust/extracted/pem/objsign-ca-bundle.pem
/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem
/etc/pki/tls/cert.pem
/root/WP-AWS.pem
/root/mycloud.pem
/root/public_html/worldposta/wp-content/plugins/google-analytics-for-wordpress/assets/lib/google/src/Google/IO/cacerts.pem
/root/public_html/worldposta/wp-content/plugins/updraftplus/includes/cacert.pem
/root/public_html/worldposta/wp-content/plugins/updraftplus/includes/Google/IO/cacerts.pem
/root/public_html/worldposta/wp-content/plugins/updraftplus/vendor/guzzle/guzzle/src/Guzzle/Http/Resources/cacert.pem
/root/public_html/wp-content/plugins/updraftplus/includes/cacert.pem
/root/public_html/wp-content/plugins/updraftplus/includes/Google/IO/cacerts.pem
/root/public_html/wp-content/plugins/updraftplus/vendor/guzzle/guzzle/src/Guzzle/Http/Resources/cacert.pem
/usr/local/aws/lib/python2.7/site-packages/botocore/cacert.pem
/usr/local/aws/lib/python2.7/site-packages/pip/_vendor/certifi/cacert.pem_
/var/www/html/wordpress/wp-content/plugins/all-in-one-wp-migration-gdrive-extension/lib/vendor/gdrive-client/certs/cacert.pem

<VirtualHost *:443>

        SSLEngine on
        SSLCertificateFile /etc/pki/tls/certs/roaya_co.crt
        SSLCertificateKeyFile /etc/pki/tls/certs/roaya_co.key
        SSLCACertificateFile /etc/pki/tls/certs/USERTrust_RSA_Certification_Authority.crt

        <Directory /var/www/html/wordpress>
                AllowOverride All
        </Directory>
        DocumentRoot /var/www/html/wordpress
        ServerName roaya.co

</VirtualHost>


# selinux commands:
sudo setenforce 0
sestatus