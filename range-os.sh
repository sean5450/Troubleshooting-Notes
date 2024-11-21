#!/bin/bash
KUBECONFIG_CONTENT=$(cat <<EOF
apiVersion: v1
kind: Config
clusters:
- name: "677a8892-6cbe-4640-8955-b7f9f6d03e3c-bvpjn"
  cluster:
    server: "https://rangeos-rancher-ent1.perepsvcs.com/k8s/clusters/c-m-ndcm7qgr"
    insecure-skip-tls-verify: true
users:
- name: "677a8892-6cbe-4640-8955-b7f9f6d03e3c-bvpjn"
  user:
    token: "kubeconfig-u-9wkq9qpg97:47tjgjkmgq5mzgcx45nqfnrs8c2749hdzzlcj68t6xh8pws7x6sn7q"
contexts:
- name: "677a8892-6cbe-4640-8955-b7f9f6d03e3c-bvpjn"
  context:
    user: "677a8892-6cbe-4640-8955-b7f9f6d03e3c-bvpjn"
    cluster: "677a8892-6cbe-4640-8955-b7f9f6d03e3c-bvpjn"
current-context: "677a8892-6cbe-4640-8955-b7f9f6d03e3c-bvpjn"
EOF
)
# Create a temporary file for the kubeconfig
KUBECONFIG_FILE=$(mktemp)
# Write the kubeconfig content to the temporary file
echo "$KUBECONFIG_CONTENT" > "$KUBECONFIG_FILE"
# 1. Get the total number of namespaces that have names that are UUIDs and output that value
uuid_namespace_count=$(kubectl get namespaces --kubeconfig "$KUBECONFIG_FILE" -o json | jq '[.items[].metadata.name | select(test("^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"))] | length')
echo "Total number of JQR labs currentrly running is: $uuid_namespace_count"
# 2. Get the total number of RangeVM resources
rangevm_count=$(kubectl get rangevms.rangeos.cloudcents.bylight.com --kubeconfig "$KUBECONFIG_FILE" --all-namespaces -o json | jq '.items | length')
echo "Total number of VM resources: $rangevm_count"
# 3. Get the total number of RangeVolume resources
rangevolume_count=$(kubectl get rangevolumes.rangeos.cloudcents.bylight.com --kubeconfig "$KUBECONFIG_FILE" --all-namespaces -o json | jq '.items | length')
echo "Total number of Volume resources: $rangevolume_count"
# 4. Check if total RangeVM + RangeVolume > 1500 and echo accordingly
total_resources=$((rangevm_count + rangevolume_count))
if [ "$total_resources" -gt 1500 ]; then
    echo "Warning: Total RangeVM and RangeVolume resources exceed 1500. Begin powering off JQRs and prevent futher launches."
else
    echo "Total RangeVM and RangeVolume resources are within acceptable limits."
fi
# 5. Get the total number of Pending PVCs. If it's over 10, echo a warning
pending_pvc_count=$(kubectl get pvc --kubeconfig "$KUBECONFIG_FILE" --all-namespaces -o json | jq '[.items[] | select(.status.phase == "Pending")] | length')
echo "Total number of Pending PVCs: $pending_pvc_count"
if [ "$pending_pvc_count" -gt 15 ]; then
    echo "Warning: There are over 15 Pending PVCs. This could indicate an issue. Contact Metova to resolve"
fi
# 6. Get the total number of Released PVs. If it's over 50, echo a warning
released_pv_count=$(kubectl get pv --kubeconfig "$KUBECONFIG_FILE" -o json | jq '[.items[] | select(.status.phase == "Released")] | length')
echo "Total number of Released PVs: $released_pv_count"
if [ "$released_pv_count" -gt 50 ]; then
    echo "Warning: There are over 50 Released PVs. This is a side effect that slowly builds in RangeOS V8 related to the 1500 limit. Contact Metova to resolve."
fi
# 7. Check if all cluster nodes are ready
echo "Checking if all cluster nodes are Ready..."
non_ready_nodes=$(kubectl get nodes --kubeconfig "$KUBECONFIG_FILE" -o json | jq -r '.items[] | select(.status.conditions[] | select(.type=="Ready") | .status != "True") | .metadata.name')
if [ -z "$non_ready_nodes" ]; then
    echo "All cluster nodes are Ready."
else
    echo "Warning: NOT all cluster nodes are Ready. This is normally caused by a failed vCenter HA move. Contact Metova to resolve."
    echo "$non_ready_nodes"
fi
# Clean up the temporary file after use
rm -f "$KUBECONFIG_FILE"
