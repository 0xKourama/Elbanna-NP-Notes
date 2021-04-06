#Exchange Audit Logs

#Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
$logs=Search-AdminAuditLog -StartDate (Get-Date).AddDays(-1) | Sort Caller | Select Caller, OriginatingServer, CmdletName, CmdletParameters, ObjectModified

$smtpsettings = @{
	To =  "pghobrial@roaya.co", "mtawfik@roaya.co" #, "mothman@roaya.co"
	From = "ExchangeMonitor@Roaya.co"
	Subject = "Exchange Audit Logs"
	SmtpServer = "localhost"
}
$reportime = Get-Date

$Header = "
		<style>
		TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
		TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;}
		TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
		</style>
		<h2 align=""center"">Exchange Audit Logs</h3>
		<h4 align=""center"">Generated On $((Get-Date))</h5>
		"

$htmlhead="<html>
                <style>
                BODY{font-family: Arial; font-size: 8pt;}
                H1{font-size: 16px;}
                H2{font-size: 14px;}
                H3{font-size: 12px;}
                TABLE{border: 1px solid black; border-collapse: collapse; font-size: 8pt;}
                TH{border: 1px solid black; background: #dddddd; padding: 5px; color: #000000;}
                TD{border: 1px solid black; padding: 5px; }
                td.pass{background: #7FFF00;}
                td.warn{background: #FFE600;}
                td.fail{background: #FF0000; color: #ffffff;}
                td.info{background: #85D4FF;}
                </style>
                <body>
                <h1 align=""center"">Exchange Audit Logs</h1>
                <h3 align=""center"">Generated: $reportime</h3>"

$htmltableheader = "    <p>
                        <table>
                        <tr>
                        <th>Caller</th>
                        <th>OriginatingServer</th>
                        <th>CmdletName</th>
                        <th>CmdletParameters</th>
                        <th>ObjectModified</th>
                        </tr>"

$exchangeserverreporthtmltable = $htmlhead + $htmltableheader 

Foreach ($log in $logs){

    $htmltablerow = "<tr>"
    $htmltablerow += "<td class=""pass"">$($log.Caller)</td>"
    $htmltablerow += "<td class=""pass"">$($log.OriginatingServer)</td>"
    if (
        $log.CmdletName -like "*Delete*" -OR `
        $log.CmdletName -like "*Disable*" -OR `
        $log.CmdletName -like "*Remove*"
    ){
        $htmltablerow += "<td class=""fail"">$($log.CmdletName)</td>"
    }
	else{
        $htmltablerow += "<td class=""pass"">$($log.CmdletName)</td>"
    }
										
    if (
        $log.CmdletParameters -like "*Delete*" -OR `
        $log.CmdletParameters -like "*Disable*" -OR `
        $log.CmdletParameters -like "*Remove*"
    ){
        $htmltablerow += "<td class=""fail"">$($log.CmdletParameters)</td>"
    }
	else{
        $htmltablerow += "<td class=""pass"">$($log.CmdletParameters)</td>"
    }
										
    $htmltablerow += "<td class=""pass"">$($log.ObjectModified)</td>"
    $exchangeserverreporthtmltable = $exchangeserverreporthtmltable + $htmltablerow
}

$exchangeserverreporthtmltable = $exchangeserverreporthtmltable + "</table></p>"

$htmltail = "</body>
			</html>"

$exchangeserverreporthtmltable = $exchangeserverreporthtmltable + $htmltail

Send-MailMessage @smtpsettings -Body ($exchangeserverreporthtmltable) -BodyAsHtml -Encoding ([System.Text.Encoding]::UTF8)