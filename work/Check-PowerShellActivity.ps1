$Script = {
    $List = @() 
    $Messages = (Get-WinEvent -FilterHashtable @{LogName = 'Windows Powershell'; ID = 800}).Message
    ForEach ($Message in $Messages){
        $Message = $Message -split '\n'
        $List += [PSCustomObject][Ordered]@{
            ComputerName = $env:COMPUTERNAME
            User         = ($Message | Select-String -Pattern '^\s+UserId=(.*)\s+'      -AllMatches).Matches.Groups[1].Value
            Command      = ($Message | Select-String -Pattern '^\s+CommandLine=(.*)\s+' -AllMatches).Matches.Groups[1].Value
        }
    }
    Write-Output $List
}
Invoke-Command -ComputerName (Return-ADOnlineComputers) -ScriptBlock $Script