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

$group_csv_path = '.\GroupData.csv'

$old_Group_Data = Import-Csv $group_csv_path

$old_file_hash  = (Get-FileHash -Path $group_csv_path -Algorithm MD5).Hash

$New_Group_Data = @()

foreach($Admin_Group in $Admin_Security_Groups){
    $New_Group_Data += [PSCustomObject][Ordered]@{
        Name    = $Admin_Group
        Members = ((Get-ADGroup -Identity $Admin_Group -Properties Members).Members | ForEach-Object {$_ -replace ',\w{2}=.*' -replace 'CN='}) -join ' | '
    }
}

$New_Group_Data | Export-Csv $group_csv_path -NoTypeInformation

$New_file_hash  = (Get-FileHash -Path $group_csv_path -Algorithm MD5).Hash

if($New_file_hash -ne $old_Group_Data){
    $Difference_array = @()

    foreach($Group in $Admin_Security_Groups){
        $old_group_members = ($old_Group_Data | Where-Object {$_.Name -eq $Group}).Members -split ' \| ' | Where-Object {$_ -ne ''}
        $new_group_members = ($new_Group_Data | Where-Object {$_.Name -eq $Group}).Members -split ' \| ' | Where-Object {$_ -ne ''}
        foreach($old_member in $old_group_members){
            if($new_group_members -notcontains $old_member){
                $Difference_array += [PSCustomObject][Ordered]@{
                    Action = 'Removal'
                    Group  = $Group
                    Member = $old_member
                }
            }
        }
        foreach($new_member in $new_group_members){
            if($old_group_members -notcontains $new_member){
                $Difference_array += [PSCustomObject][Ordered]@{
                    Action = 'Addition'
                    Group  = $Group
                    Member = $new_member
                }
            }
        }
    }
    $Difference_array | Format-Table -AutoSize -Wrap
}

$Summary = @"
<h3>Current Membership Data</h3>
$($New_Group_Data | ConvertTo-Html -Fragment | Out-String)
"@

if($Difference_array){
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $($Difference_array | ConvertTo-Html -Fragment | Out-String) $Summary"
}