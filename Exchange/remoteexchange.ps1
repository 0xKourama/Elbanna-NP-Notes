# Copyright (c) Microsoft Corporation. All rights reserved.  

#load hashtable of localized string
Import-LocalizedData -BindingVariable RemoteExchange_LocalizedStrings -FileName RemoteExchange.strings.psd1

#Increase Powershell function limit
$MaximumFunctionCount = 32768

## INCREASE WINDOW WIDTH #####################################################
function WidenWindow([int]$preferredWidth)
{
  [int]$maxAllowedWindowWidth = $host.ui.rawui.MaxPhysicalWindowSize.Width
  if ($preferredWidth -lt $maxAllowedWindowWidth)
  {
    # first, buffer size has to be set to windowsize or more
    # this operation does not usually fail
    $current=$host.ui.rawui.BufferSize
    $bufferWidth = $current.width
    if ($bufferWidth -lt $preferredWidth)
    {
      $current.width=$preferredWidth
      $host.ui.rawui.BufferSize=$current
    }
    # else not setting BufferSize as it is already larger
    
    # setting window size. As we are well within max limit, it won't throw exception.
    $current=$host.ui.rawui.WindowSize
    if ($current.width -lt $preferredWidth)
    {
      $current.width=$preferredWidth
      $host.ui.rawui.WindowSize=$current
    }
    #else not setting WindowSize as it is already larger
  }
}

WidenWindow(120)

## ALIASES ###################################################################

set-alias list       format-list 
set-alias table      format-table 

## Confirmation is enabled by default, uncommenting next line will disable it 
# $ConfirmPreference = "None"

## EXCHANGE VARIABLEs ########################################################

$global:exbin = (get-itemproperty HKLM:\SOFTWARE\Microsoft\ExchangeServer\v15\Setup).MsiInstallPath + "bin\"
$global:exinstall = (get-itemproperty HKLM:\SOFTWARE\Microsoft\ExchangeServer\v15\Setup).MsiInstallPath
$global:exscripts = (get-itemproperty HKLM:\SOFTWARE\Microsoft\ExchangeServer\v15\Setup).MsiInstallPath + "scripts\"

## LOAD CONNECTION FUNCTIONS #################################################

# ConnectFunctions.ps1 uses some of the Exchange types. PowerShell does some type binding at the 
# time of loading the scripts, so we'd rather load the scripts before we reference those types.
"Microsoft.Exchange.Data.dll", "Microsoft.Exchange.Configuration.ObjectModel.dll" `
  | ForEach { [System.Reflection.Assembly]::LoadFrom((join-path $global:exbin $_)) } `
  | Out-Null

. $global:exbin"CommonConnectFunctions.ps1"
. $global:exbin"ConnectFunctions.ps1"

## LOAD EXCHANGE EXTENDED TYPE INFORMATION ###################################

$FormatEnumerationLimit = 16

# loads powershell types file, parses out just the type names and returns an array of string
# it skips all template types as template parameter types individually are defined in types file
function GetTypeListFromXmlFile( [string] $typeFileName ) 
{
	$xmldata = [xml](Get-Content $typeFileName)
	$returnList = $xmldata.Types.Type | where { (($_.Name.StartsWith("Microsoft.Exchange") -or $_.Name.StartsWith("Microsoft.Office.CompliancePolicy")) -and !$_.Name.Contains("[[")) } | foreach { $_.Name }
	return $returnList
}

# Check if every single type from from Exchange.Types.ps1xml can be successfully loaded
$typeFilePath = join-path $global:exbin "exchange.types.ps1xml"
$typeListToCheck = GetTypeListFromXmlFile $typeFilePath
# Load all management cmdlet related types.
$assemblyNames = [Microsoft.Exchange.Configuration.Tasks.CmdletAssemblyHelper]::ManagementCmdletAssemblyNames
$typeLoadResult = [Microsoft.Exchange.Configuration.Tasks.CmdletAssemblyHelper]::EnsureTargetTypesLoaded($assemblyNames, $typeListToCheck)
# $typeListToCheck is a big list, release it to free up some memory
$typeListToCheck = $null

