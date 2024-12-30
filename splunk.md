### SOCAP 

`input.confs`

```
[default]
host = site-onion

[monitor:///nsm/zeek/logs/current/conn.log]
_TCP_ROUTING = *
index = zeek
source = bro.conn.log
sourcetype = bro:json

[monitor:///nsm/zeek/logs/current/dns.log]
_TCP_ROUTING = *
index = zeek
source = bro.dns.log
sourcetype = bro:json

[monitor:///nsm/zeek/logs/current/software.log]
_TCP_ROUTING = *
index = zeek
source = bro.software.log
sourcetype = bro:json

[monitor:///nsm/zeek/logs/current/smtp.log]
_TCP_ROUTING = *
index = zeek
source = bro.smtp.log
sourcetype = bro:json

[monitor:///nsm/zeek/logs/current/ssl.log]
_TCP_ROUTING = *
index = zeek
source = bro.ssl.log
sourcetype = bro:json

[monitor:///nsm/zeek/logs/current/ssh.log]
_TCP_ROUTING = *
index = zeek
source = bro.ssh.log
sourcetype = bro:json

[monitor:///nsm/zeek/logs/current/x509.log]
_TCP_ROUTING = *
index = zeek
source = bro.x509.log
sourcetype = bro:json

[monitor:///nsm/zeek/logs/current/ftp.log]
_TCP_ROUTING = *
index = zeek
source = bro.ftp.log
sourcetype = bro:json

[monitor:///nsm/zeek/logs/current/http.log]
_TCP_ROUTING = *
index = zeek
source = bro.http.log
sourcetype = bro:json

[monitor:///nsm/zeek/logs/current/rdp.log]
_TCP_ROUTING = *
index = zeek
source = bro.rdp.log
sourcetype = bro:json

[monitor:///nsm/zeek/logs/current/smb_files.log]
_TCP_ROUTING = *
index = zeek
source = bro.smb_files.log
sourcetype = bro:json

[monitor:///nsm/zeek/logs/current/smb_mapping.log]
_TCP_ROUTING = *
index = zeek
source = bro.smb_mapping.log
sourcetype = bro:json

[monitor:///nsm/zeek/logs/current/snmp.log]
_TCP_ROUTING = *
index = zeek
source = bro.snmp.log
sourcetype = bro:json

[monitor:///nsm/zeek/logs/current/sip.log]
_TCP_ROUTING = *
index = zeek
source = bro.sip.log
sourcetype = bro:json

[monitor:///nsm/zeek/logs/current/files.log]
_TCP_ROUTING = *
index = zeek
source = bro.files.log
sourcetype = bro:json

[monitor:///nsm/suricata/*.json]
disabled = false
sourcetype = suricata_eve
index=suricata
```
