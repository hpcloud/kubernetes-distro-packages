#!/bin/bash

# if [ $1 -eq 1 ] ; then
        # Initial installation
        ln -sf /lib/init/upstart-job /etc/init.d/kubelet
        update-rc.d kubelet defaults >/dev/null 2>&1 || :
# fi
