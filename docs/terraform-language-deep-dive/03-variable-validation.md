# Variable Validation

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand Variable Validation
* Create Validation Rules
* Prevent Invalid Inputs
* Use Terraform Functions in Validation
* Build Self-Validating Modules
* Implement Production Validation Patterns
* Avoid Common Validation Mistakes

---

# Introduction

Variables allow users to provide input.

But what happens if they provide:

```text id="n8r3qt"
Wrong values

Unexpected values

Dangerous values
```

Without validation:

```text id="m7v5kc"
Terraform accepts the value
```

and may fail later.

With validation:

```text id="y4x2pf"
Terraform rejects the value immediately
```

before any infrastructure changes occur.

---

# Why Validation Matters

Example:

```hcl id="t7x3na"
variable "environment" {
  type = string
}
```

User enters:

```text id="r6n4pl"
production
```

But your company standard is:

```text id="s5x8bh"
dev

staging

prod
```

Without validation:

Terraform continues.

With validation:

Terraform stops immediately.

---

# Validation Block Syntax

Basic structure:

```hcl id="a9q7vz"
variable "environment" {

  type = string

  validation {

    condition = true

    error_message = "Validation failed."

  }

}
```

Components:

```text id="k3m1ru"
validation
│
├── condition
│
└── error_message
```

---

# How Validation Works

Terraform evaluates:

```hcl id="x8p4nb"
condition
```

If:

```text id="w9d6hj"
true
```

Terraform continues.

If:

```text id="e2q7ms"
false
```

Terraform stops.

Then displays:

```hcl id="f5c8yo"
error_message
```

---

# Example: Environment Validation

Variable:

```hcl id="c4z7bn"
variable "environment" {

  type = string

  validation {

    condition = contains(
      ["dev", "staging", "prod"],
      var.environment
    )

    error_message = "Environment must be dev, staging, or prod."

  }

}
```

Valid:

```text id="h7v9xc"
dev

staging

prod
```

Invalid:

```text id="n4m2ks"
production
```

Terraform fails immediately.

---

# The contains Function

A very common validation function.

Example:

```hcl id="q2w8df"
contains(
  ["dev", "staging", "prod"],
  var.environment
)
```

Result:

```text id="r8c5tn"
true
```

if the value exists.

Otherwise:

```text id="m1x6gy"
false
```

---

# Example: Minimum Length Validation

Variable:

```hcl id="y3p8rv"
variable "application_name" {

  type = string

  validation {

    condition = length(var.application_name) >= 3

    error_message = "Application name must contain at least 3 characters."

  }

}
```

Valid:

```text id="g7w2me"
web

inventory
```

Invalid:

```text id="v9r4pq"
ab
```

---

# Using length()

Terraform provides:

```hcl id="s2q9nt"
length()
```

for validation.

Example:

```hcl id="c8x5vf"
length(var.application_name)
```

Returns:

```text id="n5y1ko"
Number of characters
```

---

# Example: Numeric Range Validation

Variable:

```hcl id="m4k7zd"
variable "replicas" {

  type = number

  validation {

    condition = (
      var.replicas >= 1 &&
      var.replicas <= 10
    )

    error_message = "Replicas must be between 1 and 10."

  }

}
```

Valid:

```text id="b3n8cx"
1

5

10
```

Invalid:

```text id="y8j6tm"
0

50
```

---

# Example: AWS Region Validation

Variable:

```hcl id="u6k9dh"
variable "aws_region" {

  type = string

  validation {

    condition = contains(
      [
        "eu-west-1",
        "eu-central-1",
        "us-east-1"
      ],
      var.aws_region
    )

    error_message = "Unsupported AWS region."

  }

}
```

This prevents deployment into unexpected regions.

---

# Example: Prefix Validation

Suppose all applications must start with:

```text id="z4t8vm"
app-
```

Validation:

```hcl id="h1p7cq"
variable "application_name" {

  type = string

  validation {

    condition = startswith(
      var.application_name,
      "app-"
    )

    error_message = "Application names must begin with app-."

  }

}
```

