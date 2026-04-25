## Требования к среде
- Kubernetes кластер (Minikube с поддержкой PodSecurity admission включён по умолчанию в v1.23+).
- Установленный OPA Gatekeeper (опционально, если проверяется только PodSecurity).

## Порядок проверки

### 1. Создание namespace с PodSecurity restricted
```bash
kubectl apply -f 01-create-namespace.yaml
```

### 2. Проверка работы PodSecurity admission (без Gatekeeper)

Примените insecure манифесты. Они должны быть отклонены:
```bash 
kubectl apply -f insecure-manifests/01-privileged-pod.yaml
kubectl apply -f insecure-manifests/02-hostpath-pod.yaml
kubectl apply -f insecure-manifests/03-root-user-pod.yaml
```

Примените secure манифесты. Они должны создаться успешно:
```bash
kubectl apply -f secure-manifests/01-secure.yaml
kubectl apply -f secure-manifests/02-secure.yaml
kubectl apply -f secure-manifests/03-secure.yaml
```

### 3. Установка и настройка Gatekeeper

```bash
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
kubectl apply -f gatekeeper/constraint-templates/
kubectl apply -f gatekeeper/constraints/
```

После этого повторите попытки создания insecure подов – Gatekeeper также должен их отклонить с соответствующими сообщениями.

### 4. Запуск проверочных скриптов

``` bash
cd verify/
chmod +x verify-admission.sh validate-security.sh
./verify-admission.sh   # Ожидается три PASS
./validate-security.sh  # Ожидается три PASS
```

### 5. Аудит

Политика аудита (audit-policy.yaml) может быть применена к API-серверу для логирования событий, связанных с подами.

```bash
minikube start --extra-config=apiserver.audit-policy-file=/etc/kubernetes/audit-policy.yaml ...
```

### Ожидаемый результат

- Insecure поды не создаются.
- Secure поды создаются.
- Скрипты проверки возвращают только PASS.
