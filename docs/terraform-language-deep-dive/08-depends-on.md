# depends_on

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand Terraform Dependency Graphs
* Understand Implicit Dependencies
* Understand Explicit Dependencies
* Use depends_on Correctly
* Avoid Overusing depends_on
* Troubleshoot Dependency Issues
* Understand Production Dependency Patterns

---

# Introduction

Terraform does not execute resources in the order they appear in files.

Example:

```hcl
resource "aws_instance" "web" {}

resource "aws_vpc" "main" {}
```

Terraform may create:

```text
VPC First

Instance First

In Parallel
```

depending on the dependency graph.

Terraform cares about dependencies, not file order.

---

# What is a Dependency?

A dependency exists when one resource requires another resource to exist first.

Example:

```hcl
resource "aws_vpc" "main" {

  cidr_block = "10.0.0.0/16"

}

resource "aws_subnet" "private" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.1.0/24"

}
```

The subnet requires:

```text
aws_vpc.main
```

to exist first.

Terraform detects this automatically.

---

# Implicit Dependencies

Most dependencies are created automatically.

Example:

```hcl
resource "aws_subnet" "private" {

  vpc_id = aws_vpc.main.id

}
```

Terraform sees:

```hcl
aws_vpc.main.id
```

and understands:

```text
Create VPC First

Create Subnet Second
```

No extra configuration required.

This is called:

```text
Implicit Dependency
```

---

# Dependency Graph

Terraform builds a graph.

Example:

```text
VPC
 │
 ▼
Subnet
 │
 ▼
EC2 Instance
```

Terraform evaluates the graph and determines execution order.

This is one of Terraform's most powerful features.

---

# Visualizing the Dependency Graph

Terraform can generate a graph.

Command:

```bash
terraform graph
```

Output:

```text
Dependency Graph Representation
```

Often used for troubleshooting large infrastructures.

---

# Parallel Resource Creation

Terraform creates resources in parallel whenever possible.

Example:

```hcl
resource "aws_s3_bucket" "logs" {}

resource "aws_s3_bucket" "backups" {}
```

No dependencies exist.

Terraform may create both simultaneously.

Benefits:

```text
Faster Deployments

Improved Scalability
```

---

# When Implicit Dependencies Fail

Sometimes Terraform cannot determine a dependency.

Example:

```hcl
resource "null_resource" "initialize" {

  provisioner "local-exec" {

    command = "echo setup"

  }

}
```

Another resource may depend on that setup completing.

Terraform cannot detect this automatically.

This is where:

```hcl
depends_on
```

becomes useful.

---

# What is depends_on?

depends_on creates an explicit dependency.

Example:

```hcl
resource "aws_instance" "web" {

  depends_on = [
    null_resource.initialize
  ]

}
```

Terraform now guarantees:

```text
initialize

↓

web
```

creation order.

---

# Syntax

Basic syntax:

```hcl
depends_on = [
  resource_type.resource_name
]
```

Example:

```hcl
depends_on = [
  aws_vpc.main
]
```

Terraform waits for the VPC.

---

# Multiple Dependencies

A resource may depend on multiple resources.

Example:

```hcl
resource "aws_instance" "web" {

  depends_on = [

    aws_vpc.main,

    aws_security_group.web

  ]

}
```

Terraform waits until all dependencies complete.

---

# Example: Security Group Dependency

```hcl
resource "aws_security_group" "web" {

  name = "web-sg"

}

resource "aws_instance" "web" {

  depends_on = [
    aws_security_group.web
  ]

}
```

Terraform guarantees:

```text
Security Group

↓

Instance
```

---

# Module Dependencies

depends_on also works with modules.

Example:

```hcl
module "network" {

  source = "./modules/network"

}

module "compute" {

  source = "./modules/compute"

  depends_on = [
    module.network
  ]

}
```

Terraform creates:

```text
Network Module

↓

Compute Module
```

This pattern appears frequently in enterprise repositories.

---

# Why Overusing depends_on is Dangerous

Bad:

```hcl
resource "aws_instance" "web" {

  depends_on = [
    aws_vpc.main
  ]

}
```

when:

```hcl
subnet_id = aws_subnet.private.id
```

already exists.

Terraform already knows the dependency.

Adding depends_on is unnecessary.

---

# Rule of Thumb

Use:

```text
Implicit Dependencies
```

whenever possible.

Use:

```text
depends_on
```

only when Terraform cannot infer the dependency.

---

# Common Real-World Use Cases

Examples:

```text
Provisioners

Scripts

External Systems

Cross-Module Dependencies

Custom Resources

Third-Party Integrations
```

These often require explicit dependencies.

---

# Example: Null Resource Dependency

```hcl
resource "null_resource" "bootstrap" {

  provisioner "local-exec" {

    command = "echo Bootstrap Complete"

  }

}
```

Resource:

```hcl
resource "aws_instance" "web" {

  depends_on = [
    null_resource.bootstrap
  ]

}
```

Terraform ensures bootstrap runs first.

---

# Resource Graph Optimization

Terraform tries to maximize parallelism.

Example:

```text
VPC
 │
 ├── Subnet A
 │
 ├── Subnet B
 │
 └── Subnet C
```

Terraform can create:

```text
Subnet A

Subnet B

Subnet C
```

simultaneously.

This improves deployment speed significantly.

---

# Common Beginner Mistakes

## Assuming File Order Matters

Bad assumption:

```text
Top Resource Runs First
```

Terraform ignores file order.

Dependencies determine execution order.

---

## Adding depends_on Everywhere

Bad:

```hcl
depends_on = [
  aws_vpc.main
]
```

when Terraform already knows.

This creates unnecessary complexity.

---

## Ignoring Dependency Errors

Errors often indicate:

```text
Missing Reference

Incorrect Dependency

Race Condition
```

Investigate the dependency graph carefully.

---

# Production Example

Network Module:

```hcl
module "network" {

  source = "./modules/network"

}
```

Compute Module:

```hcl
module "compute" {

  source = "./modules/compute"

  depends_on = [
    module.network
  ]

}
```

Monitoring Module:

```hcl
module "monitoring" {

  source = "./modules/monitoring"

  depends_on = [
    module.compute
  ]

}
```

Execution Order:

```text
Network

↓

Compute

↓

Monitoring
```

A common enterprise pattern.

---

# Best Practices

* Prefer implicit dependencies
* Use depends_on sparingly
* Understand Terraform's graph
* Avoid unnecessary dependencies
* Use module dependencies carefully
* Troubleshoot using terraform graph

---

# Key Takeaways

* Terraform uses dependency graphs.
* File order does not matter.
* Resource references create implicit dependencies.
* depends_on creates explicit dependencies.
* Most Terraform configurations do not require depends_on.
* Overusing depends_on can reduce parallelism.
* Understanding dependencies is critical for production Terraform.

---

# Next Chapter

In the next chapter, we will learn about:

```text
lifecycle
```

Lifecycle rules allow Terraform to control how resources are:

* Created
* Updated
* Replaced
* Destroyed

This is one of the most important production safety features in Terraform.
