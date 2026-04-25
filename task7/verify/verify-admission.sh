#!/bin/bash

echo "=== Проверка блокировки привилегированного пода ==="
kubectl apply -f ../insecure-manifests/01-privileged-pod.yaml --dry-run=server 2>&1 | grep -q "Forbidden"
if [ $? -eq 0 ]; then
    echo "PASS: privileged pod rejected"
else
    echo "FAIL: privileged pod should be rejected"
fi

echo "=== Проверка блокировки hostPath ==="
kubectl apply -f ../insecure-manifests/02-hostpath-pod.yaml --dry-run=server 2>&1 | grep -q "Forbidden"
if [ $? -eq 0 ]; then
    echo "PASS: hostPath pod rejected"
else
    echo "FAIL: hostPath pod should be rejected"
fi

echo "=== Проверка блокировки root пользователя ==="
kubectl apply -f ../insecure-manifests/03-root-user-pod.yaml --dry-run=server 2>&1 | grep -q "Forbidden"
if [ $? -eq 0 ]; then
    echo "PASS: root user pod rejected"
else
    echo "FAIL: root user pod should be rejected"
fi