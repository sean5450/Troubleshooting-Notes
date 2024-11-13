# Wazuh Installation Guide
---

## 1) Certificate Creation

### Generating the SSL Certificates 

1) Edit `./config.yml` and replace the node names and IP values with the corresponding names and IP addresses. You need to do this for all Wazuh server, Wazuh indexer, and Wazuh dashboard nodes. Add as many node fields as needed.

```
nodes:
  # Wazuh indexer nodes
  indexer:
    - name: node-1
      ip: "<indexer-node-ip>"
    #- name: node-2
    #  ip: "<indexer-node-ip>"
    #- name: node-3
    #  ip: "<indexer-node-ip>"

  # Wazuh server nodes
  # If there is more than one Wazuh server
  # node, each one must have a node_type
  server:
    - name: wazuh-1
      ip: "<wazuh-manager-ip>"
    #  node_type: master
    #- name: wazuh-2
    #  ip: "<wazuh-manager-ip>"
    #  node_type: worker
    #- name: wazuh-3
    #  ip: "<wazuh-manager-ip>"
    #  node_type: worker

  # Wazuh dashboard nodes
  dashboard:
    - name: dashboard
      ip: "<dashboard-node-ip>"
```

2) Run `./wazuh-certs-tool.sh` to create the certificates. For a multi-node cluster, these certificates need to be later deployed to all Wazuh instances in your cluster.

```
bash ./wazuh-certs-tool.sh -A
```

3) Compress all the necessary files.

```
tar -cvf ./wazuh-certificates.tar -C ./wazuh-certificates/ .
rm -rf ./wazuh-certificates
```
4) Copy the wazuh-certificates.tar file to all the nodes, including the Wazuh indexer, Wazuh server, and Wazuh dashboard nodes. This can be done by using the scp utility.

## 2) Node Installations 

### Configuring the Wazuh Indexer

1) Edit the /etc/wazuh-indexer/opensearch.yml configuration file and replace the following values:

    a.  `network.host:` Sets the address of this node for both HTTP and transport traffic. The node will bind to this address and use it as its publish address. Accepts an IP address or a hostname.

    Use the same node address set in config.yml to create the SSL certificates.

    b. `node.name:` Name of the Wazuh indexer node as defined in the `config.yml` file. For example, `node-1`.

    c. `cluster.initial_master_nodes:` List of the names of the master-eligible nodes. These names are defined in the `config.yml` file. Uncomment the `node-2` and `node-3` lines, change the names, or add more lines, according to your `config.yml` definitions.

    ```
    cluster.initial_master_nodes:
    - "node-1"
    - "node-2"
    - "node-3"
    ```
    d. `discovery.seed_hosts:` List of the addresses of the master-eligible nodes. Each element can be either an IP address or a hostname. You may leave this setting commented if you are configuring the Wazuh indexer as a single node. For multi-node configurations, uncomment this setting and set the IP addresses of each master-eligible node.

    ```
    discovery.seed_hosts:
    - "10.0.0.1"
    - "10.0.0.2"
    - "10.0.0.3"
    ```
    e. `plugins.security.nodes_dn:` List of the Distinguished Names of the certificates of all the Wazuh indexer cluster nodes. Uncomment the lines for `node-2` and `node-3` and change the common names (CN) and values according to your settings and your `config.yml` definitions.

    ```
    plugins.security.nodes_dn:
    - "CN=node-1,OU=Wazuh,O=Wazuh,L=California,C=US"
    - "CN=node-2,OU=Wazuh,O=Wazuh,L=California,C=US"
    - "CN=node-3,OU=Wazuh,O=Wazuh,L=California,C=US"
    ```

### Deploying Certificates

1) Run the following commands replacing `<indexer-node-name>` with the name of the Wazuh indexer node you are configuring as defined in `config.yml`. For example, `node-1`. This deploys the SSL certificates to encrypt communications between the Wazuh central components.

```
NODE_NAME=<indexer-node-name>
```
```
mkdir /etc/wazuh-indexer/certs
tar -xf ./wazuh-certificates.tar -C /etc/wazuh-indexer/certs/ ./$NODE_NAME.pem ./$NODE_NAME-key.pem ./admin.pem ./admin-key.pem ./root-ca.pem
mv -n /etc/wazuh-indexer/certs/$NODE_NAME.pem /etc/wazuh-indexer/certs/indexer.pem
mv -n /etc/wazuh-indexer/certs/$NODE_NAME-key.pem /etc/wazuh-indexer/certs/indexer-key.pem
chmod 500 /etc/wazuh-indexer/certs
chmod 400 /etc/wazuh-indexer/certs/*
chown -R wazuh-indexer:wazuh-indexer /etc/wazuh-indexer/certs
```
2) Recommended action: If no other Wazuh components are going to be installed on this node, remove the `wazuh-certificates.tar` file by running `rm -f ./wazuh-certificates.tar` to increase security.

