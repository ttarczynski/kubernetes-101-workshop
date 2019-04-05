#!/bin/bash

set -x
set -eu

# CONSTATNTS
node_nums=`seq 101 103`

for i in $node_nums; do
  ssh -F ./ssh-config root@ks${i} "rdate -s ntp.task.gda.pl"
done