$SupportPath = join-path $global:exbin "Microsoft.Exchange.Management.Powershell.Support.dll"
[Microsoft.Exchange.Configuration.Tasks.TaskHelper]::LoadExchangeAssemblyAndReferences($SupportPath) > $null

if (Get-ItemProperty HKLM:\Software\microsoft\ExchangeServer\v15\CentralAdmin -ea silentlycontinue)
{
    $CentralAdminPath = join-path $global:exbin "Microsoft.Exchange.Management.Powershell.CentralAdmin.dll"
    [Microsoft.Exchange.Configuration.Tasks.TaskHelper]::LoadExchangeAssemblyAndReferences($CentralAdminPath) > $null
}

if (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\PowerShell\1\PowerShellSnapins\Microsoft.Exchange.Management.AntiSpamTasks -ea silentlycontinue)
{
    $AntiSpamTasksPath = join-path $global:exbin "Microsoft.Exchange.Management.AntiSpamTasks.dll"
    [Microsoft.Exchange.Configuration.Tasks.TaskHelper]::LoadExchangeAssemblyAndReferences($AntiSpamTasksPath) > $null
}

if (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\PowerShell\1\PowerShellSnapins\Microsoft.Exchange.Management.PeopleICommunicateWith -ea silentlycontinue)
{
    $picwTasksPath = join-path $global:exbin "Microsoft.Exchange.Management.PeopleICommunicateWith.dll"
    [Microsoft.Exchange.Configuration.Tasks.TaskHelper]::LoadExchangeAssemblyAndReferences($picwTasksPath) > $null
}

if (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\PowerShell\1\PowerShellSnapins\Microsoft.Exchange.Management.People -ea silentlycontinue)
{
    $peopleTasksPath = join-path $global:exbin "Microsoft.Exchange.Management.People.dll"
    [Microsoft.Exchange.Configuration.Tasks.TaskHelper]::LoadExchangeAssemblyAndReferences($peopleTasksPath) > $null
}

if (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\PowerShell\1\PowerShellSnapins\Microsoft.Exchange.Management.Xrm -ea silentlycontinue)
{
    $xrmTasksPath = join-path $global:exbin "Microsoft.Exchange.Management.Xrm.dll"
    [Microsoft.Exchange.Configuration.Tasks.TaskHelper]::LoadExchangeAssemblyAndReferences($xrmTasksPath) > $null
}

# Register Assembly Resolver to handle generic types
[Microsoft.Exchange.Data.SerializationTypeConverter]::RegisterAssemblyResolver()

# Finally, load the types information
# We will load type information only if every single type from Exchange.Types.ps1xml can be successfully loaded
if ($typeLoadResult)
{
	Update-TypeData -PrependPath $typeFilePath
}
else
{
	write-error $RemoteExchange_LocalizedStrings.res_types_file_not_loaded
}

#load partial types
$partialTypeFile = join-path $global:exbin "Exchange.partial.Types.ps1xml"
Update-TypeData -PrependPath $partialTypeFile 

# If Central Admin cmdlets are installed, it loads the types information for those too
if (Get-ItemProperty HKLM:\Software\microsoft\ExchangeServer\v15\CentralAdmin -ea silentlycontinue)
{
	$typeFile = join-path $global:exbin "Exchange.CentralAdmin.Types.ps1xml"
	Update-TypeData -PrependPath $typeFile
}

# Loads FFO-specific type and formatting xml files.
$ffoTypeData = join-path $global:exbin "Microsoft.Forefront.Management.Powershell.types.ps1xml"
$ffoFormatData = join-path $global:exbin "Microsoft.Forefront.Management.Powershell.format.ps1xml"

if ((Test-Path $ffoTypeData) -and (Test-Path $ffoFormatData))
{
    Update-TypeData -PrependPath $ffoTypeData
    Update-FormatData -PrependPath $ffoFormatData
}

## FUNCTIONs #################################################################

## returns all defined functions 

function functions
{ 
    if ( $args ) 
    { 
        foreach($functionName in $args )
        {
             get-childitem function:$functionName | 
                  foreach { "function " + $_.Name; "{" ; $_.Definition; "}" }
        }
    } 
    else 
    { 
        get-childitem function: | 
             foreach { "function " + $_.Name; "{" ; $_.Definition; "}" }
    } 
}

