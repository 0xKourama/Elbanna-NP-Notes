Param($IP)
$API_key = '18c878690f2c8c081485c10abb136019d470158631d0eced7bb8269b432db49e'
Invoke-WebRequest "https://www.virustotal.com/vtapi/v2/ip-address/report?apikey=$API_key&ip=$IP" | ConvertFrom-Json | Select-Object -ExpandProperty detected_urls