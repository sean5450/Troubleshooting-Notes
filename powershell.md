
**Add Multiple Computers to Domain**
```
add-computer -computername (get-content computers.txt) -domainname ace.lan –credential AD\adminitrator -restart –force
```

**PowerCLI Extract Data From Event**
```
Connect-VIServer -server server.name.lan
$Folder = Get-Folder "DEPLOYMENT NAME"
$VMs = $folder | get-VM "VM NAME"
  
 
Copy-VMGuestFile -Source /PATH/TO/FILE -Destination /PATH/TO/SAVE -VM $VMs -GuestToLocal -GuestUser xadmin -GuestPassword 1234qwer!@#$QWER
```
