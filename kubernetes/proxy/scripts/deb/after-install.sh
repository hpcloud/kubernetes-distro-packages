#!/bin/bash

# if [ $1 -eq 1 ] ; then
        # Initial installation
        ln -sf /lib/init/upstart-job /etc/init.d/kube-proxy
        update-rc.d kube-proxy defaults >/dev/null 2>&1 || :
# fi