## only returns exchange commands 

function get-excommand
{
	if ($args[0] -eq $null)
	{
		get-command -module $global:importResults
	}
	else
	{
		get-command $args[0] | where { $_.module -eq $global:importResults }
	}
}


## only returns PowerShell commands 

function get-pscommand
{
	if ($args[0] -eq $null) 
	{
		get-command -pssnapin Microsoft.PowerShell* 
	}
	else 
	{
		get-command $args[0] | where { $_.PsSnapin -ilike 'Microsoft.PowerShell*' }	
	}
}

## prints the Exchange Banner in pretty colors 

function get-exbanner
{
	write-host $RemoteExchange_LocalizedStrings.res_welcome_message

	write-host -no $RemoteExchange_LocalizedStrings.res_full_list
	write-host -no " "
	write-host -fore Yellow $RemoteExchange_LocalizedStrings.res_0003

	write-host -no $RemoteExchange_LocalizedStrings.res_only_exchange_cmdlets
	write-host -no " "
	write-host -fore Yellow $RemoteExchange_LocalizedStrings.res_0005

	write-host -no $RemoteExchange_LocalizedStrings.res_cmdlets_specific_role
	write-host -no " "
	write-host -fore Yellow $RemoteExchange_LocalizedStrings.res_0007

	write-host -no $RemoteExchange_LocalizedStrings.res_general_help
	write-host -no " "
	write-host -fore Yellow $RemoteExchange_LocalizedStrings.res_0009

	write-host -no $RemoteExchange_LocalizedStrings.res_help_for_cmdlet
	write-host -no " "
	write-host -fore Yellow $RemoteExchange_LocalizedStrings.res_0011

	write-host -no $RemoteExchange_LocalizedStrings.res_team_blog
	write-host -no " "
	write-host -fore Yellow $RemoteExchange_LocalizedStrings.res_0015

	write-host -no $RemoteExchange_LocalizedStrings.res_show_full_output
	write-host -no " "
	write-host -fore Yellow $RemoteExchange_LocalizedStrings.res_0017

	write-host -no $RemoteExchange_LocalizedStrings.res_updatable_help
	write-host -no " "
	write-host -fore Yellow $RemoteExchange_LocalizedStrings.res_0018
}

## shows quickref guide

function quickref
{
     # This isn't vulnerable to PowerShell injection or isn't interesting to exploit. Justification: Suppress existing rule violation.
     invoke-expression 'cmd /c start http://go.microsoft.com/fwlink/p/?LinkId=259608'
}

function get-exblog
{
       # This isn't vulnerable to PowerShell injection or isn't interesting to exploit. Justification: Suppress existing rule violation.
       invoke-expression 'cmd /c start http://go.microsoft.com/fwlink/?LinkId=35786'
}

## FILTERS #################################################################
## Assembles a message and writes it to file from many sequential BinaryFileDataObject instances 
Filter AssembleMessage ([String] $Path) { Add-Content -Path:"$Path" -Encoding:"Byte" -Value:$_.FileData }

## now actually call the functions 

get-exbanner 
get-tip 

#
# TIP: You can create your own customizations and put them in My Documents\WindowsPowerShell\profile.ps1
# Anything in profile.ps1 will then be run every time you start the shell. 
#


