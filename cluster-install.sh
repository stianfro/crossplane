#!/bin/bash

ctlptl apply -f cluster.yaml

helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update
helm install crossplane --namespace crossplane-system \
                        --create-namespace crossplane-stable/crossplane

sleep 10

kubectl wait --namespace crossplane-system \
             --for=condition=ready pod \
             --selector=app.kubernetes.io/instance=crossplane \
             --timeout=90s

cat << EOF | kubectl apply -f -
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-kubernetes
spec:
  package: "crossplanecontrib/provider-kubernetes:main"
EOF

echo "Sleeping for 10 seconds"
sleep 10

SA=$(kubectl -n crossplane-system get sa -o name | grep provider-kubernetes | sed -e 's|serviceaccount\/|crossplane-system:|g')
kubectl create clusterrolebinding provider-kubernetes-admin-binding --clusterrole cluster-admin --serviceaccount="${SA}"

cat << EOF | kubectl apply -f -
apiVersion: kubernetes.crossplane.io/v1alpha1
kind: ProviderConfig
metadata:
  name: kubernetes-provider
spec:
  credentials:
    source: InjectedIdentity
EOF
