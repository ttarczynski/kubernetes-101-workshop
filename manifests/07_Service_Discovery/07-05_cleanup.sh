#!/bin/bash

set -x

# Delete everything from this chapter
kubectl delete services,deployments -l app
