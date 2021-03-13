Set-Alias -Name w -Value 'Write-Host'
Switch(Get-Random 3){
	0{
		$type  = 'Cmdlet'
		$color = 'DarkBlue'
	}
	1{
		$type = 'Function'
		$color = 'DarkMagenta'
	}
	2{
		$type = 'Application'
		$color = 'DarkGreen'
	}
}
Write-Host "Hello, $env:USERNAME. Here's a random $type`: " -NoNewLine
$Result = Get-Command -CommandType $type
Write-Host $Result[$(Get-Random $Result.Count)].Name -ForeGroundColor $color
Remove-Variable Result
Write-Host
function Prompt{
	$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
	if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $true){
		$PROMPT = "#"
	}
	else{
		$PROMPT = ">"
	}
	"[$($env:USERNAME.ToUpper())] $(Get-Location)$PROMPT "
}
