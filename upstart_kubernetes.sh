#!/bin/bash
set -ex

K8S_VERSION=${K8S_VERSION:-1.1.2}
rm -f kubernetes/builds/kubernetes-*_${K8S_VERSION}_amd64.deb

pushd kubernetes/source/kubernetes/v$K8S_VERSION
tar xfvz kubernetes.tar.gz
tar xfvz kubernetes-server-linux-amd64.tar.gz
popd

fpm -s dir -n "kubernetes-common" \
-p kubernetes/builds \
-C ./kubernetes/common -v $K8S_VERSION \
-t deb \
-a amd64 \
-d "dpkg (>= 1.17)" \
--before-install kubernetes/common/scripts/deb/before-install.sh \
--license "Apache Software License 2.0" \
--maintainer "Helion Stackato <support@stackato.com>" \
--vendor "Hewlett Packard Enterprise" \
--description "Kubernetes Common" \
--url "http://www.stackato.com" \
etc/kubernetes/manifests

fpm -s dir -n "kubernetes-apiserver" \
-p kubernetes/builds \
-C ./kubernetes/apiserver -v $K8S_VERSION \
-t deb \
-a amd64 \
-d "dpkg (>= 1.17)" \
-d "kubernetes-common (= $K8S_VERSION)" \
--license "Apache Software License 2.0" \
--maintainer "Helion Stackato <support@stackato.com>" \
--vendor "Hewlett Packard Enterprise" \
--description "Kubernetes API Server" \
--url "http://www.stackato.com" \
--after-install kubernetes/apiserver/scripts/deb/after-install.sh \
--before-remove kubernetes/apiserver/scripts/deb/before-remove.sh \
--deb-upstart kubernetes/apiserver/services/upstart/kube-apiserver \
--deb-default kubernetes/apiserver/initd_config/kube-apiserver \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kube-apiserver=/usr/bin/kube-apiserver

fpm -s dir -n "kubernetes-controller-manager" \
-p kubernetes/builds \
-C ./kubernetes/controller-manager -v $K8S_VERSION \
-t deb \
-a amd64 \
-d "dpkg (>= 1.17)" \
-d "kubernetes-common (= $K8S_VERSION)" \
--license "Apache Software License 2.0" \
--maintainer "Helion Stackato <support@stackato.com>" \
--vendor "Hewlett Packard Enterprise" \
--description "Kubernetes Controller Manager" \
--url "http://www.stackato.com" \
--after-install kubernetes/controller-manager/scripts/deb/after-install.sh \
--before-remove kubernetes/controller-manager/scripts/deb/before-remove.sh \
--deb-upstart kubernetes/controller-manager/services/upstart/kube-controller-manager \
--deb-default kubernetes/controller-manager/initd_config/kube-controller-manager \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kube-controller-manager=/usr/bin/kube-controller-manager

fpm -s dir -n "kubernetes-proxy" \
-p kubernetes/builds \
-C ./kubernetes/proxy -v $K8S_VERSION \
-t deb \
-a amd64 \
-d "dpkg (>= 1.17)" \
-d "kubernetes-common (= $K8S_VERSION)" \
--license "Apache Software License 2.0" \
--maintainer "Helion Stackato <support@stackato.com>" \
--vendor "Hewlett Packard Enterprise" \
--description "Kubernetes Proxy" \
--url "http://www.stackato.com" \
--after-install kubernetes/proxy/scripts/deb/after-install.sh \
--before-remove kubernetes/proxy/scripts/deb/before-remove.sh \
--deb-upstart kubernetes/proxy/services/upstart/kube-proxy \
--deb-default kubernetes/proxy/initd_config/kube-proxy \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kube-proxy=/usr/bin/kube-proxy

