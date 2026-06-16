# Terraform Modules

## Learning Objectives

By the end of this chapter, you should understand:

- What Terraform modules are
- Why modules are important
- How modules improve code reuse
- The difference between root and child modules
- How real companies structure Terraform code

---

# Introduction

As Terraform projects grow, configuration becomes larger.

Example:

A production application may need:

```
VPC

Subnets

Security Groups

EC2

Load Balancer

Database

Monitoring
```

Writing everything in one folder becomes difficult.

Example:

```
main.tf

1000 lines

```

This is hard to:

- Maintain
- Reuse
- Test
- Understand

Terraform solves this using:

```
Modules
```

---

# What Is A Terraform Module?

A module is a collection of Terraform files grouped together.

Example:

```
module

=

Terraform files

+

Resources

+

Variables

+

Outputs
```

---

# Simple Example

Without modules:

```
main.tf

resource "aws_vpc" "main" {}

resource "aws_subnet" "public" {}

resource "aws_instance" "web" {}
```

Everything is mixed together.

---

With modules:

```
network module

    |
    |
    v

VPC
Subnet


compute module

    |
    |
    v

EC2
```

---

# Terraform Module Types

Terraform has two main module types.

---

# 1. Root Module

The folder where Terraform runs.

Example:

```
terraform apply
```

is executed here.

Example:

```
project/

├── main.tf

├── variables.tf

└── outputs.tf
```

This is the root module.

---

# 2. Child Module

A reusable module called by another module.

Example:

```
project/

├── main.tf

└── modules/

    └── network/

        ├── main.tf

        ├── variables.tf

        └── outputs.tf
```

---

# Why Use Modules?

## Reuse

Instead of writing:

```
VPC code
```

many times.

Create:

```
network module
```

and reuse.

---

## Consistency

Every environment uses the same structure.

Example:

```
dev

staging

production
```

all use:

```
network module
```

---

## Maintainability

Change one module:

```
modules/network
```

Every environment benefits.

---

# Real Company Example

A company may have:

```
terraform/

├── modules/

│
├── vpc/

├── ec2/

├── rds/

├── eks/

│
└── environments/

    ├── dev/

    ├── staging/

    └── prod/
```

---

# Module Communication

Modules communicate using:

```
Inputs

and

Outputs
```

Flow:

```
Root Module

      |
      |
      v

Module Input

      |
      |
      v

Resources

      |
      |
      v

Module Output
```

---

# Module Example

Call a module:

```hcl
module "network" {

 source = "./modules/network"

 cidr_block = "10.0.0.0/16"

}
```

---

The module receives:

```hcl
variable "cidr_block" {

}
```

---

The module returns:

```hcl
output "vpc_id" {

}
```

---

# Module Folder Standard

Professional module:

```
modules/network/

├── main.tf

├── variables.tf

├── outputs.tf

├── versions.tf

└── README.md
```

---

# main.tf

Contains:

```
Resources
```

Example:

```hcl
resource "aws_vpc" "main" {

}
```

---

# variables.tf

Contains:

```
Inputs
```

Example:

```hcl
variable "cidr_block" {

}
```

---

# outputs.tf

Contains:

```
Returned values
```

Example:

```hcl
output "vpc_id" {

}
```

---

# Module Best Practices

Good modules:

- Have one purpose
- Accept inputs
- Return outputs
- Are reusable
- Are documented

---

# Bad Module

Example:

```
everything-module
```

contains:

```
VPC

EC2

Database

Kubernetes

Monitoring
```

Hard to reuse.

---

# Good Modules

Better:

```
network

compute

database

security

monitoring
```

---

# Key Takeaways

- Modules are reusable Terraform components
- Root modules call child modules
- Inputs customize modules
- Outputs expose information
- Modules are required for production Terraform

---

# Next Chapter

Next:

```
02-module-structure.md
```

We will build a real module structure.