Valid:

```text id="j3x5nb"
app-inventory
```

Invalid:

```text id="e8m2kr"
inventory
```

---

# Using startswith()

Terraform function:

```hcl id="w5r9tz"
startswith()
```

Checks string prefixes.

Very useful for naming standards.

---

# Example: Suffix Validation

Example:

```hcl id="t9c6hy"
variable "bucket_name" {

  type = string

  validation {

    condition = endswith(
      var.bucket_name,
      "-logs"
    )

    error_message = "Bucket name must end with -logs."

  }

}
```

Useful for enforcing conventions.

---

# Regex Validation

Terraform supports regular expressions.

Example:

```hcl id="k7v2pa"
variable "environment" {

  type = string

  validation {

    condition = can(
      regex(
        "^(dev|staging|prod)$",
        var.environment
      )
    )

    error_message = "Environment must be dev, staging, or prod."

  }

}
```

Regex provides maximum flexibility.

---

# CIDR Validation Example

Networking modules often validate CIDR blocks.

Example:

```hcl id="p4x8mg"
variable "vpc_cidr" {

  type = string

  validation {

    condition = can(
      cidrhost(
        var.vpc_cidr,
        0
      )
    )

    error_message = "Invalid CIDR block."

  }

}
```

Valid:

```text id="m9y6rd"
10.0.0.0/16
```

Invalid:

```text id="f2v8kj"
not-a-cidr
```

---

# Multiple Validation Rules

A variable may contain multiple validations.

Example:

```hcl id="g6q4ne"
variable "application_name" {

  type = string

  validation {

    condition = length(var.application_name) >= 3

    error_message = "Minimum length is 3."

  }

  validation {

    condition = startswith(
      var.application_name,
      "app-"
    )

    error_message = "Must begin with app-."

  }

}
```

Terraform evaluates all validations.

---

# Enterprise Validation Pattern

Example:

```hcl id="r8w3xp"
variable "environment" {

  description = "Deployment environment"

  type = string

  validation {

    condition = contains(
      ["dev", "staging", "prod"],
      var.environment
    )

    error_message = "Valid values: dev, staging, prod."

  }

}
```

This pattern appears in many production modules.

---

# Common Validation Functions

Terraform functions frequently used in validation:

```text id="q5t9md"
contains()

length()

startswith()

endswith()

regex()

can()
```

Learn these well.

---

# Common Beginner Mistakes

## No Validation

Bad:

```hcl id="x1r7vk"
variable "environment" {
  type = string
}
```

Users can enter anything.

---

## Overly Restrictive Validation

Bad:

```text id="h6m8pc"
Rejecting legitimate future values
```

Leave room for growth.

---

## Poor Error Messages

Bad:

```hcl id="n2q4yb"
error_message = "Invalid value."
```

Good:

```hcl id="v8p1je"
error_message = "Environment must be dev, staging, or prod."
```

Be specific.

---

# Best Practices

* Validate critical inputs
* Write helpful error messages
* Validate environment names
* Validate regions
* Validate CIDR blocks
* Validate naming conventions
* Keep validation readable

---

# Real-World Examples

Common validations:

```text id="z6k4hy"
Environment Names

AWS Regions

Subnet CIDRs

Application Names

Resource Prefixes

Replica Counts

Storage Sizes
```

These validations prevent many production issues.

---

# Key Takeaways

* Validation protects Terraform configurations from invalid input.
* Validation runs before infrastructure deployment.
* Conditions must evaluate to true.
* Helpful error messages improve usability.
* Validation is heavily used in production modules.
* Functions such as contains(), length(), regex(), and startswith() are commonly used.

---

# Next Chapter

In the next chapter, we will explore Expressions.

Expressions are the foundation of Terraform logic and enable:

* Conditionals
* Dynamic Values
* Computed Infrastructure
* Advanced Configuration Patterns

This is where Terraform starts feeling like a programming language.
