#!/bin/bash
echo "Installing node $K8S_VERSION locally"
echo `yum -y --nogpgcheck localinstall /kubernetes/kubernetes/builds/kubernetes-node-"$K8S_VERSION"-1.x86_64.rpm`

yum clean expire-cache

echo "Running Services"
echo "systemctl start kube-proxy..."
echo `systemctl start kube-proxy`

echo "systemctl start kubelet..."
echo `systemctl start kubelet`

# echo "service status with"
echo `systemctl list-units -t service`

sleep 5
echo "Testing api server with curl http://192.168.200.2:8080/api/v1/nodes"
echo `curl http://192.168.200.2:8080/api/v1/nodes`

echo "Testing api server pod.."
echo `curl -X POST -d @/kubernetes/kubernetes/source/kubernetes/v"$K8S_VERSION"/kubernetes/examples/guestbook-go/redis-master-controller.json http://192.168.200.2:8080/api/v1/namespaces/default/replicationcontrollers --header "Content-Type:application/json"`
echo `curl -X POST -d @/kubernetes/kubernetes/source/kubernetes/v"$K8S_VERSION"/kubernetes/examples/guestbook-go/redis-master-service.json http://192.168.200.2:8080/api/v1/namespaces/default/services --header "Content-Type:application/json"`
