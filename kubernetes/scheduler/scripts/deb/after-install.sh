#!/bin/bash

# if [ $1 -eq 1 ] ; then
        # Initial installation
        ln -sf /lib/init/upstart-job /etc/init.d/kube-scheduler
        update-rc.d kube-scheduler defaults >/dev/null 2>&1 || :
# fi
