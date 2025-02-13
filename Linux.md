
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
