# install ntp client package
`apt install ntpdate`

# disable `timesyncd` service
`timedatectl set-ntp off`

# synchronize with the target server
`ntpdate <SERVER_IP>`

# using `rdate`
`apt-get -y install rdate`
`rdate -n <DC_IP>`