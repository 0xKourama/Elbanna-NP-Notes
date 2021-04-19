Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$Admin_Security_Groups = @(
    'Server Operators'
    'Administrators'
    'Domain Admins'
    'Enterprise Admins'
    'Schema Admins'
    'Organization Management'
)

#location for the file to track membership data
$Admin_Group_Tracker_Path = '.\GroupData.csv'

$Old_Group_Data = Import-Csv $Admin_Group_Tracker_Path

#calculating the hash for the old data file
$Old_Hash = (Get-FileHash -Path $Admin_Group_Tracker_Path).Hash

$New_Group_Data = @()

#pulling the data from the high privelege groups from active directory
$Admin_Security_Groups | ForEach-Object {
    $New_Group_Data += [PSCustomObject][Ordered]@{
        Name    = $_
        Members = (Get-ADGroupMember -Identity $_ | Where-Object {$_.ObjectClass -eq 'user'} | 
                    Select-Object -ExpandProperty SamAccountName | Sort-Object) -join ';'
    }
}

#exporting the new data to the tracker file
$New_Group_Data | Export-Csv -NoTypeInformation $Admin_Group_Tracker_Path

#calculating the hash of the new file to detect changes
$New_Hash = (Get-FileHash -Path $Admin_Group_Tracker_Path).Hash

#if the hash for the old file doesn't match the new one
if($New_Hash -ne $Old_Hash){
    $Difference_Array = @()
    0..($Admin_Security_Groups.Count - 1) | ForEach-Object {
        
        #Write-Host -ForegroundColor Cyan "[*] looping $($Old_Group_Data[$_].name) and $($Old_Group_Data[$_].name)"
        $OldGroupMembers = $Old_Group_Data[$_].Members -split ';' | Where-Object {$_ -ne ''}
        $NewGroupMembers = $New_Group_Data[$_].Members -split ';' | Where-Object {$_ -ne ''}

        foreach($member1 in $OldGroupMembers){
            if($NewGroupMembers -notcontains $member1){
                $Difference_Array += [PSCustomObject][Ordered]@{
                    ChangedMember = $member1
                    ChangedGroup  = $Admin_Security_Groups[$_]
                    ChangeType    = 'Removal'
                }
            }
        }
        foreach($member2 in $NewGroupMembers){
            if($OldGroupMembers -notcontains $member2){
                $Difference_Array += [PSCustomObject][Ordered]@{
                    ChangedMember = $member2
                    ChangedGroup  = $Admin_Security_Groups[$_]
                    ChangeType    = 'Addition'
                }
            }
        }
    }

    Write-Output "$(Get-Date) [!] change detected. Sending mail."
    Write-Output $Difference_Array

    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Difference_Array | ConvertTo-Html -Fragment | Out-String)"
}
else{
    Write-Output "$(Get-Date) [*] No change detected."
}