### SOCAP 

`input.confs`

```
[monitor:///nsm/zeek/logs/current/]
index = security-onion
sourcetype = zeek
disabled = 0

[monitor:///nsm/wazuh/logs/alerts.json]
index = security-onion
sourcetype = wazuh-alerts
disabled = 0

[monitor:///nsm/suricata/logs/*.json]
index = security-onion
sourcetype = suricata
disabled = 0

[monitor:///nsm/strelka/log/strelka.log]
index = security-onion
sourcetype = strelka
disabled = 0
```
