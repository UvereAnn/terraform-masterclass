# Writing Production Terraform

## Learning Objectives

By the end of this chapter, you should be able to:

* Structure Terraform projects professionally
* Follow Terraform naming conventions
* Organize variables, outputs, and locals
* Implement tagging standards
* Design reusable configurations
* Manage multiple environments
* Avoid common anti-patterns
* Write maintainable Terraform code
* Understand production-grade Terraform principles

---

# Introduction

Writing Terraform that works is relatively easy.

Writing Terraform that remains maintainable after:

* 6 months
* 1 year
* Multiple engineers
* Multiple environments

is much harder.

Production Terraform focuses on:

```text
Readability
Consistency
Reusability
Scalability
Security
```

---

# The Goal of Production Terraform

A production Terraform repository should be:

```text
Easy to Read
Easy to Modify
Easy to Reuse
Easy to Scale
```

Future engineers should understand the code quickly.

Good Terraform reduces operational risk.

---

# Use a Consistent Project Structure

Bad:

```text
main.tf
network.tf
test.tf
random.tf
stuff.tf
new.tf
```

Good:

```text
terraform-masterclass/
│
├── environments/
├── modules/
├── global/
├── docs/
├── examples/
├── tests/
└── scripts/
```

Structure should be predictable.

---

# Separate Environments

Never mix environments.

Bad:

```text
One configuration
for dev, staging and prod
```

Good:

```text
environments/
├── dev/
├── staging/
└── prod/
```

Each environment should have:

* Its own variables
* Its own state
* Its own deployment lifecycle

---

# Organize Terraform Files

A common layout:

```text
main.tf
variables.tf
outputs.tf
locals.tf
versions.tf
providers.tf
```

Purpose:

```text
main.tf       → Resources

variables.tf  → Input Variables

outputs.tf    → Outputs

locals.tf     → Local Values

versions.tf   → Terraform and Provider Versions

providers.tf  → Provider Configuration
```

Engineers instantly understand the project.

---

# Use Meaningful Resource Names

Bad:

```hcl
resource "aws_instance" "test" {

}
```

Bad:

```hcl
resource "aws_instance" "server1" {

}
```

Good:

```hcl
resource "aws_instance" "frontend_web_server" {

}
```

Names should describe purpose.

---

# Standardize Naming Conventions

Create naming rules.

Example:

```text
environment-application-component
```

Examples:

```text
dev-web-alb

dev-web-ec2

prod-api-rds
```

Consistency improves operations.

---

# Use Variables for Configuration

Bad:

```hcl
instance_type = "t3.micro"
```

Good:

```hcl
instance_type = var.instance_type
```

Hardcoded values become maintenance problems.

---

# Use Locals for Calculations

Bad:

```hcl
bucket = "${var.environment}-${var.application}-logs"

name = "${var.environment}-${var.application}-ec2"

alb_name = "${var.environment}-${var.application}-alb"
```

Good:

```hcl
locals {
  naming_prefix = "${var.environment}-${var.application}"
}
```

Then:

```hcl
bucket = "${local.naming_prefix}-logs"
```

Reduce duplication whenever possible.

---

# Centralize Tags

Most organizations require tags.

Bad:

```hcl
tags = {
  Environment = "dev"
  Team        = "Platform"
}
```

repeated everywhere.

Good:

```hcl
locals {

  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Team        = "Platform"
  }

}
```

Usage:

```hcl
tags = local.common_tags
```

---

# Pin Terraform Versions

Always define:

```hcl
terraform {
  required_version = ">= 1.8.0"
}
```

This prevents unexpected behavior.

---

# Pin Provider Versions

Bad:

```hcl
aws = {
  source = "hashicorp/aws"
}
```

Good:

```hcl
aws = {
  source  = "hashicorp/aws"
  version = "~> 6.0"
}
```

Version drift creates operational risk.

---

# Never Hardcode Secrets

Bad:

```hcl
password = "SuperSecret123"
```

Bad:

