# What is Infrastructure as Code (IaC)?

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand what Infrastructure as Code (IaC) is
* Explain why organizations use IaC
* Understand the problems IaC solves
* Compare manual infrastructure management with automated infrastructure management
* Understand Terraform's role in Infrastructure as Code
* Recognize the benefits and challenges of IaC adoption

---

# Introduction

Traditionally, infrastructure was created and managed manually.

A system administrator would:

* Log into servers
* Create virtual machines
* Configure networking
* Set permissions
* Install software
* Create databases
* Configure storage

This process often involved clicking through graphical interfaces or running commands manually.

While this approach works for small environments, it quickly becomes difficult to manage as infrastructure grows.

Common problems include:

* Human error
* Inconsistent environments
* Lack of documentation
* Difficult disaster recovery
* Slow deployment times
* Configuration drift

Infrastructure as Code was created to solve these problems.

---

# What is Infrastructure as Code?

Infrastructure as Code (IaC) is the practice of managing and provisioning infrastructure using code rather than manual processes.

Instead of creating infrastructure through cloud consoles or manual commands, infrastructure is described in files that can be:

* Written
* Version controlled
* Reviewed
* Tested
* Automated
* Reused

The infrastructure definition becomes part of the software development lifecycle.

Just as developers write application code, infrastructure engineers write infrastructure code.

---

# Traditional Infrastructure vs Infrastructure as Code

## Traditional Approach

Imagine you need a web application environment.

A typical manual process might involve:

1. Logging into AWS
2. Creating a VPC
3. Creating subnets
4. Configuring route tables
5. Launching EC2 instances
6. Creating security groups
7. Creating a database
8. Configuring storage

If another engineer needs the same environment, they must repeat the process manually.

This often results in inconsistencies.

---

## Infrastructure as Code Approach

With IaC, the entire environment is defined in code.

Example:

```hcl id="i3y0ef"
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}
```

The code becomes the source of truth.

Infrastructure can be recreated consistently at any time.

---

# Why Infrastructure as Code Matters

Modern organizations rely on:

* Cloud computing
* Microservices
* Containers
* Continuous Delivery
* Multi-environment deployments

Managing these environments manually is not scalable.

IaC provides:

## Consistency

Every environment is created using the same code.

Development, staging, and production environments remain aligned.

---

## Repeatability

Infrastructure can be recreated at any time.

This is valuable for:

* Disaster recovery
* Testing
* Environment rebuilds

---

## Version Control

Infrastructure changes are tracked using Git.

Benefits include:

* Change history
* Code reviews
* Rollbacks
* Collaboration

---

## Automation

Infrastructure deployment can be integrated into CI/CD pipelines.

This reduces manual intervention and deployment risk.

---

## Scalability

Large environments can be managed efficiently through reusable code.

Organizations can deploy infrastructure across:

* Multiple regions
* Multiple accounts
* Multiple cloud providers

using the same approach.

---

# Core Principles of Infrastructure as Code

## Declarative Configuration

Most modern IaC tools use a declarative approach.

Instead of telling the system how to perform every action, you describe the desired end state.

Example:

```text id="6l5l2s"
I want a VPC.

I want three subnets.

I want one EC2 instance.
```

The tool determines how to create those resources.

Terraform follows this declarative model.

---

## Idempotency

An important concept in IaC is idempotency.

Running the same code multiple times should produce the same result.

Example:

```text id="n4qqnn"
Apply infrastructure once.
Apply infrastructure again.
```

The second execution should not create duplicates.

Terraform compares the desired state to the current state and only makes necessary changes.

---

## Version Controlled Infrastructure

Infrastructure definitions should be stored in source control systems such as Git.

Benefits:

* Auditability
* Team collaboration
* Change tracking
* Rollback capability

Infrastructure should be treated like application code.

---

# Common Infrastructure as Code Tools

Several tools are commonly used in the industry.

## Terraform

Terraform is a cloud-agnostic Infrastructure as Code platform.

Features:

* Multi-cloud support
* Large provider ecosystem
* Declarative syntax
* Reusable modules

Terraform is the primary focus of this repository.

---

## OpenTofu

OpenTofu is an open-source fork of Terraform.

It was created following Terraform licensing changes.

Many organizations are evaluating or adopting OpenTofu while maintaining compatibility with existing Terraform workflows.

---

## AWS CloudFormation

AWS-native Infrastructure as Code solution.

Used primarily for AWS environments.

---

## Pulumi

Infrastructure as Code using programming languages such as:

* TypeScript
* Python
* Go
* C#

---

# Where Terraform Fits

Terraform acts as the orchestration layer between your code and your infrastructure.

You write:

```text id="m5kxzb"
Terraform Configuration
```

Terraform communicates with:

* AWS APIs
* Azure APIs
* Google Cloud APIs
* Kubernetes APIs

Terraform then creates, updates, or destroys resources based on the desired configuration.

---

# Real-World Example

A company may need:

* VPC
* Public Subnets
* Private Subnets
* Load Balancer
* Auto Scaling Group
* EC2 Instances
* RDS Database

Without IaC:

* Manual configuration
* High risk of mistakes
* Difficult recovery

With IaC:

* Entire infrastructure stored in code
* Version controlled
* Reproducible
* Automated

Infrastructure becomes predictable and manageable.

---

# Benefits of Infrastructure as Code

### Faster Deployments

Infrastructure can be deployed in minutes.

### Reduced Human Error

Automation reduces manual mistakes.

### Better Collaboration

Teams work from a shared codebase.

### Disaster Recovery

Environments can be recreated quickly.

### Auditing and Compliance

Changes are recorded and traceable.

### Scalability

Infrastructure grows alongside business requirements.

---

# Challenges of Infrastructure as Code

While IaC provides significant benefits, it also introduces responsibilities.

Challenges include:

* Learning curve
* State management
* Security considerations
* Secret management
* Module design
* Team governance

These topics will be explored throughout this repository.

---

# Key Takeaways

* Infrastructure as Code (IaC) manages infrastructure through code rather than manual processes.
* IaC improves consistency, repeatability, and automation.
* Infrastructure definitions should be version controlled.
* Terraform uses a declarative approach to describe desired infrastructure state.
* IaC is a foundational skill for modern DevOps, Cloud, and Platform Engineers.
* Terraform is one of the most widely adopted Infrastructure as Code tools in the industry.

---

# Next Chapter

In the next chapter, we will explore Terraform Architecture and understand how Terraform interacts with providers, APIs, state files, and infrastructure resources.
