## using `Netsh` (requires administrator privileges)
```shell
netsh interface portproxy add v4tov4 listenaddress=10.10.10.240 listenport=9000 connectaddress=127.0.0.1 connectport=5985
```
## socat port forwarding
### scenario: if web port port 8000 is only listening locally on a machine that has socat. we can bind it to the outside on port 1234 and expose it to the outside:
```bash
socat TCP-LISTEN:1234,fork,reuseaddr, tcp:127.0.0.1:8000 &
```
### if we curl the address on port 1234
```bash
curl http://192.168.145.131:1234/index.html
```
### we get a response
```
<h1>hosted only internally</h1>
```