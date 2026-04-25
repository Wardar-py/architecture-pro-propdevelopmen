## Порядок проверки

### 1. Создание пользователей
```bash
 chmod +x create_users.sh && ./create_users.sh
 ```

### 2. Применение ролей пользователей
```bash
kubectl apply -f roles.yaml
```

### 2. Применение привязки ролей пользователей
```bash
kubectl apply -f roles_bindings.yaml
```

### 3. Проверка
```bash
kubectl auth can-i get pods --as=system:serviceaccount:default:viewer-analyst 
```
Ответ должен быть yes