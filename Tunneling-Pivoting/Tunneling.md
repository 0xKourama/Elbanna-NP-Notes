# using `Netsh` (requires administrator privileges)
```shell
netsh interface portproxy add v4tov4 listenaddress=10.10.10.240 listenport=9000 connectaddress=127.0.0.1 connectport=5985
```