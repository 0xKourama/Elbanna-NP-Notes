#!/bin/bash
#usage:
#squid.sh <CLIENT IP>
echo "[*]    updating apt..."
apt update
echo "[+]    apt updated"; echo "[*]    installing squid..."
apt -y install squid
echo "[+]    squid installed"; echo "[*]    starting squid..."
systemctl start squid
echo "[+]    squid started"; echo "[*]    enabling squid..."
systemctl enable squid
echo "[+]    squid enabled"; echo "[*]    configuring squid..."; echo "[*]    changing port to 8888..."
sed -i '1907s/3128/8888/' /etc/squid/squid.conf
echo "[+]    port modified to 8888"; echo "[*]    allowing access to squid..."
sed -i '1411s/deny/allow/' /etc/squid/squid.conf
echo "[+]    access to squid allowed"; echo '[*]    allowing access to '$1''
sed -i '1196s/.*/acl localnet src '$1'\n/' /etc/squid/squid.conf
echo '[+]    access allowed to '$1''; echo "[*]    restarting squid to apply configuration..."
systemctl restart squid
echo "[+]    squid restarted"; echo "[+]    finished."; echo "[*]    showing squid status"
systemctl status squid
