### 1) **Enable Local Admin Account**
```
net user Administrator /active:yes
net user Administrator NewSecurePassword123
```

### 2) **Delete Unwanted Accounts**
```
Get-LocalUser
Remove-LocalUser -Name "TestUser"
```
### 3) **Resolve Stuck Sysmon Delete Service**
```
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Sysmon64 >>> Delete this key
Remove-Item -Path "C:\Windows\Sysmon64.exe" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\SysmonDrv.sys" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Program Files\Sysmon" -Recurse -Force -ErrorAction SilentlyContinue
```
### 4) **Promote Secondary DC**
```
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSDomainController `
    -DomainName "yourdomain.local" ` >>>>>> change
    -ReplicationSourceDC "site-dc01.site.lan" `  >>>>>> change
    -InstallDns `
    -Credential (Get-Credential) `
    -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "YourDSRMPasswordHere" -Force) ` >>>>>> Change password
    -Verbose `
    -Force
```
### 5) **Find Region Locale**
```
systeminfo | findstr /B /C:"System Locale" /C:"Input Locale"
```

### 6) **Robocopy**
```
robocopy "C:\Users\Public" "\\teller-win10-2\C$\Temp" test.txt /R:1 /W:1 /V /NP /LOG:C:\robocopy.log
Get-Content C:\robocopy.log -Tail 20

robocopy "C:\Users\Public" "\\teller-win10-2\C$\Temp" test.txt /R:1 /W:1 /V /NP
```

### 7) **Check WPAD DNS Block**
```
## Checks block
dnscmd /info /globalqueryblocklist

## Removes block
dnscmd /config /globalqueryblocklist isatap

net stop dns
net start dns
```

### 8) **Certificate Manager from DC**
```
certlm.msc
```
