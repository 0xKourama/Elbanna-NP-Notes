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

Import-Module '..\UtilityFunctions.ps1'

$Online = Return-OnlineComputers -ComputerNames ($ADComputers | Where-Object {$_.IPV4Address}).Name
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
        Count = ($ADComputers | Where-Object {$_.OperatingSystem -eq $OS}).Count
        ComputerList = ($ADComputers | Where-Object {$_.OperatingSystem -eq $OS}).Name -join ' | '
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
$OUs = ($ADComputers | Select-Object -Property @{n='OU';e={$_.canonicalname -replace "/$($_.name)"}} -Unique).OU
$OU_Summary = @()
foreach($OU in $OUs){
    $OU_Summary += [PSCustomObject][Ordered]@{
        OU = $OU
        Count = ($ADComputers | Where-Object {($_.CanonicalName -replace "/$($_.name)") -eq $OU}).Count
        ComputerList = ($ADComputers | Where-Object {($_.CanonicalName -replace "/$($_.name)") -eq $OU}).Name -join ' | '
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
                    Select-Object -Property Computername, @{n='Uptime';e={"$($_.Days) day(s) $($_.Hours) hour(s) $($_.Minutes) minute(s)"}}
#endregion

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
"@
#endregion

Write-Output "$(Get-Date) [*] Sending mail"

Write-Output $Connectivity_Summary
Write-Output $OS_Summary
Write-Output $LastLogonDate_Summary
Write-Output $Exchange_Group_Membership_summary
Write-Output $DomainController_Summary
Write-Output $uptime_summary

Send-MailMessage @MailSettings -BodyAsHtml "$style $header $body"