$old_pwd = $pwd
Set-Location ~\PowerShell
git add .; git status;pause; git commit -m '+1'; git push
Set-Location $old_pwd