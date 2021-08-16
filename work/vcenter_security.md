# Mission: Find all the hardening procedures and what's applicable to implement?
1. what needs to be known?
- the details of every prodecure

# what are my questions?
1. what is a distributed virtual switch? what do we use it for? it a centralized switch across all ESXi hosts to allow for networking management
2. what is the link between NSX and VCenter?
3. what is a port group? a group of virtual distributed switch ports that make up a network
4. what is NVDS?
5. what are the convenience features that would be annoying if removed for security?
6. what is the use of domains on vsphere?
7. what's an identity source? what's it's importance?
8. what is the network layout?
9. what does an edge do?
10. what is a cluster?
11. what is PTP?
12. what is a distributed port group?
13. what is the Vcenter architecture?
14. what is an uplink?
15. what is a standard switch?
16. what is vService manager?
17. what is the VPX user?
18. what is VMkernel?
19. what is vSAN?
20. vMotion?
21. IP storage?
22. Fault Tolerance?
23. vSAN?
24. vSphere ESX Agent Manager?
25. VIB? what are the acceptance levels?
26. what's the difference between local and shared datastores?
27. What are our host types? SuperMicro + Dell
28. What is a host profile?
29. What is auto deploy?
30. what is ESXi Web Proxy?
31. what is WS-MAN?
32. what is ESXCLI?
33. What is the CIM Service?
34. what is VMCA Mode?
35. what is Thumbprint mode?
36. what is VECS?
37. what is a SAN, what is NAS?
38. what is vSphere Authentication Proxy?
39. what would happen if we move AD to azure?
----------------------------
# what are the permissions that Abdo,Ahmed,Islam,Tawfik Need?
1. 

# what are the permissions there? what's the location of the permissions?
----------------------------
# What does this manual include?
Best practices for the *different components of your vSphere infrastructure*
----------------------------
# what are the complimentatry resources?
1. Information on ESXi and vCenter Server security and operations, including secure configuration and hypervisor security.
	https://core.vmware.com/security
2. VMware security policy, up-to-date security alerts, security downloads, and focus discussions of security topics
	http://www.vmware.com/go/security
3. Compliance and security standards, and partner solutions and in-depth content about virtualization and compliance
	https://core.vmware.com/compliance
4. Information on security certifications and validations such as CCEVS and FIPS for different versions of the components of vSphere
	https://www.vmware.com/support/support-resources/certifications.html
5. Security configuration guides (formerly known as hardening guides) for different versions of vSphere and other VMware products
	https://core.vmware.com/security
6. Security of the VMware vSphere Hypervisor white paper
	http://www.vmware.com/files/pdf/techpaper/vmw-wp-secrty-vsphrhyprvsr-uslet-101.pdf
----------------------------
# what are the out-of-the-box security features?
1. authentication
2. authorization
3. firewall on each ESXi
----------------------------
# what can be done for security?
1. set permissions on Vcenter objects
	- vcenter servers
	- esxi hosts
	- vms
	- network objects
	- storage objects
2. open/close firewall ports
----------------------------
# what are the main topics?
1. Secure ESXi
2. Vcenter Servers & Associated Services
3. Virtual Networking Layer
4. VMs
5. Passwords
----------------------------
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
----------------------------
# Securing vCenter Server Systems and Associated Services
*Authentication -> VCenter SSO*
*Authorization  -> VCenter Server permissions model*

1. Harden all vCenter host machines
	- hardening each machine on which vCenter Server or an associated service runs

2. Learn about the vCenter certificate model
	- VMware Certificate Authority (VMCA)  provisions each ESXi host and each machine in the environment with a certificate signed by VMCA

3. Configure vCenter Single Sign-On

4. Assign roles to named users or groups
	1. associate each permission that you give on an object with a named user or group and a predefined role or custom role
	*Restrict administrator privileges and the use of the administrator role. If possible, do not use the anonymous Administrator user.*

5. Set up PTP or NTP
	- Set up PTP or NTP for each node in your environment. The certificate infrastructure requires an accurate time stamp and does not work correctly if the nodes are out of sync
----------------------------
# Securing Virtual Machines
1. Protect the guest operating system
	- most recent patches
	- anti-spyware
	- anti-malware

2. Disable unnecessary functionality
	- Remove unnecessary hardware
	- disable certain features such as:
		- host-guest filesystem (HGFS)
		- copy and paste between the virtual machine and a remote console.

3. Minimize use of the virtual machine console
	- Users with access to a virtual machine console have access to:
		1. virtual machine power management
		2. removable device connectivity controls
		*As a result, virtual machine console access might allow a malicious attack on a virtual machine.*

