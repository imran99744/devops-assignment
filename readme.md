# DevOps - Assignment Structure

This repository contains the setup and solutions for the DevOps assignment.

## Directory Structure

* **`infra-setup/`**: This directory holds the infrastructure setup code.
    * **`aws-terraform/`**: Contains Terraform scripts for provisioning AWS infra resources. The scripts are organized in a modular, maintainable, and readable manner.
    * **`docker-k8s/`**: Includes a basic Node.js application, along with a `Dockerfile` for containerization and Kubernetes deployment YAML files for orchestration.

* **`Questions-answers/`**: This directory contains the answers to the assignment questions.
    * **`answer1.md`**: Explanation and solution for Question 1.
    * **`answer2.md`**: Explanation and solution for Question 2.
    * **`answer3.md`**: Explanation and solution for Question 3.
    * **`answer4.md`**: Explanation and solution for Question 4.

* **`Real-world-scenarios/`**: This directory contains solutions and explanations for the real-world scenarios presented in the assignment.

## Getting Started

1.  **Infrastructure Setup**: Navigate to `infra-setup/aws-terraform/backend/` to review and apply the Terraform scripts for remote backend and dynamodb state locking. Ensure you have the necessary AWS credentials configured. Then you can change the directory to `infra-setup/aws-terraform/`and to review run `terraform plan`
2.  **Node Application Deployment**: To deploy the Node.js application, refer to the dedicated readme in `docker-k8s` directory.
3.  **Assignment Answers**: Review the answers to the assignment questions in the `Questions-answers/` directory.
4.  **Real-world Scenarios**: Find the solutions and explanations for the real-world scenarios in `Real-world-scenarios/`.