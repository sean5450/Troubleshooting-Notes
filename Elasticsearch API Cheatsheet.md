# *Elasticsearch API Commands*

`GET _cat/allocation` Provides a snapshot of how many shards are allocated to each data node and how much disk space they are using.

`GET _cat/count` Provides quick access to the document count of the entire cluster, or individual indices.

`GET _cat/health` Returns a concise representation of the cluster health.

`GET _cat` Returns help for Cat APIs. 

`GET _cat/indices` Returns information about indices: number of primaries and replicas, document counts, disk size.

`GET _cat/master` Returns information about the master node.

`GET /_cat/indices?v&h=i,d` Returns list of dangling indexes.

`GET _cat/nodeattrs` Returns information about custom node attributes.

`GET _cat/nodes` Returns basic statistics about performance of cluster nodes.

`GET _cat/recovery` Returns information about index shard recoveries, both on-going completed.

`GET _cat/repositories` Returns information about snapshot repositories registered in the cluster.

`GET _cat/shards` Provides a detailed view of shard allocation on nodes.

`GET _cat/templates` Returns information about existing templates.

`GET _cluster/allocation/explain` Provides explanations for shard allocations in the cluster.

`GET _cluster/health` Returns basic information about the health of the cluster.

`GET _cluster/state` Returns a comprehensive information about the state of the cluster.

`GET _cluster/stats` Returns high-level overview of cluster statistics.

`GET _cat/nodes?h=heap*` Check heap size of nodes

`GET _nodes/hot_threads?threads=3` Show hot threads

`DELETE _dangling/{index_uuid}` Deletes the specified dangling index.

`DELETE {index}` Deletes an index.

`DELETE _index_template/{name}` Deletes an index template.

`POST /_cluster/reroute?retry_failed` Retries dangling indexes. 
