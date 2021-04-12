$Params = @{
    "All"           = $true
    "Server"        = 'Frank-PDC'
    "NamingContext" = 'dc=roaya,dc=loc'
}
get-ADReplAccount @Params | Test-PasswordQuality -WeakPasswordsFile .\weakpasswords.txt -IncludeDisabledAccounts > PasswordQualityReport.txt