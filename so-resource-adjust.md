### **Elasticsearch Heap**
---

1. Navigate to the following directory on the SO manager. 
   `/opt/so/saltstack/local/pillar/minions/<managername>.sls`

2. Adjust the `<esheap: 'xxxxm'>` setting to half of the available ram allocated to the manager node and not to exceed 32GB (see documentation). 
https://www.elastic.co/guide/en/elasticsearch/reference/7.17/advanced-configuration.html#set-jvm-heap-size
   
```
manager:
  mainip: '172.16.1.8'
  mainint: 'ens224'
  esheap: '4066m'
  esclustername: {{ grains.host }}
  freq: 0
  domainstats: 0
  mtu:
  elastalert: 1
  es_port: 9200
  log_size_limit: 262
  cur_close_days: 30
  grafana: 1
  osquery: 1
  thehive: 1
  playbook: 1

elasticsearch:
  mainip: '172.16.1.8'
  mainint: 'ens224'
  esheap: '4066m'
  esclustername: {{ grains.host }}
  node_type: ''
  es_port: 9200
  log_size_limit: 262
  node_route_type: 'hot'
```

3. Save the file and restart Elasticsearch with `so-restart-elasticsearch`

4. Verify the changes took effect by running `GET _cat/nodes?h=heap*` from Dev Tools in Kibana. 