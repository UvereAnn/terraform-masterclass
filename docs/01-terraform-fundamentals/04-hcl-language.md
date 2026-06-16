# HashiCorp Configuration Language (HCL)

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand what HCL is
* Read Terraform configurations confidently
* Write valid HCL syntax
* Understand blocks and arguments
* Work with strings, numbers, booleans, lists, and maps
* Use expressions and references
* Understand comments and formatting
* Read production Terraform code

---

# What is HCL?

HCL stands for **HashiCorp Configuration Language**.

It is the language used by Terraform to define infrastructure.

Example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t3.micro"
}
```

HCL is designed to be:

* Human-readable
* Machine-readable
* Declarative
* Easy to maintain

Terraform configurations are primarily written using HCL.

---

# HCL Philosophy

Terraform is declarative.

You describe:

```text
What you want.
```

Not:

```text
How to create it.
```

Example:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "company-logs"
}
```

You are describing the desired state.

Terraform decides how to achieve it.

---

# Basic Building Blocks

Everything in Terraform is built using:

* Blocks
* Arguments
* Expressions

These are the foundations of HCL.

---

# Blocks

Blocks are the most important structure in HCL.

Example:

```hcl
resource "aws_instance" "web" {

}
```

General format:

```hcl
BLOCK_TYPE "LABEL1" "LABEL2" {

}
```

Examples:

```hcl
resource "aws_instance" "web" {

}

provider "aws" {

}

variable "environment" {

}

output "instance_id" {

}
```

---

# Understanding Block Labels

Example:

```hcl
resource "aws_instance" "web" {

}
```

Breakdown:

```text
resource       → Block Type

aws_instance   → Resource Type

web            → Resource Name
```

Terraform identifies resources using:

```text
aws_instance.web
```

This becomes important later when referencing resources.

---

# Arguments

Arguments configure a block.

Example:

```hcl
resource "aws_instance" "web" {
  instance_type = "t3.micro"
}
```

Here:

```text
instance_type → Argument

t3.micro → Value
```

General pattern:

```hcl
argument_name = value
```

---

# Strings

Strings are enclosed in quotation marks.

Example:

```hcl
name = "web-server"
```

Multiple examples:

```hcl
environment = "dev"

region = "eu-west-1"

owner = "platform-team"
```

Strings are one of the most common value types in Terraform.

---

# Numbers

Numeric values do not require quotes.

Example:

```hcl
disk_size = 50

cpu_count = 2
```

Bad:

```hcl
disk_size = "50"
```

Use actual numbers when possible.

---

# Booleans

Booleans represent true or false.

Example:

```hcl
enabled = true

encrypted = false
```

Notice:

```text
No quotes
```

Correct:

```hcl
enabled = true
```

Incorrect:

```hcl
enabled = "true"
```

---

# Lists

Lists store multiple values.

Example:

```hcl
availability_zones = [
  "eu-west-1a",
  "eu-west-1b",
  "eu-west-1c"
]
```

Structure:

```hcl
[
  value1,
  value2,
  value3
]
```

Lists are heavily used in networking and infrastructure design.

---

# Maps

Maps store key-value pairs.

Example:

```hcl
tags = {
  Environment = "dev"
  Team        = "platform"
  Owner       = "engineering"
}
```

Structure:

```hcl
{
  key = value
}
```

Maps are commonly used for tagging resources.

---

# Nested Blocks

Blocks can exist inside other blocks.

Example:

```hcl
resource "aws_security_group" "web" {

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

}
```

The ingress block is nested inside the resource block.

This pattern appears frequently in Terraform.

---

# References

Terraform resources can reference each other.

Example:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
}
```

Reference syntax:

```text
RESOURCE_TYPE.RESOURCE_NAME.ATTRIBUTE
```

Example:

```hcl
aws_vpc.main.id
```

This tells Terraform:

```text
Use the ID from this VPC.
```

---

# Expressions

Expressions allow Terraform to compute values.

Example:

```hcl
name = "server-${var.environment}"
```

If:

```hcl
environment = "dev"
```

Result:

```text
server-dev
```

Expressions make configurations dynamic.

---

# Comments

Single-line comments:

```hcl
# Create web server

// Create web server
```

Multi-line comments:

```hcl
/*
This is a
multi-line comment
*/
```

Use comments sparingly.

Good code should be self-explanatory.

---

# HCL Formatting

Bad:

```hcl
resource "aws_instance" "web"{
instance_type="t3.micro"
}
```

Good:

```hcl
resource "aws_instance" "web" {
  instance_type = "t3.micro"
}
```

Terraform provides:

```bash
terraform fmt
```

to automatically format code.

Always use it.

---

# Reading Terraform Code

Example:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "company-logs"

  tags = {
    Environment = "dev"
  }
}
```

How to read it:

1. Resource block
2. Resource type = aws_s3_bucket
3. Resource name = logs
4. Bucket name = company-logs
5. Apply tags

This skill becomes critical when working with large codebases.

---

# HCL Best Practices

## Use Meaningful Names

Bad:

```hcl
resource "aws_instance" "x" {

}
```

Good:

```hcl
resource "aws_instance" "web_server" {

}
```

---

## Keep Formatting Consistent

Always run:

```bash
terraform fmt
```

before committing code.

---

## Prefer References

Bad:

```hcl
vpc_id = "vpc-123456"
```

Good:

```hcl
vpc_id = aws_vpc.main.id
```

References reduce errors.

---

## Avoid Hardcoding

Bad:

```hcl
instance_type = "t3.micro"
```

Better:

```hcl
instance_type = var.instance_type
```

We'll cover variables in a dedicated chapter.

---

# HCL Mastery Checklist

You should now understand:

* Blocks
* Arguments
* Strings
* Numbers
* Booleans
* Lists
* Maps
* Nested Blocks
* References
* Expressions
* Comments
* Formatting

These concepts appear in nearly every Terraform configuration.

---

# Key Takeaways

* HCL is the language used by Terraform.
* Terraform configurations are built from blocks and arguments.
* Values can be strings, numbers, booleans, lists, or maps.
* References allow resources to communicate with each other.
* Expressions create dynamic configurations.
* Consistent formatting improves readability and maintainability.
* Learning HCL is the foundation of becoming proficient with Terraform.

---

# Next Chapter

In the next chapter, we will explore Providers.

Providers allow Terraform to communicate with platforms such as AWS, Azure, Google Cloud, Kubernetes, GitHub, and many others.
