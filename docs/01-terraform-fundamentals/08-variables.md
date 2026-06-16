# Variables

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand why Variables exist
* Define Input Variables
* Use Variables in Terraform configurations
* Understand Variable Types
* Use Default Values
* Pass Variables using multiple methods
* Understand Sensitive Variables
* Implement Variable Validation
* Follow Variable Best Practices

---

# What are Variables?

Variables allow Terraform configurations to accept input values.

Instead of hardcoding values directly into configurations, variables make infrastructure reusable and configurable.

Without variables:

```hcl
resource "aws_instance" "web" {
  instance_type = "t3.micro"
}
```

With variables:

```hcl
resource "aws_instance" "web" {
  instance_type = var.instance_type
}
```

Now the instance type can change without modifying the code.

---

# Why Variables Matter

Imagine supporting three environments:

```text
Development
Staging
Production
```

Without variables:

```text
Three separate configurations
```

With variables:

```text
One configuration
Multiple input values
```

This dramatically improves maintainability.

---

# Declaring Variables

Variables are defined using the variable block.

Example:

```hcl
variable "instance_type" {
  type = string
}
```

General syntax:

```hcl
variable "name" {

}
```

Terraform creates:

```text
var.instance_type
```

for use throughout the configuration.

---

# Using Variables

Variable:

```hcl
variable "instance_type" {
  type = string
}
```

Usage:

```hcl
resource "aws_instance" "web" {
  instance_type = var.instance_type
}
```

Reference syntax:

```text
var.<variable_name>
```

Example:

```hcl
var.instance_type
```

---

# Default Values

Variables may include defaults.

Example:

```hcl
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
```

If no value is supplied:

```text
t3.micro
```

will be used automatically.

---

# Required Variables

Variables without defaults are required.

Example:

```hcl
variable "environment" {
  type = string
}
```

Terraform will prompt:

```text
Enter a value:
```

if the variable is not supplied.

---

# Variable Types

Terraform supports multiple variable types.

---

## String

```hcl
variable "environment" {
  type = string
}
```

Example value:

```text
dev
```

---

## Number

```hcl
variable "disk_size" {
  type = number
}
```

Example:

```text
50
```

---

## Boolean

```hcl
variable "enable_encryption" {
  type = bool
}
```

Example:

```text
true
```

---

## List

```hcl
variable "availability_zones" {
  type = list(string)
}
```

Example:

```hcl
[
  "eu-west-1a",
  "eu-west-1b"
]
```

---

## Map

```hcl
variable "tags" {
  type = map(string)
}
```

Example:

```hcl
{
  Environment = "dev"
  Team        = "platform"
}
```

---

## Object

```hcl
variable "server" {

  type = object({
    name = string
    size = string
  })

}
```

Example:

```hcl
{
  name = "web"
  size = "t3.micro"
}
```

Objects are heavily used in enterprise Terraform projects.

---

# Variable Description

Always document variables.

Example:

```hcl
variable "instance_type" {

  description = "EC2 instance type"

  type = string

}
```

Descriptions improve readability and module usability.

---

# Sensitive Variables

Some variables contain secrets.

Examples:

* Passwords
* Tokens
* API Keys

Mark them as sensitive.

Example:

```hcl
variable "database_password" {

  type      = string
  sensitive = true

}
```

Terraform hides sensitive values from output.

---

# Variable Validation

Terraform can validate inputs.

Example:

```hcl
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

```text
dev
staging
prod
```

Invalid:

```text
production
```

Terraform will fail with a clear error.

---

# Supplying Variable Values

Terraform supports multiple methods.

---

## Method 1: Interactive Prompt

```bash
terraform apply
```

Terraform asks:

```text
Enter a value:
```

---

## Method 2: Command Line

```bash
terraform apply \
  -var="environment=dev"
```

---

## Method 3: Variable File

Create:

```text
terraform.tfvars
```

Example:

```hcl
environment   = "dev"
instance_type = "t3.micro"
```

Terraform automatically loads this file.

---

## Method 4: Custom Variable File

Create:

```text
dev.tfvars
```

Use:

```bash
terraform apply \
  -var-file="dev.tfvars"
```

Common in multi-environment deployments.

---

## Method 5: Environment Variables

Example:

```bash
export TF_VAR_environment=dev
```

Terraform automatically loads:

```text
TF_VAR_<variable_name>
```

---

# Variable Precedence

When multiple values exist, Terraform follows precedence rules.

Highest priority:

```text
Command Line Variables
```

Then:

```text
Variable Files
```

Then:

```text
Environment Variables
```

Then:

```text
Default Values
```

Understanding precedence prevents confusion.

---

# Common Production Pattern

variables.tf

```hcl
variable "environment" {
  type = string
}

variable "instance_type" {
  type = string
}
```

dev.tfvars

```hcl
environment   = "dev"
instance_type = "t3.micro"
```

prod.tfvars

```hcl
environment   = "prod"
instance_type = "t3.large"
```

Same code.

Different environments.

---

# Common Beginner Mistakes

## Hardcoding Values

Bad:

```hcl
instance_type = "t3.micro"
```

Better:

```hcl
instance_type = var.instance_type
```

---

## Missing Types

Bad:

```hcl
variable "environment" {}
```

Good:

```hcl
variable "environment" {
  type = string
}
```

Always specify types.

---

## Storing Secrets in Git

Never commit:

```hcl
password = "super-secret-password"
```

Use:

* Environment Variables
* Secret Managers
* Vault Solutions

---

# Best Practices

* Always define types
* Add descriptions
* Use validation where possible
* Use tfvars files for environments
* Mark secrets as sensitive
* Avoid hardcoded values
* Keep variables focused and meaningful

---

# Key Takeaways

* Variables make Terraform reusable.
* Variables accept input values.
* Variables support multiple data types.
* Variables can have defaults.
* Variables can be validated.
* Variables can be marked sensitive.
* Production Terraform projects rely heavily on variables.

---

# Next Chapter

In the next chapter, we will explore Outputs.

Outputs allow Terraform to expose information about created infrastructure and are commonly used to connect modules and share infrastructure details.
