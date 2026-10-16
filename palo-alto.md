```
api.paloaltonetworks.com
apitrusted.paloaltonetworks.com
lic.lc.prod.us.cs.paloaltonetworks.com
certificatetrusted.paloaltonetworks.com
identity.services-edge.paloaltonetworks.com
```


Cortex Find GUID for Uninstall 
```
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | 
Where-Object { $_.DisplayName -like "*Cortex XDR*" -or $_.DisplayName -like "*Traps*" } | 
Select-Object DisplayName, DisplayVersion, PSChildName
```
