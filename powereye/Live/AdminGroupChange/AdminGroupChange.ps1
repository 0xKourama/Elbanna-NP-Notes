Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$Admin_Security_Groups = @(
    'Administrators'
	'Authorized Personnel'
	'Compliance Management'
	'Delegated Setup'
	'Discovery Management'
	'Domain Admins'
	'Enterprise Admins'
	'Exchange Servers'
	'Exchange Trusted Subsystem'
	'Exchange Windows Permissions'
	'ExchangeLegacyInterop'
	'FrontAdmins'
	'Help Desk'
	'Hygiene Management'
	'Impersonation-Privilege'
	'import and export role permissions'
	'Managed Availability Servers'
	'Organization Management'
	'Public Folder Management'
	'Recipient Management'
	'Records Management'
	'Schema Admins'
	'Security Administrator'
	'Security Reader'
	'Server Management'
	'Server Operators'
	'UM Management'
	'View-Only Organization Management'
	'Import-Export-Mailboxes'
	'WP-Support-L1'
	'WP-Support-L2'
)

$Script = {
    #supress errors, only error is when there are no logs matching the criteria
    $ErrorActionPreference = 'SilentlyContinue'

    $EventID1 = 4728
    $EventID2 = 4729
    $XML_Path1 = "C:\Users\Public\Event_$EventID1`_LastCheck.xml"
    $XML_Path2 = "C:\Users\Public\Event_$EventID2`_LastCheck.xml"

    $Events = @()

    $Collected_Properties = @(
        'ID'
        'Message'
        'TimeCreated'
    )

    if(!(Test-Path -Path $XML_Path1)){
        $Events += Get-WinEvent -FilterHashtable @{LogName = 'Security'; ID = $EventID1} | Select-Object -Property $Collected_Properties
    }
    else{
        $Events += Get-WinEvent -FilterHashtable @{LogName = 'Security'; ID = $EventID1; StartTime = Import-Clixml -Path $XML_Path1} |
                    Select-Object -Property $Collected_Properties
    }

    if(!(Test-Path -Path $XML_Path2)){
        $Events += Get-WinEvent -FilterHashtable @{LogName = 'Security'; ID = $EventID2} | Select-Object -Property $Collected_Properties
    }
    else{
        $Events += Get-WinEvent -FilterHashtable @{LogName = 'Security'; ID = $EventID2; StartTime = Import-Clixml -Path $XML_Path2} |
                  Select-Object -Property $Collected_Properties
    }

    Get-Date | Export-Clixml -Path $XML_Path1
    Get-Date | Export-Clixml -Path $XML_Path2
    $Results = @()

    foreach($Event in $Events){
        $Message = $Event.Message -split '\n'

        $Subject_Part = ($Message | Select-String -Pattern '^Subject:\s+$' -Context 0,2).Context.PostContext
        $Member_Part  = ($Message | Select-String -Pattern '^Member:\s+$'  -Context 0,2).Context.PostContext
        $Group_Part   = ($Message | Select-String -Pattern '^Group:\s+$'   -Context 0,2).Context.PostContext
        
        $Results += [PSCustomObject][Ordered]@{
            Date          = $Event.TimeCreated
            Action        = if($Event.Id -eq 4728){'Addition'}else{'Removal'}
            Group         = ($Group_Part   | Select-String -Pattern '\s+Group Name:\s+(.*)\s+$'  ).Matches.Groups[1].Value
            SourceAccount = ($Subject_Part | Select-String -Pattern '\s+Account Name:\s+(.*)\s+$').Matches.Groups[1].Value
            TargetAccount = ($Member_Part  | Select-String -Pattern '\s+Account Name:\s+(.*)\s+$').Matches.Groups[1].Value
        }
    }
    $Results
}

$Results = Invoke-Command -ComputerName (Return-OnlineComputers -ComputerNames (Get-ADDomainController -Filter *).Name) -ScriptBlock $Script | 
           Select-Object -Property Date, @{n='ComputerName';e={$_.PSComputerName}}, Action, Group, SourceAccount, @{n='TagetAccount';e={$_.TargetAccount -replace ',\w{2}=.*' -replace 'CN='}}

$NormalResults = $Results | Where-Object {$Admin_Security_Groups -notcontains $_.Group}
$AdminResults  = $Results | Where-Object {$Admin_Security_Groups -contains    $_.Group}

if($NormalResults){
$Body += @"
<h3>Normal Group Changes</h3>
$($NormalResults | ConvertTo-Html -Fragment | Out-String)
"@
}

if($AdminResults){
$Body += @"
<h3>Admin Group Changes</h3>
$($AdminResults | ConvertTo-Html -Fragment | Out-String)
"@
}

if($Results){
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Body"
    Clear-Variable -Name Body
}

#testing
#$Admin_Security_Groups | %{remove-ADGroupMember -Identity (Get-ADGroup -Identity $_) -Members unauthtest -Confirm:$false}
#$Admin_Security_Groups | %{Add-ADGroupMember -Identity (Get-ADGroup -Identity $_) -Members unauthtest}