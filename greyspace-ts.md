```
From the Master Node:
#use this to view certifcate status
sudo kubeadm alpha certs check-expiration
#use this to renew certs
sudo kubeadm alpha certs renew all
From the Interop (greycore) VM:
docker stop rancher
mv /home/greyadmin/rancher /home/greyadmin/rancher.old
docker start rancher
docker stop rancher
mv /home/greyadmin/rancher /home/greyadmin/rancher.new
mv /home/greyadmin/rancher.old /home/greyadmin/rancher
cp -r /home/greyadmin/rancher.new/k3s/server/tls/* /home/greyadmin/rancher/k3s/server/tls/
docker start rancher
docker stop rancher
docker start rancher
This restored rancher and the pod services, however did not allow the pods to come up due to the docker registry key being expired (and not included in the kubeadm command above). The following ansible playbook will generate a new registry key and push and apply the keys to all of the workers in the cluster, allowing all services to come back up as intended:
On the interop VM, copy the following playbook into rollcerts.yaml 
cat << EOF > rollcerts.yaml
- hosts: storage
  become: true
  gather_facts: no
  tasks:
    - name: Create SSL Key for registry server
      become: true
      become_user: greyadmin
      become_method: sudo
      command: "{{ item }}"
      with_items:
        - openssl req -newkey rsa:4096 -nodes -sha256 -keyout /home/greyadmin/system/certs/domain.key -x509 -days 365 -out /home/greyadmin/system/certs/domain.crt -subj "/CN=greycore"
        - docker stop registry
        - docker start registry

    - name: Copy SSL key to local certs directory
      become: true  
      become_user: root
      become_method: sudo
      command: "{{ item }}"
      with_items:
        - "cp /home/greyadmin/system/certs/domain.crt /etc/docker/certs.d/greycore:5000/ca.crt"


- hosts: masters
  gather_facts: no
  tasks:
    - name: Copy registry keys
      become: true
      become_user: root
      become_method: sudo
      copy:
        src: /etc/docker/certs.d
        dest: /etc/docker/

- hosts: workers
  gather_facts: no
  tasks:
    - name: Copy registry keys
      become: true
      become_user: root
      become_method: sudo
      copy:
        src: /etc/docker/certs.d
        dest: /etc/docker/
EOF
sudo ansible-playbook -i /home/greyadmin/system/inventory.yaml rollcerts.yaml
```
