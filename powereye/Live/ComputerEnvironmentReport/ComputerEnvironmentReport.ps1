Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

#region properties to be collected from both normal computers and domain controllers
$ADProperties = @(
    'Name'
    'CanonicalName'
    'IPV4Address'
    'LastLogonDate'
    'OperatingSystem'
    'MemberOf'
)

$DCProperties = @(
    'Site'
    'Name'
    'IPv4Address'
    'isGlobalCatalog'
    'OperatingSystem'
)
#endregion

#getting the computers in the 'old servers' OU to be excluded from report
$OldServers = (Get-ADComputer -Filter * -SearchBase 'OU=OldServers,DC=Roaya,DC=loc').Name

#fetch all AD computers with the needed properties
$ADComputers = Get-ADComputer -Filter * -Properties $ADProperties | Where-Object {$OldServers -notcontains $_.name} |
                Select-Object -Property $ADProperties

$DomainControllers = Get-ADDomainController -Filter * | Select-Object -Property $DCProperties

#region connectivity summary
$Connectivity_Summary = @()
$Online = Test-Connection -ComputerName ($ADComputers | Where-Object {$_.IPV4Address}).Name -Count 1 -AsJob |
          Receive-Job -Wait | Where-Object {$_.StatusCode -eq 0} | Select-Object -ExpandProperty Address
$NoIPV4Assigned = $ADComputers | Where-Object {!$_.IPV4Address} | Select-Object -ExpandProperty Name
$Offline = $ADComputers.Name | Where-Object {$Online -notcontains $_}

$Connectivity_Summary += [PSCustomObject][Ordered]@{
    State  = 'Online'
    Count = $Online.Count
    ComputerList  = $Online -join ' | '
}
$Connectivity_Summary += [PSCustomObject][Ordered]@{
    State = 'Offline'
    Count = $Offline.Count
    ComputerList = $Offline -join ' | '
}
$Connectivity_Summary += [PSCustomObject][Ordered]@{
    State  = 'NoIPV4'
    Count = $NoIPV4Assigned.Count
    ComputerList  = $NoIPV4Assigned -join ' | '
}
#endregion

#region operating system summary
$OS_Summary = @()
foreach($OS in ($ADComputers.OperatingSystem | Select-Object -Unique)){
    $OS_Summary += [PSCustomObject][Ordered]@{
        OperatingSystem = $OS
        ComputerList = ($ADComputers | Where-Object {$_.OperatingSystem -eq $OS}).Name -join ' | '
        Count = $list.Count
    }
}
$OS_Summary = $OS_Summary | Sort-Object -Property Count -Descending
#endregion

#region computer Last logon date
$LastLogonDate_Summary = @()
foreach($Computer in $ADComputers){
    $LastLogonDate_Summary += [PSCustomObject][Ordered]@{
        ComputerName = $Computer.Name
        LastLogonDate = if($Computer.LastLogonDate){$Computer.LastLogonDate}else{$null}
        Days          = if($Computer.LastLogonDate){(New-TimeSpan -Start ($Computer.LastLogonDate) -End (Get-Date)).Days}else{$null}
    }
}
$LastLogonDate_Summary = $LastLogonDate_Summary | Sort-Object -Property Days -Descending
#endregion

#region OU summary
$OUs = $ADComputers.CanonicalName -replace "/\S+$" | Select-Object -Unique
$OU_Summary = @()
foreach($OU in $OUs){
    $OU_Summary += [PSCustomObject][Ordered]@{
        OU = $OU
        ComputerList = ($ADComputers | Where-Object {($_.CanonicalName -replace "/\S+$") -eq $OU}).Name -join ' | '
        Count = $List.Count
    }
}
$OU_Summary = $OU_Summary | Sort-Object -Property Count -Descending
#endregion

#region Exchange server group memberships summary
$Exchange_Group_Membership_summary = @()
$Exchange_Servers = (Get-ADGroupMember -Identity 'Exchange Servers' |
                    Where-Object {$_.ObjectClass -eq 'Computer'}).name
foreach($ExchangeServer in $Exchange_Servers){
    $Exchange_Group_Membership_summary += [PSCustomObject][Ordered]@{
        Server = $ExchangeServer
        OperatingSystem = ($ADComputers | Where-Object {$_.Name -eq $ExchangeServer}).OperatingSystem
        MemberOf = (
            Get-ADComputer -Identity $ExchangeServer -Properties memberof |
            Select-Object -ExpandProperty MemberOf |
            ForEach-Object {Get-ADGroup -Identity $_ | Select-Object -ExpandProperty Name}     
        ) -join ' | '
    }
}
$Exchange_Group_Membership_summary = $Exchange_Group_Membership_summary | Sort-Object -Property Server
#endregion

