
### 1) **Find the largest file in a directory**

`du -a / | sort -n -r | head -n 20`

### 2) **How to add free up disc space for root partition**

```
sudo su 

fdisk /dev/sdb
new partition
primary
default
default
default
w

mkfs.ext4 /dev/sdb1
mkdir /opt/tmp
mount /dev/sdb1 /opt/tmp
mv /opt/velociraptor /opt/tmp
umount /dev/sdb1
cd /opt
rmdir /opt/tmp

add the following line to the bottom of /etc/fstab
/dev/sdb1 /opt ext4 defaults 0 1 #with tabs instead of spaces

mount -a
```
### 3) **How to extend partition**

```
sudo pvcreate /dev/sdb
sudo lvmdiskscan -l
sudo vgextend system-nsm /dev/sdb
sudo lvm lvextend -l +100%FREE /dev/system/nsm
sudo xfs_growfs /dev/system/nsm
```
### 4) **Install RPM File**

```
rpm -Uvh
```

### 5) **Enable All Disabled Repos (YUM)**

```
dnf config-manager --set-enabled \*
dnf clean all
dnf makecache
dnf update
```

### 6) **Check DNS Source**

`resolvectl status`

Example Output: 
```
Global
       Protocols: -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
resolv.conf mode: stub

Link 2 (eth0)
Current Scopes: none
     Protocols: -DefaultRoute +LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported

Link 3 (eth1)
    Current Scopes: DNS
         Protocols: +DefaultRoute +LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
Current DNS Server: 172.16.2.7
       DNS Servers: 172.16.2.7
        DNS Domain: site.lan

Link 4 (docker0)
Current Scopes: none
     Protocols: -DefaultRoute +LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
```

### 7) Make Script Usable

`chmod +x _name-of-script_.sh`

### 8) Simple Http Server

`python3 -m http.server 8080` or `python3 -m http.server 8080 -b 0.0.0.0`

### 9) OpenSSL Cert Check

`openssl x509 -in server.crt -enddate -noout`

### 10) libtinfo5 Fix

```
sudo apt update
wget http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2ubuntu0.1_amd64.deb
sudo apt install ./libtinfo5_6.3-2ubuntu0.1_amd64.deb
```
### 11) Set bash for user
```
sudo usermod -s /bin/bash username
```
### 12) Clear Command History ZSH
```
lsattr ~/.zsh_history ## ----i--------e-- /home/youruser/.zsh_history (If "i" flag is present, run command below)

sudo chattr -i ~/.zsh_history

unset HISTFILE

rm ~/.zsh_history

exec zsh
```

### 13) Owncloud SSL

Create cnf file for SSL cert
```
[ req ]
default_bits       = 4096
prompt             = no
default_md         = sha256
x509_extensions    = v3_req
distinguished_name = dn

[ dn ]
CN = team42.owncloud.com

[ v3_req ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = team42.owncloud.com
```
Create SSL cert
```
openssl req -x509 -nodes -days 825 -newkey rsa:4096 \
  -keyout team42.owncloud.com.key \
  -out team42.owncloud.com.crt \
  -config openssl-san.cnf
```
Upload to Owncloud proxy manager 

Domain Name: team42.owncloud.com

Scheme: http

Forward Hostname / IP: owncloud_server ← must match the container name

Forward Port: 8080 ← matches what ownCloud is listening on

✅ Block Common Exploits

✅ Websockets Support

Then in the SSL tab:

✅ SSL Certificate: team42.owncloud.com (your custom cert)

✅ Force SSL

✅ HTTP/2 Support

✅ Websockets Support

Save

### 14) **Velociraptor**
```
velociraptor config client  --config server.config.yaml > client.config.yaml
velociraptor config repack --exe velociraptor-v0.74.1-windows-amd64.exe client.config.yaml velociraptor-agent-win.exe
velociraptor config repack --exe velociraptor-v0.74.1-linux-amd64 client.config.yaml velociraptor-agent-linux
```

```
docker run -d -p 8080:80 \
  -v /path/to/your/site:/var/www/html \
  --name vuln-web vuln-apache

docker run -d -p 8080:80 -v /home/simspace/hatsuden:/var/www/html --name apache-server php:7.2-apache
```

### 15) **Docker Copy**
```
docker cp /host/path/file.txt container_name:/container/path/file.txt --> host to container

docker cp container_name:/container/path/file.txt /host/path/file.txt --> container to host

```

### 16) **Join Linux Host to AD**
```
# Install required packages
sudo dnf install realmd sssd oddjob oddjob-mkhomedir adcli samba-common-tools

# Discover your domain
sudo realm discover YOURDOMAIN.COM

# Join the domain
sudo realm join --user=Administrator YOURDOMAIN.COM

# Verify the join
sudo realm list
```
