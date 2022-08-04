
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
