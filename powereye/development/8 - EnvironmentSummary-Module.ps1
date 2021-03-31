$Remoting_clutter_properties = @(
    'PSShowComputerName'
    'PSComputerName'
    'RunSpaceId'
)

$ADProperties = @(
    'Name'
    'CanonicalName'  #OU membership
    'IPV4Address' #computers without ipv4
    'LastLogonDate' #obsolete computers
    'OperatingSystem' #OS
    'MemberOf' #group  membership
)

$DCProperties = @(
    'Site'
    'Name'
    'IPv4Address'
    'isGlobalCatalog'
    'OperatingSystem'
)

$ADComputers = Get-ADComputer -Filter * -Properties $ADProperties | Select-Object -Property $ADProperties

$DomainControllers = Get-ADDomainController -Filter * | Select-Object -Property $DCProperties

#region online, offline and IPless computers
$Online = Test-Connection -ComputerName ($ADComputers | Where-Object {$_.IPV4Address}).Name -Count 1 -AsJob |
          Receive-Job -Wait | Where-Object {$_.StatusCode -eq 0} | Select-Object -ExpandProperty Address
$NoIPV4Assigned = $ADComputers | Where-Object {!$_.IPV4Address} | Select-Object -ExpandProperty Name
$Offline = $ADComputers.Name | Where-Object {$Online -notcontains $_}
#endregion

#region operating system summary
$OS_Summary = @()
$OS_List = $ADComputers.OperatingSystem | Select-Object -Unique
foreach($OS in $OS_List){
    $OS_Group = @{} | Select-Object -Property OperatingSystem, Count, ComputerList
    $OS_Group.OperatingSystem = $OS
    $list = $ADComputers | Where-Object {$_.OperatingSystem -eq $OS} | Select-Object -ExpandProperty Name
    $OS_Group.ComputerList = $List -join ','
    $OS_Group.Count = $list.Count
    $OS_Summary += $OS_Group
}
$OS_Summary = $OS_Summary | Sort-Object -Property Count
#endregion

#region computer Last logon date
$LastLogonDate_Summary = @()
foreach($Computer in $ADComputers){
    $Obj = @{} | Select-Object -Property ComputerName, LastLogonDate, Days
    $Obj.ComputerName = $Computer.Name
    if($Computer.LastLogonDate -eq $null){
        $Obj.LastLogonDate = 'Null'
        $Obj.Days = 'N/A'
    }
    else{
        $Obj.LastLogonDate = $Computer.LastLogonDate
        $Obj.Days = (New-TimeSpan -Start ($Computer.LastLogonDate) -End (Get-Date)).Days    
    }
    $LastLogonDate_Summary += $Obj
}
$LastLogonDate_Summary = $LastLogonDate_Summary | Sort-Object -Property Days -Descending
#endregion

#region OU summary
$OUs = $ADComputers.CanonicalName -replace "/\S+$" | Select-Object -Unique
$OU_Summary = @()
foreach($OU in $OUs){
    $Obj = @{} | Select-Object -Property OU, Count, ComputerList
    $Obj.OU = $OU
    $List = $ADComputers | Where-Object {($_.CanonicalName -replace "/\S+$") -eq $OU} | Select-Object -ExpandProperty Name
    $Obj.ComputerList = $List -join ','
    $Obj.Count = $List.Count
    $OU_Summary += $Obj
}
$OU_Summary = $OU_Summary | Sort-Object -Property Count -Descending
#endregion

#region Exchange server group memberships summary
$Exchange_Group_Membership_summary = @()
$Exchange_Servers = Get-ADGroupMember -Identity 'Exchange Servers' |
                    Where-Object {$_.ObjectClass -eq 'Computer'} |
                    Select-Object -ExpandProperty name
foreach($ExchangeServer in $Exchange_Servers){
    $obj = @{} | Select-Object -Property Server, MemberOf
    $Obj.Server = $ExchangeServer
    $Obj.MemberOf = (
        Get-ADComputer -Identity $ExchangeServer -Properties memberof |
        Select-Object -ExpandProperty MemberOf |
        ForEach-Object {Get-ADGroup -Identity $_ | Select-Object -ExpandProperty Name}     
    ) -join ','
    $Exchange_Group_Membership_summary += $Obj
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
$uptime_summary = Invoke-Command -ComputerName $Online -ErrorAction SilentlyContinue -ScriptBlock $uptime_script | 
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
$session_summary = Invoke-Command -ComputerName $Online -ErrorAction SilentlyContinue -ScriptBlock $session_script |
                   Select-Object -Property ComputerName, Username, LogonTime, Status | Sort-Object -Property ComputerName
$session_RDP_summary = $session_summary | Where-Object {$_.Status -eq 'ACTIVE - RDP'}
$session_CONSOLE_summmary = $session_summary | Where-Object {$_.Status -eq 'ACTIVE - CONSOLE'}
$session_inactive_summary = $session_summary | Where-Object {$_.Status -eq 'INACTIVE'}
#endregion