# Locals

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand what Locals are
* Create Local Values
* Reference Local Values
* Reduce Code Duplication
* Build Dynamic Naming Conventions
* Improve Terraform Readability
* Understand Common Local Patterns
* Follow Local Best Practices

---

# What are Locals?

Locals allow you to assign a value to a name and reuse it throughout your Terraform configuration.

Think of Locals as:

```text
Reusable internal variables
```

Unlike Input Variables:

```text
Variables receive input from users
```

Locals:

```text
Are calculated inside Terraform
```

---

# Why Locals Exist

Without Locals:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "dev-platform-logs"
}

resource "aws_s3_bucket" "backups" {
  bucket = "dev-platform-backups"
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "dev-platform-artifacts"
}
```

Notice:

```text
dev-platform
```

is repeated everywhere.

This creates maintenance problems.

---

# Using Locals

Instead:

```hcl
locals {
  project_prefix = "dev-platform"
}
```

Then:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "${local.project_prefix}-logs"
}

resource "aws_s3_bucket" "backups" {
  bucket = "${local.project_prefix}-backups"
}
```

Now the value exists in one location.

---

# Local Block Syntax

General syntax:

```hcl
locals {

}
```

Example:

```hcl
locals {
  environment = "dev"
}
```

Reference syntax:

```hcl
local.environment
```

Notice:

```text
local
```

not:

```text
locals
```

---

# Multiple Local Values

You can define many locals within a single block.

Example:

```hcl
locals {

  environment = "dev"

  application = "web"

  owner = "platform-team"

}
```

Usage:

```hcl
local.environment

local.application

local.owner
```

---

# Building Dynamic Values

Locals often combine variables and expressions.

Example:

```hcl
variable "environment" {
  type = string
}

locals {
  project_name = "${var.environment}-platform"
}
```

If:

```text
environment = dev
```

Then:

```text
project_name = dev-platform
```

---

# Locals and String Interpolation

Example:

```hcl
locals {
  bucket_name = "${var.environment}-logs"
}
```

Usage:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = local.bucket_name
}
```

This is extremely common in production Terraform.

---

# Locals Using Functions

Locals can use Terraform functions.

Example:

```hcl
locals {
  project_name = upper(var.environment)
}
```

Input:

```text
dev
```

Output:

```text
DEV
```

Another example:

```hcl
locals {
  full_name = join(
    "-",
    [
      var.environment,
      var.application
    ]
  )
}
```

Result:

```text
dev-web
```

---

# Locals Using Conditionals

Locals frequently contain logic.

Example:

```hcl
locals {
  instance_type = var.environment == "prod"
    ? "t3.large"
    : "t3.micro"
}
```

Result:

```text
prod → t3.large

dev → t3.micro
```

This keeps resource blocks clean.

---

# Locals Using Maps

Example:

```hcl
locals {

  instance_sizes = {
    dev     = "t3.micro"
    staging = "t3.small"
    prod    = "t3.large"
  }

}
```

Usage:

```hcl
local.instance_sizes[var.environment]
```

Result:

```text
dev → t3.micro
```

This pattern appears frequently in enterprise Terraform code.

---

# Common Production Example

Variables:

```hcl
variable "environment" {
  type = string
}
```

Locals:

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
resource "aws_s3_bucket" "logs" {

  bucket = "company-logs"

  tags = local.common_tags

}
```

Instead of repeating tags on every resource.

---

# Resource Naming Pattern

Production teams often use locals for naming.

Example:

```hcl
locals {

  naming_prefix = join(
    "-",
    [
      var.environment,
      var.application
    ]
  )

}
```

Result:

```text
dev-web

staging-web

prod-web
```

Resources become:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "${local.naming_prefix}-logs"
}
```

---

# Locals vs Variables

Variables:

```text
Receive external input
```

Example:

```hcl
variable "environment" {}
```

Locals:

```text
Calculate internal values
```

Example:

```hcl
locals {
  bucket_name = "${var.environment}-logs"
}
```

Rule of thumb:

```text
User supplies Variables

Terraform calculates Locals
```

---

# Common Beginner Mistakes

## Using Variables Instead of Locals

Bad:

```hcl
variable "project_name" {
  default = "dev-platform"
}
```

Better:

```hcl
locals {
  project_name = "dev-platform"
}
```

---

## Duplicating Values

Bad:

```hcl
bucket = "dev-platform-logs"

bucket = "dev-platform-backups"

bucket = "dev-platform-artifacts"
```

Use a Local instead.

---

## Excessively Complex Locals

Bad:

```hcl
locals {
  giant_expression = ...
}
```

Keep locals understandable.

---

# Best Practices

* Use locals to reduce duplication
* Centralize naming conventions
* Centralize common tags
* Use locals for calculations
* Keep locals readable
* Avoid unnecessary complexity

---

# Real-World Enterprise Pattern

Most production repositories contain:

```hcl
locals {

  project = "terraform-masterclass"

  common_tags = {
    ManagedBy = "Terraform"
    Project   = local.project
    Team      = "Platform"
  }

}
```

Almost every resource references:

```hcl
tags = local.common_tags
```

This ensures consistency across infrastructure.

---

# Key Takeaways

* Locals create reusable internal values.
* Locals reduce duplication.
* Locals improve readability.
* Locals can use expressions, functions, and conditionals.
* Locals are heavily used in production Terraform projects.
* Variables provide input; Locals calculate values.

---

# Next Chapter

In the next chapter, we will explore the Terraform CLI.

The Terraform CLI is the primary interface used to initialize, validate, plan, apply, destroy, debug, and manage infrastructure.
