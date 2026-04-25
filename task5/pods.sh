# Создание подов с метками
kubectl run front-end-app --image=nginx --labels=role=front-end
kubectl run back-end-api-app --image=nginx --labels=role=back-end-api
kubectl run admin-front-end-app --image=nginx --labels=role=admin-front-end
kubectl run admin-back-end-api-app --image=nginx --labels=role=admin-back-end-api

# Создание сервисов для каждого пода
kubectl expose pod front-end-app --port=80 --name=front-end-svc
kubectl expose pod back-end-api-app --port=80 --name=back-end-api-svc
kubectl expose pod admin-front-end-app --port=80 --name=admin-front-end-svc
kubectl expose pod admin-back-end-api-app --port=80 --name=admin-back-end-api-svc