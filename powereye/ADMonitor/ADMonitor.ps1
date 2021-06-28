Param([int]$Timeout)

Invoke-Expression -Command (Get-Content -Path 'Mail-Settings.txt' -Raw)
Invoke-Expression -Command (Get-Content -Path 'HTML-Layout.txt'   -Raw)

$Script = {
    #supress errors, only error is when there are no logs matching the criteria
    $ErrorActionPreference = 'SilentlyContinue'

    Class Event{
        [Int]$ID
        [String]$Title
    }

    $EventList = @(
		[Event]@{ID=4720; Title='User created'}
        [Event]@{ID=4726; Title='User deleted'}
        [Event]@{ID=4722; Title='User enabled'}
        [Event]@{ID=4725; Title='User disabled'}
        [Event]@{ID=4723; Title='User changed his own password'}
        [Event]@{ID=4724; Title='An administrator changed a user password'}
        [Event]@{ID=4738; Title='User changed'}
        [Event]@{ID=4740; Title='User locked out'}
        [Event]@{ID=4767; Title='User unlocked'}
        [Event]@{ID=4781; Title='User name changed'}

        [Event]@{ID=4741; Title='Computer account created'}
        [Event]@{ID=4742; Title='Computer account changed'}
        [Event]@{ID=4743; Title='Computer account was deleted'}

        [Event]@{ID=4764; Title='A Group type was changed'}

        [Event]@{ID=4731; Title='Local sec group created'}
        [Event]@{ID=4735; Title='Local sec group changed'}
        [Event]@{ID=4734; Title='Local sec group deleted'}
        [Event]@{ID=4732; Title='Local sec group member added'}
        [Event]@{ID=4733; Title='Local sec group member removed'}

        [Event]@{ID=4727; Title='Global sec group created'}
        [Event]@{ID=4737; Title='Global sec group changed'}
        [Event]@{ID=4730; Title='Global sec group deleted'}
        [Event]@{ID=4728; Title='Global sec group member added'}
        [Event]@{ID=4729; Title='Global sec group member removed'}

        [Event]@{ID=4754; Title='Universal sec group created'}
        [Event]@{ID=4755; Title='Universal sec group changed'}
        [Event]@{ID=4758; Title='Universal sec group deleted'}
        [Event]@{ID=4756; Title='Universal sec group member added'}
        [Event]@{ID=4757; Title='Universal sec group member removed'}

        [Event]@{ID=4744; Title='Local distribution group created'}
        [Event]@{ID=4745; Title='Local distribution group changed'}
        [Event]@{ID=4748; Title='Local distribution group deleted'}
        [Event]@{ID=4746; Title='Local distribution group member added'}
        [Event]@{ID=4747; Title='Local distribution group member removed'}

        [Event]@{ID=4749; Title='Global distribution group created'}
        [Event]@{ID=4750; Title='Global distribution group changed'}
        [Event]@{ID=4753; Title='Global distribution group deleted'}
        [Event]@{ID=4751; Title='Global distribution group member added'}
        [Event]@{ID=4752; Title='Global distribution group member removed'}

        [Event]@{ID=4759; Title='Universal distribution group created'}
        [Event]@{ID=4760; Title='Universal distribution group changed'}
        [Event]@{ID=4763; Title='Universal distribution group deleted'}
        [Event]@{ID=4761; Title='Universal distribution group member added'}
        [Event]@{ID=4762; Title='Universal distribution group member removed'}

        [Event]@{ID=5137; Title='ADobject Created'}
        [Event]@{ID=5136; Title='ADObject Modified'}
        [Event]@{ID=5139; Title='ADObject Moved'}
        [Event]@{ID=5141; Title='ADObject deleted'}
        [Event]@{ID=5138; Title='ADObject Undeleted'}

        [Event]@{ID=4794; Title='Attempt to set DSRM Administrator password'}

        [Event]@{ID=5376; Title='Credential Manager credentials backed up'}
        [Event]@{ID=5377; Title='Credential Manager credentials restored from backedup'}
    )

    $Results = @()

    foreach($Event in $EventList){
        $XML_Path = "C:\Users\Public\ADMon_Event_$($Event.ID)`_LastCheck.xml"
        #region if the date of last query is found, we query events from that point forward, otherwise, we query all events
        #if(!(Test-Path -Path $XML_Path)){
            $CollectedEvents = Get-WinEvent -FilterHashtable @{LogName = 'Security'; ID = $Event.ID} |
                               Select-Object -Property Message, TimeCreated -First 5
        <#}
        else{
            $CollectedEvents = Get-WinEvent -FilterHashtable @{LogName = 'Security'; ID = $Event.ID; StartTime = Import-Clixml -Path $XML_Path} |
                               Select-Object -Property Message, TimeCreated
        }#>
        #update the tracker XML file
        #Get-Date | Export-Clixml -Path $XML_Path
        #endregion

        #region parse event messages into an object

        if($CollectedEvents){
            Foreach ($CollectedEvent in $CollectedEvents) {
                $Message = $_.Message -split '\n'
                $Results += [PSCustomObject][Ordered]@{
                    ComputerName  = $env:COMPUTERNAME
                    Title         = $Event.Title
                    TimeGenerated = $CollectedEvent.TimeCreated
                    Content       = $CollectedEvent.Message
                }
            }        
        }
        #endregion
    }

    Write-Output $Results
}

Import-Module '..\UtilityFunctions.ps1'

#testing connectivity for all domain computers
$Online = Return-ADOnlineComputers

#invoke the script over the remote computers
$Results = Invoke-Command -ComputerName $Online -ScriptBlock $Script |
          Select-Object -Property * -ExcludeProperty RunSpaceID, PSShowComputerName, PSComputerName |
          Sort-Object -Property TimeGenerated -Descending

if($Results){
    Write-Output "$(Get-Date) [!] AD Changes detected. Sending mail."
    Write-Output $Results

    $body = ""

    foreach($Result in $Results){
$body += @"
<h3>[$($Result.TimeGenerated)] $($Result.ComputerName): $($Result.Title)</h3>
$(($Result.Content) -split '\n' | ForEach-Object {(((($_ ) -split '\n') -replace "^\s+" | ? {$_ -ne ''}) -replace ':\s+',': ')}  |
ForEach-Object -Begin {'<ul>'} {if($_ -like '*:*'){ "<li><b>$($_ -replace ':',':</b>')</li>"}else{"<li><b>$_</b></li>"} } -End {'</ul>'} )
"@
    }

    Send-MailMessage @MailSettings -BodyAsHtml "$Style $body"
}
else{
    Write-Output "$(Get-Date) [*] No Security Event log clear(s) detected."
}