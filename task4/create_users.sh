#!/bin/bash
# create-users.sh
# Создание ServiceAccount для представления пользователей и генерация kubeconfig (опционально)

set -e

NAMESPACES=("sales" "housing" "finance" "data")
USERS=(
  "developer-sales"
  "developer-housing"
  "developer-finance"
  "developer-data"
  "viewer-analyst"
  "viewer-manager"
  "cluster-operator"
  "security-admin"
)

# Создание namespace'ов (если ещё не созданы)
for ns in "${NAMESPACES[@]}"; do
  kubectl create namespace "$ns" --dry-run=client -o yaml | kubectl apply -f -
done

# Создание ServiceAccount для разработчиков (в их namespace'ах)
for ns in "${NAMESPACES[@]}"; do
  kubectl create serviceaccount "developer" -n "$ns" --dry-run=client -o yaml | kubectl apply -f -
done

# Создание ServiceAccount для зрителей (в default namespace или в отдельных, но они кластерные)
kubectl create serviceaccount "viewer-analyst" -n default --dry-run=client -o yaml | kubectl apply -f -
kubectl create serviceaccount "viewer-manager" -n default --dry-run=client -o yaml | kubectl apply -f -

# Создание ServiceAccount для операторов и безопасников (kube-system или default)
kubectl create serviceaccount "cluster-operator" -n kube-system --dry-run=client -o yaml | kubectl apply -f -
kubectl create serviceaccount "security-admin" -n kube-system --dry-run=client -o yaml | kubectl apply -f -

echo "ServiceAccounts созданы."
