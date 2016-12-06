#!/bin/bash
set -ex

K8S_VERSION=${K8S_VERSION:-1.1.2}
rm -f kubernetes/master/kubernetes-master_$K8S_VERSION_amd64.deb
rm -f kubernetes/master/kubernetes-node_$K8S_VERSION_amd64.deb

pushd kubernetes/source/kubernetes/v$K8S_VERSION
tar xfvz kubernetes.tar.gz
tar xfvz kubernetes-server-linux-amd64.tar.gz
popd

fpm -s dir -n "kubernetes-master" \
-p kubernetes/builds \
-C ./kubernetes/master -v $K8S_VERSION \
-t deb \
-a amd64 \
-d "dpkg (>= 1.17)" \
--after-install kubernetes/master/scripts/deb/after-install.sh \
--before-install kubernetes/master/scripts/deb/before-install.sh \
--after-remove kubernetes/master/scripts/deb/after-remove.sh \
--before-remove kubernetes/master/scripts/deb/before-remove.sh \
--deb-init kubernetes/master/services/initd/kube-apiserver \
--deb-init kubernetes/master/services/initd/kube-controller-manager \
--deb-init kubernetes/master/services/initd/kube-scheduler \
--deb-init kubernetes/master/services/initd/kubelet \
--deb-default kubernetes/master/initd_config/kube-apiserver \
--deb-default kubernetes/master/initd_config/kube-controller-manager \
--deb-default kubernetes/master/initd_config/kube-scheduler \
--deb-default kubernetes/master/initd_config/kubelet \
--license "Apache Software License 2.0" \
--maintainer "Helion Stackato <support@stackato.com>" \
--vendor "Hewlett Packard Enterprise" \
--description "Kubernetes master binaries and services" \
--url "http://www.stackato.com" \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kube-apiserver=/usr/bin/kube-apiserver \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kube-controller-manager=/usr/bin/kube-controller-manager \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kube-scheduler=/usr/bin/kube-scheduler \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kubectl=/usr/bin/kubectl \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kubelet=/usr/bin/kubelet \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/hyperkube=/usr/bin/hyperkube \
etc/kubernetes/manifests

fpm -s dir -n "kubernetes-node" \
-p kubernetes/builds \
-C ./kubernetes/node -v $K8S_VERSION \
-t deb \
-a amd64 \
-d "dpkg (>= 1.17)" \
--after-install kubernetes/node/scripts/deb/after-install.sh \
--before-install kubernetes/node/scripts/deb/before-install.sh \
--after-remove kubernetes/node/scripts/deb/after-remove.sh \
--before-remove kubernetes/node/scripts/deb/before-remove.sh \
--deb-default kubernetes/node/initd_config/kubelet \
--deb-default kubernetes/node/initd_config/kube-proxy \
--deb-init kubernetes/node/services/initd/kubelet \
--deb-init kubernetes/node/services/initd/kube-proxy \
--license "Apache Software License 2.0" \
--maintainer "Helion Stackato <support@stackato.com>" \
--vendor "Hewlett Packard Enterprise" \
--description "Kubernetes master binaries and services" \
--url "http://www.stackato.com" \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kubelet=/usr/bin/kubelet \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kube-proxy=/usr/bin/kube-proxy \
etc/kubernetes/manifests
