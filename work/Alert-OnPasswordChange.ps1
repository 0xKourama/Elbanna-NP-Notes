$ErrorActionPreference = 'Stop'

while($true){
    $Domain_Controllers = (Get-ADDomainControllers -Filter *).Name

    $Online = Test-Connection -ComputerName $Domain_Controllers -Count 1 -AsJob | Receive-Job -Wait | Where-Object {$_.StatusCode -eq 0} | Select-Object -ExpandProperty Address

    $Admin_Security_Groups = @(
        'Administrators',
        'Domain Admins',
        'Enterprise Admins'
    )

    $Admin_Group_Members = $Admin_Security_Groups | ForEach-Object {
        Get-ADGroupMember -Identity $_ |
        Where-Object {$_.ObjectClass -eq 'user'} |
        Select-Object -ExpandProperty SamAccountName
    } | Sort-Object -Unique

    $Script = {

        $Event_properties = @(
            'Message',
            'TimeCreated'
        )

        if(!(Test-Path 'C:\Users\Public\Event_4724_LastCheck.xml')){
            $Events = Get-WinEvent -FilterHashtable @{
                LogName='Security'
                id=4724
            } | Select-Object -Property $Event_properties
            Get-Date | Export-Clixml 'C:\Users\Public\Event_4724_LastCheck.xml'
        }
        else{
            $start_time = Import-Clixml 'C:\Users\Public\Event_4724_LastCheck.xml'
            $Events = Get-WinEvent -FilterHashtable @{
                LogName='Security'
                id=4724
                StartTime=$start_time
            } | Select-Object -Property $Event_properties    
        }

        $Results = @()

        foreach($Event in $Events){
        
            $obj = @{} | Select-Object -Property ComputerName, ChangeDate, ChangeSource, ChangeTarget
        
            $Account_matches = ($Event.Message -split "\n" | Select-String -Pattern "^\s+Account Name:\s+(\S+)" -AllMatches).Matches.Groups |
                Where-Object {$_.name -eq 1} | Select-Object -ExpandProperty Value
        
            $obj.ComputerName = $env:COMPUTERNAME
            $obj.ChangeDate   = $Event.TimeCreated
            $obj.ChangeSource = $Account_matches[0]
            $obj.ChangeTarget = $Account_matches[1]

            $Results += $obj
        }

        Write-Output $Results

        Write-Host -ForegroundColor Green "[+] $env:COMPUTERNAME queried"
    }

    Write-Host -ForegroundColor Cyan "[*] Module ran at $(Get-Date)"

    $Result = Invoke-Command -ComputerName $Online -ScriptBlock $Script |
              Where-Object {$Admin_Group_Members -contains $_.ChangeTarget} |
              Select-Object -Property * -ExcludeProperty RunSpaceID, PSShowComputerName, PSComputerName

    $ResultHTML = $Result | ConvertTo-Html

    $Header = @"
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
<h3>Admin Password Change:</h3>
"@

    $MailSettings = @{
        SMTPserver = 'mail.worldposta.com'
        From       = 'PowerEye@worldposta.com'
        To         = 'MGabr@roaya.co'
        Subject    = 'Admin Password Change'
    }

    Send-MailMessage @MailSettings -BodyAsHtml "$Header $ResultHTML"

    Start-Sleep -Seconds 60
}