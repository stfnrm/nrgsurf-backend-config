# CitrinOS Development Environment Configuration Guide

This guide explains how to configure and deploy CitrinOS in a development environment using Helm charts and Kubernetes.

## 1. Core Configuration Settings

### Monitoring Stack
```yaml
monitoring:
  enabled: true  # Set to true to enable Prometheus, Grafana, and Loki; false to disable
```

### Namespace Configuration
```yaml
namespace:
  name: citrinos  # Defines the Kubernetes namespace for all services
```

## 2. Service Configurations

### Directus - Headless CMS
```yaml
directus:
  name: directus
  port: 8055  # Port inside the Kubernetes cluster
  resources:
    requests:
      cpu: "250m"
      memory: "512Mi"
    limits:
      cpu: "500m"
      memory: "1024Mi"
```

### Citrine - Main Application Service
```yaml
ports:
  - port: 8080
  - port: 8081
  - port: 8082
  - port: 8085
  - port: 8443
  - port: 8444
resources:
  requests:
    cpu: "500m"
    memory: "900Mi"
  limits:
    cpu: "1"
    memory: "2Gi"
```

### RabbitMQ - Message Broker
```yaml
ports:
  - name: management
    port: 15672  # Management UI
  - name: amqp
    port: 5672   # AMQP protocol communication
persistence:
  enabled: true
  size: 1Gi      # Persistent storage allocation
```

### PostgreSQL - Database
```yaml
database:
  name: "citrine"
  user: "citrine"
  password: "citrine"
persistence:
  enabled: true
  size: 100Mi    # Storage allocation for database
```

### MQTT - Message Queue
```yaml
service:
  port: 1883     # MQTT server port
```

## 3. Ingress Configuration

Ingress resources are managed separately through YAML files and must be applied individually:

```bash
kubectl apply -f ingress/8081.yaml         # Citrine service on 8081.nrgsurf.de
kubectl apply -f ingress/grafana-ingress.yaml  # Grafana on grafana.nrgsurf.de
kubectl apply -f ingress/ingress.yaml      # Dashboard on dashboard.nrgsurf.de
```

### Citrine Service Ingress (8081.yaml)
Exposes the Citrine service port 8081 at `8081.nrgsurf.de` with TLS enabled and WebSocket support.

### Grafana Ingress (grafana-ingress.yaml)
Provides secure access to Grafana dashboards at `grafana.nrgsurf.de`.

### Dashboard Ingress (ingress.yaml)
Routes requests to Directus CMS at `dashboard.nrgsurf.de` for administration access.

## 4. Deployment

To apply your configuration and deploy/update CitrinOS:

```bash
helm upgrade --install dev-citrinos ./citrin-os --values ./citrin-os/values-dev.yaml
```

## Important Notes

- Adjust resource allocations based on your development environment capabilities
- All ingress configurations use cert-manager with Let's Encrypt for TLS
- The Directus CMS is accessible via port 8055 inside the cluster
