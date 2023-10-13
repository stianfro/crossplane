#!/bin/bash

kubectl apply -f compositions/webapp.yaml
kubectl apply -f xrds/xwebapp.yaml
kubectl apply -f claims/example.yaml
kubectl apply -f claims/example-qa.yaml
kubectl apply -f claims/example-prod.yaml