fpm -s dir -n "kubernetes-scheduler" \
-p kubernetes/builds \
-C ./kubernetes/scheduler -v $K8S_VERSION \
-t deb \
-a amd64 \
-d "dpkg (>= 1.17)" \
-d "kubernetes-common (= $K8S_VERSION)" \
--license "Apache Software License 2.0" \
--maintainer "Helion Stackato <support@stackato.com>" \
--vendor "Hewlett Packard Enterprise" \
--description "Kubernetes Scheduler" \
--url "http://www.stackato.com" \
--after-install kubernetes/scheduler/scripts/deb/after-install.sh \
--before-remove kubernetes/scheduler/scripts/deb/before-remove.sh \
--deb-upstart kubernetes/scheduler/services/upstart/kube-scheduler \
--deb-default kubernetes/scheduler/initd_config/kube-scheduler \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kube-scheduler=/usr/bin/kube-scheduler

fpm -s dir -n "kubernetes-kubectl" \
-p kubernetes/builds \
-C ./kubernetes/kubectl -v $K8S_VERSION \
-t deb \
-a amd64 \
-d "dpkg (>= 1.17)" \
-d "kubernetes-common (= $K8S_VERSION)" \
--license "Apache Software License 2.0" \
--maintainer "Helion Stackato <support@stackato.com>" \
--vendor "Hewlett Packard Enterprise" \
--description "Kubernetes Kubectl" \
--url "http://www.stackato.com" \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kubectl=/usr/bin/kubectl

fpm -s dir -n "kubernetes-kubelet" \
-p kubernetes/builds \
-C ./kubernetes/kubelet -v $K8S_VERSION \
-t deb \
-a amd64 \
-d "dpkg (>= 1.17)" \
-d "kubernetes-common (= $K8S_VERSION)" \
--deb-pre-depends "openssl" \
--license "Apache Software License 2.0" \
--maintainer "Helion Stackato <support@stackato.com>" \
--vendor "Hewlett Packard Enterprise" \
--description "Kubernetes Kubelet" \
--url "http://www.stackato.com" \
--after-install kubernetes/kubelet/scripts/deb/after-install.sh \
--before-remove kubernetes/kubelet/scripts/deb/before-remove.sh \
--deb-upstart kubernetes/kubelet/services/upstart/kubelet \
--deb-default kubernetes/kubelet/initd_config/kubelet \
../source/kubernetes/v$K8S_VERSION/kubernetes/server/bin/kubelet=/usr/bin/kubelet

## Meta packages for backwards compat

fpm -s dir -n "kubernetes-master" \
-p kubernetes/builds \
-v $K8S_VERSION \
-t deb \
-a amd64 \
-d "dpkg (>= 1.17)" \
-d "kubernetes-common (= $K8S_VERSION)" \
-d "kubernetes-apiserver (= $K8S_VERSION)" \
-d "kubernetes-controller-manager (= $K8S_VERSION)" \
-d "kubernetes-scheduler (= $K8S_VERSION)" \
-d "kubernetes-kubectl (= $K8S_VERSION)" \
-d "kubernetes-kubelet (= $K8S_VERSION)" \
--license "Apache Software License 2.0" \
--maintainer "Helion Stackato <support@stackato.com>" \
--vendor "Hewlett Packard Enterprise" \
--description "Kubernetes Master Metapackage" \
--url "http://www.stackato.com" \
-s empty

fpm -s dir -n "kubernetes-node" \
-p kubernetes/builds \
-v $K8S_VERSION \
-t deb \
-a amd64 \
-d "dpkg (>= 1.17)" \
-d "kubernetes-common (= $K8S_VERSION)" \
-d "kubernetes-proxy (= $K8S_VERSION)" \
-d "kubernetes-kubectl (= $K8S_VERSION)" \
-d "kubernetes-kubelet (= $K8S_VERSION)" \
--license "Apache Software License 2.0" \
--maintainer "Helion Stackato <support@stackato.com>" \
--vendor "Hewlett Packard Enterprise" \
--description "Kubernetes Node Metapackage" \
--url "http://www.stackato.com" \
-s empty
