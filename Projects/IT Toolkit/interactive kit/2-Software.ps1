function Get-InsalltedSoftware{
    while($true){
        Display -Header "Installed Software" `
                -Footer "X to Return"        `
                -OptionList @("Enter computer name", "L] Load from file")

        $InvokeBlock = {

            Invoke-Expression $args[0]

            $PropertyList = @(
                "DisplayName"   ,
                "DisplayVersion",
                "Publisher"     ,
                "InstallDate"
            )
                
            $Reg_path = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
                
            $string = Get-ItemProperty $Reg_path | ? {$_.displayname -ne $null} | Select-Object -Property $PropertyList | Sort-Object -Property DisplayName |
                                                                                  Format-Table  -Property @{n='Application' ; e='DisplayName'    ; width = 65},
                                                                                                          @{n='Version'     ; e='DisplayVersion' ; width = 15},
                                                                                                          @{n='Publisher'   ; e='Publisher'      ; width = 16},
                                                                                                          @{n='InstallDate' ; e='InstallDate'    ; width = 11} | Out-String

            $output = [System.Collections.ArrayList]@()
            
            $output += "$env:COMPUTERNAME"
            $output += '-' * $env:COMPUTERNAME.Length
            $string.trim() -split "`n" | % {$output += $_}

            Display -OptionList $output
        }

        $computers = Quick-ping -Computernames (Get-ComputerCriteria)

        Invoke-Command -ComputerName $computers -ScriptBlock $InvokeBlock -ArgumentList $UtilityFunctions
    }
}