## Kubernetes Deployment Guide

This guide provides steps to deploy and manage Kubernetes resources using Helm and Kubernetes manifests.

Clone the Repo
```
git clone https://github.com/jyothiram266/citirin-k8s-depolyment.git
```

### Prerequisites

- Kubernetes cluster (EKS, Minikube, or any K8s setup)
- kubectl installed and configured
- Helm installed 
- Access to the necessary container images and repositories

## 🚀 Deployment Steps

#### 1.Apply the Helm Chart

created, install the Helm chart (citrin-os):

for Dev
```
helm install dev-citrinos ./citrin-os --values ./citrin-os/values-dev.yaml
```

for Prod

```
helm install prod-citrinos ./citrin-os --values ./citrin-os/values-prod.yaml
```
Confirm that the deployment is running successfully:

```
helm list
kubectl get pods -n citrin-os
```

you can upgrade the values and to reflect the changes run the following command accordingly

```
helm upgrade <HELM_NAME> ./citrin-os --values ./citrin-os/values-<dev-prod>.yaml 
```
#### 🔗 Enable Loki for Logging
To deploy Loki (along with Promtail and Grafana, if needed), run:

```
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install loki grafana/loki-stack
```
✅ The citrin-os Helm chart automatically configures the Loki datasource in Grafana if you're using Grafana from this stack — because it's pre-defined in the values-dev.yaml and values-prod.yaml.

#### 2. Updating the Deployment

If any changes are made in values-dev.yaml or values-prod.yaml
To upgrade the Helm release with new configurations:

```
helm upgrade <HELM_NAME> ./citrin-os --values ./citrin-os/values-<dev-prod>.yaml 
```

## 5️⃣ Cleanup the Deployment
#### To remove the Helm release:

```
helm uninstall <HELM-CHART-NAME>
```

# 📌 Notes
- Deploy the Helm chart (citrin-os/) afterward ensure dependents services are available. At intial stages Citirus , Diritus pods may go backoff state because of the DB and rabbitmq may take more time to get ready to run