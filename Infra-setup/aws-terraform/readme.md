# AWS Infrastructure Setup with Terraform

This directory (`aws-terraform/`) contains Terraform scripts for provisioning AWS resources. The infrastructure is organized in a modular, maintainable, and readable manner.

## My Approach

My approach to building this infrastructure was to prioritize modularity, readability and maintainability. By separating the infrastructure into reusable modules and configuring a remote backend for state management and dynamodb for state locking, I aimed to create a scalable and robust setup.

* **Modularity**:  Breaking down the infrastructure into modules like `ec2`, `rds`, `security_groups`, and `vpc` allows for easier reuse and management of individual components.
* **Remote State Management**: Using an S3 bucket and DynamoDB for state management ensures that the state is shared and locked, preventing conflicts in a team environment.
* **Clear Separation of Concerns**: The `backend/` directory is dedicated to backend configuration, while the `modules/` directory holds the resource definitions, keeping the root directory clean and focused on orchestration.

## Directory Structure

* **`backend/`**: Configures a remote backend for Terraform state management using AWS S3 and DynamoDB for state locking.
    * **`main.tf`**: Contains the backend configuration.
    * **`variables.tf`**: Defines variables used in the backend configuration.
    * **`outputs.tf`**: Defines output values for the backend configuration.

* **`modules/`**: Contains reusable Terraform modules for different AWS resources.
    * **`ec2/`**: Module for creating EC2 instances.
    * **`rds/`**: Module for creating RDS instances.
    * **`security_groups/`**: Module for creating security groups.
    * **`vpc/`**: Module for creating VPC resources.

* **Root directory (`aws-terraform/`)**:
    * **`main.tf`**: Calls the modules defined in the `modules/` directory to create the infrastructure.
    * **`variables.tf`**: Defines variables used in the modules.
    * **`outputs.tf`**: Defines output values for the infrastructure.
    * **`.gitignore`**: Specifies files and directories to be ignored by Git.
    * **`readme.md`**: This file.

## Getting Started

1.  **Configure AWS Credentials**: Ensure you have AWS credentials configured (e.g., using `aws configure`).
2.  **Initialize Terraform Backend**:
    * Navigate to `backend/`.
    * Run `terraform init` to initialize the backend and download providers.
    * Run `terraform apply` to create the S3 bucket and DynamoDB table for state management.
3.  **Initialize Terraform Modules**:
    * Navigate back to the root directory (`aws-terraform/`).
    * Run `terraform init` to initialize the modules and download providers.
4.  **Review Terraform Plan**:
    * Run `terraform plan` to see the changes that Terraform will make to your infrastructure.
5.  **Apply Terraform Changes**:
    * Run `terraform apply` to create the infrastructure.


## Challenges Faced During Terraform Apply

While running `terraform apply`, I encountered an error related to the RDS instance deployment. Terraform highlighted that, due to RDS's design for high availability and scalability, it requires deployment across two different Availability Zones. This necessitated the creation of two private subnets instead of just one.

**Resolution:**

To address this, I modified the `vpc` module to create two private subnets spanning different Availability Zones within the region. I then updated the `rds` module to reference these two private subnets, ensuring the RDS instance was deployed across both Availability Zones as required.

This experience reinforced the importance of understanding AWS service best practices and how Terraform enforces them, particularly for services like RDS that prioritize high availability.



# Handling Terraform State File Conflicts

Since I've encountered and resolved this in a recent project and detailed it in Question 1's answer, let's take another look at the problem and approach.

## Understanding the Problem

Terraform's state file (`terraform.tfstate`) tracks the current state of our infrastructure. When two or more engineers modify the state file concurrently, the last write wins, potentially overwriting changes made by others. This can lead to:

- **Data Loss:** Changes made by one engineer might be lost.
- **Infrastructure Drift:** The actual infrastructure might diverge from the recorded state.
- **Errors:** Subsequent Terraform operations might fail due to an inconsistent state.

## Prevention Strategies

1.  **Remote Backend with State Locking (This is implemented in this project):**

    -   Use a remote backend(that i also used this aws infra project) like AWS S3.
    -   Remote backends provide state locking, which prevents concurrent modifications.
    -   When an engineer runs `terraform apply`, the state file is locked, preventing others from making changes until the operation completes.


2.  **Clear Communication and Coordination:**

    -   Establish a clear communication channel for engineers to coordinate Terraform operations.
    -   Use tools like Slack, Microsoft Teams, or Jira to inform others when you're running `terraform apply`.
    -   Implement a code review process to catch potential conflicts before they occur.

3.  **Short-Lived Branches and Feature Flags:**

    -   Use short-lived branches for feature development.
    -   Implement feature flags to enable or disable new features without directly modifying the main infrastructure.
    -   Merge changes frequently to minimize the risk of conflicts.

## Conflict Resolution

1.  **Identify the Conflict:**

    -   If a conflict occurs, Terraform will typically report an error indicating that the state file is locked or that a concurrent modification was detected.
    -   Check the logs and error messages for details.

2.  **Unlock the State File (if necessary):**

    -   If the state file is locked due to an interrupted operation, you might need to manually unlock it.
    -   Use the `terraform force-unlock` command with the lock ID.

    ```bash
    terraform force-unlock <lock-id>
    ```

    -   **Caution:** Only use `force-unlock` if you're sure that no other operations are in progress.

3.  **Reconcile Changes:**

    -   If changes were overwritten, you might need to manually reconcile them.
    -   Review the Terraform plan and apply the necessary changes.
    -   If possible, revert to a previous version of the state file and reapply the changes.

4.  **Communicate and Collaborate:**

    -   Communicate with other engineers to understand the changes that were made.
    -   Collaborate to resolve the conflict and ensure that the infrastructure is in a consistent state.

## Best Practices

-   Always use a remote backend with state locking.
-   Implement a code review process for Terraform changes.
-   Establish clear communication and coordination among engineers.
-   Use short-lived branches and feature flags.
-   Regularly back up your Terraform state file.

By following these guidelines, we can minimize the risk of state file conflicts and ensure that your infrastructure is managed consistently and reliably.