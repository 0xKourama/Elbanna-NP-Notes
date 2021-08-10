# what are the out-of-the-box security features?
1. authentication
2. authorization
3. firewall on each ESXi

# what can be done for security?
1. set permissions on Vcenter objects
	- vcenter servers
	- esxi hosts
	- vms
	- network objects
	- storage objects
2. open/close firewall ports

1. Secure ESXi
2. Vcenter Servers & Associated Services
3. VMs
4. Virtual Networking Layer
5. Passwords

# Securing ESXi Hypervisor
1. Limit ESXi access
	1. Disable ESXi Shell
	2. Disable SSH
		*we can set timeout to limit the risk of unauthorized access*
	3. Limit permissions on host management from VCenter
2. Disable root access and create users with limited permissions
	*vSphere Single Host Management can be used instead of managin users directly on the host because options are limited*
3. limit the number of open ports on ESXi firewall
	*we can use the vSphere Client or ESXCLI or PowerCLI commands to check and manage firewall port status*
4. [Built-in] Lockdown Mode (ESXi hosts can only be accessed through VCenter Server)
	Strict/Normal Lockdown Mode
	*You can define Exception Users to allow direct access to service accounts such as backup agents*
6. VCenter Server MFA
7. Consider ESXi account lockout
	_Access is through 2 ways:_
	1. SSH
	2. vSphere Web Services SDK
	*The Direct Console Interface (DCUI) and the ESXi Shell do not support account lockout*


# Securing vCenter Server Systems and Associated Services
1. Authentication -> VCenter SSO
2. Authorization  -> VCenter Server permissions model

1. 