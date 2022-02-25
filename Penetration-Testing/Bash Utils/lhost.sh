#!/bin/bash
i=$(ifconfig tun0 | grep -Po '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -n 1)
echo $i && export LHOST=$i
