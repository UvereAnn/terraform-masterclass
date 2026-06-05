# terraform-masterclass
A comprehensive Terraform and Infrastructure as Code learning repository.

# Terraform Masterclass

A comprehensive, hands-on Terraform learning repository designed to take a learner from Terraform fundamentals to production-grade Infrastructure as Code (IaC) practices used by modern DevOps, Cloud, Platform, and Site Reliability Engineering teams.

This repository serves as both a learning roadmap and a practical implementation guide, covering Terraform concepts, cloud infrastructure provisioning, state management, modular design, CI/CD integration, Kubernetes automation, testing, security, and OpenTofu compatibility.

---

## Repository Goals

The purpose of this repository is to:

* Learn Terraform from the ground up
* Build production-ready Infrastructure as Code practices
* Understand cloud infrastructure automation
* Develop reusable Terraform modules
* Implement CI/CD pipelines for infrastructure deployments
* Learn Kubernetes provisioning through Terraform
* Explore enterprise Terraform concepts
* Understand OpenTofu and migration considerations
* Build a professional portfolio of real-world Terraform projects

---

# Learning Roadmap

## 1. Terraform Fundamentals

Topics covered:

* Infrastructure as Code (IaC)
* Terraform Architecture
* Terraform Workflow

  * terraform init
  * terraform plan
  * terraform apply
  * terraform destroy
* HashiCorp Configuration Language (HCL)
* Providers
* Resources
* Data Sources
* Variables
* Outputs
* Locals
* Terraform CLI

Example:

```hcl
provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t3.micro"
}
```

---

## 2. Terraform Language Deep Dive

### Variables

* Input Variables
* Variable Types
* Validation Rules
* Sensitive Variables

### Expressions

* String Interpolation
* Conditional Expressions
* For Expressions
* Dynamic Blocks

### Functions

* String Functions
* Collection Functions
* File Functions
* Encoding Functions

Examples:

```hcl
upper()
join()
split()
jsondecode()
file()
```

### Meta Arguments

* count
* for_each
* depends_on
* lifecycle

---

## 3. State Management

Topics:

* Terraform State
* State File Structure
* State Locking
* State Commands

```bash
terraform state list
terraform state show
terraform state mv
terraform state rm
```

### Remote State

* AWS S3 Backend
* Azure Storage Backend
* Google Cloud Storage Backend

### State Locking

Examples:

* AWS DynamoDB Locking
* Cloud-Native Locking Solutions

Key Concepts:

* State Corruption
* Team Collaboration
* State Recovery
* Backend Migration

---

## 4. Modules

Topics:

* Creating Modules
* Consuming Modules
* Module Inputs
* Module Outputs
* Module Versioning
* Public Module Registries

Example:

```hcl
module "network" {
  source = "./modules/network"
}
```

Advanced Topics:

* Nested Modules
* Reusable Enterprise Modules
* Module Design Best Practices

---

## 5. Terraform Project Structure

Topics:

* Environment Separation
* Naming Conventions
* Directory Design
* Scalability

Example Structure:

```text
terraform/
├── environments
│   ├── dev
│   ├── test
│   └── prod
├── modules
├── backend
└── scripts
```

---

## 6. Cloud Provider Resources

### AWS

Topics:

* VPC
* Subnets
* Route Tables
* Internet Gateways
* NAT Gateways
* Security Groups
* EC2
* EBS
* S3
* IAM
* Lambda
* RDS
* ECS
* EKS
* CloudWatch

Core Focus:

* Networking
* IAM
* EC2
* S3

### Azure

Topics:

* Resource Groups
* Virtual Networks
* Network Security Groups
* Virtual Machines
* Storage Accounts
* AKS
* Key Vault

### Google Cloud

Topics:

* VPC
* Compute Engine
* Cloud Storage
* GKE
* IAM

---

## 7. Terraform Workspaces

Topics:

```bash
terraform workspace new dev
terraform workspace select dev
```

Concepts:

* Multi-Environment Deployments
* Workspace Limitations
* When Not To Use Workspaces

---

## 8. Secrets Management

Topics:

* Environment Variables
* AWS Secrets Manager
* Azure Key Vault
* Google Secret Manager
* HashiCorp Vault

Best Practice:

Never hardcode credentials, tokens, or passwords in Terraform code.

---

## 9. Terraform Testing

Topics:

### Validation

```bash
terraform validate
```

### Formatting

```bash
terraform fmt
```

### Linting

* TFLint

### Security Scanning

* Checkov
* tfsec

### Policy as Code

* Sentinel
* Open Policy Agent (OPA)

---

## 10. CI/CD Integration

Platforms:

* GitHub Actions
* GitLab CI/CD
* Jenkins
* Azure DevOps

Pipeline Stages:

* Lint
* Validate
* Plan
* Approval
* Apply

Concepts:

* Pull Request Workflows
* Automated Plans
* Manual Approvals
* Drift Detection

---

## 11. Kubernetes with Terraform

Topics:

* Kubernetes Provider
* Helm Provider
* EKS Provisioning
* AKS Provisioning
* GKE Provisioning

Deployments:

* Namespaces
* Services
* Deployments
* Ingresses

---

## 12. Advanced Terraform

Topics:

* Dynamic Blocks
* Complex Data Types

  * map
  * set
  * list
  * object
  * tuple
* terraform import
* Moved Blocks
* Resource Refactoring
* Resource Lifecycle
* Dependency Graphs
* Custom Providers
* Provider Aliases

---

## 13. Terraform Enterprise Concepts

Topics:

* Remote Execution
* Team Workflows
* Governance
* Policy Enforcement
* Private Module Registries

---

## 14. OpenTofu

Topics:

* OpenTofu Fundamentals
* Terraform Licensing Changes
* Migration Paths
* State Compatibility
* OpenTofu Best Practices

---

## 15. Real-World DevOps Topics Around Terraform

Topics:

* Git
* Linux
* Docker
* Networking
* Cloud Architecture
* CI/CD
* Kubernetes
* Monitoring
* Security

Terraform is most effective when combined with a broader DevOps skill set.

---

## 16. Portfolio Projects

### Project 1

AWS VPC + EC2 + Security Groups

### Project 2

3-Tier Architecture

* VPC
* Application Load Balancer
* Auto Scaling
* RDS

### Project 3

EKS Cluster Deployment

### Project 4

Reusable Module Library

### Project 5

GitHub Actions CI/CD Terraform Pipeline

### Project 6

Multi-Account AWS Deployment

### Project 7

Production-Grade Infrastructure

* Remote State
* Secrets Management
* Modules
* CI/CD
* Monitoring

---

# Job-Ready Terraform Roadmap

Recommended Order of Study:

1. Terraform Fundamentals
2. HCL Language
3. Variables and Functions
4. State Management
5. Modules
6. AWS Basics
7. Networking
8. IAM
9. Remote State
10. CI/CD Pipelines
11. Secrets Management
12. Kubernetes
13. Testing and Security
14. OpenTofu
15. Production Infrastructure Projects