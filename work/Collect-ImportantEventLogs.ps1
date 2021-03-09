Param(
    $ComputerName,
    $ShowEventInformation
)
if($ComputerName){
    Invoke-Command -ComputerName $ComputerName -ScriptBlock {
        $result += Get-WinEvent -FilterHashtable @{
            LogName='Security'
            id=4624,4625,4634,4720,4726,4738,4731,4735,4732,4733,4734
        }

        $result += Get-WinEvent -FilterHashtable @{
            LogName='System'
            id=7045
        }

        $result += Get-WinEvent -FilterHashtable @{
            LogName='Application'
            id=11707,11724
        }

        $result += Get-WinEvent -FilterHashtable @{
            LogName='Application'
            ProviderName='MsiInstaller'
            id=1036
        }
        Write-Output $result
    }
}
elseif($ShowEventInformation -eq $true){
    class Event {
        [string]$LogName
        [string]$Provider
        [int   ]$ID
        [string]$Title
        [string]$Description
    }

    $Event_Data = @(
        [Event]@{LogName='Security'    ; Provider='N/A'; ID=4624 ; Title='User Logon'; Description='A users log in will likely be the first sign of an attack and can indicate suspicious behavior. It can also give an analyst a starting time to create a timeline of events. This log is recquired in the HIPAA and PCI DSS regulations and is recommended by the NSA Event Forwarding Guidance and JPCERT.'}
		[Event]@{Logname='Security'    ; Provider='N/A'; ID=4625 ; Title='Failed User Login'; Description='Failed user logins can show possible password spray and password guessing attacks. Not every failed login is an attack, but they can be early indicators of one. This log is recquired by the PCI DSS regulation and is recommended by the NSA Cyber Event Forwarding Guidance.'}
		[Event]@{Logname='Security'    ; Provider='N/A'; ID=4634 ; Title='User Logoff'; Description='A users log off can indicate the end of an attack or potential system restarts that may have occurred. This can conclude a timeline or give a bit more insight to a users activity. This log is recommended by the NSA Cyber Event Forwarding Guidance and JPCERT.'}
		[Event]@{Logname='Security'    ; Provider='N/A'; ID=4720 ; Title='Account Created'; Description='Account creation logs can indicate a suspicious new account that was created in preparation for an attack or someone trying to do things they necessarily shouldnt. It is also a good idea to know when there may be new users on the network so you are prepared for their activity. This log is required by NIST SP 800-53, HIPAA and PCI DSS regulations. It is also recommended under the NSA Cyber Event Forwarding Guidance.'}
		[Event]@{Logname='Security'    ; Provider='N/A'; ID=4726 ; Title='Account Deleted'; Description='An attacker may attempt to tidy up after themselves by deleting an account or simply disrupt normal workflow by deleting legitimate accounts.'}
		[Event]@{Logname='Security'    ; Provider='N/A'; ID=4738 ; Title='Account Changed'; Description='Account changes, such as password and username changes may indicate a successful breach and a backdoor setup for a user. Also can be used to track changes for legitimate users.'}
		[Event]@{Logname='Security'    ; Provider='N/A'; ID=4731 ; Title='Group Creation'; Description='Groups allow for multiple user accounts to be managed as one and an attacker may try and create a group with escalated privileges.'}
		[Event]@{Logname='Security'    ; Provider='N/A'; ID=4735 ; Title='Group Change'; Description='Group change can indicate unauthorized privilege escalation of a whole user group. This should be monitored so that user permissions are known and not over reaching. This log is recommended by the NSA Cyber Event Forwarding Guidance.'}
		[Event]@{Logname='Security'    ; Provider='N/A'; ID=4732 ; Title='Member Added to Group'; Description='Group membership change can indicate a user adding themselves to an admin group without permissions. It is important to monitor the groups that have escalated permissions. This log is recommended by the NSA Cyber Event Forwarding Guidance.'}
		[Event]@{Logname='Security'    ; Provider='N/A'; ID=4733 ; Title='Member Removed from Group'; Description='Group membership change can indicate a user removing themselves from an admin group in an effort to clean up after an attack. It is important to monitor the groups that have escalated permissions.'}
		[Event]@{Logname='Security'    ; Provider='N/A'; ID=4734 ; Title='Group Deletion'; Description='Group deletion may signal the cleanup of an attack or someone trying to inconvenience a group of users in a network. It is also good to know what groups are active.'}

        [Event]@{Logname='System'      ; Provider='N/A'; ID=7045 ; Title='Service Installed'; Description='Services on a Windows machine have many purposes and these logs may indicate a malicious service being places on the computer. This log is recommended by JPCERT.'}

        [Event]@{Logname='Application' ; Provider='N/A'; ID=11707; Title='Software Installed'; Description='Many attack rely on software being installed and this log can signal who and what installed the software that may cause a vulnerability. It can also be used to make sure that only authorized apps are being installed.'}
        [Event]@{Logname='Application' ; Provider='N/A'; ID=11724; Title='Software Uninstalled'; Description='Software removal may indicate previously used malicious software being taken off a machine or an attempt to disrupt the normal workflow.'}

        [Event]@{Logname='Application' ; Provider='MSIInstaller'; ID=1036 ; Title='Software Updated'; Description='Software updates are not always a sign of an attack, but often contain patches for known vulnerabilities. An update may also introduce vulnerabilities and it is important to know if and when that was installed.'}
    )

    Write-Output $Event_Data
}