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

Sample

```
Sources:
OUTSIDE 182.168.32/24
INSIDE 192.168.34.2.5/30
DMZ 192.168.12.0/24
CPT FIREWALL 192.168.34.5/30

# &&&&&&&&&&&&&&&&&&&&&&&&& ADDRESS Groups  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

set firewall group address-group BAD-GUYS description "THESE ARE COMPROMISED SYSTEMS"
set firewall group address-group BAD-GUYS address 52.63.44.107
set firewall group address-group BAD-GUYS address 199.83.131.169
set firewall group address-group BAD-GUYS address 206.126.236.2
set firewall group address-group BAD-GUYS address 23.63.227.168
set firewall group address-group BAD-GUYS address 134.170.184.137
set firewall group address-group BAD-GUYS address 197.248.7.64
set firewall group address-group BAD-GUYS address 192.42.174.30
set firewall group address-group BAD-GUYS address 156.154.145.2
set firewall group address-group BAD-GUYS address 104.16.175.5
set firewall group address-group BAD-GUYS address 40.79.215.2
set firewall group address-group BAD-GUYS address 200.58.101.200

set firewall group address-group AIRBASE-WEB-SERVERS address 192.168.2.4
set firewall group address-group AIRBASE-MAIL-SERVERS address 192.168.12.2
set firewall group address-group AIRBASE-DNS-SERVERS address 192.168.12.3
set firewall group address-group OUTSIDE-ADDRESS address 51.120.53.2
set firewall group address-group INSIDE-ADDRESS address 192.168.32.1
set firewall group address-group AIRBASE-DMZ address 192.168.12.1

#  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&     NETWORK GROUPS  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

set firewall group network-group IT-ADMINS network 192.168.15.0/24

set firewall group network-group AIRBASE-BS-DMZ network 192.168.12.0/24

set firewall group network-group AIRBASE-NETWORKS network 192.168.2.0/24
set firewall group network-group AIRBASE-NETWORKS network 192.168.3.0/24
set firewall group network-group AIRBASE-NETWORKS network 192.168.5.0/24
set firewall group network-group AIRBASE-NETWORKS network 192.168.6.0/24
set firewall group network-group AIRBASE-NETWORKS network 192.168.7.0/24
set firewall group network-group AIRBASE-NETWORKS network 192.168.8.0/24
set firewall group network-group AIRBASE-NETWORKS network 192.168.11.0/24
set firewall group network-group AIRBASE-NETWORKS network 192.168.14.0/24
set firewall group network-group AIRBASE-NETWORKS network 192.168.16.0/24
set firewall group network-group AIRBASE-NETWORKS network 192.168.19.0/24
set firewall group network-group AIRBASE-NETWORKS network 192.168.30.0/24

#  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&   PORT GROUPS  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

set firewall group port-group PORT-TCP-MAIL-SERVER port 25
set firewall group port-group PORT-TCP-SSH-CLIENT port 22
set firewall group port-group PORT-TCP-WEB-SERVER port 80
set firewall group port-group PORT-TCP-WEB-SECURE-SERVER port 443
set firewall group port-group PORT-UDP-DNS-SERVER port 53
 
#  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&   Rule-Sets  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

#  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&   Rule-Sets OUTSIDE-TO-DMZ  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

set firewall name OUTSIDE-TO-DMZ default-action drop
set firewall name OUTSIDE-TO-DMZ rule 1010 action drop
set firewall name OUTSIDE-TO-DMZ rule 1010 state invalid enable
set firewall name OUTSIDE-TO-DMZ rule 1010 log enable # logging enabled for this rule
set firewall name OUTSIDE-TO-DMZ rule 1010 source group address-group BAD-GUYS
set firewall name OUTSIDE-TO-DMZ rule 1010 destination group address-group AIRBASE-DMZ
set firewall name OUTSIDE-TO-DMZ rule 1010 action drop

set firewall name OUTSIDE-TO-DMZ rule 1020 action accept
set firewall name OUTSIDE-TO-DMZ rule 1020 state established enable
set firewall name OUTSIDE-TO-DMZ rule 1020 state related enable
set firewall name OUTSIDE-TO-DMZ rule 1020 log enable # logging enabled for this rule
set firewall name OUTSIDE-TO-DMZ rule 1020 source group address-group AIRBASE-WEB-SERVERS
set firewall name OUTSIDE-TO-DMZ rule 1020 destination group address-group AIRBASE-DMZ
set firewall name OUTSIDE-TO-DMZ rule 1020 destination group port-group PORT-TCP-WEB-SERVER
set firewall name OUTSIDE-TO-DMZ rule 1020 action drop

set firewall name OUTSIDE-TO-DMZ rule 1030 action accept
set firewall name OUTSIDE-TO-DMZ rule 1030 state established enable
set firewall name OUTSIDE-TO-DMZ rule 1030 state related enable
set firewall name OUTSIDE-TO-DMZ rule 1030 log enable # logging enabled for this rule
set firewall name OUTSIDE-TO-DMZ rule 1030 source group address-group AIRBASE-MAIL-SERVERS
set firewall name OUTSIDE-TO-DMZ rule 1030 destination group address-group AIRBASE-DNS-SERVERS
set firewall name OUTSIDE-TO-DMZ rule 1030 destination group port-group PORT-TCP-MAIL-SERVER
set firewall name OUTSIDE-TO-DMZ rule 1030 destination group port-group PORT-UDP-DNS-SERVER
set firewall name OUTSIDE-TO-DMZ rule 1030 action drop


#  &&&&&&&&&&&&&&&&&&&&&&&&&&&&    Rule-Sets INSIDE-TO-DMZ   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

set firewall name INSIDE-TO-DMZ rule 1040 action accept
set firewall name INSIDE-TO-DMZ rule 1040 state established enable
set firewall name INSIDE-TO-DMZ rule 1040 state related enable
set firewall name INSIDE-TO-DMZ rule 1040 log enable # logging enabled for this rule
set firewall name INSIDE-TO-DMZ rule 1040 source group address-group AIRBASE-WEB-SERVERS
set firewall name INSIDE-TO-DMZ rule 1040 destination group address-group AIRBASE-DMZ
set firewall name INSIDE-TO-DMZ rule 1040 destination group port-group PORT-TCP-WEB-SERVER
set firewall name INSIDE-TO-DMZ rule 1040 action drop

set firewall name INSIDE-TO-DMZ rule 1050 action accept
set firewall name INSIDE-TO-DMZ rule 1050 state established enable
set firewall name INSIDE-TO-DMZ rule 1050 state related enable
set firewall name INSIDE-TO-DMZ rule 1050 log enable # logging enabled for this rule
set firewall name INSIDE-TO-DMZ rule 1050 source group address-group AIRBASE-DNS-SERVERS
set firewall name INSIDE-TO-DMZ rule 1050 destination group address-group AIRBASE-DMZ
set firewall name INSIDE-TO-DMZ rule 1050 destination group port-group PORT-UDP-DNS-SERVER
set firewall name INSIDE-TO-DMZ rule 1050 action drop

set firewall name INSIDE-TO-DMZ rule 1060 action accept
set firewall name INSIDE-TO-DMZ rule 1060 state established enable
set firewall name INSIDE-TO-DMZ rule 1060 state related enable
set firewall name INSIDE-TO-DMZ rule 1060 log enable # logging enabled for this rule
set firewall name INSIDE-TO-DMZ rule 1060 source group network-group IT-ADMINS
set firewall name INSIDE-TO-DMZ rule 1060 destination group network-group AIRBASE-BS-DMZ
set firewall name INSIDE-TO-DMZ rule 1060 destination group port-group PORT-TCP-SSH-CLIENT
set firewall name INSIDE-TO-DMZ rule 1060 action drop

set firewall name INSIDE-TO-DMZ rule 1070 action accept
set firewall name INSIDE-TO-DMZ rule 1070 state established enable
set firewall name INSIDE-TO-DMZ rule 1070 state related enable
set firewall name INSIDE-TO-DMZ rule 1070 log enable # logging enabled for this rule
set firewall name INSIDE-TO-DMZ rule 1070 source group address-group AIRBASE-MAIL-SERVERS
set firewall name INSIDE-TO-DMZ rule 1070 destination group address-group AIRBASE-DMZ
set firewall name INSIDE-TO-DMZ rule 1070 destination group port-group PORT-TCP-MAIL-SERVER
set firewall name INSIDE-TO-DMZ rule 1070 action drop

#  &&&&&&&&&&&&&&&&&&&&&&&&     Rule-Sets INSIDE-TO-OUTSIDE  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

set firewall name INSIDE-TO-OUTSIDE rule 1080 action accept
set firewall name INSIDE-TO-OUTSIDE rule 1080 state established enable
set firewall name INSIDE-TO-OUTSIDE rule 1080 state related enable
set firewall name INSIDE-TO-OUTSIDE rule 1080 log enable # logging enabled for this rule
set firewall name INSIDE-TO-OUTSIDE rule 1080 source group network-group AIRBASE-NETWORKS
set firewall name INSIDE-TO-OUTSIDE rule 1080 destination group address-group OUTSIDE-ADDRESS
set firewall name INSIDE-TO-OUTSIDE rule 1080 destination group port-group PORT-TCP-WEB-SERVER
set firewall name INSIDE-TO-OUTSIDE rule 1080 destination group port-group PORT-TCP-WEB-SECURE-SERVER
set firewall name INSIDE-TO-OUTSIDE rule 1080 action drop

#  &&&&&&&&&&&&&&&&&&&&&&&&&    Rule-Sets DMZ-TO-INSIDE    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

set firewall name DMZ-TO-INSIDE rule 1090 action accept
set firewall name DMZ-TO-INSIDE rule 1090 state established enable
set firewall name DMZ-TO-INSIDE rule 1090 state related enable
set firewall name DMZ-TO-INSIDE rule 1090 log enable # logging enabled for this rule
set firewall name DMZ-TO-INSIDE rule 1090 source group address-group AIRBASE-DNS-SERVERS 
set firewall name DMZ-TO-INSIDE rule 1090 destination group address-group INSIDE-ADDRESS
set firewall name DMZ-TO-INSIDE rule 1090 group port-group PORT-UDP-DNS-SERVER 
set firewall name DMZ-TO-INSIDE rule 1090 source group address-group AIRBASE-MAIL-SERVERS
set firewall name DMZ-TO-INSIDE rule 1090 destination group address-group INSIDE-ADDRESS
set firewall name DMZ-TO-INSIDE rule 1090 destination group port-group PORT-TCP-MAIL-SERVER
set firewall name DMZ-TO-INSIDE rule 1090 source group address-group AIRBASE-WEB-SERVERS
set firewall name DMZ-TO-INSIDE rule 1090 destination group address-group INSIDE-ADDRESS
set firewall name DMZ-TO-INSIDE rule 1090 destination group port-group PORT-TCP-MAIL-SERVER
set firewall name DMZ-TO-INSIDE rule 1090 action drop

#  &&&&&&&&&&&&&&&&&&&&&&&&&&  Set up syslogging to Security Onion   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

set system syslog host <security onion IP address> facility security level notice


#  &&&&&&&&&&&&&&&&&&&&&&&&&&   Apply rule to an interface   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

set interfaces ethernet eth2 firewall in name OUTSIDE-TO-DMZ
set interfaces ethernet eth3 firewall in name INSIDE-TO-DMZ
set interfaces ethernet eth3 firewall in name INSIDE-TO-OUTSIDE
set interfaces ethernet eth1 firewall in name DMZ-TO-INSIDE

```


