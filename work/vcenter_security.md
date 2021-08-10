# what are my questions?
1. what is a distributed virtual switch? what do we use it for? it a centralized switch across all ESXi hosts to allow for networking management
2. what is the link between NSX and VCenter?
3. what is a port group? a group of virtual distributed switch ports that make up a network
4. what is NVDS?
5. what are the convenience features that would be annoying if removed for security?
6. what is the use of domains on vsphere?
7. what's an identity source?
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
3. VMs
4. Virtual Networking Layer
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