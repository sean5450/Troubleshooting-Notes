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
### 3) **Vector CSV to JSON**
```
sources:
  zscaler_nss_tcp:
    type: "socket"
    address: "0.0.0.0:10514"
    mode: "tcp"

transforms:
  convert_to_json:
    type: "remap"
    inputs: ["zscaler_nss_tcp"]
    source: |
      # Parse the incoming CSV array into structured JSON fields
      arr = parse_csv!(.message)
      . = {
        "datetime": arr[0],
        "reason": arr[1],
        "event_id": to_int(arr[2]) ?? 0,
        "protocol": arr[3],
        "action": arr[4],
        "transactionsize": to_int(arr[5]) ?? 0,
        "responsesize": to_int(arr[6]) ?? 0,
        "requestsize": to_int(arr[7]) ?? 0,
        "urlcategory": arr[8],
        "serverip": arr[9],
        "requestmethod": arr[10],
        "refererURL": arr[11],
        "useragent": arr[12],
        "product": arr[13],
        "location": arr[14],
        "ClientIP": arr[15],
        "status": arr[16],
        "user": arr[17],
        "url": arr[18],
        "vendor": arr[19],
        "hostname": arr[20],
        "clientpublicIP": arr[21],
        "threatcategory": arr[22],
        "threatname": arr[23],
        "filetype": arr[24],
        "appname": arr[25],
        "app_status": arr[26],
        "pagerisk": to_int(arr[27]) ?? 0,
        "threatseverity": arr[28],
        "department": arr[29],
        "urlsupercategory": arr[30],
        "appclass": arr[31],
        "dlpengine": arr[32],
        "urlclass": arr[33],
        "threatclass": arr[34],
        "dlpdictionaries": arr[35],
        "fileclass": arr[36],
        "bwthrottle": arr[37],
        "contenttype": arr[38],
        "unscannabletype": arr[39],
        "devicehostname": arr[40],
        "deviceowner": arr[41],
        "keyprotectiontype": arr[42]
      }

sinks:
  gcs_bucket:
    type: "gcp_cloud_storage"
    inputs: ["convert_to_json"]
    bucket: "ext-tfh-simspace-seamlesslabs"
    credentials_path: "/etc/vector/gcp-key.json"
    key_prefix: "tfh-zscaler-syslog/zscaler-logs/%Y/%m/%d/"
    encoding:
      codec: "json"
    batch:
      max_bytes: 10485760
      timeout_secs: 30
```
