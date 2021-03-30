
$ErrorActionPreference = 'Inquire'

$script = {

    $Event_properties = @(
        'ID'
        'Message'
        'TimeCreated'
    )

    $result += Get-WinEvent -FilterHashtable @{
        LogName='Security'
        id=4624,4625,4634,4720,4726,4738,4731,4735,4732,4733,4734,4723,4724
    }

    $result += Get-WinEvent -FilterHashtable @{
        LogName='System'
        id=7045
    }

    $result += Get-WinEvent -FilterHashtable @{
        LogName='Application'
        id=11707,11724
    }

    $result += Get-WinEvent -FilterHashtable @{
        LogName='Application'
        ProviderName='MsiInstaller'
        id=1036
    }

    Write-Host -ForegroundColor Green "[+] Data pulled from $env:COMPUTERNAME"

    $result

}

$result = Invoke-Command -ComputerName (Get-ADComputer -Filter *).Name -ErrorAction SilentlyContinue -ScriptBlock $Script

<#
$result | ForEach-Object {
    $ID = $_.id
    $SplitMessage = $_.Message -split "\n" 
    $ComputerName = $_.MAchineName
    switch($id){
        4624{
            $NewLogonBlock = $SplitMessage |
            Select-String -Pattern "New Logon:" -Context 0,3 |
            Select-Object -ExpandProperty Context |
            Select-Object -ExpandProperty PostContext

            $AccountName = (
                $NewLogonBlock |
                Select-String -Pattern 'Account Name:\s+(.*)' |
                Select-Object -ExpandProperty matches |
                Select-Object -ExpandProperty Groups
            )[1].Value

            $AccountDomain = (
                $NewLogonBlock |
                Select-String -Pattern 'Account Domain:\s+(.*)' |
                Select-Object -ExpandProperty matches |
                Select-Object -ExpandProperty Groups        
            )[1].Value

            $NetworkInformatiobBlock = $SplitMessage |
            Select-String -Pattern "Network Information:" -Context 0,1 |
            Select-Object -ExpandProperty Context |
            Select-Object -ExpandProperty PostContext

            $WorkStationName = (
                $NetworkInformatiobBlock |
                Select-String -Pattern "\s+Workstation Name:\s+(.*)" |
                Select-Object -ExpandProperty matches | 
                Select-Object -ExpandProperty Groups
            )[1].Value

            $LogonType = (
                $SplitMessage |
                Select-String -Pattern "Logon Type:\s+(.*)" |
                Select-Object -ExpandProperty matches | 
                Select-Object -ExpandProperty Groups        
            )[1].Value

            $Report = "New type $LogonType logon by $AccountDomain\$AccountName on Workstation $ComputerName"
            break;
        }

        4625{
            $SubjectBlock = $SplitMessage |
            Select-String -Pattern "Subject:" -Context 0,3 |
            Select-Object -ExpandProperty Context |
            Select-Object -ExpandProperty PostContext

            $AccountName = (
                $NewLogonBlock |
                Select-String -Pattern 'Account Name:\s+(.*)' |
                Select-Object -ExpandProperty matches |
                Select-Object -ExpandProperty Groups
            )[1].Value

            $AccountDomain = (
                $NewLogonBlock |
                Select-String -Pattern 'Account Domain:\s+(.*)' |
                Select-Object -ExpandProperty matches |
                Select-Object -ExpandProperty Groups        
            )[1].Value

        }

        default{
            $report = "Event ID $ID not yet configured"
        }
    }
    Write-Host $Report
}
#>