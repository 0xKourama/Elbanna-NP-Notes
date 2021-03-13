Clear-Host
Write-Host "Welcome, $env:USERNAME. Happy scripting :)`n" -ForeGroundColor Green
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
