
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
**Fixing sysvol/GPO Failures in Multi Domain Environments**

```
Run this on DC1 , 1x to fix all issues

----------------------
Install-WindowsFeature RSAT-DFS-Mgmt-Con, FS-DFS-Replication, FS-DFS-NameSpace
Stop-Service DFSR

$ParentDC = (Get-ADDomainController).HostName
$DN=(Get-ADDomainController).ComputerObjectDN
$dc1 = [ADSI]"LDAP://$ParentDC/CN=SYSVOL Subscription,CN=Domain System Volume,CN=DFSR-LocalSettings,$DN"


$dc1.Put("msDFSR-Options",1)
$dc1.Put("msDFSR-Enabled","FALSE")
$dc1.SetInfo()

$domainControllers = (Get-ADDomainController -Filter *).HostName

$counter = 1

foreach($dc in $domainControllers) {
    if ($dc -contains $ParentDC) {

    }
    else {
        $DN=(Get-ADDomainController -Server $dc).ComputerObjectDN
        $dc2 = [ADSI]"LDAP://$dc/CN=SYSVOL Subscription,CN=Domain System Volume,CN=DFSR-LocalSettings,$DN"
        $dc2.Put("msDFSR-Enabled","FALSE")
        $dc2.SetInfo()

    }
}

Start-Process -FilePath 'C:\Windows\System32\repadmin.exe' -ArgumentList "/syncall $ParentDC /APed"
Start-Service DFSR

$dc1.Put("msDFSR-Enabled","TRUE")
$dc1.SetInfo()
Start-Process -FilePath 'C:\Windows\System32\repadmin.exe' -ArgumentList "/syncall $ParentDC /APed"

foreach($dc in $domainControllers) {
    if ($dc -contains $ParentDC) {

    }
    else { 
        $DN=(Get-ADDomainController -Server $dc).ComputerObjectDN
        $dc2 = [ADSI]"LDAP://$dc/CN=SYSVOL Subscription,CN=Domain System Volume,CN=DFSR-LocalSettings,$DN"
        $dc2.Put("msDFSR-Enabled","TRUE")
        $dc2.SetInfo()
    }
}


foreach ($dc in $domainControllers) {
    Invoke-Command -ComputerName $dc -ScriptBlock {Stop-Service DFSR}
    Invoke-Command -ComputerName $dc -ScriptBlock {Start-Service DFSR}
}
```

**Create a new local admin, assign a random password, then provide a csv with the workstation and the admin password**

```
Add-Type -AssemblyName System.Web

$computers = (Get-ADComputer -Filter *).Name
$username = "DannyBoy"

$local_security_group = "Administrators"
$returnObj = @()

Foreach ($computer in $computers) {
    $users = $null
    $comp = [ADSI]"WinNT://$computer"
    $password = [System.Web.Security.Membership]::GeneratePassword(12,2)
    Try {
        $users = $comp.psbase.children | select -expand name

        if ($users.contains("$username")) {
        Write-Host "$username already exists on $computer"
        } 
        else {
        Write-Host "$username does not exists on $computer"
        Write-Host "Attempting to create user"
        $user = $comp.Create("User","$username")
        $user.SetPassword("$password")
        $ADS_UF_DONT_EXPIRE_PASSWD = 0x10000
        $ADS_UF_PASSWD_CANT_CHANGE = 0x40
        $user.userflags = $ADS_UF_DONT_EXPIRE_PASSWD + $ADS_UF_PASSWD_CANT_CHANGE
        $user.SetInfo()
        Write-Host "Created User attempting Group"
        $group = [ADSI]"WinNT://$computer/$local_security_group,group"
        $group.add("WinNT://$computer/$username")
        Write-Host "Check This end group "
        $users = $comp.psbase.children | select -expand name
        if ($users.contains("$username")) {
             Write-Host "Adding to output "
             $returnObj += [pscustomobject]@{Computer=$computer;Username=$username;Password=$password}
        }
        }
    }
    Catch {
        Write-Host "Error creating $username on $($computer.path):  $($Error[0].Exception.Message)"
    }
    }
$returnObj | format-table
$returnObj | Export-CSV -NoTypeInformation "passwords.csv"
```
