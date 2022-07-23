```bash
nmap -v -p- -T4 <RHOST>; ports=$(nmap -p- --min-rate=1000 -T4 <RHOST> | grep ^[0-9] | cut -d '/' -f1 | tr '\n' ',' | sed s/,$//); nmap -p$ports -sC -sV -oA nmap-tcp <RHOST>; mkdir nmap-tcp && mv nmap-tcp.* nmap-tcp/; nmap --top-ports 100 -sU -sC -sV -oA nmap-udp <RHOST>; mkdir nmap-udp && mv nmap-udp.* nmap-udp/`
```