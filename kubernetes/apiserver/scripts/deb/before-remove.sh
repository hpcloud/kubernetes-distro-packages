#!/bin/bash

# if [ $1 -eq 0 ] ; then
        # Package removal, not upgrade
        chkconfig kube-apiserver off >/dev/null 2>&1 || :
        service kube-apiserver stop >/dev/null 2>&1 || :
        update-rc.d -f kube-apiserver remove >/dev/null 2>&1 || :
# fi
