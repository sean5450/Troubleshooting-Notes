1. **Disable shard allocation**

Using Devtools

```
PUT _cluster/settings
{
  "persistent": {
    "cluster.routing.allocation.enable": "primaries"
  }
}

```
Using CURL
```
curl -X PUT "localhost:9200/_cluster/settings?pretty" -H 'Content-Type: application/json' -d'
{
  "persistent": {
    "cluster.routing.allocation.enable": "primaries"
  }
}
'
```
2. **Stop indexing and perform a synced flush**

Using Devtools

```
POST _flush/synced
```
Using CURL
```
curl -X POST "localhost:9200/_flush/synced?pretty"
```
3. **Shutdown/Stop all services**

Stop on **ALL** nodes

`systemctl stop elasticsearch`

4. **Upgrade all nodes**

`yum update elasticsearch -y`

5. **Start each upgraded node**

If you have dedicated master nodes, start them first and wait for them to form a cluster and elect a master before proceeding with your data nodes. You can check progress by looking at the logs.
As soon as enough master-eligible nodes have discovered each other, they form a cluster and elect a master. At that point, you can use `_cat/health` and `_cat/nodes` to monitor nodes joining the cluster:

Using Devtools

```
GET _cat/health

GET _cat/nodes

```
Using CURL
```
curl -X GET "localhost:9200/_cat/health?pretty"
curl -X GET "localhost:9200/_cat/nodes?pretty"
```
5. **Reenable allocation**

Using Devtools
```
PUT _cluster/settings
{
  "persistent": {
    "cluster.routing.allocation.enable": null
  }
}
```
Using CURL
```
curl -X PUT "localhost:9200/_cluster/settings?pretty" -H 'Content-Type: application/json' -d'
{
  "persistent": {
    "cluster.routing.allocation.enable": null
  }
}
'
```

Once allocation is reenabled, the cluster starts allocating replica shards to the data nodes. At this point it is safe to resume indexing and searching, but your cluster will recover more quickly if you can wait until all primary and replica shards have been successfully allocated and the status of all nodes is green. Use `_cat/health` to monitor status of cluster. 
