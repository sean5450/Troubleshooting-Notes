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
