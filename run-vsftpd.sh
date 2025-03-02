#!/bin/sh
echo " "
echo "Starting vsftpd server..."

# When running from a container, the service still
# needs to advertise the host's IP - not the 
# containerised one

# PASV_ADDRESS=$(ip route | awk '/default/ { print $3 }')           # this will get the IP of the Gateway
# PASV_ADDRESS=$(ip route get 1 | awk '{print $7; exit}')             # this will get the IP of the container

# echo "pasv_address=${PASV_ADDRESS}" >> /etc/vsftpd/vsftpd.conf

# Start vsftpd in foreground mode
exec vsftpd /etc/vsftpd/vsftpd.conf
