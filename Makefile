minikube-start:
	minikube start

helm-init:
	helm init

create-dev:
	minikube addons enable ingress
	kubectl create namespace dev

	helm install stable/redis -n redis-dev --namespace dev -f k8s/helm/redis.yaml

	# Ingress
	kubectl apply -f k8s/ingress/ingress-dev.yaml -n dev

	# ConfigMaps
	kubectl apply -f k8s/configmap/dev/api-configmap.yaml
	kubectl apply -f k8s/configmap/dev/orchestrator-configmap.yaml
	kubectl apply -f k8s/configmap/dev/worker-configmap.yaml

	# Deployments and services
	kubectl apply -f k8s/deployments/api-deployment.yaml -n dev
	kubectl apply -f k8s/deployments/orchestrator-deployment.yaml -n dev
	kubectl apply -f k8s/deployments/worker-deployment.yaml -n dev

	kubectl apply -f k8s/deployments/api-svc.yaml -n dev
	kubectl apply -f k8s/deployments/orchestrator-svc.yaml -n dev

create-staging:
	minikube addons enable ingress
	kubectl create namespace staging

	helm install stable/redis -n redis-staging --namespace staging -f k8s/helm/redis.yaml

	# Ingress
	kubectl apply -f k8s/ingress/ingress-staging.yaml -n staging

	# Configmaps
	kubectl apply -f k8s/configmap/staging/api-configmap.yaml
	kubectl apply -f k8s/configmap/staging/orchestrator-configmap.yaml
	kubectl apply -f k8s/configmap/staging/worker-configmap.yaml

	# Deployments and services
	kubectl apply -f k8s/deployments/api-deployment.yaml -n staging
	kubectl apply -f k8s/deployments/orchestrator-deployment.yaml -n staging
	kubectl apply -f k8s/deployments/worker-deployment.yaml -n staging

	kubectl apply -f k8s/deployments/api-svc.yaml -n staging
	kubectl apply -f k8s/deployments/orchestrator-svc.yaml -n staging
