### Error
Cannot purge elasticsearch data after running so-import-pcap. 

#### Useful Outputs
```
[root@securityonion-sensor sensor]# ls
maccdc2012_00003.pcap  SecurityOnion
[root@securityonion-sensor sensor]# so-import-pcap maccdc2012_00003.pcap maccdc2012_00004.pcap                                                                                  
Processing Import: /home/sensor/maccdc2012_00003.pcap
- verifying file
- assigning unique identifier to import: 3e6ddbac01ed5fb406c125dcd70e6edc
- analyzing traffic with Suricata
- analyzing traffic with Zeek
- saving PCAP data spanning dates 2012-03-16 through 2012-03-16

Processing Import: /home/sensor/maccdc2012_00004.pcap
- verifying file
- assigning unique identifier to import: 9eb79fffb595d0516b7be6f48b1977fe
- analyzing traffic with Suricata
- analyzing traffic with Zeek
- saving PCAP data spanning dates 2012-03-16 through 2012-03-16

Cleaning up:

Import complete!

You can use the following hyperlink to view data in the time range of your import.  You can triple-click to quickly highlight the entire hyperlink and you can then copy it into your browser:
https://192.168.1.69/#/hunt?q=import.id:9eb79fffb595d0516b7be6f48b1977fe%20%7C%20groupby%20event.module%20event.dataset&t=2012%2F03%2F16%2000%3A00%3A00%20AM%20-%202012%2F03%2F17%2000%3A00%3A00%20AM&z=UTC

or you can manually set your Time Range to be (in UTC):
From: 2012-03-16    To: 2012-03-17

Please note that it may take 30 seconds or more for events to appear in Onion Hunt.

```
#### Useful Links


#### Posible Solution


