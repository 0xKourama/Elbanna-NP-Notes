$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'AdminGroupChange@Roaya.co'
   #To         = 'Operation@Roaya.co'
    To         = 'MGabr@Roaya.co'
    Subject    = 'Admin Group Change'
}

#region html layout
$Header = "<h3>Admin Group Change</h3>"

$Style = @"
<style>
th, td {
    border: 2px solid black;
    text-align: center;
}
table{
    border-collapse: collapse;
    border: 2px solid black;
    width: 100%;
}
h3{
    color: white;
    background-color: #e00000;
    padding: 3px;
    text-align: Center;
    border: 2px solid black;
}
</style>
"@
#endregion

$Admin_Security_Groups = @(
    'Server Operators'
    'Administrators'
    'Domain Admins'
    'Enterprise Admins'
    'Schema Admins'
)

#location for the file to track membership data
$Admin_Group_Tracker_Path = '.\test.csv'

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
    #loop over all groups and find the difference between the old and new data
    0..(($Admin_Security_Groups).Count - 1) | ForEach-Object {
        $Differences = Compare-Object -ReferenceObject ($Old_Group_Data.Members[$_] -split ';') -DifferenceObject ($New_Group_Data.Members[$_] -split ';')
        Foreach($Difference in $Differences){
            $Difference_Array += [PSCustomObject][Ordered]@{
                ChangedMember = $Difference.InputObject
                ChangedGroup  = $New_Group_Data[$_].name
                ChangeType    = if($Difference.SideIndicator -eq '=>'){'Addition'}
                            elseif($Difference.SideIndicator -eq '<='){'Removal'}
            }
        }
    }
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Difference_Array | ConvertTo-Html -Fragment | Out-String)"
}