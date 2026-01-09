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

---

schtasks /Create /TN SysmonCleanup /SC ONCE /ST 00:00 /RU SYSTEM /TR "cmd /c sc stop sysmon64 ^& sc delete sysmon64" /F
schtasks /Run /TN SysmonCleanup
timeout /t 5
schtasks /Delete /TN SysmonCleanup /F
shutdown /r /t 0
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

### 9) **SSBolt Fix** 
```
sc stop ssbolt
sc delete ssbolt

sc create ssbolt binPath= "\"C:\Program Files\SSbolt_Legacy\ssbolt.exe\" -f \"C:\ProgramData\ssh\ssbolt_config\"" start= auto type= own obj= "LocalSystem"
sc description ssbolt "SimSpace Bolt (legacy)"
sc sdset ssbolt "D:(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)"

net start ssbolt
```

### 10) **Check Build Version/Applied Patch**
```
systeminfo | findstr /B /C:"OS Version"

Get-HotFix | Where-Object {$_.HotFixID -eq "KB5066187"}

```
### 11) **Get Distinguished Name**
```
(Get-ADDomain).DistinguishedName      ## Domain

Get-ADUser -Identity Administrator | Select DistinguishedName     ## Username
```
### 12) **Get Exchange Mailbox Message Tracking Log**
```
Get-MessageTrackingLog -Recipients "user@domain.com" -Start (Get-Date).AddHours(-2)
```
### 13) **Disable Defender Via Registry**
```
HKLM\SOFTWARE\Microsoft\Windows Defender
DWORD: DisableAntiSpyware = 1

or

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -Type DWord -Force
```
