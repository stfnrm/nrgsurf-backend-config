## Development Environment Configuration Guide  

This guide explains the main configurations in `values.yaml` for running CitrinOS in a development environment.  

### **1. Monitoring Stack Configuration**  
- **Enable/Disable Monitoring**  
  ```yaml
  monitoring:
    enabled: true
  ```
  - Set `true` to enable Prometheus, Grafana, and Loki; `false` to disable.  

### **2. Namespace Configuration**  
- **Kubernetes Namespace**  
  ```yaml
  namespace:
    name: citrinos
  ```
  - Defines the namespace where all services will be deployed.  

### **3. Directus - Headless CMS Configuration**  
- **Service Details**  
  ```yaml
  directus:
    name: directus
    port: 8055
  ```
  - Runs on port `8055` inside the Kubernetes cluster.  

- **Resource Allocation**  
  ```yaml
  resources:
    requests:
      cpu: "250m"
      memory: "512Mi"
    limits:
      cpu: "500m"
      memory: "1024Mi"
  ```
  - Defines minimum and maximum CPU/memory allocation.  

### **4. Citrine - Main Application Service**  
- **Service Ports**  
  ```yaml
  ports:
    - port: 8080
    - port: 8081
    - port: 8082
    - port: 8085
    - port: 8443
    - port: 8444
  ```
  - Configures various ports for different functionalities.  

- **Resource Allocation**  
  ```yaml
  resources:
    requests:
      cpu: "500m"
      memory: "900Mi"
    limits:
      cpu: "1"
      memory: "2Gi"
  ```
  - Ensures optimal resource usage for the Citrine service.  

### **5. RabbitMQ - Message Broker**  
- **Ports Configuration**  
  ```yaml
  ports:
    - name: management
      port: 15672
    - name: amqp
      port: 5672
  ```
  - `15672`: Management UI  
  - `5672`: AMQP protocol communication.  

- **Persistent Storage**  
  ```yaml
  persistence:
    enabled: true
    size: 1Gi
  ```
  - Enables persistent storage with `1Gi` allocated.  

### **6. PostgreSQL - Database Configuration**  
- **Database Information**  
  ```yaml
  database:
    name: "citrine"
    user: "citrine"
    password: "citrine"
  ```
  - Defines credentials for PostgreSQL access.  

- **Storage Configuration**  
  ```yaml
  persistence:
    enabled: true
    size: 100Mi
  ```
  - Allocates `100Mi` persistent storage for the database.  

### **7. MQTT - Message Queue Configuration**  
- **Port Assignment**  
  ```yaml
  service:
    port: 1883
  ```
  - MQTT server listens on port `1883`.  

### **8. Ingress Configuration**  
- **CitrineOS Ingress**  
  ```yaml
  citrinosIngress:
    enabled: false
    rules:
      - host: dashboard.nrgsurf.de
        service:
          name: directus
          port: 8055
  ```
  - Defines an optional ingress for accessing Directus externally.  

- **Grafana Ingress**  
  ```yaml
  grafanaIngress:
    enabled: false
    host: grafana.nrgsurf.de
    service:
      port: 3000
  ```
  - Allows external access to Grafana if enabled.  

This guide highlights the key configurations for deploying CitrinOS in development. Adjust values as needed for your environment. 🚀