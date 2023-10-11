#!/bin/bash

# Applying the Composite Resource Definition (XRD)
kubectl apply -f xrd/webapplication-xrd.yaml
kubectl get compositeresourcedefinition.apiextensions.crossplane.io/webapplications.example.com

# Waiting for the XRD to be registered
echo "Waiting for XRD to be registered..."
sleep 10  # Adjust this value as needed

# Applying the Composition
kubectl apply -f compositions/webapplication-composition.yaml

# Waiting for the Composition to be registered
echo "Waiting for Composition to be registered..."
sleep 10  # Adjust this value as needed

# Applying the Composite Resource (XR)
kubectl apply -f xr/test-app.yaml

echo "Resources have been applied to the cluster."
