function Access-HiddenShare{
    while($true){
        Display -Header "Access hidden share" `
                -Footer "X to Return"         `
                -OptionList @("Enter computer name", "L] Load from file")

        Quick-ping -Computernames (Get-ComputerCriteria) | % {
            if(Test-Path -Path "\\$_\C$"){
                explorer.exe \\$_\c$
                Write-host "║ " -NoNewline
                write-host "[+] Admin share opened on $_" -ForegroundColor Green
            }
            else{
                Write-host '║ ' -NoNewline
                write-host '[-] An error occured' -ForegroundColor Red
            }
            Write-Host '║'
            Divider
        }
    }
}