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
    - Opened my web browser and accessed the app in this url `https://67dbb4774e828cad9173d17b-cd4c7e.node-c9a5.iximiuz.com/`. it will be valid for 1 hour only. As of now this url is expeired. 

# Also added screen shots regarding this implementation. please check on inside `k8s-manifest/` directory. 

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


## Troubleshooting OOMKilled Errors in Kubernetes

**In my current organization, I directly experienced pods crashing with `OOMKilled` errors, significantly impacting application availability.** This required immediate troubleshooting. I quickly identified insufficient memory allocation as the root cause. **By promptly increasing the pod memory limits, I stabilized the application and prevented further disruptions.**

This hands-on experience underscored the importance of a structured approach to diagnosing and resolving `OOMKilled` issues. Here’s the process I followed:

### Diagnostic Steps

1.  **Rapidly Checked Pod Events:**
    * Used `kubectl describe pod <pod-name>` to confirm `OOMKilled` events and pinpoint the affected pods.

    ```bash
    kubectl describe pod <pod-name>
    ```

2.  **Analyzed Recent Pod Logs:**
    * Quickly reviewed `kubectl logs <pod-name>` to look for any immediate patterns or clues indicating memory spikes.

    ```bash
    kubectl logs <pod-name>
    ```

3.  **Immediately Verified Resource Limits and Requests:**
    * Checked the pod's deployment YAML to confirm the memory limits were inadequate.

    ```yaml
    resources:
      limits:
        memory: "512Mi" # Example (Original)
      requests:
        memory: "256Mi" # Example (Original)
    ```

4.  **Used `kubectl top` for Quick Memory Snapshot:**
    * Employed `kubectl top pod <pod-name>` to get a real-time view of memory usage and confirm the memory exhaustion.

    ```bash
    kubectl top pod <pod-name>
    ```

### Root Cause Analysis (RCA)

1.  **Identified the Trigger (Recent Traffic Surge):**
    * Determined that a recent traffic surge was the likely trigger for the increased memory consumption.

2.  **Analyzed Memory Usage Patterns (Observed Spikes):**
    * Noted consistent memory spikes leading to the `OOMKilled` events.

3.  **Reviewed Recent Code Changes (None Found):**
    * Quickly ruled out recent code changes as a factor.

4.  **Implemented Resource Adjustment (Increased Memory Limits):**
    * Immediately increased the pod's memory limits to resolve the issue.

5.  **Documented Findings and Actions (Sent to Senior):**
    * Documented the investigation, root cause, and the implemented solution, and shared it with my senior for review and approval.