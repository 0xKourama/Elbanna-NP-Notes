function Search-User{
    while($true){
        Display -Header "Search User" `
                -Footer "X to Return" `
                -OptionList @("Enter username")

        $wanted_user = $host.ui.ReadLine().replace(' ','').toUpper()

        if($wanted_user -eq 'X'){break}

        write-Host "║"
        Write-Host "║ [?] Enter search area: " -NoNewline

        $InvokeBlock = {

            $ErrorActionPreference = 'SilentlyContinue'

            $PropertyList = @(
                'ComputerName' ,
                'Username'     ,
                'Status'
            )

            $User_list = @()

            Quser | % {
                if($_ -eq " USERNAME              SESSIONNAME        ID  STATE   IDLE TIME  LOGON TIME"){}
                else{
                    $User = @{} | Select-Object -Property $PropertyList
                    $User.Computername = $env:COMPUTERNAME
                    $User.username     = $_.Substring(0 , 23).Trim().toUpper()
                    $state             = $_.Substring(46, 8 ).Trim().toUpper()
                    if($state -eq 'Disc'){$User.status = '[INACTIVE]'}
                    else{
                        $session = $_.Substring(22, 20).Trim().toUpper()
                        if($session -like 'RDP*'){$session = 'RDP'  }
                        else                     {$session = 'LOCAL'}
                        $User.status = "[ACTIVE - $session]"
                    }
                    $User_list += $User
                }    
            }

            Write-Output $User_list            
        }

        $computers = Quick-ping -ComputerNames (Get-ComputerCriteria)

        Write-Host '║ ' -NoNewline
        Write-Host "[*] Searching for user $wanted_user in the given criteria..." -ForegroundColor Cyan

        $Result = Invoke-Command -ComputerName $computers -ScriptBlock $InvokeBlock -ErrorAction SilentlyContinue | ? {$_.username -eq $wanted_user} |
                  select -Property ComputerName,Status

        if(!$Result){
            Write-Host '║ ' -NoNewline
            Write-Host "[-] User $wanted_user wasn't found in the given criteria" -ForegroundColor Gray
        }
        else{
            Write-Host '║ ' -NoNewline
            Write-Host "[+] Search results for User $wanted_user`:" -ForegroundColor Green
            Write-Host '║ '
            ($Result | sort -Property Computername | ft -AutoSize | Out-String).trim() -split "`n" | % {Write-Host "║ $_"}
        }

        Write-Host "║"

        Divider
    }
}