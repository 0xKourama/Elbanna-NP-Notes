function GP-Update{
    while($true){
        $option_list = @(
            "1] View User Policy"      ,
            "2] View Computer Policy"  ,
            "3] View Full HTML Report" ,
            "4] Group Policy Update"
        )
        Display -Header "Group Policy" `
                -Footer "X to Cancel"  `
                -OptionList $option_list

        $option = $host.ui.ReadLine()
        if($option -eq 'X'){break}

        switch($option){
            1{$title = 'View User Policy'      }
            2{$title = 'View Computer policy'  }
            3{$title = 'View Full HTML Report' }
            4{$title = 'Group Policy Update'   }
            default{
                Write-Host '║ ' -NoNewline
                Write-Host '[-] Invalid choice' -ForegroundColor Red
            }
        }

        Display -Header $title `
                -Footer "X to Return"  `
                -OptionList @("Enter computer name", "L] Load from file")

        $Computers = Quick-ping -Computernames (Get-ComputerCriteria)

        mkdir -Path "$env:PUBLIC\GP-Results" -ErrorAction SilentlyContinue | Out-Null
        foreach($computer_FQDN in $computers){
        
            $underline = '╠═'
            @(1..$($computer_FQDN.length)) | % {$underline += "═"}

            Write-Host '║'
            Write-Host "║ $computer_FQDN"
            Write-Host $underline
            Write-Host '║'

            try{
                switch($option){
                    1{
                        gpresult /user (Read-Host '║ [?] Enter username') /s $computer_FQDN /r /scope:user | % {Write-Output "║ $_"}
                    }
                    2{
                        gpresult /user (Read-Host '║ [?] Enter username') /s $computer_FQDN /r /scope:computer | % {Write-Output "║ $_"}
                    }
                    3{
                        $filename = "GP Result $computer_FQDN - $((Get-Date).ToString().Replace(':','-').Replace('/','-')).html"

                        gpresult /user (Read-Host '║ [?] Enter username') /s $computer_FQDN /h $env:PUBLIC\GP-results\$filename; start $env:PUBLIC\GP-results\$filename
                        Write-Host '║'
                    }
                    4{
                        Write-Host '║ ' -NoNewline
                        Write-Host '[*] Updating Policy...' -ForegroundColor Cyan
                        $result = Invoke-Command -ComputerName $computer_FQDN -ScriptBlock {gpupdate /force}
                        $result | % {
                            if($_ -eq 'Computer Policy update has completed successfully.'){
                                Write-Host '║ ' -NoNewline
                                Write-Host '[+] Computer Policy updated' -ForegroundColor Green
                            }
                            elseif($_ -eq 'User Policy update has completed successfully.'){
                                Write-Host '║ ' -NoNewline
                                Write-Host '[+] User Policy updated' -ForegroundColor Green
                            }
                        }
                    }
                    x{}
                    default{
                        Write-Host '║ ' -NoNewline
                        Write-Host '[+] Invalid choice' -ForegroundColor Red
                    }
                }
                Write-Host '║'
            }
            catch{
                Show-Error
            }
            Divider
        }
    }
}