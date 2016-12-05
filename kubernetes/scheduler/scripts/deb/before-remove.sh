#!/bin/bash

# if [ $1 -eq 0 ] ; then
        # Package removal, not upgrade
        chkconfig kube-scheduler off >/dev/null 2>&1 || :
        service kube-scheduler stop >/dev/null 2>&1 || :
        update-rc.d -f kube-scheduler remove >/dev/null 2>&1 || :
# fi
