Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$Admin_Security_Groups = @(
    'Administrators'
	'Compliance Management'
	'Delegated Setup'
	'Discovery Management'
	'Domain Admins'
	'Enterprise Admins'
	'Exchange Servers'
	'Exchange Trusted Subsystem'
	'Exchange Windows Permissions'
	'ExchangeLegacyInterop'
	'Group Policy Creator Owners'
	'Hygiene Management'
	'Impersonation-Privilege'
	'import and export role permissions'
	'Import-Export-Mailboxes'
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
	'View-Only Organization Management'
)

$group_csv_path = '.\GroupData.csv'

$old_Group_Data = Import-Csv $group_csv_path

$old_file_hash  = (Get-FileHash -Path $group_csv_path -Algorithm MD5).Hash

$New_Group_Data = @()

foreach($Admin_Group in $Admin_Security_Groups){
    $Tries = 6
    Do{
        $Pulled_members = (Get-ADGroup -Identity $Admin_Group -Properties Members).Members
        $Tries--
        Start-Sleep -Seconds 3
    }While($Pulled_members.Count -eq 0 -and $Tries -ne 0)

    $New_Group_Data += [PSCustomObject][Ordered]@{
        Name    = $Admin_Group
        Members = ($Pulled_members | ForEach-Object {$_ -replace ',\w{2}=.*' -replace 'CN='}) -join ' | '
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

$Header = '<h3>Admin Group Change</h3>'

$Summary = @"
<h3>Current Membership Data</h3>
$($New_Group_Data | ConvertTo-Html -Fragment | Out-String)
"@

if($Difference_array){
    Write-Host "[*] [$(Get-Date)] Admin group changes detected. Sending mail."
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Difference_array | ConvertTo-Html -Fragment | Out-String) $Summary"
}
else{
    Write-Host "[*] [$(Get-Date)] No admin group changes detected."
}
