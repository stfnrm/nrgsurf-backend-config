# CitrinOS Kubernetes Deployment Guide

This guide provides steps to deploy and manage CitrinOS on Kubernetes using Helm charts and Kubernetes manifests.

## Getting Started

Clone the repository:
```bash
git clone https://github.com/stfnrm/nrgsurf-backend-config.git
```

### Prerequisites

- Kubernetes cluster (EKS, Minikube, or any K8s setup)
- kubectl installed and configured
- Helm installed
- Access to the necessary container images and repositories

## 🚀 Deployment Steps

### 1. Deploy with Helm Chart

Install the Helm chart for your environment:

For Development:
```bash
helm install dev-citrinos ./citrin-os --values ./citrin-os/values-dev.yaml
```

For Production:
```bash
helm install prod-citrinos ./citrin-os --values ./citrin-os/values-prod.yaml
```

Verify deployment status:
```bash
helm list
kubectl get pods -n citrinos
```

Update configuration and apply changes:
```bash
helm upgrade --install dev-citrinos ./citrin-os --values ./citrin-os/values-dev.yaml
```

### 2. Configure Ingress Resources

Ingress resources are now managed separately from the Helm chart for more precise service exposure:

```bash
kubectl apply -f ingress/8081.yaml         # Expose Citrine service
kubectl apply -f ingress/grafana-ingress.yaml  # Expose Grafana dashboards
kubectl apply -f ingress/ingress.yaml      # Expose Directus dashboard
```

This approach allows for customized routing, TLS configuration, and annotations for each exposed service.

### 3. Enable Loki for Logging

To deploy Loki with Promtail and Grafana:
```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install loki grafana/loki-stack
```

✅ The CitrinOS Helm chart automatically configures the Loki datasource in Grafana if you're using Grafana from this stack, as it's pre-defined in the values files.

## 🧹 Cleanup

To remove the deployment:
```bash
helm uninstall dev-citrinos
```

To remove ingress resources:
```bash
kubectl delete -f ingress/
```

## 📌 Important Notes

- During initial deployment, some pods (Citrine, Directus) may enter a backoff state while waiting for dependencies like PostgreSQL and RabbitMQ to initialize.
- Ingress resources should be applied after the Helm chart deployment to ensure all referenced services exist.
- Check logs if services do not start properly: `kubectl logs -n citrinos <pod-name>`
