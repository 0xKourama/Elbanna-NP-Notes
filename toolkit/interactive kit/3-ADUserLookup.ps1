function Lookup-User{
    while($true){
        Display -Header "User Lookup" `
                -Footer "X to Return" `
                -OptionList @("Enter username")

        $wanted_user = $Host.UI.ReadLine()

        if($wanted_user -eq 'X'){break}
        $Property_list = @(
            "memberof"      ,
            "emailaddress"  ,
            "lastlogondate" ,
            "created"       ,
            "canonicalname" ,
            "employeeid"    ,
            "enabled"       ,
            "description"
        )
        try{
            $Result = Get-ADUser -Server $Domain                          `
                                 -Identity ($wanted_user.replace(" ","")) `
                                 -Properties $Property_list
           
            $output = [System.Collections.ArrayList]@()

            $output += 
            $output += "Location    : $(($result.canonicalname).replace('/',' > '))"
            $output += "Active      : $($result.enabled)"
            $output += "Description : $($result.description)"
            $output += "E-mail      : $($result.emailaddress)"
            $output += "HITS ID     : $($result.employeeid)"
            $output += "Date Joined : $($result.created)"
            $output += "Last Logon  : $($result.lastlogondate)"
            $output += "Member of   : $($Result.memberof | % {"[$(($_.split(',')[0] -replace ('CN=','')))]"})"

            Display -OptionList $output
        }
        catch{
            Display-Negative "Not found in $Domain domain"
        }
    }
}