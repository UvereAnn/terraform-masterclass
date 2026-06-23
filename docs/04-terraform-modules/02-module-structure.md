# Terraform Module Structure

## Learning Objectives

By the end of this chapter, you should understand:

- Professional Terraform module structure
- Root modules vs child modules
- Where files belong
- How to organize reusable infrastructure
- How companies structure Terraform repositories

---

# Introduction

A Terraform module is not just a folder.

A good module follows a predictable structure.

Professional Terraform repositories usually separate:

```
Reusable Modules

and

Environment Configurations
```

---

# Basic Module Structure

A simple module:

```
modules/

└── network/

    ├── main.tf

    ├── variables.tf

    ├── outputs.tf

    └── versions.tf
```

---

# main.tf

Purpose:

Contains the resources.

Example:

```hcl
resource "aws_vpc" "main" {

}
```

Think:

```
What does this module create?
```

---

# variables.tf

Purpose:

Defines inputs.

Example:

```hcl
variable "cidr_block" {

 type = string

}
```

Think:

```
What does the user provide?
```

---

# outputs.tf

Purpose:

Returns useful information.

Example:

```hcl
output "vpc_id" {

 value = aws_vpc.main.id

}
```

Think:

```
What should users receive back?
```

---

# versions.tf

Purpose:

Defines Terraform and provider requirements.

Example:

```hcl
terraform {

 required_version = ">=1.8.0"

}
```

---

# Complete Module Example

Structure:

```
modules/

└── network/

    ├── main.tf

    ├── variables.tf

    ├── outputs.tf

    ├── versions.tf

    └── README.md
```

---

# README.md

A professional module documents:

- Purpose
- Inputs
- Outputs
- Examples
- Requirements

Example:

```
Network Module

Creates:

- VPC
- Subnets
- Routing

Inputs:

cidr_block

Outputs:

vpc_id
```

---

# Root Module Structure

The root module calls other modules.

Example:

```
environment/

├── main.tf

├── variables.tf

├── outputs.tf

└── terraform.tfvars
```

---

# Example Environment

```
environments/

└── dev/

    ├── main.tf

    ├── variables.tf

    ├── terraform.tfvars

    └── providers.tf
```

---

# Relationship

The root module:

```
environments/dev
```

calls:

```
modules/network
```

Example:

```hcl
module "network" {

 source = "../../modules/network"

 cidr_block = "10.0.0.0/16"

}
```

---

# Module Sources

Modules can come from:

## Local

Example:

```hcl
source = "./modules/network"
```

---

## Git Repository

Example:

```hcl
source = "github.com/company/network"
```

---

## Terraform Registry

Example:

```hcl
source = "terraform-aws-modules/vpc/aws"
```

---

# Module Naming

Good:

```
network

security

compute

database
```

Avoid:

```
module1

stuff

final-module
```

---

# One Module = One Responsibility

Bad:

```
infrastructure-module
```

creates:

```
VPC

EC2

RDS

Kubernetes

Monitoring
```

---

Better:

```
network

compute

database

monitoring
```

---

# Module Inputs

A module should expose configuration.

Example:

```hcl
module "network" {

 source = "./modules/network"

 cidr_block = "10.0.0.0/16"

}
```

The module does not hardcode values.

---

# Module Outputs

Expose only useful values.

Example:

```hcl
output "subnet_ids" {

 value = aws_subnet.public[*].id

}
```

---

# Enterprise Repository Structure

A real company might use:

```
terraform/

├── modules/

│   ├── vpc/

│   ├── ec2/

│   ├── rds/

│   └── eks/

│
├── environments/

│   ├── dev/

│   ├── staging/

│   └── prod/

│
└── global/
```

---

# Module Versioning

Modules change.

Example:

Version 1:

```
network v1
```

Version 2:

```
network v2
```

Users should control versions.

---

# Module Testing

Modules should be tested before reuse.

Common checks:

```bash
terraform fmt
```

```bash
terraform validate
```

---

# Module Documentation

Good modules explain:

- Inputs
- Outputs
- Examples
- Requirements
- Limitations

---

# Common Mistakes

## Mistake 1

Hardcoding values.

Bad:

```hcl
cidr = "10.0.0.0/16"
```

inside module.

---

## Mistake 2

Too many responsibilities.

Fix:

Split modules.

---

## Mistake 3

No outputs.

Users cannot consume results.

---

# Key Takeaways

- Modules are reusable Terraform building blocks
- main.tf creates resources
- variables.tf accepts inputs
- outputs.tf exposes values
- Good structure makes Terraform scalable

---

# Next Chapter

Next:

```
03-using-modules.md
```

You will learn:

- Calling modules
- Module arguments
- Module sources
- Module composition