### Starting the Service 

```
systemctl daemon-reload
systemctl enable wazuh-indexer
systemctl start wazuh-indexer
```

### Cluster Initialization 

1) Run the Wazuh indexer `indexer-security-init.sh` script on any Wazuh indexer node to load the new certificates information and start the single-node or multi-node cluster.**Note: Wazuh-Indexer service must be started on all nodes before cluster initialization.** 

```
/usr/share/wazuh-indexer/bin/indexer-security-init.sh
```

### Testing the Cluster Installation

1) Replace `<WAZUH_INDEXER_IP_ADDRESS>` and run the following commands to confirm that the installation is successful.

```
curl -k -u admin:admin https://<WAZUH_INDEXER_IP_ADRESS>:9200
```
 
**Output**:
```
{
  "name" : "node-1",
  "cluster_name" : "wazuh-cluster",
  "cluster_uuid" : "095jEW-oRJSFKLz5wmo5PA",
  "version" : {
    "number" : "7.10.2",
    "build_type" : "rpm",
    "build_hash" : "db90a415ff2fd428b4f7b3f800a51dc229287cb4",
    "build_date" : "2023-06-03T06:24:25.112415503Z",
    "build_snapshot" : false,
    "lucene_version" : "9.6.0",
    "minimum_wire_compatibility_version" : "7.10.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "The OpenSearch Project: https://opensearch.org/"
}
```

2) Replace `<WAZUH_INDEXER_IP_ADDRESS>` and run the following command to check if the single-node or multi-node cluster is working correctly.

    ```
    curl -k -u admin:admin https://<WAZUH_INDEXER_IP_ADDRESS>:9200/_cat/nodes?v
    ```

### Configuring Filebeat (On Wazuh Server if Multi-Node)

1) Edit the `/etc/filebeat/filebeat.yml` configuration file and replace the following value:

    a. `hosts:` The list of Wazuh indexer nodes to connect to. You can use either IP addresses or hostnames. By default, the host is set to localhost `hosts: ["127.0.0.1:9200"]`. Replace it with your Wazuh indexer address accordingly.
    If you have more than one Wazuh indexer node, you can separate the addresses using commas. For example, `hosts: ["10.0.0.1:9200"`, `"10.0.0.2:9200"`, `"10.0.0.3:9200"]`

    ```
    # Wazuh - Filebeat configuration file
    output.elasticsearch:
    hosts: ["10.0.0.1:9200"]
    protocol: https
    username: ${username}
    password: ${password}
    ```

2) Create a Filebeat keystore to securely store authentication credentials.
    ```
    filebeat keystore create
    ```

3) Add the default username and password `admin`:`admin` to the secrets keystore.

    ```
    echo admin | filebeat keystore add username --stdin --force
    echo admin | filebeat keystore add password --stdin --force
    ```

### Deploying Certificates

1) Replace `<SERVER_NODE_NAME>` with your Wazuh server node certificate name, the same one used in `config.yml` when creating the certificates. Then, move the certificates to their corresponding location.

```
NODE_NAME=<SERVER_NODE_NAME>
```
```
mkdir /etc/filebeat/certs
tar -xf ./wazuh-certificates.tar -C /etc/filebeat/certs/ ./$NODE_NAME.pem ./$NODE_NAME-key.pem ./root-ca.pem
mv -n /etc/filebeat/certs/$NODE_NAME.pem /etc/filebeat/certs/filebeat.pem
mv -n /etc/filebeat/certs/$NODE_NAME-key.pem /etc/filebeat/certs/filebeat-key.pem
chmod 500 /etc/filebeat/certs
chmod 400 /etc/filebeat/certs/*
chown -R root:root /etc/filebeat/certs
```

### Configuring the Wazuh Indexer Connection

1) Save the Wazuh indexer username and password into the Wazuh manager keystore using the wazuh-keystore tool:

```
/var/ossec/bin/wazuh-keystore -f indexer -k username -v <INDEXER_USERNAME>
/var/ossec/bin/wazuh-keystore -f indexer -k password -v <INDEXER_PASSWORD>
```
2) Edit `/var/ossec/etc/ossec.conf` to configure the indexer connection.

    By default, the indexer settings have one host configured. It's set to 0.0.0.0 as highlighted below.

```
    <indexer>
  <enabled>yes</enabled>
  <hosts>
    <host>https://0.0.0.0:9200</host>
  </hosts>
  <ssl>
    <certificate_authorities>
      <ca>/etc/filebeat/certs/root-ca.pem</ca>
    </certificate_authorities>
    <certificate>/etc/filebeat/certs/filebeat.pem</certificate>
    <key>/etc/filebeat/certs/filebeat-key.pem</key>
  </ssl>
</indexer>
```

