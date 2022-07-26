## record types

| Record | Description |
| ----- | ----- |
| NS | Nameserver records contain the name of the authoritative servers hosting the DNS records for a domain. |
| A | Also known as a host record, the “a record” contains the IP address of a hostname (such as www.example.com). |
| MX | Mail Exchange records contain the names of the servers responsible for handling email for the domain. A domain can contain multiple MX records. |
| PTR | Pointer Records are used in reverse lookup zones and are used to find the records associated with an IP address. |
| CNAME | Canonical Name Records are used to create aliases for other host records. |
| TXT | Text records can contain any arbitrary data and can be used for various purposes, such as domain ownership verification |

## host command
```bash
host -t ns <DOMAIN_NAME>
host -t mx <DOMAIN_NAME>
host -t txt <DOMAIN_NAME>
```

## DNS forward bruteforce
```bash
for name in $(cat domain_names.txt); do host $name.company.com; done
```

## DNS reverse bruteforce
```bash
for ip in $(seq 1 254); do host 10.10.10.$ip; done | grep -v "not found"
```

## DNS zone transfer
```bash
host -l <DOMAIN_NAME> <DNS_SERVER>
```

## DNS zone trasnfer script (works if the NS query returned values)
```bash
#!/bin/bash
# Simple Zone Transfer Bash Script
# $1 is the first argument given after the bash script
# Check if argument was given, if not, print usage
if [ -z "$1" ]; then
	echo "[*] Simple Zone transfer script"
	echo "[*] Usage : $0 <domain name> "
	exit 0
fi
# if argument was given, identify the DNS servers for the domain
for server in $(host -t ns $1 | cut -d " " -f4); do
	# For each of these servers, attempt a zone transfer
	host -l $1 $server | grep "has address"
done
```

## Tools
1. dnsrecon
2. dnsenum