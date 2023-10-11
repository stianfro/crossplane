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
