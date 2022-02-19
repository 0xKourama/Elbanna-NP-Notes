# 1. update and ugprade
`apt update && apt upgrade -y`

# 2. install the necessary packages
`apt install xrdp lxde-core lxde kali-defaults kali-root-login desktop-base -y`

# 3. start and enable the necessary services
`service xrdp start && service xrdp-sesman start && update-rc.d xrdp enable`

# 4. change the window manager
`update-alternatives --config x-session-manager`
*Choose /usr/bin/startlxde*

# 5. resart the machine
`reboot`

# BONUS: Script
```
apt update && apt upgrade -y;\
apt install xrdp lxde-core lxde kali-defaults kali-root-login desktop-base -y;\
service xrdp start && service xrdp-sesman start && update-rc.d xrdp enable;\
update-alternatives --config x-session-manager
```