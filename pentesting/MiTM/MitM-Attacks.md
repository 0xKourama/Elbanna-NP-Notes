# Arp Poisoning
## Set ipv4 forwarding
`echo 1 >  /proc/sys/net/ipv4/ip_forward`
## Start ettercap and set the listening interface
## Start network host discovery. Ettercap will scan the native network
## Start select the host you want to sniff traffic to
## Start arp poisoning from the MitM menu
## Start unified sniffing
## Start wiresharp and start filtering for plaintext protocols to grab passwords