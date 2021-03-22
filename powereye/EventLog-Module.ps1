
<#
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

#>

$result | Where-Object {$_.id -eq 4624} |
Select-Object -First 100 -ExpandProperty Message |
ForEach-Object {
    #($_ | Select-String -Pattern "\s+Account Name:\s+(.*)" -AllMatches | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty groups) # | Select-Object -ExpandProperty Groups)[4].Value |
    #Where-Object {$_ -notmatch "-\s+"}
    $_
    pause
}
# | Select-Object -Unique