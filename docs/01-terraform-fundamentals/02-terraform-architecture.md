# Terraform Architecture

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand Terraform's architecture
* Explain how Terraform interacts with cloud providers
* Understand Providers and Plugins
* Understand Resources
* Understand State Files
* Understand the Terraform Workflow
* Explain how Terraform determines infrastructure changes
* Visualize the complete Terraform execution process

---

# Introduction

Terraform is not a cloud platform.

Terraform does not create infrastructure by itself.

Instead, Terraform acts as an orchestration engine between your infrastructure code and the APIs exposed by cloud providers and services.

Terraform reads your configuration, determines the desired state of your infrastructure, compares it with the current state, and executes the required actions to make reality match your configuration.

---

# High-Level Architecture

Terraform consists of several major components:

```text
                +----------------+
                | Terraform Code |
                +----------------+
                         |
                         v
                +----------------+
                | Terraform Core |
                +----------------+
                         |
                         v
                +----------------+
                |   Providers    |
                +----------------+
                         |
                         v
                +----------------+
                | Cloud APIs     |
                +----------------+
                         |
                         v
                +----------------+
                | Infrastructure |
                +----------------+
```

Each component has a specific responsibility.

---

# Terraform Configuration

Terraform configurations are written using HashiCorp Configuration Language (HCL).

Example:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "company-logs"
}
```

This code describes the desired infrastructure.

Terraform does not execute the resource directly.

Instead, it passes this information through several layers.

---

# Terraform Core

Terraform Core is the central engine of Terraform.

Responsibilities include:

* Reading configuration files
* Building dependency graphs
* Managing state
* Generating execution plans
* Determining required changes
* Coordinating provider communication

Terraform Core does not understand AWS, Azure, Kubernetes, or any other platform directly.

It relies on Providers.

---

# Providers

Providers are plugins that allow Terraform to communicate with external platforms.

Examples include:

* AWS Provider
* Azure Provider
* Google Cloud Provider
* Kubernetes Provider
* GitHub Provider

Provider example:

```hcl
provider "aws" {
  region = "eu-west-1"
}
```

When Terraform encounters an AWS resource, it delegates the work to the AWS Provider.

---

# Provider Plugins

Providers are downloaded during:

```bash
terraform init
```

Terraform automatically downloads the required plugins.

Example:

```text
.terraform/
└── providers/
```

These plugins know how to interact with:

* AWS APIs
* Azure APIs
* Google APIs
* Kubernetes APIs

Without providers, Terraform cannot manage infrastructure.

---

# Resources

Resources represent infrastructure objects.

Examples:

```hcl
resource "aws_instance" "web" {
  instance_type = "t3.micro"
}
```

Examples of resources:

* Virtual Machines
* Databases
* Storage Buckets
* Security Groups
* Kubernetes Deployments

Resources are the building blocks of Terraform configurations.

---

# Data Sources

Resources create or manage infrastructure.

Data Sources retrieve information from existing infrastructure.

Example:

```hcl
data "aws_availability_zones" "available" {}
```

Terraform reads information from AWS and makes it available to your configuration.

Common use cases:

* Existing VPCs
* Existing Subnets
* Existing AMIs
* Existing DNS Zones

---

# Terraform State

Terraform must know what infrastructure it manages.

This information is stored in the State File.

Example:

```text
terraform.tfstate
```

State stores:

* Managed resources
* Resource IDs
* Resource attributes
* Dependency information

Without state, Terraform would not know:

* What already exists
* What must be updated
* What should be deleted

State is one of the most important concepts in Terraform.

A dedicated chapter later in this repository focuses entirely on state management.

---

# Desired State vs Current State

Terraform operates using a comparison model.

## Desired State

Defined in your code:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "company-logs"
}
```

## Current State

Stored in:

```text
terraform.tfstate
```

Terraform compares:

```text
Desired State
      vs
Current State
```

The differences become an execution plan.

---

# Execution Plan

Before making changes, Terraform generates a plan.

Example:

```bash
terraform plan
```

Terraform determines:

* Resources to create
* Resources to modify
* Resources to destroy

Example output:

```text
Plan: 2 to add, 1 to change, 0 to destroy.
```

This preview allows engineers to validate changes before execution.

---

# Dependency Graph

Terraform automatically builds a dependency graph.

Example:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
}
```

Terraform understands:

```text
VPC
 |
Subnet
```

The VPC must exist before the subnet can be created.

Terraform automatically determines execution order.

---

# Cloud Provider APIs

Terraform never creates infrastructure directly.

Terraform Providers communicate with APIs exposed by cloud platforms.

Example:

```text
Terraform
    |
AWS Provider
    |
AWS API
    |
EC2 Instance
```

The same pattern applies to:

* Azure
* Google Cloud
* Kubernetes
* GitHub
* Datadog
* Cloudflare

Terraform acts as a universal infrastructure orchestrator.

---

# Terraform Lifecycle

A typical workflow looks like:

```text
Write Configuration
        |
terraform init
        |
terraform validate
        |
terraform plan
        |
terraform apply
        |
Infrastructure Created
```

Terraform repeats this cycle whenever changes are introduced.

---

# Complete Architecture Flow

```text
Developer
    |
    v
Terraform Configuration
    |
    v
Terraform Core
    |
    v
Provider Plugin
    |
    v
Cloud API
    |
    v
Infrastructure
    |
    v
State File Updated
```

This is the full Terraform execution path.

Understanding this flow is essential for troubleshooting and designing infrastructure.

---

# Why Understanding the Architecture Matters

When engineers encounter issues, the problem usually falls into one of these layers:

* Configuration Error
* Provider Error
* Authentication Error
* API Error
* State Issue
* Dependency Issue

Understanding Terraform Architecture helps you quickly identify where problems originate.

---

# Key Takeaways

* Terraform Core is the engine that processes configurations.
* Providers allow Terraform to communicate with external platforms.
* Resources represent infrastructure components.
* Data Sources retrieve information from existing infrastructure.
* State tracks managed infrastructure.
* Terraform compares desired state and current state.
* Execution plans preview infrastructure changes.
* Providers interact with cloud APIs to create and manage resources.
* Terraform automatically builds dependency graphs to determine execution order.

---

# Next Chapter

In the next chapter, we will explore the Terraform Workflow and examine the purpose of:

* terraform init
* terraform plan
* terraform apply
* terraform destroy

These four commands form the foundation of everyday Terraform operations.
