#!/bin/bash
# Script Modified By WILDYVPN
# initializing var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
echo "Masukkan Domain VPS Mu Jika Ga ada skip"
read -p "Domain :" Domain
echo "IP=$Domain" >> /root/ipvps.conf
MYIP=$(dig @resolver1.opendns.com -t A -4 myip.opendns.com +short)
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#Membuat Certificate
country=ID
state=Riau
locality=Bagansiapiapi
organization=wildyvpn.my.id
organizationalunit=wildyvpn.my.id
commonname=wildysheverando
email=wildysheverando.net@gmail.com

#GASKUNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
cd
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

chmod +x /etc/rc.local

systemctl enable rc-local
systemctl start rc-local.service

echo 0 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 0 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc

apt update -y
apt upgrade -y
apt dist-upgrade -y
apt -y install wget curl
apt -y autoremove
apt -y autoclean
apt -y clean
apt -y remove --purge unscd
mkdir /etc/v2ray
cd /etc/v2ray
wget http://wildyvpn.my.id/akun.conf
li
cd
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install neofetch
apt -y install gcc
apt -y install make
apt -y install cmake
apt -y install git
apt -y install screen
apt -y install unzip
apt -y install curl
apt -y install zlib1g-dev
apt -y install bzip2
apt -y install neofetch
echo "clear" >> .profile
echo "neofetch" >> .profile

apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/server/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Script Created By WILDY VPN</pre>" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/server/vps.conf"
/etc/init.d/nginx restart

cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/server/badvpn-udpgw64"
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 1000' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 1000' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 1000
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 1000
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config

#MENGINSTALL DROPBEAR
apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 110 -p 109 -p 456"/g' /etc/default/dropbear
wget https://matt.ucc.asn.au/dropbear/releases/dropbear-2020.80.tar.bz2
bzip2 -cd dropbear-2020.80.tar.bz2 | tar xvf -
cd dropbear-2020.80
./configure
make && make install
mv /usr/sbin/dropbear /usr/sbin/dropbear.old
ln /usr/local/sbin/dropbear /usr/sbin/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart
rm -f /root/dropbear-2020.80.tar.bz2
rm -rf /root/dropbear-2020.80
 
#INSTALL SUID PROXY / SQUID3
cd
apt -y install squid3
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/config/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# setting vnstat
apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install 
cd
vnstat -u -i $NET
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz 
rm -rf /root/vnstat-2.6

# install webmin
cd
wget http://prdownloads.sourceforge.net/webadmin/webmin_1.910_all.deb
dpkg --install webmin_1.910_all.deb;
apt-get -y -f install;
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
rm -f webmin_1.910_all.deb
/etc/init.d/webmin restart

# install stunnel
apt install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 443
connect = 127.0.0.1:109

[dropbear]
accept = 777
connect = 127.0.0.1:22

[dropbear]
accept = 222
connect = 127.0.0.1:22

[dropbear]
accept = 990
connect = 127.0.0.1:109

[openvpn]
accept = 442
connect = 127.0.0.1:1194

END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

#OpenVPN & L2TP + V2RAY
wget https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/server/vpn.sh &&  chmod +x vpn.sh && bash vpn.sh
wget https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/ipsec.sh && chmod +x ipsec.sh && ./ipsec.sh

# install fail2ban
apt -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# xml parser
cd
apt install -y libxml-parser-perl

# banner /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/banner/sayang.conf"
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# download script
cd /usr/bin
wget -O about "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/about.sh"
wget -O utama "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/utama.sh"
wget -O tambah "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/tambah.sh"
wget -O percobaan "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/percobaan.sh"
wget -O hapus "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/hapus.sh"
wget -O anggota "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/anggota.sh"
wget -O delexp "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/delexp.sh"
wget -O cek "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/cek.sh"
wget -O restart "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/restart.sh"
wget -O remin "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/remin.sh"
wget -O reovpn "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/reovpn.sh"
wget -O redrop "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/redrop.sh"
wget -O resquid "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/resquid.sh"
wget -O ressh "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/ressh.sh"
wget -O restun "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/restun.sh"
wget -O ujicoba "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/ujicoba.py"
wget -O info "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/info.sh"
wget -O installvpn "https://raw.githubusercontent.com/wildyvpn/wildyvpn/main/Script/ipsec.sh"

echo "0 5 * * * root reboot" >> /etc/crontab

chmod +x about
chmod +x utama
chmod +x tambah
chmod +x percobaan
chmod +x hapus
chmod +x anggota
chmod +x delexp
chmod +x cek
chmod +x restart
chmod +x remin
chmod +x reovpn
chmod +x redrop
chmod +x resquid
chmod +x ressh
chmod +x restun
chmod +x ujicoba
chmod +x info
chmod +x installvpn

# finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/webmin restart
/etc/init.d/stunnel4 restart
/etc/init.d/vnstat restart
/etc/init.d/squid restart
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 1000
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 1000
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/debian.sh

# finihsing
clear
neofetch
echo -e "================== SSH / OVPN ========================"
echo -e "* utama          : Menampilkan Menu Menu yang ada    *"
echo -e "* tambah         : Membuat akun SSH & OVPN Baru      *"
echo -e "* percobaan      : Membuat akun SSH & OVPN Percobaan *"
echo -e "* hapus          : Menghapus akun Yang Bandel        *"
echo -e "* cek            : Cek Siapa Saja Yang Login         *"
echo -e "* anggota        : Cek Semua Anggota Di SSH / OVPN   *"
echo -e "* delexp         : Menghapus Akun Yang Expired       *"
echo -e "================== SSH / OVPN ========================"
echo -e "*     WILDY VPN AUTO INSTALL SSH / OVPN SCRIPT       *"
echo -e "================== Menu System ======================="
echo -e "» restart        : Merestart Semua Menu VPN          *"
echo -e "» ressh          : Merestart SSH                     *"
echo -e "» redrop         : Merestart Dropbear                *"
echo -e "» resquid        : Merestart Squid Proxy             *"
echo -e "» reovpn         : Merestart OVPN Service            *"
echo -e "» restun         : Merestart Stunnel                 *"
echo -e "» remin          : Merestart Webmin                  *"
echo -e "» reboot         : Merestart Server VPS              *" 
echo -e "» ujicoba        : Mencoba Kecepatan Jaringan        *"
echo -e "» info           : Menampilkan Informasi System      *"
echo -e "» about          : Menampilkan Informasi Script      *"
echo -e "» exit           : Logout Dari Server                *"
echo -e "==================== Tambahan ========================"
echo -e "* installvpn     : Meningstall Package L2TP          *"
echo -e "================== Menu System ======================="
echo -e "*                                                    *"
echo -e "*           Script Created By WILDYVPN               *"
echo -e "*               WA = 0896-3528-4000                  *"
echo -e "*                                                    *"
echo -e "=================== Thanks You ======================="
echo -e ""
echo "PERTAMAKALI INSTALL REBOOT DLU VPS MUUUUU !!!!"
