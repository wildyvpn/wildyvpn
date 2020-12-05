#!/bin/bash

data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
echo -e "=================== Informasi ========================"
echo -e "*                                                    *"
echo -e "*           Script Created By WILDYVPN               *"
echo -e "*               WA = 0896-3528-4000                  *"
echo -e "*                                                    *"
echo -e "=================== Informasi ========================"
echo -e ""
echo -e "    ================ Dropbear =================";
echo -e "    *Di Bawah Adalah Akun User Yang Lagi Login*";
echo -e "    ================ Dropbear =================";

for PID in "${data[@]}"
do
	#echo "check $PID";
	NUM=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
	USER=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $10}'`;
	IP=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $12}'`;
	if [ $NUM -eq 1 ]; then
        echo -e "    =============== Daftar User ===============";
		echo -e "    * $PID - $USER - $IP                      *";
        echo -e "    =============== Daftar User ===============";
	fi
done

echo "";

data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);

echo -e "    ================ Open SSH =================";
echo -e "    *Di Bawah Adalah Akun User Yang Lagi Login*";
echo -e "    ================ Open SSH =================";
for PID in "${data[@]}"
do
        #echo "check $PID";
	NUM=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | wc -l`;
	USER=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $9}'`;
	IP=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $11}'`;
        if [ $NUM -eq 1 ]; then
                echo -e "    =============== Daftar User ===============";
		        echo -e "    * $PID - $USER - $IP                      *";
                echo -e "    =============== Daftar User ===============";

        fi
done

echo "";

echo -e "=================== Informasi ========================"
echo -e "*                                                    *"
echo -e "*           Script Created By WILDYVPN               *"
echo -e "*               WA = 0896-3528-4000                  *"
echo -e "*                                                    *"
echo -e "=================== Informasi ========================"

echo "";
