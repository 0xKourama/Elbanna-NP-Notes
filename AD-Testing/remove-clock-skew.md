# install ntp client package
`apt install ntpdate`

# disable `timesyncd` service
`timedatectl set-ntp off`

# synchronize with the target server
`ntpdate <SERVER_IP>`

# using `rdate`
```bash
apt-get -y install rdate
rdate -n <DC_IP>
```

# or manually using `date`
`date -s "1 JAN 2000 18:00:00"`