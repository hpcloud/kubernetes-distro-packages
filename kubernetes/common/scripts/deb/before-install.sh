#!/bin/bash

mkdir -p -m 755 /var/run/kubernetes

getent group kube >/dev/null || groupadd -r kube
getent passwd kube >/dev/null || useradd -r -g kube -d /var/run/kubernetes -s /sbin/nologin \
        -c "Kubernetes user" kube

chown -R kube /var/run/kubernetes
chgrp -R kube /var/run/kubernetes
