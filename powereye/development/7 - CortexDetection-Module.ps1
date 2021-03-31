while($true){
    $online = Test-Connection -ComputerName (
        Get-ADComputer -Filter * -Properties IPV4Address | Where-Object {$_.IPV4Address} |
        Select-Object -ExpandProperty Name
    ) -Count 1 -AsJob | Receive-Job -Wait | Where-Object {$_.statuscode -eq 0} |
    Select-Object -ExpandProperty Address

    $script = {
        $ErrorActionPreference = 'Stop'
        $Obj = @{} | Select-Object -Property ComputerName, CortexInstalled, Error
        $Obj.ComputerName = $env:COMPUTERNAME
        try{
            $Check = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like '*Cortex*'}
            if($Check -eq $null){
                $Obj.CortexInstalled = $false
            }
            else{
                $Obj.CortexInstalled = $true
            }
            $Obj.Error = 'N/A'
        }
        catch{
            $Obj.Error = $Error[0]
        }
        Write-Output $Obj
    }

    $Result = Invoke-Command -ComputerName $online -ErrorAction SilentlyContinue -ScriptBlock $script | 
              Select-Object -Property * -ExcludeProperty PSComputerName, PSShowComputerName, RunSpaceId

    Write-Output $Result | Format-Table -AutoSize

    $Alert_Result = $Result | Where-Object {$_.CortexInstalled -eq $false}

    $Alert_Result_HTML = $Alert_Result | ConvertTo-Html | Out-String

$style = @"
<style>
th, td {
    border: 2px solid black;
    text-align: center;
}
table{
    border-collapse: collapse;
    border: 2px solid black;
    width: 100%;
}
h3{
    color: white;
    background-color: #FF0000;
    padding: 3px;
    text-align: Center;
    border: 2px solid black;
}
</style>
"@

$Header = @"
<h3>Cortex Endpoint Check:</h3>
"@

    $MailSettings = @{
        SMTPserver = '192.168.3.202'
        From       = 'PowerEye@worldposta.com'
        To         = 'MGabr@roaya.co'
        Subject    = 'PowerEye | Cortex Endpoint Check Module'
    }

    if($Alert_Result){
        Write-Host -ForegroundColor Yellow '[!] Cortex missing on some computers. Sending mail'
        Send-MailMessage @MailSettings -Body "$style $Header $Alert_Result_HTML"    
    }
    else{
        Write-Host -ForegroundColor Green '[+] Cortex Endpoint installed on all computers'
    }

    Start-Sleep -Seconds 60

}