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
