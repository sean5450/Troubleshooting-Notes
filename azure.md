### 1) **MDE Registry Entries**
```
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Advanced Threat Protection\DeviceTagging" /v Group /t REG_SZ /d "MDE-Management" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Advanced Threat Protection" /v ProxyServer /t REG_SZ /d "http://10.10.0.100:8080" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Advanced Threat Protection" /v ProxyServerType /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Advanced Threat Protection" /v ForceProxyOnly /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v DisableEnterpriseAuthProxy /t REG_DWORD /d 1 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v TelemetryProxyServer /t REG_SZ /d "10.10.0.100:8080" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Advanced Threat Protection" /v PreferStaticProxyForHttpRequest /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v ProxyServer /t REG_SZ /d "http://10.10.0.100:8080" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SSLOptions /t REG_DWORD /d 2 /f
```

### 2) **MDE Useful Commands**
```
##Check Defender version
Get-MpComputerStatus | Select AMProductVersion

##Check Defender Disable
Get-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" | Format-List

##Check MDE Plugin Log
C:\Packages\Plugins\Microsoft.Azure.AzureDefenderForServers.MDE.Windows\<version>\Status\

# Check if the Sense service is installed and running
Get-Service Sense

# Check the onboarding status
Get-MpComputerStatus | Select-Object AMServiceEnabled, AMProductVersion, AMRunningMode, AMServiceVersion

# Verify if the machine has connected to Defender cloud backend
Test-NetConnection -ComputerName winatp-gw-cus.microsoft.com -Port 443

# Review Defender logs
Get-WinEvent -LogName "Microsoft-Windows-SENSE/Operational" -MaxEvents 20 | Format-List

# Confirm MDE AV state (if using Microsoft Defender Antivirus)
MpCmdRun.exe -GetFiles

# Health Check Sense
wevtutil qe Microsoft-Windows-SENSE/Operational /q:"*[System[(Level=4 or Level=0) and (EventID=72 or EventID=419 or EventID=412)]]" /c:10 /rd:true /f:text

# Onboarding/Offboarding
Start-Process -FilePath "C:\Path\To\WindowsDefenderATPOnboardingScript.cmd" -Verb RunAs -Wait
```
### 3) **Zscaler Custom Syslog NSS**
```
{"datetime":"%s{time}","reason":"%s{reason}","event_id":%d{recordid},"protocol":"%s{proto}","action":"%s{action}","transactionsize":%d{totalsize},"responsesize":%d{respsize},"requestsize":%d{reqsize},"urlcategory":"%s{urlcat}","serverip":"%s{sip}","requestmethod":"%s{reqmethod}","refererURL":"%s{ereferer}","useragent":"%s{ua}","product":"NSS","location":"%s{location}","ClientIP":"%s{cip}","status":"%s{respcode}","user":"%s{login}","url":"%s{eurl}","vendor":"Zscaler","hostname":"%s{ehost}","clientpublicIP":"%s{cintip}","threatcategory":"%s{malwarecat}","threatname":"%s{threatname}","filetype":"%s{filetype}","appname":"%s{appname}","app_status":"%s{app_status}","pagerisk":%d{riskscore},"threatseverity":"%s{threatseverity}","department":"%s{dept}","urlsupercategory":"%s{urlsupercat}","appclass":"%s{appclass}","dlpengine":"%s{dlpeng}","urlclass":"%s{urlclass}","threatclass":"%s{malwareclass}","dlpdictionaries":"%s{dlpdict}","fileclass":"%s{fileclass}","bwthrottle":"%s{bwthrottle}","contenttype":"%s{contenttype}","unscannabletype":"%s{unscannabletype}","devicehostname":"%s{devicehostname}","deviceowner":"%s{deviceowner}","keyprotectiontype":"%s{keyprotectiontype}"}\n
```
