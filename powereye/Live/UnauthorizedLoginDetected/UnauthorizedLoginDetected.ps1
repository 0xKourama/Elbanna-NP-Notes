Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

Import-Module '..\UtilityFunctions.ps1'

$session_script = {
    $List = @()
    Try{
        $ErrorActionPreference = 'stop'
        Quser | Select -Skip 1 | ForEach-Object {
            $List += [PSCustomObject][Ordered]@{
                ComputerName = $env:COMPUTERNAME
                Username     = $_.Substring(1 , 22).Trim().toUpper()
                ID           = $_.Substring(42, 4 ).Trim()
                LogonTime    = $_.Substring(65, ($_.Length - 65)).Trim().toUpper()
                State        = if(($_.Substring(46, 8 ).Trim().toUpper()) -eq 'DISC'){'INACTIVE'}else{'ACTIVE'}
                SessionType  = $_.substring(23,19).Trim().toUpper() -replace '-.*'
            }
        }
    }
    Catch{
        $List += [PSCustomObject][Ordered]@{
            ComputerName = $env:COMPUTERNAME
            Username     = 'NONE'
        }
    }
    Write-Output $List
}

$Online = Return-OnlineComputers -ComputerNames (Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address}).Name

$AuthorizedPersonnel = (Get-ADGroupMember -Identity 'Authorized Personnel').SamAccountName

$UnAuthorizedSessions = Invoke-Command -ComputerName $Online -ErrorAction SilentlyContinue -ScriptBlock $session_script |
                        Where-Object {$AuthorizedPersonnel -notcontains $_.Username -and $_.Username -ne 'NONE'} |
                        Sort-Object -Property ComputerName | Select-Object -Property * -ExcludeProperty PSComputerName, PSShowComputerName, RunSpaceID

$LogoffScript = {
    logoff $args[0]
    if($?){
        [PSCustomObject][Ordered]@{
            ComputerName = $env:COMPUTERNAME
            Username     = $args[1]
            Logoff       = 'Success'
        }
    }
    else{
        [PSCustomObject][Ordered]@{
            ComputerName = $env:COMPUTERNAME
            Username     = $args[1]
            Logoff       = 'Fail'
        }        
    }
}

#actions
#1. change password
#2. disable
#3. remove security group membership
#4. logoff

$Secure_String_Pwd = ConvertTo-SecureString "$$UnAuthPwdChange$$" -AsPlainText -Force

$LogoffScript = {

    $Secure_String_Pwd = $args[2]

    $Obj = New-Object -TypeName PSObject -Property ComputerName, Username, Scope, Logoff, PasswordChange, Disable, GroupMembershipRemoval

    $Obj.ComputerName = $env:COMPUTERNAME
    $Obj.Username     = $args[1]

    if(Get-LocalUser -Name $args[1]){
        $Obj.Scope = 'Local'

        Get-LocalUser -Name $args[1] | Set-LocalUser -Password $Secure_String_Pwd
        if($?){$Obj.PasswordChange = 'Success'}
        else{$Obj.PasswordChange = 'Fail'}

        Disable-LocalUser -Name $args[1]
        if($?){$Obj.Disable = 'Success'}
        else{$Obj.Disable = 'Fail'}

        Get-LocalGroup | ForEach-Object {Remove-LocalGroupMember $_ -Member $args[1] -ErrorAction SilentlyContinue}
        $Obj.GroupMembershipRemoval = 'Success'
    }
    else{
        $Obj.Scope = 'ActiveDirectory'
    }
    logoff $args[0]
    if($?){$Obj.Logoff = 'Success'}
    else{$Obj.Logoff = 'Fail'}

    $Obj
}


$LogoffResults = @()

$UnAuthorizedSessions | ForEach-Object {
    $LogoffResults += Invoke-Command -ComputerName $_.ComputerName -ScriptBlock $LogoffScript -ArgumentList $_.ID, $_.Username, $Secure_String_Pwd |
                      Select-Object -Property * -ExcludeProperty PSComputerName, RunspaceId, PSShowComputerName
}

foreach($LogoffResult in ($LogoffResults | Where-Object {$_.Scope -eq 'ActiveDirectory'})){
    Set-ADAccountPassword -Identity $LogoffResult.Username -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $Secure_String_Pwd -Force)
    if($?){$_.PasswordChange = 'Success'}
    else{$_.PasswordChange = 'Fail'}

    Get-ADUser -Filter {Name -eq $LogoffResult.username} | Disable-ADAccount
    if($?){$_.Disable = 'Success'}
    else{$_.Disable = 'Fail'}

    (Get-ADUser -Filter {Name -eq $LogoffResult.username} -Properties MemberOf).MemberOf | ForEach-Object {
        Get-ADGroup $_ | Remove-ADGroupMember -Members $LogoffResult.username
    }
    $Obj.GroupMembershipRemoval = 'Success'
}


$AuthorizedPersonnelList = @"
<h3>Authorized Personnel</h3>
$($AuthorizedPersonnel | Sort-Object | ForEach-Object -Begin {'<ul>'} -Process {"<li>$($_.ToUpper())</li>"} -End {"</ul>"})
"@

if($LogoffResults){

$UnAuthorizedUsersDetected = @"
<h3>Unauthorized User(s) Detected</h3>
$($UnAuthorizedSessions.Username | Sort-Object -Unique | ForEach-Object -Begin {'<ul>'} -Process {"<li>$($_.ToUpper())</li>"} -End {"</ul>"})
"@

$UnAuthorizedSessionDetails = @"
<h3>Unauthorized Session Details</h3>
$($UnAuthorizedSessions | Select-Object -Property * -ExcludeProperty ID | ConvertTo-Html -Fragment)
"@

$LogoffSummary = @"
<h3>Logoff Results</h3>
$($LogoffResults | ConvertTo-Html -Fragment)
"@

}

if($UnAuthorizedSessions){
    Write-Output "$(Get-Date) [*] Unauthorized logins detected. Sending mail"
    Send-MailMessage @MailSettings -BodyAsHtml "$style $UnAuthorizedUsersDetected $UnAuthorizedSessionDetails $LogoffSummary $AuthorizedPersonnelList"
}
else{
    Write-Output "$(Get-Date) [*] No unauthorized logins detected."
}