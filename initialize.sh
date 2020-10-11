#!/bin/bash

HOST_IP=$(/usr/sbin/ip route|awk '/default/ { print $3 }')
echo -e "\n${HOST_IP} php5.6-apache" >> /etc/hosts

source /etc/apache2/envvars
exec apache2 -D FOREGROUND

while true; do sleep 1d; done
