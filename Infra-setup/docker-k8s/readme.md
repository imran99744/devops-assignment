# Deploying a Node.js Application to Kubernetes

This directory (`docker-k8s/`) contains the necessary files to deploy a simple Node.js application to a Kubernetes cluster.

## Application Overview

The application is a basic Node.js server that listens on port 3000 and returns a simple message. It is containerized using Docker and deployed to Kubernetes using a deployment YAML file.

## Files

- **`Dockerfile`**: Defines the steps to build the Docker image for the application.
- **`deployment.yaml`**: Defines the Kubernetes deployment for the application.
- **`app.js`**: The Node.js application code.

## Deployment Steps

### 1. Existing Playground Setup (with ArgoCD)

**Context:** I have a dedicated Kubernetes playground (i have premium subscription there) environment with ArgoCD pre-configured. This setup allows for automated deployments based on GitOps principles, simplifying the application deployment process.

1.  **Build the Docker Image:**
    ```bash
    docker build -t node-app:latest .
    ```
2.  **Push the Docker Image:**
    - Push the image to a container registry (I pushed to my Docker Hub).
    - Replace `<your-registry>/node-app:latest` in `deployment.yaml` with your image location.
3.  **Apply the Deployment:**
    - Since I have ArgoCD set up in my playground, commit the `deployment.yaml` to a Git repository.
    - ArgoCD will automatically detect the changes and deploy the application to my Kubernetes cluster.
4.  **Port Forwarding:**
    ```bash
    kubectl port-forward deployment/node-app-deployment 3000:3000
    ```
5.  **Access the Application:**
    - Open my web browser and navigated to `https://67dbb4774e828cad9173d17b-cd4c7e.node-c9a5.iximiuz.com/`. it will valid for 1 hour only.

### 2. Let's say we will deploy it to AWS EKS

1.  **Create an EKS Cluster:**
    - Use `eksctl`, `aws cli`, or the AWS Management Console to create an EKS cluster.
2.  **Configure `kubectl`:**
    - Configure `kubectl` to connect to your EKS cluster.
    ```bash
    aws eks update-kubeconfig --name <your-cluster-name> --region <your-region>
    ```
3.  **Build and Push the Docker Image:**
    - Build and push the Docker image to Amazon ECR.
4.  **Apply the Deployment:**
    ```bash
    kubectl apply -f deployment.yaml
    ```
5.  **Create a Load Balancer (Optional):**
    - If you want to expose the application externally, create a LoadBalancer service.
