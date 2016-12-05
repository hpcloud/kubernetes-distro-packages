#!/bin/bash

# if [ $1 -eq 0 ] ; then
        # Package removal, not upgrade
        chkconfig kube-controller-manager off >/dev/null 2>&1 || :
        service kube-controller-manager stop >/dev/null 2>&1 || :
        update-rc.d -f kube-controller-manager remove >/dev/null 2>&1 || :
# fi
