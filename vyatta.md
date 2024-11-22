## **Vyatta Pastable Tasks**

---

### Creating NAT destination rule

Example

```
config

set nat destination rule 5 destination address 70.39.165.194

set nat destination rule 5 destination port 443

set nat destination rule 5 inbound-interface eth1

set nat destination rule 5 protocol tcp

set nat destination rule 5 translation address 172.16.2.2

set nat destination rule 5 translation port 443

commit save

```
---

### BGP Edge Device Routing

```
Vyatta:

set policy prefix-list RFC1918-NETS rule 10 action permit
set policy prefix-list RFC1918-NETS rule 10 ge 9
set policy prefix-list RFC1918-NETS rule 10 prefix 10.0.0.0/8
set policy prefix-list RFC1918-NETS rule 15 action permit
set policy prefix-list RFC1918-NETS rule 15 ge 13
set policy prefix-list RFC1918-NETS rule 15 prefix 172.16.0.0/12
set policy prefix-list RFC1918-NETS rule 20 action permit
set policy prefix-list RFC1918-NETS rule 20 ge 17
set policy prefix-list RFC1918-NETS rule 20 prefix 192.168.0.0/16
set policy prefix-list RFC1918-NETS rule 9999 action deny
set policy prefix-list RFC1918-NETS rule 9999 le 32
set policy prefix-list RFC1918-NETS rule 9999 prefix 0.0.0.0/0
set policy prefix-list ALL-NETS rule 10 action permit
set policy prefix-list ALL-NETS rule 10 le 32
set policy prefix-list ALL-NETS rule 10 prefix 0.0.0.0/0
set policy prefix-list DEF-ROUTE-ONLY rule 10 action permit
set policy prefix-list DEF-ROUTE-ONLY rule 10 prefix 0.0.0.0/0
set policy prefix-list DEF-ROUTE-ONLY rule 9999 action deny
set policy prefix-list DEF-ROUTE-ONLY rule 9999 le 32
set policy prefix-list DEF-ROUTE-ONLY rule 9999 prefix 0.0.0.0/0
set policy route-map EXPORT-TO-GREY rule 10 action deny
set policy route-map EXPORT-TO-GREY rule 10 match ip address prefix-list RFC1918-NETS
set policy route-map EXPORT-TO-GREY rule 20 action deny
set policy route-map EXPORT-TO-GREY rule 20 match ip address prefix-list DEF-ROUTE-ONLY
set policy route-map EXPORT-TO-GREY rule 30 action permit
set policy route-map EXPORT-TO-GREY rule 30 match ip address prefix-list ALL-NETS
set policy route-map IMPORT-FROM-GREY rule 10 action permit
set policy route-map IMPORT-FROM-GREY rule 10 match ip address prefix-list DEF-ROUTE-ONLY
set policy route-map IMPORT-FROM-GREY rule 9999 action deny
set policy route-map IMPORT-FROM-GREY rule 9999 match ip address prefix-list ALL-NETS


FRR:

ip prefix-list ALL-NETS seq 5 permit 0.0.0.0/0 le 32
ip prefix-list DEF-ROUTE-ONLY seq 5 permit 0.0.0.0/0
ip prefix-list DEF-ROUTE-ONLY seq 10 deny 0.0.0.0/0 le 32
ip prefix-list RFC1918 seq 5 permit 10.0.0.0/8 ge 9
ip prefix-list RFC1918 seq 10 permit 172.16.0.0/12 ge 13
ip prefix-list RFC1918 seq 15 permit 192.168.0.0/16 ge 17
ip prefix-list RFC1918 seq 20 deny 0.0.0.0/0 le 32
route-map EXPORT-TO-REGIONAL permit 10
match ip address prefix-list DEF-ROUTE-ONLY
route-map EXPORT-TO-REGIONAL deny 20
match ip address prefix-list ALL-NETS
route-map IMPORT-FROM-REGIONAL deny 10
match ip address prefix-list DEF-ROUTE-ONLY
route-map IMPORT-FROM-REGIONAL deny 20
match ip address prefix-list RFC1918
route-map IMPORT-FROM-REGIONAL permit 30
match ip address prefix-list ALL-NETS

```

### Site-to-Site VPN

```
Router 1:

edit interfaces tunnel tun0

set address 192.168.0.1/30
set encapsulation gre
set local-ip 169.63.160.1
set remote-ip 169.63.160.2
set multicast disable

exit

edit vpn ipsec

set ipsec-interfaces interface eth2
set ike-group IKEGroup1 proposal 1 dh-group 2
set ike-group IKEGroup1 proposal 1 encryption aes128
set ike-group IKEGroup1 proposal 1 hash sha1
set ike-group IKEGroup1 ikev2-reauth no
set ike-group IKEGroup1 key-exchange ikev1
set ike-group IKEGroup1 lifetime 28800
set esp-group ESPGroup1 proposal 1 encryption aes128
set esp-group ESPGroup1 proposal 1 hash sha1
set esp-group ESPGroup1 compression disable
set esp-group ESPGroup1 lifetime 3600
set esp-group ESPGroup1 mode tunnel
set esp-group ESPGroup1 pfs enable
set site-to-site peer 169.63.160.2 authentication mode pre-shared-secret
set site-to-site peer 169.63.160.2 authentication pre-shared-secret P@55w0rd!
set site-to-site peer 169.63.160.2 connection-type initiate
set site-to-site peer 169.63.160.2 ikev2-reauth inherit
set site-to-site peer 169.63.160.2 ike-group IKEGroup1
set site-to-site peer 169.63.160.2 default-esp-group ESPGroup1
set site-to-site peer 169.63.160.2 local-address 169.63.160.1
set site-to-site peer 169.63.160.2 tunnel 1 protocol gre
set site-to-site peer 169.63.160.2 tunnel 1 allow-nat-networks disable
set site-to-site peer 169.63.160.2 tunnel 1 allow-public-networks disable


Router 2:

edit interfaces tunnel tun0

set address 192.168.0.10/30
set encapsulation gre
set local-ip 169.63.160.2
set remote-ip 169.63.160.1
set multicast disable

exit

edit vpn ipsec

set ipsec-interfaces interface eth2
set ike-group IKEGroup1 proposal 1 dh-group 2
set ike-group IKEGroup1 proposal 1 encryption aes128
set ike-group IKEGroup1 proposal 1 hash sha1
set ike-group IKEGroup1 ikev2-reauth no
set ike-group IKEGroup1 key-exchange ikev1
set ike-group IKEGroup1 lifetime 28800
set esp-group ESPGroup1 proposal 1 encryption aes128
set esp-group ESPGroup1 proposal 1 hash sha1
set esp-group ESPGroup1 compression disable
set esp-group ESPGroup1 lifetime 3600
set esp-group ESPGroup1 mode tunnel
set esp-group ESPGroup1 pfs enable
set site-to-site peer 169.63.160.1 authentication mode pre-shared-secret
set site-to-site peer 169.63.160.1 authentication pre-shared-secret P@55w0rd!
set site-to-site peer 169.63.160.1 connection-type respond
set site-to-site peer 169.63.160.1 ikev2-reauth inherit
set site-to-site peer 169.63.160.1 ike-group IKEGroup1
set site-to-site peer 169.63.160.1 default-esp-group ESPGroup1
set site-to-site peer 169.63.160.1 local-address 169.63.160.2
set site-to-site peer 169.63.160.1 tunnel 1 protocol gre
set site-to-site peer 169.63.160.1 tunnel 1 allow-nat-networks disable
set site-to-site peer 169.63.160.1 tunnel 1 allow-public-networks disable
```