4. Consider UEFI secure boot
	*ou can configure your virtual machine to use UEFI boot. If the operating system supports secure UEFI boot, you can select that option for your VMs for additional security*

5. Consider Carbon Black Cloud Workload
----------------------------
# Securing the Virtual Networking Layer
- virtual network adapters
- virtual switches
- distributed virtual switches
- ports
- port groups
*ESXi uses the virtual networking layer to communicate with iSCSI SANs, NAS storage, and so on*

1. Isolate network traffic
	- A management network isolates client traffic, command-line interface (CLI) or API traffic, and third-party software traffic from normal traffic.
	- Ensure that the management network is accessible only by system, network, and security administrators.

2. Use firewalls to secure virtual network elements
	- You can open and close firewall ports and secure each element in the virtual network separately
	- For ESXi hosts, firewall rules associate services with corresponding firewalls and can open and close the firewall according to the status of the service
	- You can also open ports on vCenter Server instances explicitly
	- List of VMware products ports: https://ports.vmware.com/

3. Consider network security policies
	-  Network security policies provide protection of traffic against MAC address impersonation and unwanted port scanning. The security policy of a standard or distributed switch is implemented in Layer 2 (Data Link Layer) of the network protocol stack. The three elements of the security policy are promiscuous mode, MAC address changes, and forged transmits

4. Secure VM networking
	*Virtual switches and distributed virtual switches provide significant protection when used with other common security practices, such as installing firewalls*

5. Consider VLANs to protect your environment
	- You can use VLANs to further protect the VM network or storage configuration
	- two VMs on the same physical network cannot send packets to or receive packets from each other unless they are on the same VLAN

6. Secure connections to virtualized storage
	- A VM stores operating system files, application files, and other data on a virtual disk
	- Each virtual disk appears to the VM as a SCSI drive that is connected to a SCSI controller
	- A VM is isolated from storage details and cannot access the information about the LUN where its virtual disk resides.
	- The Virtual Machine File System (VMFS) is a distributed file system and volume manager that presents virtual volumes to the ESXi host.
	- You are responsible for securing the connection to storage. For example, if you are using iSCSI storage, you can set up your environment to use CHAP. If required by company policy, you can set up mutual CHAP. Use the vSphere Client or CLIs to set up CHAP.

7. Evaluate the use of IPSec
	- ESXi supports IPSec over IPv6. You cannot use IPSec over IPv4.
----------------------------
# Passwords in vSphere Environment
*Password restrictions, password expiration, and account lockout in your vSphere environment
depend on the system that the user targets, who the user is, and how policies are set*

1. ESXi Passwords
2. Passwords for vCenter Server and Other vCenter Services

1. vCenter Single Sign-On Administrator/Other Users of the vCenter Single Sign-On Domain/Other Users
	- The password for the administrator@vsphere.local user, or the administrator@mydomain user if you selected a different domain during installation, does not expire and is not subject to the lockout policy. In all other regards, the password must follow the restrictions that are set in the vCenter Single Sign-On password policy

2. Passwords for vCenter Server Direct Console User Interface Users
----------------------------
# vSphere Permissions and User Management Tasks

# what are roles?
- Sets of privileges

# what are the vCenter Server Permissions?
- Global Permissions
- Group Membership in vCenter Single Sign-On Groups
- ESXi Local Host Permissions

# what is the Vcenter architecture?
1. storage folder
	1. what is a datastore?
	2. what is a datastore cluster?
2. network folder
	1. VDS
		1. distributed port group
	2. Standard Switch
3. host folder
	1. host
		1. resource pool
			1. virtual machine
			2. vApp
				1. resource pool
	2. cluster
		1. resource pool
			1. virtual machine
			2. vApp
				1. resource pool
4. VM folder
	1. virtual machine

*child permissions are more specific and override parent-set permissions*

# what is validation?
1. periodic process that checks users and their permissions every interval

# what are the VM attribues?
1. processing
2. memory
3. networking
4. storage

# what is the benefit of creating a custom role?
1. taylor the privileges to the exact tasks

# what the location of privileges?
Administration -> Roles -> Privileges

*Best practice is to create a user at the root level and assign the Administrator role to that user. After creating a named user with Administrator privileges, you can remove the root user from any permissions or change its role to No Access*

# what's the benefit of propagation?
1. permissions apply to newly-created VMs in the folder