```hcl
access_key = "ABC123"
```

Use:

* Environment Variables
* AWS Secrets Manager
* Azure Key Vault
* GCP Secret Manager
* HashiCorp Vault

Secrets should never be committed to Git.

---

# Use Data Sources for Existing Infrastructure

Bad:

```hcl
vpc_id = "vpc-123456"
```

Better:

```hcl
data.aws_vpc.main.id
```

This improves portability and maintainability.

---

# Write Small, Focused Resources

Avoid giant resource files.

Bad:

```text
5000-line main.tf
```

Good:

```text
network.tf
compute.tf
storage.tf
```

Keep files manageable.

---

# Use Modules

Repeated code should become a module.

Bad:

```text
Copy
Paste
Copy
Paste
```

Good:

```hcl
module "vpc" {
  source = "../../modules/vpc"
}
```

Modules improve reuse and consistency.

---

# Keep State Remote

Bad:

```text
terraform.tfstate
stored on developer laptop
```

Good:

```text
Remote Backend
```

Examples:

* S3 + DynamoDB
* Azure Storage
* Google Cloud Storage

Remote state is mandatory in team environments.

---

# Review Every Plan

Never blindly apply changes.

Always:

```bash
terraform plan
```

Review:

```text
Resources Added

Resources Changed

Resources Destroyed
```

before approving.

---

# Use Formatting and Validation

Before every commit:

```bash
terraform fmt

terraform validate
```

This catches many problems early.

---

# Implement CI/CD

A production workflow:

```text
Git Push
    ↓
Lint
    ↓
Validate
    ↓
Plan
    ↓
Approval
    ↓
Apply
```

Manual deployments do not scale well.

---

# Document Everything

Document:

* Modules
* Variables
* Outputs
* Environment Design
* Deployment Process

Future engineers will thank you.

---

# Common Terraform Anti-Patterns

## Giant Monolithic Projects

Avoid:

```text
Everything in one folder
```

---

## Hardcoded IDs

Avoid:

```text
vpc-123456
subnet-987654
```

---

## Copy-Paste Infrastructure

Create reusable modules instead.

---

## No Naming Standards

Inconsistent naming causes confusion.

---

## Local State in Teams

Use remote backends.

---

# Production Terraform Checklist

Before merging code:

* terraform fmt passes
* terraform validate passes
* Variables documented
* Outputs documented
* Provider versions pinned
* Terraform version pinned
* Secrets not committed
* Naming standards followed
* Tags applied
* Plan reviewed

If all are true, you're approaching production quality.

---

# Real-World Example Structure

```text
terraform-masterclass/
│
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
│
├── modules/
│   ├── vpc/
│   ├── ec2/
│   ├── alb/
│   ├── rds/
│   └── eks/
│
├── global/
│   ├── backend/
│   └── providers/
│
├── docs/
├── examples/
├── tests/
└── .github/
```

This structure scales well as infrastructure grows.

---

# Key Takeaways

* Production Terraform prioritizes maintainability.
* Separate environments properly.
* Use variables, locals, and outputs effectively.
* Standardize naming and tagging.
* Never commit secrets.
* Use modules for reuse.
* Store state remotely.
* Validate and review changes before deployment.
* Implement CI/CD pipelines.
* Write Terraform for teams, not just yourself.

---

# Terraform Fundamentals Complete

Congratulations.

You have now completed the Terraform Fundamentals section and understand:

* Infrastructure as Code
* Terraform Architecture
* Terraform Workflow
* HCL
* Providers
* Resources
* Data Sources
* Variables
* Outputs
* Locals
* Terraform CLI
* Production Terraform Practices

These concepts form the foundation for everything that follows.

---

# Next Phase

Terraform Language Deep Dive

We will now move into advanced Terraform language features:

* Expressions
* Functions
* Meta Arguments
* count
* for_each
* depends_on
* lifecycle
* Dynamic Blocks
* Complex Data Types
* Advanced Patterns

This is where Terraform starts becoming truly powerful.
