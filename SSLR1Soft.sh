#!/bin/bash
export LANG=en_US.UTF-8
export _JAVA_OPTIONS=-Duser.home=/usr/sbin/r1soft/conf

echo -e "\\n### Updating nessary packages..."
yum -y update nss nss-util nss-sysinit nss-tools wget curl ca-certificates openssl

echo -e "\\n### Installing Certbot if needed..."
if [ ! -f "/opt/certbot-auto" ]; then
        cd /opt/ || exit
        wget https://dl.eff.org/certbot-auto
        chmod a+x certbot-auto
fi

cd /usr/sbin/r1soft/conf/

echo " -- Cleaning -- "
rm -f request.csr
rm -f *.pem

echo " -- Delete Keystore -- "
rm -f keystore

echo " -- Recreate Keystore -- "
keytool -genkey -noprompt -alias cdp -dname "CN=$(hostname), OU=HaiSoft, O=HaiSoft, L=Orléans, S=Centre, C=FR" -keystore ./keystore -storepass "password" -KeySize 2048 -keypass "password" -keyalg RSA
keytool -list -keystore ./keystore -v -storepass "password" > key.check

echo " -- Build CSR -- "
keytool -certreq -alias cdp -file request.csr -keystore ./keystore -storepass "password"

echo " -- Request Certificate -- "
/opt/certbot-auto certonly --csr ./request.csr --standalone

echo " -- import Certificate -- "
keytool -import -trustcacerts -alias cdp -file 0001_chain.pem -keystore ./keystore -storepass "password"

echo " -- Cleaning -- "
rm -f request.csr
mkdir -p /usr/sbin/r1soft/conf/LetsEncrypt
/bin/mv *.pem ./LetsEncrypt/

cp /etc/pki/java/cacerts /usr/sbin/r1soft/jre/lib/security/cacerts

service cdp-server restart