#region domain controller summary
$DomainController_Summary = @()
foreach($DC in $DomainControllers){
    $DC | Add-Member -NotePropertyName Online -NotePropertyValue (Test-Connection -ComputerName $DC.Name -Count 1 -Quiet)
    $DomainController_Summary += $DC
}
$DomainController_Summary = $DomainController_Summary | Sort-Object -Property Name
#endregion

$PSSessions = New-PSSession -ComputerName $Online

#region uptime summary
$uptime_script = {
    $Result = New-TimeSpan -Start (
        [Management.ManagementDatetimeConverter]::ToDateTime(
            (Get-WmiObject -Query "SELECT LastBootUpTime FROM Win32_OperatingSystem").LastBootupTime
        )
    ) -End (get-date)
    $Result | Add-Member -NotePropertyName ComputerName -NotePropertyValue $env:COMPUTERNAME
    Write-Output $result
}
$uptime_summary = Invoke-Command -Session $PSSessions -ErrorAction SilentlyContinue -ScriptBlock $uptime_script | 
                    Sort-Object -Property TotalMinutes -Descending | 
                    Select-Object -Property Computername, Days, Hours, Minutes
#endregion

#region session summary
$session_script = {
    $PropertyList = @(
        'ComputerName'
        'Username'
        'Logontime'
        'Status'
    )
    $User_list = @()
    try{
        Quser | Select-Object -Skip 1 | ForEach-Object {
            $User = @{} | Select-Object -Property $PropertyList
            $User.ComputerName = $env:COMPUTERNAME
            $User.username     = $_.Substring(0 , 23).Trim().toUpper()
            $state             = $_.Substring(46, 8 ).Trim().toUpper()
            if($state -eq 'Disc'){$User.status = 'INACTIVE'}
            else{
                $session = $_.Substring(22, 20).Trim().toUpper()
                if($session -like 'RDP*'){$session = 'RDP'  }
                else                     {$session = 'CONSOLE'}
                $User.status = "ACTIVE - $session"
            }
            $User.logontime    = $_.Substring(65, ($_.Length - 65)).Trim().toUpper()
            $User_list += $User
        }
    }
    catch{
        $User = @{} | Select-Object -Property $PropertyList
        $User.ComputerName = $env:COMPUTERNAME
        $User.Username = "NONE"
        $User_list    += $User        
    }
    Write-Output $User_list
}
$session_summary = Invoke-Command -Session $PSSessions -ErrorAction SilentlyContinue -ScriptBlock $session_script |
                    Select-Object -Property ComputerName, Username, LogonTime, Status | Sort-Object -Property ComputerName

$session_RDP_summary      = $session_summary | Where-Object {$_.Status -eq 'ACTIVE - RDP'}
$session_CONSOLE_summmary = $session_summary | Where-Object {$_.Status -eq 'ACTIVE - CONSOLE'}
$session_inactive_summary = $session_summary | Where-Object {$_.Status -eq 'INACTIVE'}
#endregion

Remove-PSSession $PSSessions

#region HTML summary data
$body = @"
<h4>Connectivity Summary</h4>
$($Connectivity_Summary              | ConvertTo-Html -Fragment)
<h4>Operating System Summary</h4>
$($OS_Summary                        | ConvertTo-Html -Fragment)
<h4>Last Logon Summary</h4>
$($LastLogonDate_Summary             | ConvertTo-Html -Fragment)
<h4>OU Summary</h4>
$($OU_Summary                        | ConvertTo-Html -Fragment)
<h4>Exchange Server Group Memberships</h4>
$($Exchange_Group_Membership_summary | ConvertTo-Html -Fragment)
<h4>Domain Controller Summary</h4>
$($DomainController_Summary          | ConvertTo-Html -Fragment)
<h4>Server Uptime Summary</h4>
$($uptime_summary                    | ConvertTo-Html -Fragment)
<h4>Console Sessions</h4>
$($session_CONSOLE_summmary          | ConvertTo-Html -Fragment)
<h4>RDP Sessions</h4>
$($session_RDP_summary               | ConvertTo-Html -Fragment)
<h4>Inactive Sessions</h4>
$($session_inactive_summary          | ConvertTo-Html -Fragment)
"@
#endregion

Send-MailMessage @MailSettings -BodyAsHtml "$style $header $body"