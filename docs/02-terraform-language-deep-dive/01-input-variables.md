# Input Variables

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand Input Variables in depth
* Design reusable Terraform configurations
* Separate infrastructure from configuration
* Pass values using multiple methods
* Understand variable precedence
* Build environment-specific deployments
* Follow enterprise variable design practices
* Avoid common variable anti-patterns

---

# Introduction

Input Variables are one of the most important concepts in Terraform.

They allow infrastructure configurations to accept external input instead of relying on hardcoded values.

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

The configuration becomes reusable.

---

# Why Input Variables Exist

Imagine a company deploying the same application to:

```text
Development

Staging

Production
```

Without variables:

```text
Three Terraform configurations

Three sets of code

Three maintenance burdens
```

With variables:

```text
One Terraform configuration

Multiple inputs

Much easier maintenance
```

This is one of the foundations of Infrastructure as Code.

---

# Terraform Philosophy

Terraform encourages:

```text
Code should stay the same

Inputs should change
```

Bad approach:

```text
Modify code for every environment
```

Good approach:

```text
Keep code identical

Provide different variable values
```

This principle scales extremely well.

---

# Declaring an Input Variable

Basic syntax:

```hcl
variable "instance_type" {
  type = string
}
```

Terraform automatically creates:

```hcl
var.instance_type
```

which can be referenced anywhere in the configuration.

---

# Anatomy of a Variable Block

Example:

```hcl
variable "instance_type" {

  description = "EC2 instance type"

  type = string

  default = "t3.micro"

}
```

Components:

```text
variable
│
├── name
├── description
├── type
└── default
```

Each component has a specific purpose.

---

# Variable Names

Choose meaningful names.

Bad:

```hcl
variable "x" {}
```

Bad:

```hcl
variable "server" {}
```

Good:

```hcl
variable "instance_type" {}
```

Good:

```hcl
variable "database_engine_version" {}
```

Names should communicate intent.

---

# Referencing Variables

Terraform uses:

```hcl
var.<name>
```

Example:

```hcl
var.environment
```

Example:

```hcl
var.instance_type
```

Example:

```hcl
var.owner
```

This syntax appears constantly in Terraform codebases.

---

# Variables as Configuration Inputs

Example:

```hcl
variable "environment" {
  type = string
}
```

Usage:

```hcl
resource "aws_s3_bucket" "logs" {

  bucket = "${var.environment}-logs"

}
```

Results:

```text
dev-logs

staging-logs

prod-logs
```

without changing the code.

---

# Required Variables

Variables without defaults are required.

Example:

```hcl
variable "environment" {
  type = string
}
```

Terraform requires a value.

Running:

```bash
terraform apply
```

produces:

```text
Enter a value:
```

if the variable has not been supplied.

---

# Optional Variables

Variables with defaults become optional.

Example:

```hcl
variable "instance_type" {

  type    = string

  default = "t3.micro"

}
```

Terraform automatically uses:

```text
t3.micro
```

unless another value is provided.

---

# Variable Descriptions

Descriptions document variables.

Example:

```hcl
variable "environment" {

  description = "Deployment environment"

  type = string

}
```

Benefits:

```text
Improved documentation

Better module usability

Clearer intent
```

Always include descriptions.

---

# Variable Usage Across Files

Terraform loads all .tf files in a directory.

Example:

variables.tf

```hcl
variable "environment" {
  type = string
}
```

main.tf

```hcl
resource "aws_s3_bucket" "logs" {

  bucket = "${var.environment}-logs"

}
```

Terraform automatically connects them.

There is no need to import variables manually.

---

# Passing Variable Values

Terraform supports multiple methods.

---

## Method 1: Interactive Prompt

Command:

```bash
terraform apply
```

Terraform asks:

```text
Enter a value:
```

Useful for learning.

Rare in production.

---

## Method 2: Command Line Variables

Example:

```bash
terraform apply \
  -var="environment=dev"
```

Terraform receives:

```text
environment = dev
```

directly from the command line.

---

## Method 3: terraform.tfvars

File:

```hcl
environment = "dev"

instance_type = "t3.micro"
```

Terraform loads this automatically.

This is one of the most common approaches.

---

## Method 4: Custom Variable Files

Example:

```text
dev.tfvars

staging.tfvars

prod.tfvars
```

Apply:

```bash
terraform apply \
  -var-file="dev.tfvars"
```

This pattern is extremely common.

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

This approach is heavily used in CI/CD systems.

---

# Variable Precedence

Terraform follows precedence rules.

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

Understanding precedence is important for troubleshooting.

---

# Enterprise Environment Pattern

Variables:

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

staging.tfvars

```hcl
environment   = "staging"
instance_type = "t3.small"
```

prod.tfvars

```hcl
environment   = "prod"
instance_type = "t3.large"
```

Same Terraform code.

Different infrastructure behavior.

---

# Common Beginner Mistakes

## Hardcoding Values

Bad:

```hcl
instance_type = "t3.micro"
```

Good:

```hcl
instance_type = var.instance_type
```

---

## Missing Descriptions

Bad:

```hcl
variable "environment" {}
```

Good:

```hcl
variable "environment" {

  description = "Deployment environment"

  type = string

}
```

---

## Using Variables for Everything

Not every value needs a variable.

Some values belong in:

```hcl
locals {}
```

instead.

---

## Poor Naming

Bad:

```hcl
variable "test" {}
```

Good:

```hcl
variable "database_instance_class" {}
```

---

# Best Practices

* Always define variable types
* Always include descriptions
* Use meaningful names
* Use tfvars files for environments
* Avoid unnecessary variables
* Keep variables focused
* Never store secrets directly in Git

---

# Real-World Example

A production Terraform deployment might have:

```text
variables.tf

dev.tfvars

staging.tfvars

prod.tfvars
```

The infrastructure code remains unchanged.

Only inputs vary.

This approach allows:

```text
Consistency

Predictability

Scalability
```

across environments.

---

# Key Takeaways

* Input Variables make Terraform reusable.
* Variables separate configuration from code.
* Variables can be required or optional.
* Variables support multiple input methods.
* Variable files are widely used in production.
* Enterprise Terraform heavily relies on variable-driven configurations.
* Good variable design improves maintainability.

---

# Next Chapter

In the next chapter, we will explore Variable Types.

We will move beyond simple strings and learn:

* string
* number
* bool
* list
* set
* map
* object
* tuple

Understanding Terraform's type system is essential for writing advanced, production-grade Terraform.
