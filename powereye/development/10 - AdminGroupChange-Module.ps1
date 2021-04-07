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

$header = "<h3>Admin Group Change</h3>"

$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'AdminGroupChange@roaya.co'
    To         = 'operation@roaya.co'
#    To         = 'MGabr@roaya.co'
    Subject    = 'Admin Group Change'
}

$Admin_Security_Groups = @(
    'Server Operators'
    'Administrators'
    'Domain Admins'
    'Enterprise Admins'
    'Schema Admins'
)

$Variables_to_Clear = @(
    'Difference_Array'
    'DifferenceHTML'
    'Differences'
)

while($true){
    
    Write-Host -ForegroundColor Cyan "[*] Module running at $(Get-Date)"

    $Admin_Group_Tracker_Path = '.\test.csv'
    $Old_Group_Data = Import-Csv $Admin_Group_Tracker_Path
    $Old_Hash = (Get-FileHash -Path $Admin_Group_Tracker_Path).Hash

    $New_Group_Data = @()

    $Admin_Security_Groups | ForEach-Object {
        $New_Group_Data += [PSCustomObject][Ordered]@{
            Name    = $_
            Members = (Get-ADGroupMember -Identity $_ | Where-Object {$_.ObjectClass -eq 'user'} | 
                      Select-Object -ExpandProperty SamAccountName | Sort-Object) -join ';'
        }
    }

    $New_Group_Data | Export-Csv -NoTypeInformation $Admin_Group_Tracker_Path
    $New_Hash = (Get-FileHash -Path $Admin_Group_Tracker_Path).Hash

    if($New_Hash -ne $Old_Hash){
        $Difference_Array = @()
        Write-Host -ForegroundColor Yellow '[!] Change Detected. Sending mail alert'
        0..(($Admin_Security_Groups).Count - 1) | ForEach-Object {
            $Differences = Compare-Object -ReferenceObject ($Old_Group_Data.Members[$_] -split ';') -DifferenceObject ($New_Group_Data.Members[$_] -split ';')
            if($Differences -ne $null){
                Foreach($Difference in $Differences){
                    if($Difference.SideIndicator -ne '=='){
                        $Difference_Array += [PSCustomObject][Ordered]@{
                            ChangedMember = $Difference.InputObject
                            ChangedGroup  = $New_Group_Data[$_].name
                            ChangeType    = if($Difference.SideIndicator -eq '=>'){'Addition'}
                                        elseif($Difference.SideIndicator -eq '<='){'Removal'}
                        }                    
                    }
                }
            }
        }
        $DifferenceHTML = $Difference_Array | ConvertTo-Html | Out-String
        Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $DifferenceHTML"
        Clear-Variable -Name $Variables_to_Clear
    }
    else{
        Write-Host -ForegroundColor Green '[+] No changes detected'
    }
    Write-Host -ForegroundColor Cyan '[*] Sleeping for 10 minutes'
    Start-Sleep -Seconds 600
}