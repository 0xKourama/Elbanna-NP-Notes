while($true){
    $Domain_Controllers = (Get-ADDomainController -Filter *).Name

    $Online = Test-Connection -ComputerName $Domain_Controllers -Count 1 -AsJob | Receive-Job -Wait | Where-Object {$_.StatusCode -eq 0} | Select-Object -ExpandProperty Address

    $Admin_Security_Groups = @(
        'Server Operators'
        'Administrators'
        'Domain Admins'
        'Enterprise Admins'
        'Schema Admins'
    )

    $Admin_Group_Members = $Admin_Security_Groups | ForEach-Object {
        Get-ADGroupMember -Identity $_ |
        Where-Object {$_.ObjectClass -eq 'user'} |
        Select-Object -ExpandProperty SamAccountName
    } | Sort-Object -Unique

    $Script = {

        $ErrorActionPreference = 'Stop'
        
        $Event_properties = @(
            'Message',
            'TimeCreated'
        )

        $Results = @()

        try{
            if(!(Test-Path 'C:\Users\Public\Event_4724_LastCheck.xml')){
                $Events = Get-WinEvent -FilterHashtable @{
                    LogName='Security'
                    id=4724
                } | Select-Object -Property $Event_properties
            }
            else{
                $start_time = Import-Clixml 'C:\Users\Public\Event_4724_LastCheck.xml'
                $Events = Get-WinEvent -FilterHashtable @{
                    LogName='Security'
                    id=4724
                    StartTime=$start_time
                } | Select-Object -Property $Event_properties    
            }
            Get-Date | Export-Clixml 'C:\Users\Public\Event_4724_LastCheck.xml'


            foreach($Event in $Events){
        
                $obj = @{} | Select-Object -Property ComputerName, ChangeDate, Source, Target, Error
        
                $Account_matches = ($Event.Message -split "\n" | Select-String -Pattern "^\s+Account Name:\s+(\S+)" -AllMatches).Matches.Groups |
                    Where-Object {$_.name -eq 1} | Select-Object -ExpandProperty Value
        
                $obj.ComputerName  = $env:COMPUTERNAME
                $obj.ChangeDate    = $Event.TimeCreated
                $obj.Source        = $Account_matches[0]
                $obj.Target        = $Account_matches[1]
                $obj.Error         = "N/A"

                $Results += $obj
            }

            Write-Output $Results
        }
        catch{
           $obj = @{} | Select-Object -Property ComputerName, ChangeDate, Source, Target, Error
           $obj.ComputerName = $env:COMPUTERNAME
           $obj.Error = $Error[0]
           $Results += $obj
        }
    }

    Write-Host -ForegroundColor Cyan "[*] Module running at $(Get-Date)"

    $ResultNormal = Invoke-Command -ComputerName $Online -ScriptBlock $Script |
                    Select-Object -Property * -ExcludeProperty RunSpaceID, PSShowComputerName, PSComputerName |
                    Sort-Object -Property ChangeDate -Descending

    Write-Output $ResultNormal | Format-Table -AutoSize

    $ResultAdmin = $ResultNormal | Where-Object {$Admin_Group_Members -contains $_.Target}

    $ResultHTML = $ResultAdmin | ConvertTo-Html

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
        SMTPserver = '192.168.3.202'
        From       = 'PowerEye@roaya.co'
        To         = 'operation@roaya.co'
        Subject    = 'PowerEye | Admin Password Change Module'
    }

    if($ResultAdmin){
        Write-Host -ForegroundColor Red "[!] Admin password changes found! Sending mail"
        Send-MailMessage @MailSettings -BodyAsHtml "$Header $ResultHTML"
    }
    else{
        Write-Host -ForegroundColor Green "[+] No admin password changes found"
    }

    Write-Host -ForegroundColor Cyan '[*] Sleeping for 10 minutes'
    [GC]::Collect()
    Start-Sleep -Seconds (60 * 10)
}