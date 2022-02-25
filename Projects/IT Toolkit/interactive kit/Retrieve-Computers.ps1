function Get-ComputerCriteria {
    [string]$Criteria = ($Host.UI.ReadLine()).replace(" ","")
    $Computers        = @()

    if    (!$Criteria)       {continue}
    elseif($Criteria -eq 'X'){break}
    elseif($Criteria -eq 'L'){
        New-Item $env:PUBLIC\PCList.txt -ErrorAction SilentlyContinue | Out-Null

        Write-Host '* Notepad started. Please add the computers you want to target' -ForegroundColor Cyan

        Notepad $env:PUBLIC\PCList.txt | Out-Null
        Write-Host '* Computer names loaded. Querying active directory...' -ForegroundColor Cyan

        @(Get-Content $env:PUBLIC\PCList.txt) | % {

            $PC = Get-ADComputer -Server $Domain           `
                                 -Filter "Name -like '$_'" `
                                 -Properties DNSHostname | Select-Object -ExpandProperty DNSHostName
                                
            if($PC){$Computers += $PC}
            else{
                Write-Host "! Computer [$_] wasn't found in $Domain domain" -ForegroundColor Yellow
            }
        }
    }
    else{
        Write-Host "* Querying Active Directory for computers in the $Criteria criteria..." -ForegroundColor Cyan
        $Computers = Get-ADComputer -Server $Domain                  `
                                    -Filter "Name -like '$Criteria'" `
                                    -Properties DNSHostname | Select-Object -ExpandProperty DNSHostName
    }
    if(!$Computers){
        write-host "- The computer(s) weren't found in $Domain domain" -ForegroundColor Red
        continue
    }
    else{
        return $Computers
    }
}