Replace `0.0.0.0` with your Wazuh indexer node IP address or hostname. You can find this value in the Filebeat config file `/etc/filebeat/filebeat.yml`.

Ensure the Filebeat certificate and key name match the certificate files in `/etc/filebeat/certs`.

If you have a Wazuh indexer cluster, add a `<host>` entry for each one of your nodes. For example, in a two-nodes configuration:

```
<hosts>
  <host>https://10.0.0.1:9200</host>
  <host>https://10.0.0.2:9200</host>
</hosts>
```
Vulnerability detection prioritizes reporting to the first node in the list. It switches to the next node in case it's not available.

### Starting the Wazuh Manager
1) Enable and start the Wazuh manager service.

```
systemctl daemon-reload
systemctl enable wazuh-manager
systemctl start wazuh-manager
```

### Starting the Filebeat Service
1) Enable and start the Filebeat service.

```
systemctl daemon-reload
systemctl enable filebeat
systemctl start filebeat
```
2) Run the following command to verify that Filebeat is successfully installed.

```
filebeat test output
```
**Output**
```
elasticsearch: https://127.0.0.1:9200...
  parse url... OK
  connection...
    parse host... OK
    dns lookup... OK
    addresses: 127.0.0.1
    dial up... OK
  TLS...
    security: server's certificate chain verification is enabled
    handshake... OK
    TLS version: TLSv1.3
    dial up... OK
  talk to server... OK
  version: 7.10.2
```
### Configuring the Wazuh Dashboard (On Wazuh Master if Multi-Node)
1) Edit the `/etc/wazuh-dashboard/opensearch_dashboards.yml` file and replace the following values:
    a. `server.host:` This setting specifies the host of the Wazuh dashboard server. To allow remote users to connect, set the value to the IP address or DNS name of the Wazuh dashboard server. The value `0.0.0.0` will accept all the available IP addresses of the host.
    b. `opensearch.hosts:` The URLs of the Wazuh indexer instances to use for all your queries. The Wazuh dashboard can be configured to connect to multiple Wazuh indexer nodes in the same cluster. The addresses of the nodes can be separated by commas. For example, `["https://10.0.0.2:9200", "https://10.0.0.3:9200","https://10.0.0.4:9200"]`
    ```
    server.host: 0.0.0.0
    server.port: 443
    opensearch.hosts: https://localhost:9200
    opensearch.ssl.verificationMode: certificate
    ```

### Deploying Certificates
1) Replace `<DASHBOARD_NODE_NAME>` with your Wazuh dashboard node name, the same one used in `config.yml` to create the certificates, and move the certificates to their corresponding location.
```
NODE_NAME=<DASHBOARD_NODE_NAME>
```
```
mkdir /etc/wazuh-dashboard/certs
tar -xf ./wazuh-certificates.tar -C /etc/wazuh-dashboard/certs/ ./$NODE_NAME.pem ./$NODE_NAME-key.pem ./root-ca.pem
mv -n /etc/wazuh-dashboard/certs/$NODE_NAME.pem /etc/wazuh-dashboard/certs/dashboard.pem
mv -n /etc/wazuh-dashboard/certs/$NODE_NAME-key.pem /etc/wazuh-dashboard/certs/dashboard-key.pem
chmod 500 /etc/wazuh-dashboard/certs
chmod 400 /etc/wazuh-dashboard/certs/*
chown -R wazuh-dashboard:wazuh-dashboard /etc/wazuh-dashboard/certs
```
### Starting the Wazuh Dashboard Service
1) Enable and start the Wazuh dashboard service.
```
systemctl daemon-reload
systemctl enable wazuh-dashboard
systemctl start wazuh-dashboard
```
2) Edit the `/usr/share/wazuh-dashboard/data/wazuh/config/wazuh.yml` file and replace the `url` value with the IP address or hostname of the Wazuh server master node.
```
hosts:
   - default:
      url: https://<WAZUH_SERVER_IP_ADDRESS>
      port: 55000
      username: wazuh-wui
      password: wazuh-wui
      run_as: false
```
3) Access the Wazuh web interface with your credentials.
```
URL: https://<WAZUH_DASHBOARD_IP_ADDRESS>

Username: admin

Password: admin
```
### Securing your Wazuh Installation
1) Use the Wazuh passwords tool to change all the internal users' passwords.
```
/usr/share/wazuh-indexer/plugins/opensearch-security/tools/wazuh-passwords-tool.sh --api --change-all --admin-user wazuh --admin-password wazuh
```