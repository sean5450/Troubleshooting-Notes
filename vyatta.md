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
