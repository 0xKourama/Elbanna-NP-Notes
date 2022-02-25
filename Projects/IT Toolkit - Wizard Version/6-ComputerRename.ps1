function Rename-PC {
    while($true){
        Display -Header "Rename Computer" `
                -Footer "X to Return"     `
                -OptionList "Enter computer name"
        $Choice = $Host.UI.ReadLine()
        if($Choice -eq 'X'){break}
        else{
            if(Test-Connection -ComputerName $Choice -Count 1 -Quiet){
                try{Rename-Computer -ComputerName $Choice -NewName (Read-Host "New name") -Restart -Force -PassThru -DomainCredential (Get-Credential)}catch{Show-Error}
            }
            else{Write-Host "$Choice` [Offline]"}
        }
        Write-Host "╠═════════════════════════════════════════════════════════════════════════════════════════════════════════════"
    }
}