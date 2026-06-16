# Providers

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand what Providers are
* Explain why Providers are required
* Configure Providers
* Understand Provider Plugins
* Understand Provider Versioning
* Use Multiple Providers
* Understand Provider Authentication Concepts
* Read Provider Documentation

---

# What is a Provider?

Terraform itself cannot create infrastructure.

Terraform does not know:

* How AWS works
* How Azure works
* How Google Cloud works
* How Kubernetes works

Instead, Terraform relies on Providers.

A Provider is a plugin that allows Terraform to communicate with external platforms and services.

Think of a Provider as a translator between Terraform and an API.

```text
Terraform
     |
Provider
     |
Cloud API
     |
Infrastructure
```

Without Providers, Terraform cannot manage infrastructure.

---

# Why Providers Exist

Different platforms expose different APIs.

For example:

AWS exposes:

```text
AWS APIs
```

Azure exposes:

```text
Azure Resource Manager APIs
```

Kubernetes exposes:

```text
Kubernetes API Server
```

Terraform uses Providers to understand how to interact with each platform.

---

# Popular Providers

Terraform has thousands of Providers.

Common examples include:

### Cloud Providers

* AWS
* Azure
* Google Cloud

### DevOps Platforms

* GitHub
* GitLab

### Kubernetes

* Kubernetes
* Helm

### Networking

* Cloudflare

### Monitoring

* Datadog

### Databases

* PostgreSQL
* MongoDB

Terraform's ecosystem is one of its biggest strengths.

---

# Provider Block

Providers are configured using a provider block.

Example:

```hcl
provider "aws" {
  region = "eu-west-1"
}
```

Breakdown:

```text
provider     → Block Type

aws          → Provider Name

region       → Configuration
```

This tells Terraform:

```text
Use the AWS Provider
Deploy resources to eu-west-1
```

---

# Required Providers

Modern Terraform configurations define providers explicitly.

Example:

```hcl
terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

  }
}
```

---

# Understanding Required Providers

Breakdown:

```hcl
aws = {
  source  = "hashicorp/aws"
  version = "~> 5.0"
}
```

### Source

```text
hashicorp/aws
```

Means:

```text
Publisher: HashiCorp
Provider: AWS
```

### Version

```text
~> 5.0
```

Allows:

```text
5.0
5.1
5.2
5.10
```

But not:

```text
6.0
```

This prevents unexpected breaking changes.

---

# Provider Installation

Providers are downloaded automatically during:

```bash
terraform init
```

Example:

```bash
terraform init
```

Terraform output:

```text
Finding hashicorp/aws versions...

Installing hashicorp/aws...

Installed hashicorp/aws
```

Terraform stores providers locally:

```text
.terraform/
└── providers/
```

---

# How Providers Work

Suppose you write:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "company-logs"
}
```

Terraform Core sees:

```text
aws_s3_bucket
```

Terraform then:

1. Loads AWS Provider
2. Calls AWS APIs
3. Creates Bucket
4. Updates State

Terraform never creates the bucket itself.

The Provider performs the actual work.

---

# Provider Versioning

Always define versions.

Bad:

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
```

Good:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

Benefits:

* Reproducibility
* Stability
* Predictable behavior

---

# Provider Authentication

Providers usually require credentials.

AWS example:

```text
Access Key
Secret Key
```

Azure example:

```text
Service Principal
```

Google Cloud example:

```text
Service Account
```

Terraform uses these credentials to make API calls.

---

# Never Hardcode Credentials

Bad:

```hcl
provider "aws" {
  access_key = "ABC123"
  secret_key = "SECRET123"
}
```

Never commit secrets into Git repositories.

---

# Preferred Authentication Methods

Use:

### Environment Variables

Example:

```bash
export AWS_ACCESS_KEY_ID=xxxxx

export AWS_SECRET_ACCESS_KEY=xxxxx
```

### IAM Roles

### Identity Federation

### Secret Managers

Production environments should avoid hardcoded credentials entirely.

---

# Multiple Providers

Terraform can use multiple providers simultaneously.

Example:

```hcl
provider "aws" {
  region = "eu-west-1"
}

provider "github" {

}
```

Terraform can then manage:

* AWS Infrastructure
* GitHub Repositories

from the same configuration.

---

# Provider Aliases

Sometimes multiple instances of the same provider are needed.

Example:

```hcl
provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "us"
  region = "us-east-1"
}
```

Now Terraform can manage resources in multiple regions.

Example:

```hcl
provider = aws.us
```

Provider aliases become important in multi-region deployments.

---

# Reading Provider Documentation

One of the most valuable Terraform skills is reading documentation.

When learning a provider:

Look for:

### Provider Configuration

Example:

```text
Authentication
Region
Endpoint Configuration
```

### Resources

Example:

```text
aws_instance
aws_s3_bucket
aws_vpc
```

### Data Sources

Example:

```text
aws_ami
aws_vpc
aws_caller_identity
```

Good Terraform engineers spend a lot of time reading provider documentation.

---

# Common Beginner Mistakes

## Forgetting Version Constraints

Always specify provider versions.

---

## Hardcoding Credentials

Never store secrets in Terraform code.

---

## Using Outdated Examples

Providers evolve.

Always verify examples against current documentation.

---

## Not Running terraform init

After changing providers:

```bash
terraform init
```

must be executed again.

---

# Best Practices

* Pin provider versions
* Avoid hardcoded credentials
* Read documentation carefully
* Use environment variables for authentication
* Keep provider configurations simple
* Upgrade providers intentionally

---

# Key Takeaways

* Providers allow Terraform to communicate with external systems.
* Terraform Core relies on Providers to create and manage infrastructure.
* Providers are downloaded during terraform init.
* Provider versions should be explicitly defined.
* Credentials should never be hardcoded.
* Multiple providers can be used within the same configuration.
* Reading provider documentation is a core Terraform skill.

---

# Next Chapter

In the next chapter, we will explore Resources.

Resources are the fundamental building blocks of Terraform and represent the infrastructure objects that Terraform manages.
