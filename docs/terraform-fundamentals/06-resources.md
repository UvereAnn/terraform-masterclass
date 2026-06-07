# Resources

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand what a Terraform Resource is
* Read and write Resource blocks
* Understand Resource Types and Names
* Reference Resources correctly
* Understand Resource Attributes
* Understand Resource Dependencies
* Understand Resource Lifecycle basics
* Create simple Terraform resources

---

# What is a Resource?

A Resource is the fundamental building block of Terraform.

Resources represent infrastructure objects that Terraform creates, updates, and destroys.

Examples:

* Virtual Machines
* Networks
* Subnets
* Storage Buckets
* Databases
* Security Groups
* Kubernetes Deployments
* DNS Records

Whenever Terraform manages something, it is usually represented as a resource.

---

# Resource Block Syntax

General syntax:

```hcl
resource "<RESOURCE_TYPE>" "<RESOURCE_NAME>" {

}
```

Example:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "company-logs"
}
```

---

# Understanding Resource Components

Example:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "company-logs"
}
```

Breakdown:

```text
resource
│
├── aws_s3_bucket
│      Resource Type
│
├── logs
│      Resource Name
│
└── bucket
       Argument
```

---

# Resource Type

The resource type identifies what infrastructure object Terraform should create.

Examples:

```hcl
aws_instance
aws_s3_bucket
aws_vpc
aws_subnet
aws_security_group
```

The resource type is provided by the provider.

AWS Provider examples:

```hcl
aws_instance

aws_s3_bucket

aws_vpc
```

Kubernetes Provider examples:

```hcl
kubernetes_namespace

kubernetes_service

kubernetes_deployment
```

---

# Resource Name

The resource name is a local identifier within Terraform.

Example:

```hcl
resource "aws_instance" "web" {

}
```

Here:

```text
web
```

is the resource name.

Terraform references the resource using:

```text
aws_instance.web
```

The name does not necessarily match the actual cloud resource name.

---

# Resource Arguments

Arguments define how a resource should be configured.

Example:

```hcl
resource "aws_instance" "web" {
  instance_type = "t3.micro"
}
```

Argument:

```text
instance_type
```

Value:

```text
t3.micro
```

Different resources support different arguments.

Always consult documentation to determine required and optional arguments.

---

# Resource Attributes

Resources expose attributes after creation.

Example:

```hcl
aws_instance.web.id
```

Common attributes:

```text
id

arn

name

private_ip

public_ip
```

These attributes can be referenced by other resources.

---

# Referencing Resources

Terraform resources can communicate using references.

Example:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
}
```

Terraform understands:

```text
Subnet depends on VPC
```

and automatically creates resources in the correct order.

---

# Resource Dependency Graph

Terraform builds a dependency graph automatically.

Example:

```text
VPC
 |
Subnet
 |
EC2 Instance
```

Terraform uses references to determine execution order.

This is one of Terraform's most powerful features.

---

# Explicit Dependencies

Sometimes dependencies are not obvious.

Terraform provides:

```hcl
depends_on
```

Example:

```hcl
resource "aws_instance" "web" {

  depends_on = [
    aws_security_group.web
  ]

}
```

This tells Terraform:

```text
Create Security Group first.
```

---

# Resource Lifecycle

Terraform resources go through a lifecycle.

```text
Create
  |
Read
  |
Update
  |
Delete
```

Terraform continuously compares:

```text
Desired State
vs
Current State
```

and performs the necessary lifecycle operations.

---

# Example Resource

Example S3 Bucket:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "terraform-masterclass-demo-bucket"
}
```

Terraform sees:

```text
Desired State:
One S3 Bucket
```

and creates it if it does not exist.

---

# Multiple Resources

Terraform can manage many resources simultaneously.

Example:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}
```

Terraform builds the relationship automatically.

---

# Resource Naming Best Practices

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

Even better:

```hcl
resource "aws_instance" "frontend_web_server" {

}
```

Names should clearly communicate purpose.

---

# Reading Resource Documentation

When reviewing documentation, look for:

## Required Arguments

Example:

```text
bucket
```

Must be supplied.

---

## Optional Arguments

Example:

```text
tags
```

Can be supplied if needed.

---

## Attributes

Example:

```text
id
arn
```

Available after creation.

---

# Common Beginner Mistakes

## Hardcoding Resource Relationships

Bad:

```hcl
vpc_id = "vpc-12345"
```

Good:

```hcl
vpc_id = aws_vpc.main.id
```

---

## Poor Naming

Bad:

```hcl
resource "aws_instance" "test" {

}
```

Use meaningful names.

---

## Ignoring Dependencies

Always think:

```text
What must exist first?
```

Terraform usually handles dependencies automatically through references.

---

# Best Practices

* Use meaningful resource names
* Prefer references over hardcoded values
* Read documentation carefully
* Keep resources focused
* Understand dependencies
* Use explicit dependencies only when necessary

---

# Key Takeaways

* Resources are Terraform's core building blocks.
* Resources represent infrastructure objects.
* Every resource has a type and a name.
* Resources expose attributes that can be referenced.
* Terraform automatically builds dependency graphs.
* References allow resources to communicate with one another.
* Understanding resources is fundamental to becoming proficient with Terraform.

---

# Next Chapter

In the next chapter, we will explore Data Sources.

While resources create and manage infrastructure, data sources allow Terraform to retrieve information from infrastructure that already exists.
