
**Add Multiple Computers to Domain**
```
add-computer -computername (get-content computers.txt) -domainname ace.lan –credential AD\adminitrator -restart –force
```
