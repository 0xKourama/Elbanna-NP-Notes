function Quick-ping {
    param(
        [string[]]$ComputerNames
    )

    Write-Host "* Testing connectivity..." -ForegroundColor Cyan

    $Online = @()
    $Job = Test-Connection -ComputerName $ComputerNames -Count 1 -AsJob
    $Job | Wait-Job | Receive-Job | % {
        if($null -eq $_.responsetime -or $null -eq $_.ipv4address){                     }
        else                                                      {$Online += $_.Address}
    }

     Remove-Job $Job

    if(!$Online){
        
        Write-Host "- $($Online.count)/$($ComputerNames.Count) online" -ForegroundColor Gray
        continue
    }
    else{
        
        Write-Host "+ $($Online.count)/$($ComputerNames.Count) online" -ForegroundColor Green
        return $Online | Sort
    }
}