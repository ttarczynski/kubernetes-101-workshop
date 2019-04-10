#!/bin/bash

set -x

# cleanup
kubectl delete rs,svc,job -l chapter=jobs
