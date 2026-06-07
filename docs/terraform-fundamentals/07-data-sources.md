# Data Sources

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand what Data Sources are
* Understand the difference between Resources and Data Sources
* Read existing infrastructure using Terraform
* Reference Data Source attributes
* Use Data Sources with Resources
* Understand common Data Source patterns
* Avoid common Data Source mistakes

---

# What is a Data Source?

A Data Source allows Terraform to retrieve information from infrastructure that already exists.

Unlike Resources, Data Sources do not create, update, or delete infrastructure.

They simply query information.

Think of Data Sources as:

```text
READ ONLY
```

Terraform asks a provider:

```text
"Tell me information about this resource."
```

and the provider returns the information.

---

# Resources vs Data Sources

This distinction is critical.

## Resource

Creates or manages infrastructure.

Example:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "company-logs"
}
```

Terraform manages this bucket.

---

## Data Source

Reads existing infrastructure.

Example:

```hcl
data "aws_caller_identity" "current" {}
```

Terraform retrieves information but creates nothing.

---

# Data Source Syntax

General syntax:

```hcl
data "<DATA_SOURCE_TYPE>" "<NAME>" {

}
```

Example:

```hcl
data "aws_availability_zones" "available" {}
```

Breakdown:

```text
data
│
├── aws_availability_zones
│
└── available
```

---

# Why Data Sources Exist

Infrastructure often already exists.

Examples:

* Existing VPCs
* Existing Subnets
* Existing AMIs
* Existing IAM Roles
* Existing DNS Zones

Terraform needs a way to discover these resources.

Data Sources solve this problem.

---

# Example: AWS Account Information

One of the most common Data Sources:

```hcl
data "aws_caller_identity" "current" {}
```

Usage:

```hcl
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

Terraform returns:

```text
123456789012
```

without creating any infrastructure.

---

# Referencing Data Sources

The syntax is similar to resources.

General pattern:

```text
data.TYPE.NAME.ATTRIBUTE
```

Example:

```hcl
data.aws_caller_identity.current.account_id
```

Breakdown:

```text
data
│
├── aws_caller_identity
│
├── current
│
└── account_id
```

---

# Example: Availability Zones

A common AWS Data Source:

```hcl
data "aws_availability_zones" "available" {}
```

Output:

```hcl
output "azs" {
  value = data.aws_availability_zones.available.names
}
```

Possible result:

```text
[
  "eu-west-1a",
  "eu-west-1b",
  "eu-west-1c"
]
```

This makes Terraform configurations more dynamic.

---

# Example: Finding an Existing VPC

Suppose a VPC already exists.

Instead of hardcoding IDs:

Bad:

```hcl
vpc_id = "vpc-123456"
```

Use a Data Source:

```hcl
data "aws_vpc" "main" {
  id = "vpc-123456"
}
```

Reference:

```hcl
data.aws_vpc.main.id
```

This is cleaner and easier to maintain.

---

# Data Sources and Resources Together

A common pattern:

Read existing infrastructure and build on top of it.

Example:

```hcl
data "aws_vpc" "main" {
  id = "vpc-123456"
}

resource "aws_subnet" "public" {
  vpc_id     = data.aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}
```

Terraform:

```text
Reads VPC
     ↓
Creates Subnet
```

---

# Data Sources Are Evaluated During Planning

When running:

```bash
terraform plan
```

Terraform:

1. Reads Data Sources
2. Retrieves information
3. Uses the returned values
4. Generates a plan

This happens before resource creation.

---

# Common AWS Data Sources

## Account Identity

```hcl
data "aws_caller_identity" "current" {}
```

---

## Region Information

```hcl
data "aws_region" "current" {}
```

---

## Availability Zones

```hcl
data "aws_availability_zones" "available" {}
```

---

## Existing VPC

```hcl
data "aws_vpc" "main" {}
```

---

## Existing Subnets

```hcl
data "aws_subnets" "private" {}
```

---

## Existing AMI

```hcl
data "aws_ami" "amazon_linux" {}
```

One of the most frequently used Data Sources in AWS projects.

---

# Dynamic Infrastructure

Without Data Sources:

```hcl
region = "eu-west-1"
```

With Data Sources:

```hcl
data "aws_region" "current" {}
```

Terraform adapts automatically.

This makes configurations more reusable.

---

# Common Beginner Mistakes

## Confusing Resources and Data Sources

Wrong expectation:

```text
Data Source creates infrastructure
```

It does not.

Data Sources only read.

---

## Hardcoding Values

Bad:

```hcl
vpc_id = "vpc-123456"
```

Often better:

```hcl
data.aws_vpc.main.id
```

---

## Assuming Infrastructure Exists

If a Data Source cannot find a resource:

```bash
terraform plan
```

will fail.

Always verify assumptions.

---

# Best Practices

* Use Data Sources for existing infrastructure
* Avoid hardcoded IDs where possible
* Use Data Sources to make configurations dynamic
* Read documentation carefully
* Combine Data Sources and Resources effectively

---

# Real-World Example

Large organizations often have:

* Shared VPCs
* Shared IAM Roles
* Shared DNS Zones
* Shared Networking

Application teams typically do not create these resources.

Instead, they:

```text
Read Existing Infrastructure
          ↓
Deploy New Resources
```

using Data Sources.

This pattern appears in almost every enterprise Terraform codebase.

---

# Key Takeaways

* Data Sources retrieve information from existing infrastructure.
* Data Sources are read-only.
* Resources create and manage infrastructure.
* Data Sources make configurations more dynamic and reusable.
* Data Sources are commonly used to discover existing cloud resources.
* Most production Terraform projects use both Resources and Data Sources.

---

# Next Chapter

In the next chapter, we will explore Variables.

Variables allow Terraform configurations to become reusable, configurable, and environment-independent.