# SIG # Begin signature block
# MIIjlgYJKoZIhvcNAQcCoIIjhzCCI4MCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCJAHUy6VDoAGCS
# qDdsXeulhAQN+rpJ8DD+Ap0ZBM81jKCCDYUwggYDMIID66ADAgECAhMzAAAB4HFz
# JMpcmPgZAAAAAAHgMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjAxMjE1MjEzMTQ2WhcNMjExMjAyMjEzMTQ2WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDRXpc9eiGRI/2BlmU7OMiQPTKpNlluodjT2rltPO/Gk47bH4gBShPMD4BX/4sg
# NvvBun6ZOG2dxUW30myWoUJJ0iRbTAv2JFzjSpVQvPE+D5vtmdu6WlOR2ahF4leF
# 5Vvk4lPg2ZFrqg5LNwT9gjwuYgmih+G2KwT8NMWusBhO649F4Ku6B6QgA+vZld5S
# G2XWIdvS0pmpmn/HFrV4eYTsl9HYgjn/bPsAlfWolLlEXYTaCljK7q7bQHDBrzlR
# ukyyryFpPOR9Wx1cxFJ6KBqg2jlJpzxjN3udNJPOqarnQIVgB8DUm3I5g2v5xTHK
# Ovz9ucN21467cYcIxjPC4UkDAgMBAAGjggGCMIIBfjAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUVBWIZHrG4UIX3uX4142l+8GsPXAw
# VAYDVR0RBE0wS6RJMEcxLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJh
# dGlvbnMgTGltaXRlZDEWMBQGA1UEBRMNMjMwMDEyKzQ2MzAxMDAfBgNVHSMEGDAW
# gBRIbmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDEx
# XzIwMTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIB
# AE5msNzmYzYbNgpnhya6YsrM+CIC8CXDu10nwzZtkgQciPOOqAYmFcWJCwD5VZzs
# qFwad8XIOrfCylWf4hzn09mD87yuazpuCstLSqfDLNd3740+254vEZqdGxOglAGU
# ih2IiF8S0GDwucpLGzt/OLXPFr/d4MWxPuX0L+HB5lA3Y/CJE673dHGQW2DELdqt
# ohtkhp+oWFn1hNDDZ3LP++HEZvA7sI/o/981Sh4kaGayOp6oEiQuGeCXyfrIC9KX
# eew0UlYX/NHVDqr4ykKkqpHtzbUbuo7qovUHPbYKcRGWrrEtBS5SPLFPumqsRtzb
# LgU9HqfRAN36bMsd2qynGyWBVFOM7NMs2lTCGM85Z/Fdzv/8tnYT36Cmbue+IM+6
# kS86j6Ztmx0VIFWbOvNsASPT6yrmYiecJiP6H0TrYXQK5B3jE8s53l+t61ab0Eul
# 7DAxNWX3lAiUlzKs3qZYQEK1LFvgbdTXtBRnHgBdABALK3RPrieIYqPln9sAmg3/
# zJZi4C/c2cWGF6WwK/w1Nzw08pj7jaaZZVBpCeDe+y7oM26QIXxracot7zJ21/TL
# 70biK36YybSUDkjhQPP/uxT0yebLNBKk7g8V98Wna2MsHWwk0sgqpkjIp02TrkVz
# 26tcF2rml2THRSDrwpBa4x9c8rM8Qomiyeh2tEJnsx2LMIIHejCCBWKgAwIBAgIK
# YQ6Q0gAAAAAAAzANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlm
# aWNhdGUgQXV0aG9yaXR5IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEw
# OTA5WjB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYD
# VQQDEx9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+la
# UKq4BjgaBEm6f8MMHt03a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc
# 6Whe0t+bU7IKLMOv2akrrnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4D
# dato88tt8zpcoRb0RrrgOGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+
# lD3v++MrWhAfTVYoonpy4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nk
# kDstrjNYxbc+/jLTswM9sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6
# A4aN91/w0FK/jJSHvMAhdCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmd
# X4jiJV3TIUs+UsS1Vz8kA/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL
# 5zmhD+kjSbwYuER8ReTBw3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zd
# sGbiwZeBe+3W7UvnSSmnEyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3
# T8HhhUSJxAlMxdSlQy90lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS
# 4NaIjAsCAwEAAaOCAe0wggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRI
# bmTlUAXTgqoXNzcitW2oynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAL
# BgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBD
# uRQFTuHqp8cx0SOJNDBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jv
# c29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3JsMF4GCCsGAQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3J0MIGfBgNVHSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEF
# BQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1h
# cnljcHMuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkA
# YwB5AF8AcwB0AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn
# 8oalmOBUeRou09h0ZyKbC5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7
# v0epo/Np22O/IjWll11lhJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0b
# pdS1HXeUOeLpZMlEPXh6I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/
# KmtYSWMfCWluWpiW5IP0wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvy
# CInWH8MyGOLwxS3OW560STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBp
# mLJZiWhub6e3dMNABQamASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJi
# hsMdYzaXht/a8/jyFqGaJ+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYb
# BL7fQccOKO7eZS/sl/ahXJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbS
# oqKfenoi+kiVH6v7RyOA9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sL
# gOppO6/8MO0ETI7f33VtY5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtX
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCFWcwghVjAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAAHgcXMkylyY+BkAAAAA
# AeAwDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIIFi
# j5mgR6cnQdorwOB9NHY2rvgA8ewD3EDeJ3kogBYQMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAJA8PDgLPaeB5U4q1MefXfl+7KSA8k+bDGCg9
# xTE6/P/Hedviy21jTAsZYwnUndzDT3A51APeiHPE/w/+GQmxvcn/YKyc0ZLmsa5h
# vU076FkO8ZRkO7GocKceUnJ3g6MSPq1NDccRW2Z782CZwLSHX3mF/Ww8YMXBhqKq
# A8ORIsUxyLjjYPZWdR0mJ46+RuHfi3ffXviYhqVGXtTQbMqbskb6d366hYiG1zCy
# r7Ud0QVdzv247unLTI4UbX6OL2l168mZZ7785sw455KMExeQBdFb+hfY5mZdUt+3
# OgfWFOiDRqYuJhKWlAlYV/2lYpC0Z6GCSu9vJ1FRpj5Yit/OJaGCEvEwghLtBgor
# BgEEAYI3AwMBMYIS3TCCEtkGCSqGSIb3DQEHAqCCEsowghLGAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFVBgsqhkiG9w0BCRABBKCCAUQEggFAMIIBPAIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCCgv/VEFPTN6D5O3/Crp57/+be0UjkWqX+U
# nBxfbuHHwQIGYGMqihS0GBMyMDIxMDQwNDIxMDg0NC4yMzZaMASAAgH0oIHUpIHR
# MIHOMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSkwJwYDVQQL
# EyBNaWNyb3NvZnQgT3BlcmF0aW9ucyBQdWVydG8gUmljbzEmMCQGA1UECxMdVGhh
# bGVzIFRTUyBFU046QzRCRC1FMzdGLTVGRkMxJTAjBgNVBAMTHE1pY3Jvc29mdCBU
# aW1lLVN0YW1wIFNlcnZpY2Wggg5EMIIE9TCCA92gAwIBAgITMwAAAVdEB2Lcb+i+
# KgAAAAABVzANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0Eg
# MjAxMDAeFw0yMTAxMTQxOTAyMTNaFw0yMjA0MTExOTAyMTNaMIHOMQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSkwJwYDVQQLEyBNaWNyb3NvZnQg
# T3BlcmF0aW9ucyBQdWVydG8gUmljbzEmMCQGA1UECxMdVGhhbGVzIFRTUyBFU046
# QzRCRC1FMzdGLTVGRkMxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNl
# cnZpY2UwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDebQOnVGb558C/
# akLV3MDwDYQeHs/uQkK3j6f2fEx+DQa+bwHxjKNJVf5YnQWrSk4BxKzrih9dcVQH
# wXoRybx/U/zoTnPNwibPW8w4a5XdCXct3icgtMgXcVXrnEvtmtmQXedMAYP+f9mI
# 0NspXw9HcSiurUC8XTg07mnUDG3WtOZTxp1hsGd54koCClUYKqglZYR88DbUYdQB
# /mcW30nu7fM96BCgHUwMu0rD/MpIbd7K43YdAcpDxXaWgIKsFgiSSZhpNIAK0rxw
# vPr17RqNzCYVkEXuSbc3Q+ZHWih/bnPYJ0obF8gxIRmY8d/m/HLqhDvGx79Fj1/T
# ERH638b5AgMBAAGjggEbMIIBFzAdBgNVHQ4EFgQUXTF7u+g4IZ1P5D0zCnRZEfaA
# qdkwHwYDVR0jBBgwFoAU1WM6XIoxkPNDe3xGG8UzaFqFbVUwVgYDVR0fBE8wTTBL
# oEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMv
# TWljVGltU3RhUENBXzIwMTAtMDctMDEuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggr
# BgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNU
# aW1TdGFQQ0FfMjAxMC0wNy0wMS5jcnQwDAYDVR0TAQH/BAIwADATBgNVHSUEDDAK
# BggrBgEFBQcDCDANBgkqhkiG9w0BAQsFAAOCAQEAJXd5AIBul1omcr3Ymy0Zlq+8
# m+kUsnI1Q4PLXAorUtNbE1aeE/AHdkHmHyVnyugzBJO0EQXyoHTe6BPHV7ZkFS/i
# XMS49KVLsuDQeUXIXLXg+XUZ03ypUYvL4ClGsQ3KBSMzRFM9RB6aKXmoA2+P7iPV
# I+bSLsJYpP6q7/7BwMO5DOIBCyzToHXr/Wf+8aNSSMH3tHqEDN8MXAhS7n/EvTp3
# LbWhQFh7RBEfCL4EQICyf1p5bhc+vPoaw30cl/6qlkjyBNL6BOqhcdc/FLy8CqZu
# uUDcjQ0TKf1ZgqakWa8QdaNEWOz/p+I0jRr25Nm0e9JCrf3aIBRUQR1VblMX/jCC
# BnEwggRZoAMCAQICCmEJgSoAAAAAAAIwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNV
# BAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4w
# HAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29m
# dCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eSAyMDEwMB4XDTEwMDcwMTIxMzY1
# NVoXDTI1MDcwMTIxNDY1NVowfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAw
# ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCpHQ28dxGKOiDs/BOX9fp/
# aZRrdFQQ1aUKAIKF++18aEssX8XD5WHCdrc+Zitb8BVTJwQxH0EbGpUdzgkTjnxh
# MFmxMEQP8WCIhFRDDNdNuDgIs0Ldk6zWczBXJoKjRQ3Q6vVHgc2/JGAyWGBG8lhH
# hjKEHnRhZ5FfgVSxz5NMksHEpl3RYRNuKMYa+YaAu99h/EbBJx0kZxJyGiGKr0tk
# iVBisV39dx898Fd1rL2KQk1AUdEPnAY+Z3/1ZsADlkR+79BL/W7lmsqxqPJ6Kgox
# 8NpOBpG2iAg16HgcsOmZzTznL0S6p/TcZL2kAcEgCZN4zfy8wMlEXV4WnAEFTyJN
# AgMBAAGjggHmMIIB4jAQBgkrBgEEAYI3FQEEAwIBADAdBgNVHQ4EFgQU1WM6XIox
# kPNDe3xGG8UzaFqFbVUwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0P
# BAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZWy4/oolxiaNE9
# lJBb186aGMQwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQu
# Y29tL3BraS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3Js
# MFoGCCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3Nv
# ZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcnQwgaAG
# A1UdIAEB/wSBlTCBkjCBjwYJKwYBBAGCNy4DMIGBMD0GCCsGAQUFBwIBFjFodHRw
# Oi8vd3d3Lm1pY3Jvc29mdC5jb20vUEtJL2RvY3MvQ1BTL2RlZmF1bHQuaHRtMEAG
# CCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAFAAbwBsAGkAYwB5AF8AUwB0AGEA
# dABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQAH5ohRDeLG4Jg/gXED
# PZ2joSFvs+umzPUxvs8F4qn++ldtGTCzwsVmyWrf9efweL3HqJ4l4/m87WtUVwgr
# UYJEEvu5U4zM9GASinbMQEBBm9xcF/9c+V4XNZgkVkt070IQyK+/f8Z/8jd9Wj8c
# 8pl5SpFSAK84Dxf1L3mBZdmptWvkx872ynoAb0swRCQiPM/tA6WWj1kpvLb9BOFw
# nzJKJ/1Vry/+tuWOM7tiX5rbV0Dp8c6ZZpCM/2pif93FSguRJuI57BlKcWOdeyFt
# w5yjojz6f32WapB4pm3S4Zz5Hfw42JT0xqUKloakvZ4argRCg7i1gJsiOCC1JeVk
# 7Pf0v35jWSUPei45V3aicaoGig+JFrphpxHLmtgOR5qAxdDNp9DvfYPw4TtxCd9d
# dJgiCGHasFAeb73x4QDf5zEHpJM692VHeOj4qEir995yfmFrb3epgcunCaw5u+zG
# y9iCtHLNHfS4hQEegPsbiSpUObJb2sgNVZl6h3M7COaYLeqN4DMuEin1wC9UJyH3
# yKxO2ii4sanblrKnQqLJzxlBTeCG+SqaoxFmMNO7dDJL32N79ZmKLxvHIa9Zta7c
# RDyXUHHXodLFVeNp3lfB0d4wwP3M5k37Db9dT+mdHhk4L7zPWAUu7w2gUDXa7wkn
# HNWzfjUeCLraNtvTX4/edIhJEqGCAtIwggI7AgEBMIH8oYHUpIHRMIHOMQswCQYD
# VQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEe
# MBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSkwJwYDVQQLEyBNaWNyb3Nv
# ZnQgT3BlcmF0aW9ucyBQdWVydG8gUmljbzEmMCQGA1UECxMdVGhhbGVzIFRTUyBF
# U046QzRCRC1FMzdGLTVGRkMxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFNlcnZpY2WiIwoBATAHBgUrDgMCGgMVABEt+Eliew320hv4GyEME684GfDyoIGD
# MIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
# BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQG
# A1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwDQYJKoZIhvcNAQEF
# BQACBQDkFEBYMCIYDzIwMjEwNDA0MTc0MDQwWhgPMjAyMTA0MDUxNzQwNDBaMHcw
# PQYKKwYBBAGEWQoEATEvMC0wCgIFAOQUQFgCAQAwCgIBAAICHx0CAf8wBwIBAAIC
# EVwwCgIFAOQVkdgCAQAwNgYKKwYBBAGEWQoEAjEoMCYwDAYKKwYBBAGEWQoDAqAK
# MAgCAQACAwehIKEKMAgCAQACAwGGoDANBgkqhkiG9w0BAQUFAAOBgQBkktXrEaaz
# HPCCGec3+egzYMx3qJs9TMxYqfon/chQq7lqoOLyxYH7drDSDszWIfDZuJHneli0
# qTZVWmcWcjmOt9nHbJn1hIY42n/5jDudxEOFGo2GxfBeU2VZLkxBNcdIm/0xDrQF
# RIQe1BdoV1gi2OUHzM6y+vIh2Xm6Vru2/DGCAw0wggMJAgEBMIGTMHwxCzAJBgNV
# BAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4w
# HAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29m
# dCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAABV0QHYtxv6L4qAAAAAAFXMA0GCWCG
# SAFlAwQCAQUAoIIBSjAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQwLwYJKoZI
# hvcNAQkEMSIEIH4Vfnkzv+hQdRt7CJKucHFEejfoJVOpeqBxJn6Hq/kwMIH6Bgsq
# hkiG9w0BCRACLzGB6jCB5zCB5DCBvQQgLFqNDUOr87rrqVLGRDEieFLEY7UMNnRc
# WVpB7akcoBMwgZgwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAIT
# MwAAAVdEB2Lcb+i+KgAAAAABVzAiBCDpxbQRjzR/mRb8Na8p2dxpBIP7S8PlTFT4
# xCYVMtrETjANBgkqhkiG9w0BAQsFAASCAQAc/BnmSkUBGJp4gBIpQ5TVPTtQ5aeB
# MSkZWZSXT1F4WYlbAeMjdZGCCT4RlEvcbSh2XG90ghTYXKAfvsfzg+ToDlBYIS5S
# JNu1WRfq+VHiLLnFBbMCAInQY+oo+Z4kbIHhcSdicnBgn037wbdrYWiGZWXNLP7g
# wAMvzH05KrI+ohilxnAvcHHxb3MAlXSD1KwhRxp4Eg25CW15w1IUVvnYcTUnEBTH
# 4hWKT+KstJLkd09EBvwWINdSVqeMuEWfrdOBIpDWyQZ1ve5dReKaFZ4E2Bp4DxS8
# HDeEeZkSh7tCOIofaW1gtlFtbqUEFRoU2T5fjxIk/DO/IvFo0KiG/2hO
# SIG # End signature block
