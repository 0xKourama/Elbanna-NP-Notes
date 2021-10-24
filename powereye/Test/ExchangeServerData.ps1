# Exchange build numbers
# https://docs.microsoft.com/en-us/exchange/new-features/build-numbers-and-release-dates?view=exchserver-2019

$Body = @"
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
    padding: 3px;
    background-color: #210b9e;
    text-align: Center;
    border: 2px solid black;
}
</style>
<h3>Exchange Environment Report</h3>
$(Get-ExchangeServer | Select-Object name,
        @{
            n='IPAddress'
            e={
                (Resolve-DnsName -Name $_.name | ? {$_.Type -eq 'A'} | Select-Object -Expand IPAddress) -Join ' - '
            }
        },
        ##########################################################################
       @{
            n='ServerVersion'
            e={
                if($_.admindisplayversion.Minor -eq 0){
                    "Exchange Server 2013"
                }
                elseif($_.admindisplayversion.Minor -eq 2){
                    "Exchange Server 2019"
                }
            }
        },
        ##########################################################################
        edition,
        ##########################################################################
        @{
            n='Role'
            e={
                if($_.serverrole -like 'None'){
                    'CAS'
                }
                else{
                    $_.serverrole
                }
            }
        },
        ##########################################################################
        @{
            n='CU'
            e={
                $item = $_.admindisplayversion.build
                (Import-Csv .\Exch-Server-Version-Data.csv | Where-Object {$_.buildnumber -eq $item} | select -expand softwareversion)[0]
            }
        } |
        ConvertTo-Html -Fragment | Out-String)
"@
Send-MailMessage -Subject 'test env report' -From 'testttt@roaya.co' -To mgabr@roaya.co -SmtpServer 192.168.2.1 -BodyAsHtml $body