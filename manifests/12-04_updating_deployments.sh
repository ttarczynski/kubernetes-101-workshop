#!/bin/bash

set -x

#############################
## 1. Scaling a deployment ##
#############################

# 1.1 modify the manifet:
sed -i.1 's/replicas: 2/replicas: 3/' tmp/nginx-deployment.yaml
diff tmp/nginx-deployment.yaml{.1,}
read -p "Continue?"

# 1.2 apply the modified manifet
kubectl apply -f tmp/nginx-deployment.yaml
kubectl get deployments nginx
read -p "Continue?"

###################################
## 2. Updating a Container Image ##
###################################

# 2.1. motify the manifest:
SED_SCRIPT='
s/image: nginx:1.7.12/image: nginx:1.9.10/
s/imagePullPolicy: IfNotPresent/imagePullPolicy: Always/
/^    metadata:/a \
      annotations:\
        kubernetes.io/change-cause: "update nginx to 1.9.10"
'
sed -i.2 "${SED_SCRIPT}" tmp/nginx-deployment.yaml
diff tmp/nginx-deployment.yaml{.2,}
read -p "Continue?"

# 2.2. apply the modified manifet
kubectl apply -f tmp/nginx-deployment.yaml
kubectl rollout status deployments nginx &

# 2.3. observe how rollout pause and resume work
kubectl rollout pause deployments nginx
read -p "Continue?"

kubectl get replicasets -o wide
read -p "Continue?"

kubectl rollout resume deployments nginx
kubectl get replicasets -o wide
read -p "Continue?"


########################
## 3. Rollout History ##
########################

# 3.1. display rollout history
kubectl rollout history deployment nginx
read -p "Continue?"

# 3.2. display a particular rollout revision
kubectl rollout history deployment nginx --revision=2
read -p "Continue?"

# 3.3. motify the manifest:
SED_SCRIPT='
s/image: nginx:1.9.10/image: nginx:1.10.2/
s#kubernetes.io/change-cause: "update nginx to 1.9.10"#kubernetes.io/change-cause: "update nginx to 1.10.2"#
'
sed -i.3 "${SED_SCRIPT}" tmp/nginx-deployment.yaml
diff tmp/nginx-deployment.yaml{.3,}
read -p "Continue?"

# 3.3. apply the modified manifet
kubectl apply -f tmp/nginx-deployment.yaml
kubectl rollout status deployments nginx
read -p "Continue?"

# 3.4. display rollout history
kubectl rollout history deployment nginx
read -p "Continue?"

# 3.5. rollback back the last deployment
kubectl rollout undo deployments nginx
kubectl rollout status deployments nginx
read -p "Continue?"

# 3.6. display rollout history
kubectl rollout history deployment nginx
read -p "Continue?"

# 3.7 see replicasets:
kubectl get replicasets -o wide
read -p "Continue?"

# 3.8. rollback to a specific revision
kubectl rollout undo deployments nginx --to-revision=3
read -p "Continue?"

kubectl rollout history deployment nginx
read -p "Continue?"

# 3.9. limit the revision history to 14
SED_SCRIPT='
/^spec:/a \
  revisionHistoryLimit: 14
'
sed -i.4 "${SED_SCRIPT}" tmp/nginx-deployment.yaml
diff tmp/nginx-deployment.yaml{.4,}
read -p "Continue?"

kubectl apply -f tmp/nginx-deployment.yaml
read -p "Continue?"
