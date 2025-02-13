### Metova Greyspace
---

- Regional router fix
```
kubectl get pods --selector=app=router-ens194 -o name | xargs -o -I % kubectl exec -it % ip netns exec oc-ext-ns /bin/bash 
kubectl get pods --selector=app=router-ens225 -o name | xargs -o -I % kubectl exec -it % ip netns exec eu-ext-ns /bin/bash
kubectl get pods --selector=app=router-ens257 -o name | xargs -o -I % kubectl exec -it % ip netns exec me-ext-ns /bin/bash
kubectl get pods --selector=app=router-ens162 -o name | xargs -o -I % kubectl exec -it % ip netns exec as-ext-ns /bin/bash
kubectl get pods --selector=app=router-ens193 -o name | xargs -o -I % kubectl exec -it % ip netns exec af-ext-ns /bin/bash
kubectl get pods --selector=app=router-ens256 -o name | xargs -o -I % kubectl exec -it % ip netns exec na-ext-ns /bin/bash
kubectl get pods --selector=app=router-ens161 -o name | xargs -o -I % kubectl exec -it % ip netns exec la-ext-ns /bin/bash

sed -i 's/access-list 10 seq 5 permit any/access-list 10 seq 10 permit any/g' /etc/frr/ripd.conf
sed -i 's/access-list 10 seq 5 permit any/access-list 10 seq 10 permit any/g' /etc/frr/zebra.conf
kill `cat /var/run/frr/zebra.pid`
```

- Bitr.com Cert Issue
  `~/.mozilla/firefox/hppweyf7.default-esr` rename > `cert9.db`

- Bitr.com Admin Account
  `RAILS_ENV=production bin/tootctl accounts create pcteadmin --email=pcteadmin@bitr.com --role=admin --confirmed` In mastodon pod > mastodon container



### Routing
---

- Redistributes default routes for OSPF
 `set protocols ospf default-information orginate` 

- 


### Windows Administration
---

- Test WinRM
 `Invoke-Command -ComputerName "ClientComputerName" -ScriptBlock {1}`  

- Test WMI
 `Get-WmiObject -Class Win32_OperatingSystem -ComputerName "ClientComputerName"`

- WEC Network Service Read
 `(A;;0x1;;;NS)`

- WEC Server 2019
```
netsh http delete urlacl url=http://+:5985/wsman/
netsh http add urlacl url=http://+:5985/wsman/ sddl=D:(A;;GX;;;S-1-5-80-569256582-2953403351-2909559716-1301513147-412116970)(A;;GX;;;S-1-5-80-4059739203-877974739-1245631912-527174227-2996563517)
netsh http delete urlacl url=https://+:5986/wsman/
netsh http add urlacl url=https://+:5986/wsman/ sddl=D:(A;;GX;;;S-1-5-80-569256582-2953403351-2909559716-1301513147-412116970)(A;;GX;;;S-1-5-80-4059739203-877974739-1245631912-527174227-2996563517)
```
- DC Troubleshooting
  ```
  dcdiag /c /v /e /q
  cdiag /replsource:<DC>
  ```
- Powershell Check Version
  `$PSVersionTable.PSVersion`

- Windows Event Collector Quick Config
  `wecutil qc /q`

- Windows Remote Management Quick Config
  `winrm qc -q`

- MCO shell commands for creating local accounts
  ```
  mco shell -F kernel=windows run net user Administrator vCity178945
  mco shell -F kernel=windows run 'net user jcte_admin Simspace1!Simspace1! /add /Y && net localgroup Administrators jcte_admin /add /Y'
  ```

### Linux Administration
---

- Find biggest files
 `du -a / | sort -n -r | head -n 20`

- Interfaces file
 ```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
address 192.168.1.2
netmask 255.255.255.0
broadcast 192.168.1.255
network 192.168.1.0
gateway 192.168.1.1
```

- Netplan
```
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses:
        - 10.10.10.2/24
      routes:
        - to: default
          via: 10.10.10.1
      nameservers:
          search: [mydomain, otherdomain]
          addresses: [10.10.10.1, 1.1.1.1]

```
```
# Ubuntu puppet prep
sudo rm /etc/udev/rules.d/70-persistent-net.rules
network:
  version: 2
  renderer: networkd
  ethernets:
    ens160:
      dhcp4: true
    ens192:
      dhcp4: true
```

- Expand Disk
  ```
  sudo pvcreate /dev/sdb 
  sudo lvmdiskscan -l 
  sudo vgs
  sudo vgextend ubuntu-vg /dev/sdb 
  sudo lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv 
  sudo resize2fs /dev/ubuntu--vg-ubuntu--lv 
  or
  sudo xfs_growfs /dev/$your-target-dir$ 
  df -h
  ```

### UE
---

- IP:
`10.10.200.207:9060`

### Power CLI
---

**VMs must be powered down before performing these steps**

`PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false`

`connect-viserver -server server.name`

`(Get-VM "<VM-NAME>" -Location "<CONTAINING-FOLDER-NAME>").ExtensionData.PromoteDisks($true, $null)`

```
$Folder = Get-Folder "JCTE-OG-vCity-CD8-Hospital-LDP-From-2.0-Clone"
$Folder
$VMS = $Folder | Get-VM "seconion-*"
$VMS

ForEach ($vm in $VMS){
    Write-Host "Promoting:" $vm.Name
    $vm.ExtensionData.PromoteDisks($true, $null)
}
```
### Puppet

- Puppet.conf Examples
  ```
  [main]
  server=10.10.254.1
  [agent]
  certname=mattermost

  [main]
  server=10.10.254.1
  autoflush=true
  environment=production
  certname=encase
  ```

### Docker

- Start all Docker containers except $
  ```
  sudo docker start $(sudo docker ps -aq |  grep -v 54e9cf99e6c8)
  sudo docker start $(sudo docker ps -aq |  grep -v $)
  ```
