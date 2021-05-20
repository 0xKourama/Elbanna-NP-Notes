Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$Admin_Security_Groups = @(
    'Administrators'
    'Domain Admins'
    'Enterprise Admins'
    'Organization Management'
    'Schema Admins'
    'Server Operators'
)

#location for the file to track membership data
$Admin_Group_Tracker_Path = '.\GroupData.csv'

$Old_Group_Data = Import-Csv $Admin_Group_Tracker_Path | Sort-Object -Property Name

#calculating the hash for the old data file
$Old_Hash = (Get-FileHash -Path $Admin_Group_Tracker_Path).Hash

$New_Group_Data = @()

#pulling the data from the high privelege groups from active directory
$Admin_Security_Groups | ForEach-Object {
    $New_Group_Data += [PSCustomObject][Ordered]@{
        Name    = $_
        Members = (Get-ADGroupMember -Identity $_ | Where-Object {$_.ObjectClass -eq 'user'} | 
                    Select-Object -ExpandProperty SamAccountName | Sort-Object) -join ' | '
    }
}

$New_Group_Data = $New_Group_Data | Sort-Object -Property Name

#exporting the new data to the tracker file
$New_Group_Data | Export-Csv -NoTypeInformation $Admin_Group_Tracker_Path

#calculating the hash of the new file to detect changes
$New_Hash = (Get-FileHash -Path $Admin_Group_Tracker_Path).Hash

#if the hash for the old file doesn't match the new one
if($New_Hash -ne $Old_Hash){
    $Difference_Array = @()
    0..($Admin_Security_Groups.Count - 1) | ForEach-Object {
        
        Write-Host -ForegroundColor Cyan "[*] looping over old $($Old_Group_Data[$_].name) and new $($New_Group_Data[$_].name)"
        $OldGroupMembers = $Old_Group_Data[$_].Members -split ' \| ' | Where-Object {$_ -ne ''}
        $NewGroupMembers = $New_Group_Data[$_].Members -split ' \| ' | Where-Object {$_ -ne ''}

        foreach($member1 in $OldGroupMembers){
            if($NewGroupMembers -notcontains $member1){
                Write-Host -ForegroundColor Yellow "[!] Recent $($New_Group_Data[$_].Name) group data doesn't have $member1"
                $Difference_Array += [PSCustomObject][Ordered]@{
                    ChangedMember = $member1
                    ChangedGroup  = $Admin_Security_Groups[$_]
                    ChangeType    = 'Removal'
                }
            }
            else{
                Write-Host -ForegroundColor Cyan "[*] Recent $($New_Group_Data[$_].Name) group data also has $member1"
            }
        }
        foreach($member2 in $NewGroupMembers){
            if($OldGroupMembers -notcontains $member2){
                Write-Host -ForegroundColor Yellow "[!] Old $($Old_Group_Data[$_].Name) group data doesn't have $member2"
                $Difference_Array += [PSCustomObject][Ordered]@{
                    ChangedMember = $member2
                    ChangedGroup  = $Admin_Security_Groups[$_]
                    ChangeType    = 'Addition'
                }
            }
            else{
                Write-Host -ForegroundColor Cyan "[*] Old $($Old_Group_Data[$_].Name) group data also has $member2"
            }
        }

    }

    Write-Output "$(Get-Date) [!] change detected. Sending mail."
    Write-Output $Difference_Array

$Summary = @"
<h3>Current Admin Group Membership Summary</h3>
$($New_Group_Data | ConvertTo-Html -Fragment | Out-String)
"@

    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Difference_Array | ConvertTo-Html -Fragment | Out-String) $Summary"
}
else{
    Write-Output "$(Get-Date) [*] No change detected."
}