#!/bin/bash
if [ -z "$1" ]
  then
    echo "Please provide username";
    exit 1
else
        KEYFILE1=/root/wg-keys/$1-pub.key
        KEYFILE2=/root/wg-keys/$1-private.key
        if [ -f "$KEYFILE1" ] && [ -f "$KEYFILE2" ]; then
                echo "Username $1 already exists."
                exit 1
        else 
                #echo "Username $1 does not exist."

                #wg genkey | tee $KEYFILE2 | wg pubkey | tee $KEYFILE1
                #$(wg |grep 'allowed ips'|grep -Po '[0-9.]{7,15}'|sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4|tail -1)";
                LAST_USED_IP=$(wg |grep 'allowed ips'|grep -Po '[0-9.]{7,15}'|sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4|tail -1)
                nextip(){
                IP=$1
                IP_HEX=$(printf '%.2X%.2X%.2X%.2X\n' `echo $IP | sed -e 's/\./ /g'`)
                NEXT_IP_HEX=$(printf %.8X `echo $(( 0x$IP_HEX + 1 ))`)
                NEXT_IP=$(printf '%d.%d.%d.%d\n' `echo $NEXT_IP_HEX | sed -r 's/(..)/0x\1 /g'`)
                echo "$NEXT_IP"
                }
                NEW_IP=$(nextip $LAST_USED_IP)
                wg genkey | tee $KEYFILE2 | wg pubkey | tee $KEYFILE1 >>/dev/null
                PRIVATE_KEY=$(cat $KEYFILE2)
                PUBLIC_KEY=$(cat $KEYFILE1)
                wg set wg0 peer $PUBLIC_KEY allowed-ips $NEW_IP
                CONF_FILE=/root/wg-cfgs/$1.conf
                echo "[Interface]" > $CONF_FILE 
                echo "PrivateKey = $PRIVATE_KEY" >> $CONF_FILE
                echo "Address = $NEW_IP/24" >> $CONF_FILE
                echo "DNS = 1.1.1.1, 8.8.8.8" >> $CONF_FILE
                echo "" >> $CONF_FILE
                echo "[Peer]" >> $CONF_FILE
                echo "PublicKey = 39/Xh9EmOznLYZ3sFek+oByllEp7sGOwYqYyEIYIwBw=" >> $CONF_FILE
                echo "AllowedIPs = 192.168.14.14/32, 10.10.55.3/32" >> $CONF_FILE
                echo "Endpoint = 185.82.93.150:51820" >> $CONF_FILE

                echo "[Interface]";
                echo "PrivateKey = $PRIVATE_KEY";
                echo "Address = $NEW_IP/24";
                echo "DNS = 1.1.1.1, 8.8.8.8";
                echo "";
                echo "[Peer]";
                echo "PublicKey = 39/Xh9EmOznLYZ3sFek+oByllEp7sGOwYqYyEIYIwBw=";
                echo "AllowedIPs = 192.168.14.14/32, 10.10.55.3/32";
                echo "Endpoint = 185.82.93.150:51820";
                echo "------------------------------";
                echo "VPN User $1 added";
        fi
fi