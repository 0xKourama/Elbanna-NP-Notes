# Configuring Multiple Interfaces on Linux
### Step #1: add the interface from vmware workstation (Host-Only, NAT, other network etc.)
### Step #2: add the below lines to `/etc/network/interfaces` according to your setup.
### Note: change the names of the interfaces depending on your case
```
# Host only
auto eth0
iface eth0 inet dhcp

# NAT
auto eth1
iface eth1 inet dhcp
```
### Step #3: Reboot