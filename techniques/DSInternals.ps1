#DSInternals
install-module DSInternals -Force
Import-module DSInternals

$Params = @{
    "All" = $true
    "Server" = 'Frank-PDC'
    "NamingContext" = 'dc=roaya,dc=loc'
}

get-ADReplAccount @Params | Test-PasswordQuality -WeakPasswordsFile  -IncludeDisabledAccounts