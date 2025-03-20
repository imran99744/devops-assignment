# Jenkins CI/CD Pipeline Setup Guide

This instructions contains a complete guide for setting up a CI/CD pipeline using Jenkins, featuring parallel test execution and secure credential management.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation Steps](#installation-steps)
- [Pipeline Features](#pipeline-features)
- [Security Best Practices](#security-best-practices)
- [Pipeline Configuration](#pipeline-configuration)

## Prerequisites

Before starting the setup, ensure you have:
- Jenkins server (Latest LTS version)
- Git repository access
- Maven/Node.js/required build tools installed on Jenkins server
- Required Jenkins plugins(Install this from Manage Jenkins → Manage Plugins then in the avialble tab search with these plugn names):
  - Git plugin
  - Pipeline plugin
  - Credentials Binding plugin
  - Parallel Test Executor plugin


### 2. Credentials Setup
1. Navigate to "Manage Jenkins" → "Manage Credentials"
2. Add the following credentials:
   - Git repository credentials (Username/Password or SSH key)
   - Docker registry credentials
   - Deployment environment credentials
   - Kube config credentials
   - Kube namespace credentials

### 3. Pipeline Configuration
Create a `Jenkinsfile` in your repository root with the following configuration:

```
pipeline {
    agent any

    environment {
        // Define environment variables here
        DOCKER_REGISTRY = 'your-registry.com'
        APP_NAME = 'your-app'
        KUBE_CONFIG = 'your-kubeconfig-credentials-id'
        KUBE_NAMESPACE = 'staging'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }

        stage('Parallel Tests') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        sh 'npm run test:unit'
                    }
                }
                stage('Integration Tests') {
                    steps {
                        sh 'npm run test:integration'
                    }
                }
                stage('Security Tests') {
                    steps {
                        sh 'npm audit'
                    }
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([string(credentialsId: 'docker-registry-key', variable: 'DOCKER_KEY')]) {
                    sh """
                        docker build -t ${DOCKER_REGISTRY}/${APP_NAME}:${BUILD_NUMBER} .
                        docker login ${DOCKER_REGISTRY} -u jenkins -p ${DOCKER_KEY}
                        docker push ${DOCKER_REGISTRY}/${APP_NAME}:${BUILD_NUMBER}
                    """
                }
            }
        }

        stage('Deploy to Staging (Kubernetes)') {
            steps {
                withCredentials([file(credentialsId: env.KUBE_CONFIG, variable: 'KUBECONFIG')]) {
                    sh """
                        echo "Deploying to Kubernetes..."
                        export KUBECONFIG=${KUBECONFIG}
                        kubectl config set-context --current --namespace=${KUBE_NAMESPACE}

                        # Update the Kubernetes deployment with the new image
                        kubectl set image deployment/${APP_NAME} ${APP_NAME}=${DOCKER_REGISTRY}/${APP_NAME}:${BUILD_NUMBER} --record

                        # Verify the deployment
                        kubectl rollout status deployment/${APP_NAME} -n ${KUBE_NAMESPACE}
                    """
                }
            }
        }
    }

    post {
        success {
            emailext (
                subject: "Pipeline Success: ${currentBuild.fullDisplayName}",
                body: "Your pipeline has completed successfully.",
                to: 'team@company.com'
            )
        }
        failure {
            emailext (
                subject: "Pipeline Failed: ${currentBuild.fullDisplayName}",
                body: "Your pipeline has failed. Please check the Jenkins logs.",
                to: 'team@company.com'
            )
        }
    }
}


```

### Parallel Test Execution
- Multiple test suites run simultaneously
- Significant reduction in build time
- Independent test reports
- Fail-fast capability for quick feedback

### Credential Management
- Secure credential storage using Jenkins Credentials Plugin
- Supported credential types:
  - Username/password combinations
  - SSH keys
  - Secret text
  - Certificates
- Scoped credential access
- External secret manager integration capability
