# Terraform Workflow

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand the Terraform workflow
* Explain the purpose of terraform init
* Explain the purpose of terraform plan
* Explain the purpose of terraform apply
* Explain the purpose of terraform destroy
* Understand the Terraform development lifecycle
* Safely make infrastructure changes
* Follow Terraform best practices

---

# Introduction

Terraform follows a predictable workflow.

Every infrastructure change typically goes through the same lifecycle:

```text
Write Code
    |
terraform init
    |
terraform validate
    |
terraform plan
    |
terraform apply
    |
Infrastructure Updated
```

When infrastructure is no longer needed:

```text
terraform destroy
```

Understanding this workflow is fundamental to working with Terraform safely and effectively.

---

# The Terraform Lifecycle

Terraform operates using a cycle:

```text
1. Write Configuration

2. Initialize Project

3. Validate Configuration

4. Review Execution Plan

5. Apply Changes

6. Update Infrastructure

7. Repeat
```

Infrastructure evolves over time, and Terraform continuously manages those changes.

---

# Step 1: Write Configuration

Everything starts with infrastructure code.

Example:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "company-logs"
}
```

This configuration defines the desired state.

At this stage:

* No infrastructure exists
* Terraform has not communicated with any provider
* Only configuration files exist

---

# Step 2: terraform init

The first command executed in every Terraform project is:

```bash
terraform init
```

Purpose:

* Initialize the working directory
* Download providers
* Download modules
* Configure backends
* Prepare Terraform for execution

Example:

```bash
terraform init
```

Output:

```text
Initializing the backend...

Initializing provider plugins...

Terraform has been successfully initialized!
```

---

# What Happens During Initialization?

Terraform reads your configuration.

Example:

```hcl
provider "aws" {
  region = "eu-west-1"
}
```

Terraform detects:

```text
AWS Provider Required
```

Then downloads the provider plugin.

Example:

```text
.terraform/
└── providers/
```

This directory is created automatically.

---

# Why terraform init Matters

Without initialization:

* Providers are unavailable
* Modules are unavailable
* Backends are unavailable

Terraform cannot proceed.

Think of:

```bash
terraform init
```

as:

```text
Project Setup
```

It is normally run:

* When starting a project
* After changing providers
* After changing modules
* After changing backend configuration

---

# Step 3: terraform validate

Before planning changes, validate the configuration.

Command:

```bash
terraform validate
```

Purpose:

* Verify syntax
* Verify configuration structure
* Detect obvious errors

Example output:

```text
Success! The configuration is valid.
```

Example error:

```text
Missing required argument
```

Validation does not create infrastructure.

It only checks configuration correctness.

---

# Step 4: terraform plan

This is one of the most important commands in Terraform.

Command:

```bash
terraform plan
```

Purpose:

* Compare desired state
* Compare current state
* Generate execution plan

Terraform determines:

```text
What needs to change?
```

before making any modifications.

---

# Understanding the Execution Plan

Example output:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

Terraform may show:

```text
+ Create
~ Modify
- Destroy
```

Meaning:

```text
+ New resource

~ Existing resource changes

- Resource removal
```

The plan provides a safe preview before execution.

---

# Why terraform plan Is Critical

Never blindly apply infrastructure.

A plan allows you to:

* Review changes
* Catch mistakes
* Verify assumptions
* Prevent accidental destruction

Professional Terraform workflows always review plans first.

---

# Saving Plans

Terraform can save plans to a file.

Example:

```bash
terraform plan -out=tfplan
```

Produces:

```text
tfplan
```

Later:

```bash
terraform apply tfplan
```

This ensures the exact reviewed plan is applied.

Many CI/CD pipelines use this approach.

---

# Step 5: terraform apply

After reviewing the plan:

```bash
terraform apply
```

Terraform executes the changes.

Example:

```bash
terraform apply
```

Terraform asks for confirmation:

```text
Do you want to perform these actions?

Enter a value:
```

Enter:

```text
yes
```

Terraform then creates, updates, or removes resources.

---

# What Happens During Apply?

Terraform:

1. Reads configuration
2. Reads state
3. Generates plan
4. Calls provider APIs
5. Creates infrastructure
6. Updates state

Example:

```text
Terraform
     |
AWS Provider
     |
AWS API
     |
S3 Bucket Created
```

The state file is updated to reflect reality.

---

# Infrastructure Is Now Managed

After apply:

```text
Infrastructure Exists
```

Terraform now tracks the resource.

Future plans compare:

```text
Desired State

vs

Current State
```

to determine required changes.

---

# Making Changes

Suppose:

Original:

```hcl
instance_type = "t3.micro"
```

New:

```hcl
instance_type = "t3.small"
```

Workflow:

```bash
terraform plan
terraform apply
```

Terraform detects the difference and updates infrastructure accordingly.

---

# Step 6: terraform destroy

Terraform can remove managed infrastructure.

Command:

```bash
terraform destroy
```

Purpose:

* Delete managed resources
* Clean environments
* Avoid unnecessary costs

Example:

```bash
terraform destroy
```

Terraform displays:

```text
Plan: 0 to add, 0 to change, 5 to destroy.
```

Confirmation is required before deletion.

---

# When to Use terraform destroy

Common scenarios:

* Learning environments
* Temporary testing environments
* Development sandboxes
* Cost cleanup

Be extremely cautious in production environments.

---

# The Daily Terraform Workflow

Most engineers follow this pattern:

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```

This should become muscle memory.

---

# Recommended Development Workflow

For every infrastructure change:

Step 1

Modify code.

Step 2

Format code.

```bash
terraform fmt
```

Step 3

Validate configuration.

```bash
terraform validate
```

Step 4

Review plan.

```bash
terraform plan
```

Step 5

Apply changes.

```bash
terraform apply
```

This workflow significantly reduces mistakes.

---

# Common Beginner Mistakes

## Skipping terraform plan

Bad:

```bash
terraform apply
```

Good:

```bash
terraform plan
terraform apply
```

---

## Forgetting terraform init

If providers or modules change:

```bash
terraform init
```

must be run again.

---

## Ignoring Validation

Always run:

```bash
terraform validate
```

before planning changes.

---

## Destroying Infrastructure Accidentally

Always read the plan carefully before applying changes.

---

# Best Practices

* Always review plans
* Commit code before applying major changes
* Use version control
* Validate configurations
* Format configurations
* Understand what Terraform will destroy
* Avoid manual infrastructure changes outside Terraform

---

# Key Takeaways

* Terraform follows a predictable workflow.
* terraform init prepares the project.
* terraform validate checks configuration correctness.
* terraform plan previews changes.
* terraform apply executes changes.
* terraform destroy removes managed resources.
* Reviewing plans is one of the most important Terraform habits.
* Most infrastructure changes follow the cycle:
  Write → Validate → Plan → Apply.

---

# Next Chapter

In the next chapter, we will learn HashiCorp Configuration Language (HCL), the language used to write Terraform configurations.

We will begin learning how to read and write Terraform code effectively.