# Best Practices for Roles and Permissions
1. Best Practices for Roles and Permissions
2. Grant permissions only on the objects where they are needed, and assign privileges only to users or groups that must have them. Use the minimum number of permissions to make it easier to understand and manage your permissions structure.
3. If you assign a restrictive role to a group, check that the group does not contain the Administrator user or other users with administrative privileges. Otherwise, you migh unintentionally restrict administrators' privileges in the parts of the inventory hierarchy where you have assigned that group the restrictive role.
4. Use folders to group objects. For example, to grant modify permission on one set of hosts and view permission on another set of hosts, place each set of hosts in a folder
5. Use caution when adding a permission to the root vCenter Server objects. Users with privileges at the root level have access to global data on vCenter Server, such as roles, custom attributes, vCenter Server settings
6. Consider enabling propagation when you assign permissions to an object. Propagation ensures that new objects in the object hierarchy inherit permissions. For example, you can assign a permission to a virtual machine folder and enable propagation to ensure that the permission applies to all VMs in the folder
7. Use the No Access role to mask specific areas of the hierarchy. The No Access role restricts access for the users or groups with that role

# Securing ESXi Hosts
# ESXi security features:
1. CPU Isolation
2. Memory Isolation
3. Device Isolation
4. Lockdown Mode
5. ceritifcate replacement
6. firewall
7. ESXi Shell

# Built-In Security Features
1. ESXi Shell and SSH interfaces --> Disabled By default
	*keep disabled unless for admin purposes*
2. Only a limited number of firewall ports are open by default
3. ESXi runs only services that are essential to managing its functions
4. By default, all ports that are not required for management access to the host are closed
5. weak ciphers are disabled and communications from clients are secured by SSL
6. An internal web service is used by ESXi to support access by Web clients
7. To protect hosts from loading drivers and applications that are not cryptographically signed, use UEFI Secure boot. Enabling Secure Boot is done at the system BIOS
8. If your ESXi host has a TPM 2.0 chip, enable and configure the chip in the system BIOS. Working together with Secure Boot, TPM 2.0 provides enhanced security and trust assurance rooted in hardware

# Additional Security Measures:
## Limit Access:
- Disable access to DCUI, ESXi Shell & SSH
## Do not access managed hosts directly:
- Use the vSphere Client to administer ESXi hosts that are managed by a vCenter Server. Do not access managed hosts directly with the VMware Host Client, and do not change managed hosts from the DCUI
## USE DCUI for troubleshooting only
## Use only VMware sources to upgrade ESXi components
*The host runs several third-party packages to support management interfaces or tasks that you must perform. VMware only supports upgrades to these packages that come from a VMware source. If you use a download or patch from another source, you might compromise management interface security or functions. Check third-party vendor sites and the VMware knowledge base for security alerts*

## Configure ESXi Hosts with Host Profiles
Good for scripting on multiple hosts and setting security configuration

## Using the VMware DirectPath I/O feature to pass through a PCI or PCIe device to a virtual machine results in a potential security vulnerability

## Disable the Managed Object Browser

## ESXi Networking Security Recommendations
- vSphere infrastructure networks are used for features such as vSphere vMotion, VMware vSphere Fault Tolerance, VMware vSAN, and storage. Isolate these networks for their specific functions. It is often not necessary to route these networks outside a single physical server rack.
- A management network isolates client traffic, command-line interface (CLI) or API traffic, and third-party software traffic from other traffic. This network should be accessible only by system, network, and security administrators. Use jump box or virtual private network (VPN) to secure access to the management network. Strictly control access within this network. 

*VMCA certificates require ESXi 6.5 or later*

# Add Allowed IP Addresses for an ESXi Host
- restrict traffic, change each service to allow traffic only from your management subnet
- Incoming and Outgoing Firewall Ports for ESXi Hosts
- https://ports.vmware.com/
- disable any NFS rules not in use
- disable any uncessary services
- lockdown mode:
	1. restricts operations to be done through VCenter only
	2. Direct Console User Interface (DCUI) service is disabled
	3. Exception user list with admin privileges can access functions normally (DCUI, ESXi Shell and SSH)
*All access is logged for both strict and normal lockdown mode*
*Lockdown mode behaviour reference: page 88*
- add service accounts such as a backup agent to the Exception Users list.
*The Exception Users list is meant for service accounts that perform very specific tasks, and not for administrators. Adding administrator users to the Exception Users list defeats the purpose of lockdown mode*
- Best practice is to create at least one named user account, assign it full administrative privileges on the host, and use this account instead of the root account. Set a highly complex password for the root account and limit the use of the root account. Do not remove the root account.
- Assigning Permissions to Standalone ESXi Hosts
- UEFI Secure Boot for ESXi Hosts
	- Secure boot is part of the UEFI firmware standard. With secure boot enabled, a machine refuses to load any UEFI driver or app unless the operating system bootloader is cryptographically signed. Starting with vSphere 6.5, ESXi supports secure boot if it is enabled in the hardware.