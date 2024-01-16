# Documentation for ML-App Project

## Overview
This document provides instructions on how to run and deploy the ML-App, a FastAPI application, using Docker and Kubernetes. The application is containerized using Docker and can be deployed on a Kubernetes cluster.

## Prerequisites
- Docker installed on your machine.
- Kubernetes cluster or Minikube for local deployment.
- `kubectl` command-line tool installed and configured to interact with your Kubernetes cluster.

## Running the Application Locally with Docker

### Building the Docker Image
1. Navigate to the root directory of the project where the Dockerfile is located.

2. Build the Docker image:
   ```bash
   docker build -t ml-app .
   ```

### Running the Docker Container
1. Run the container:
   ```bash
   docker run -p 8080:8080 -it ml-app
   ```

2. Access the application:
   - Open a web browser and navigate to `http://localhost:8080`.

## Deploying the Application on Kubernetes

### Prerequisites for Kubernetes Deployment
- Make sure your Kubernetes cluster is running.
- For local testing with Minikube, start Minikube with `minikube start --vm-driver=qemu`.

### Creating a Kubernetes Deployment

1. Create a `deployment.yaml` file with the following content:

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: ml-app-deployment
     labels:
       app: ml-app
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: ml-app
     template:
       metadata:
         labels:
           app: ml-app
       spec:
         containers:
         - name: ml-app
           image: ml-app:latest
           imagePullPolicy: Never
           ports:
           - containerPort: 8080
   ```

   - **Note**: `imagePullPolicy: Never` is used for local images. If you're using a registry, set this to `IfNotPresent` and use the full image name.

2. Apply the deployment file:
   ```bash
   kubectl apply -f deployment.yaml
   ```

### Creating a Kubernetes Service

1. Create a `service.yaml` file with the following content:

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: ml-app-service
   spec:
     type: LoadBalancer
     selector:
       app: ml-app
     ports:
       - protocol: TCP
         port: 8080
         targetPort: 8080
   ```

2. Apply the service file:
   ```bash
   kubectl apply -f service.yaml
   ```

### Accessing the Application

- **Using LoadBalancer (Cloud Environments)**:
  - Get the external IP of the service:
    ```bash
    kubectl get service ml-app-service
    ```
  - Access the application via the external IP in the browser.

- **Using Minikube (Optional)**:
  - Run the Minikube tunnel in a separate terminal:
    ```bash
    minikube tunnel
    ```
  - Get the URL of the service:
    ```bash
    minikube service ml-app-service --url
    ```
  - Access the application via the provided URL.

### Port Forwarding (Alternative Method)

- If you prefer not to use a LoadBalancer, you can use port forwarding:
  ```bash
  kubectl port-forward service/ml-app-service 8080:8080
  ```
- Access the application at `http://localhost:8080`.

## Conclusion

This document covers the basic steps to build, run, and deploy the ML-App using Docker and Kubernetes. Adjustments might be needed based on your specific environment or requirements.
