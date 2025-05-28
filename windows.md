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
