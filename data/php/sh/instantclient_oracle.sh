#!/bin/sh
# apk add libaio libaio-dev libnsl-dev libnsl libc6-compat && \

cd  /tmp/extensions/oracle_instantclient 

# unzip instantclient-basic-linux.x64-11.2.0.4.0.zip && unzip instantclient-sdk-linux.x64-11.2.0.4.0.zip

cp -r instantclient_11_2/* /lib 

cd /lib 
# Linking ld-linux-x86-64.so.2 to the lib/ location (Update accordingly)
ln -s /lib64/* /lib 
ln -s /lib/libnsl.so.2 /usr/lib/libnsl.so.1 
ln -s /lib/libc.so /usr/lib/libresolv.so.2
ln -s /lib/libclntsh.so.11.1  /lib/libclntsh.so
ln -s /lib/libocci.so.11.1 /lib/libocci.so
ln -s /usr/lib/libnsl.so /lib/
ln -s /lib/libnsl.so /lib/libnsl.so.1

echo "alias ll='ls -ahl'" >> /etc/profile

echo "export LD_LIBRARY_PATH=/lib" >> /etc/profile

source /etc/profile

echo "=== link finish ==="