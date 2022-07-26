## standard nmap
```bash
nmap -v -p- -T4 <RHOST>; ports=$(nmap -p- --min-rate=1000 -T4 <RHOST> | grep ^[0-9] | cut -d '/' -f1 | tr '\n' ',' | sed s/,$//); nmap -p$ports -sC -sV -oA nmap-tcp <RHOST>; mkdir nmap-tcp && mv nmap-tcp.* nmap-tcp/; nmap --top-ports 100 -sU -sC -sV -oA nmap-udp <RHOST>; mkdir nmap-udp && mv nmap-udp.* nmap-udp/
```

## netcat TCP port scanner (connect scan)
```bash
nc -vnz -w 1 <IP> 1-65535
```

## nmap scanning through proxy
```bash
nmap -sT <IP> <OPTIONS>
```

## nmap TCP/UDP scans
```bash
nmap -sS -sU <IP> <OPTIONS>
```

## Strategy: conduct sweeps for certain ports:
- low-hanging fruit
- services that provide valuable info like DNS
- services with file sharing (FTP, SMB, NFS etc.)
- services with remote administration capabilities
- services with clear text that can be good for MitM or services with auth capture capabilities
- services where enumeration takes time and could be started early to save time
- services with quick and/or known test cases/enumeration steps
- services you are most familiar with (ex: Active directory)
```bash
nmap -p 80,443 10.10.10.0/24 -oG web-sweep.txt
```