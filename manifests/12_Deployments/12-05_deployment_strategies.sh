#!/bin/bash

set -x

###############################
## 1. RollingUpdate Strategy ##
###############################

# 1.1. recreate deployment example:

# motify the manifest:
SED_SCRIPT='
s/image: nginx:.\+/image: nginx:1.10.3/
s/maxSurge: .\+/maxSurge: 0/
s/maxUnavailable: .\+/maxUnavailable: 100%/
'
sed -i.5 "${SED_SCRIPT}" tmp/nginx-deployment.yaml
diff tmp/nginx-deployment.yaml{.5,}
read -p "Continue?"

# apply the modified manifet
kubectl apply -f tmp/nginx-deployment.yaml
kubectl rollout status deployments nginx
read -p "Continue?"

# 1.2. blue/green deployment example:

# motify the manifest:
SED_SCRIPT='
s/image: nginx:1.10.3/image: nginx:1.11.4/
s/maxSurge: 0/maxSurge: 100%/
s/maxUnavailable: 100%/maxUnavailable: 0/
'
sed -i.6 "${SED_SCRIPT}" tmp/nginx-deployment.yaml
diff tmp/nginx-deployment.yaml{.6,}
read -p "Continue?"

# apply the modified manifet
kubectl apply -f tmp/nginx-deployment.yaml
kubectl rollout status deployments nginx
read -p "Continue?"


##################################################
## 2. Slowing Rollouts to Ensure Service Health ##
##################################################

# 2.1. set minReadySeconds and progressDeadlineSeconds

# motify the manifest:
SED_SCRIPT='
s/image: nginx:1.11.4/image: nginx:1.11.5/
s/maxSurge:.\+/maxSurge: 1/
s/maxUnavailable:.\+/maxUnavailable: 0/
/^spec:/a \
  minReadySeconds: 60\
  progressDeadlineSeconds: 600
'
sed -i.7 "${SED_SCRIPT}" tmp/nginx-deployment.yaml
diff tmp/nginx-deployment.yaml{.7,}
read -p "Continue?"

# apply the modified manifet
kubectl apply -f tmp/nginx-deployment.yaml
kubectl rollout status deployments nginx
read -p "Continue?"
