#!/bin/bash
#Script Created By WILDYVPN
IP=`dig +short myip.opendns.com @resolver1.opendns.com`

Login=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
hari="1"
Pass=`</dev/urandom tr -dc a-f0-9 | head -c9`

useradd -e `date -d "$hari days" +"%Y-%m-%d"` -s /bin/false -M $Login
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e "========================================"
echo -e "==  Di Bawah Ini Informasi Akun Anda  =="
echo -e "========================================"
echo -e "Username         : $Login "
echo -e "Password         : $Pass "
echo -e "Host / IP Server : $IP" 
echo -e "Port OpenSSH     : 22"
echo -e "Port SSL/TLS     : 443"
echo -e "Port Dropbear    : 80,444,143,442,110"
echo -e "Port Squid       : 80.8080,3128 ( Saran Pakai 80 )"
echo -e "OpenVPN TCP 1194 : http://$IP:81/client-tcp-1194.ovpn"
echo -e "OpenVPN UDP 2200 : http://$IP:81/client-udp-2200.ovpn"
echo -e "OpenVPN SSL 442  : http://$IP:81/client-tcp-ssl.ovpn"
echo -e "========================================"
echo -e "==  Masa Aktif Akun Anda : $hari      =="
echo -e "========================================"
echo -e "         Script By WILDY VPN "