# LetsEncryptForR1Soft

Script that automatically setups a Let's Encrypt certificate for R1Soft, and handles renewal.

Here is what the script does :
- Updates the following packages : nss nss-util nss-sysinit nss-tools wget curl ca-certificates openssl
- Downloads Certbot (if not already done)
- Creates a keystore for R1Soft cdp
- Creates a Let's Encrypt certificate through Certbot
- Imports the certificate into R1Soft keystore

Just wget the script, change execution rights and launch it :  
```bash
wget -N  ; chmod +x SSLR1Soft.sh
```  
```bash
./SSLR1Soft.sh
```

You can add a cron every month to renew your certificate :  
```bash
0 5 1 * * /root/SSLR1Soft.sh
```  

You can also clone this git repo, and create a cron task to get the script updates :
```bash
mkdir -p /scripts/r1soft
cd !$
git clone https://github.com/amitsdalal/r1soft-letsencrypt-auto.git

0 5 1 * * /scripts/r1soft/SSLR1Soft.sh
0 0 1 * * cd /scripts/r1soft ; git pull
```

You just have to make sure your web ports are not filtered, and nothing is running on port 80 (or you'll have to stop it before launching the script).

--
Tested and created on CentOS 7 and CentOS 6.
