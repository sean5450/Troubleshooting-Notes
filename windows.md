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
    -ReplicationSourceDC "site-dc01" `  >>>>>> change
    -InstallDns `
    -Credential (Get-Credential) `
    -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "YourDSRMPasswordHere" -Force) ` >>>>>> Change password
    -Verbose `
    -Force
```
