# Enuygun DevOps Case Study

This is my solution for the Enuygun DevOps Engineer case study. In this project, I created a Google Kubernetes Engine (GKE) cluster using Terraform and deployed an application with monitoring, autoscaling, and service mesh tools.

## Architecture Diagram

![Architecture Diagram](images/architecture.png)

*(Note: The diagram shows the traffic flow and the cluster components.)*

## Tools and Technologies
* Cloud Provider: Google Cloud Platform (GCP)
* Infrastructure as Code: Terraform
* Container Orchestration: Kubernetes (GKE)
* Package Manager: Helm
* Monitoring: Prometheus & Grafana (kube-prometheus-stack)
* Autoscaling: KEDA
* Service Mesh: Istio

## Project Steps

1. **GKE Cluster:** Created a cluster named `enuygun-cluster` in the `europe-west1` region.
2. **Node Pools:** Created two separate node pools:
   - `main-pool`: Standard nodes for system components.
   - `application-pool`: Autoscaled nodes (1-3) only for the application.
3. **Application Deployment:** Deployed an Nginx app to the `application-pool` using `nodeSelector`.
4. **HPA:** Set up CPU-based scaling (1 to 5 pods) when CPU usage reaches 25%.
5. **Monitoring:** Installed Prometheus and Grafana using Helm.
6. **Grafana Alert:** Created an alert rule in Grafana using PromQL (`increase(kube_pod_container_status_restarts_total[5m])`) to catch pod restarts in the last 5 minutes.
7. **KEDA Integration:** Used a KEDA `ScaledObject` to manage CPU scaling instead of standard HPA.
8. **Istio Service Mesh:** Installed Istio components (istiod, ingress-gateway, egress-gateway) via Helm to manage traffic.

## Troubleshooting: GCP Quota Issue

During the Terraform deployment, I got a `RUNNING_WITH_ERROR` state because of the GCP Free Tier limit (maximum 8 vCPUs). The regional cluster was trying to create nodes in 3 different zones (europe-west1-a, b, c). 

To fix this problem, I changed the Terraform code to use only one specific zone (`node_locations = ["europe-west1-b"]`). This solved the quota issue and the cluster was created successfully.

## How to Run the Project

### 1. Terraform Deployment
```bash
cd terraform
terraform init
terraform apply