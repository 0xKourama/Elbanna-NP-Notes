$MailSettings = @{
    SMTPserver = '192.168.3.202'
    From       = 'AdminPasswordChange@Roaya.co'
    #To         = 'Operation@Roaya.co'
    To         = 'MGabr@Roaya.co'
    Subject    = 'Admin Password Change'
}

#region HTML Layout
$Header = "<h3>Admin Password Change</h3>"

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
    background-color: #FF0000;
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

#region retrieve members of the configured security groups
$Admin_Group_Members = $Admin_Security_Groups | ForEach-Object {
    Get-ADGroupMember -Identity $_ |
    Where-Object {$_.ObjectClass -eq 'user'} |
    Select-Object -ExpandProperty SamAccountName
} | Sort-Object -Unique
#endregion

$Script = {
    #supress errors, only error is when there are no logs matching the criteria
    $ErrorActionPreference = 'SilentlyContinue'

    $EventID = 4724
    $XML_Path = "C:\Users\Public\Event_$EventID`_LastCheck.xml"

    $Results = @()

    #region if the date of last query is found, we query events from that point forward, otherwise, we query all events
    if(!(Test-Path -Path $XML_Path)){
        $Events = Get-WinEvent -FilterHashtable @{LogName = 'Security'; ID = $EventID} |
                  Select-Object -Property Message, TimeCreated
    }
    else{
        $Events = Get-WinEvent -FilterHashtable @{LogName = 'Security'; ID = $EventID; StartTime = Import-Clixml -Path $XML_Path} |
                  Select-Object -Property Message, TimeCreated
    }
    #update the tracker XML file
    Get-Date | Export-Clixml -Path $XML_Path
    #endregion

    #region parse event messages into an object
    $Events | ForEach-Object {
        $Account_matches = ($_.Message -split "\n" | Select-String -Pattern "^\s+Account Name:\s+(\S+)" -AllMatches).Matches.Groups |
                           Where-Object {$_.name -eq 1} | Select-Object -ExpandProperty Value
        $Results += [PSCustomObject][Ordered]@{
            ComputerName  = $env:COMPUTERNAME
            ChangeDate    = $_.TimeCreated
            Source        = $Account_matches[0]
            Target        = $Account_matches[1]
        }
    }
    #endregion

    Write-Output $Results
}

#testing connectivity for all domain computers
$Online = (Test-Connection -ComputerName (Get-ADDomainController -Filter *).Name -Count 1 -AsJob |
          Receive-Job -Wait | Where-Object {$_.StatusCode -eq 0}).Address

#invoke the script over the remote computers
$Result = Invoke-Command -ComputerName $Online -ScriptBlock $Script | Where-Object {$Admin_Group_Members -contains $_.Target} |
          Select-Object -Property * -ExcludeProperty RunSpaceID, PSShowComputerName, PSComputerName |
          Sort-Object -Property ChangeDate -Descending

if($Result){
    Send-MailMessage @MailSettings -BodyAsHtml "$Style $Header $($Result | ConvertTo-Html)"
}