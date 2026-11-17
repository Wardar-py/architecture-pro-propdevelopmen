#!/bin/bash
# Проверка, что безопасные поды успешно проходят валидацию

echo "=== Проверка разрешения безопасного пода (бывший privileged) ==="
kubectl apply -f ../secure-manifests/01-secure.yaml --dry-run=server 2>&1 | grep -q "created\|configured\|unchanged"
if [ $? -eq 0 ]; then
    echo "PASS: secure pod (no privileged) allowed"
else
    echo "FAIL: secure pod should be allowed"
fi

echo "=== Проверка разрешения пода с emptyDir вместо hostPath ==="
kubectl apply -f ../secure-manifests/02-secure.yaml --dry-run=server 2>&1 | grep -q "created\|configured\|unchanged"
if [ $? -eq 0 ]; then
    echo "PASS: secure pod (no hostPath) allowed"
else
    echo "FAIL: secure pod should be allowed"
fi

echo "=== Проверка разрешения пода с runAsNonRoot ==="
kubectl apply -f ../secure-manifests/03-secure.yaml --dry-run=server 2>&1 | grep -q "created\|configured\|unchanged"
if [ $? -eq 0 ]; then
    echo "PASS: secure pod (non-root) allowed"
else
    echo "FAIL: secure pod should be allowed"
fi