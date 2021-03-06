#!/bin/bash 
if [ "$(hostname -s|grep -c master)" -ne 1 ]; then
    echo "This must be run on the master..."
    exit 1
fi

cd /vagrant/cluster
rm -fr caasp4-cluster 2>/dev/null
echo "Initializing cluster..."
set -x
skuba cluster init --control-plane caasp4-lb-1 caasp4-cluster
set +x
