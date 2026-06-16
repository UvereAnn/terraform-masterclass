# Complex Data Types in Terraform

## Learning Objectives

By the end of this chapter, you should be able to:

* Understand Terraform complex data types
* Use list, map, set, tuple, and object
* Build strongly typed variables
* Design production-grade variable schemas
* Use nested objects for real infrastructure modules
* Avoid weakly structured variables
* Understand type constraints and validation

---

# Introduction

In previous chapters, we used simple types:

```text id="a1b2c3"
string
number
bool
```

These are called **primitive types**.

But real infrastructure is complex:

```text id="d4e5f6"
Servers have multiple attributes
Networks have structured rules
IAM policies contain nested objects
```

Primitive types are not enough.

Terraform provides:

```text id="g7h8i9"
Complex Data Types
```

---

# 1. List Type

A list contains multiple values of the same type.

Example:

```hcl id="l1st01"
variable "ports" {
  type = list(number)
}
```

Example value:

```hcl id="l1st02"
ports = [80, 443, 8080]
```

Access:

```hcl id="l1st03"
var.ports[0]  # 80
```

---

## Use Case

```text id="l1st04"
Multiple ports
Multiple availability zones
Multiple instance IDs
```

---

# 2. Map Type

A map stores key-value pairs.

Example:

```hcl id="mp01"
variable "tags" {
  type = map(string)
}
```

Value:

```hcl id="mp02"
tags = {
  Name        = "web-server"
  Environment = "dev"
}
```

Access:

```hcl id="mp03"
var.tags["Name"]
```

---

## Use Case

```text id="mp04"
Tags
Configuration dictionaries
Lookup tables
```

---

# 3. Set Type

A set is like a list but:

```text id="st01"
No duplicates
Unordered
```

Example:

```hcl id="st02"
variable "zones" {
  type = set(string)
}
```

Value:

```hcl id="st03"
zones = ["a", "b", "c"]
```

Duplicate values are removed automatically.

---

## Use Case

```text id="st04"
Unique security groups
Unique subnet IDs
Unique permissions
```

---

# 4. Tuple Type

A tuple is a **fixed structure list** with different types.

Example:

```hcl id="tp01"
variable "instance_config" {
  type = tuple([string, number, bool])
}
```

Value:

```hcl id="tp02"
instance_config = ["t3.micro", 2, true]
```

Meaning:

```text id="tp03"
string  → instance type
number  → count
bool    → monitoring enabled
```

---

## Use Case

```text id="tp04"
Fixed configuration structures
Strict input ordering
Low-level module design
```

---

# 5. Object Type (MOST IMPORTANT)

Object is the most powerful Terraform type.

It allows structured data with named fields.

Example:

```hcl id="obj01"
variable "server" {
  type = object({
    name          = string
    instance_type = string
    disk_size     = number
    monitoring    = bool
  })
}
```

Value:

```hcl id="obj02"
server = {
  name          = "web-1"
  instance_type = "t3.micro"
  disk_size     = 20
  monitoring    = true
}
```

---

## Accessing Fields

```hcl id="obj03"
var.server.name
var.server.disk_size
```

---

## Why Object is Powerful

```text id="obj04"
Strong structure
Self-documenting
Reusable modules
Safer inputs
```

---

# 6. Map of Objects (REAL PRODUCTION PATTERN)

This is heavily used in enterprise Terraform.

Example:

```hcl id="mobj01"
variable "servers" {
  type = map(object({
    instance_type = string
    disk_size     = number
    monitoring    = bool
  }))
}
```

Value:

```hcl id="mobj02"
servers = {
  web = {
    instance_type = "t3.micro"
    disk_size     = 20
    monitoring    = true
  }

  api = {
    instance_type = "t3.small"
    disk_size     = 30
    monitoring    = true
  }
}
```

---

## Why This Is Important

This pattern enables:

```text id="mobj03"
for_each modules
dynamic infrastructure
clean scaling
reusable architectures
```

---

# 7. List of Objects

Another very common pattern.

Example:

```hcl id="lob01"
variable "subnets" {
  type = list(object({
    name   = string
    cidr   = string
    public = bool
  }))
}
```

Value:

```hcl id="lob02"
subnets = [
  {
    name   = "subnet-a"
    cidr   = "10.0.1.0/24"
    public = true
  },
  {
    name   = "subnet-b"
    cidr   = "10.0.2.0/24"
    public = false
  }
]
```

---

## Use Case

```text id="lob03"
Networking (subnets)
IAM policies
Kubernetes configs
Multi-resource deployments
```

---

# 8. Type Constraints

You can enforce strict input rules.

Example:

```hcl id="tc01"
variable "port" {
  type = number

  validation {
    condition     = var.port > 0 && var.port < 65536
    error_message = "Port must be between 1 and 65535"
  }
}
```

---

## Why It Matters

Prevents:

```text id="tc02"
Invalid infrastructure inputs
Runtime failures
Misconfigurations
```

---

# 9. Optional Attributes (Advanced)

Terraform allows optional fields in objects.

Example:

```hcl id="op01"
variable "server" {
  type = object({
    name     = string
    backup   = optional(bool, false)
  })
}
```

If not provided:

```text id="op02"
backup = false (default)
```

---

# 10. Complex Nested Structure (REAL WORLD)

Example:

```hcl id="ns01"
variable "app" {
  type = object({
    name = string

    network = object({
      vpc_id  = string
      subnets = list(string)
    })

    scaling = object({
      min = number
      max = number
    })
  })
}
```

---

## Why This Matters

This is how real production modules are designed:

```text id="ns02"
EKS clusters
VPC modules
Multi-tier applications
Enterprise Terraform modules
```

---

# Best Practices

* Always prefer object over loose variables
* Use map(object) for scalable infrastructure
* Avoid untyped lists in production
* Use validation for safety
* Keep structures predictable
* Design variables like APIs

---

# Key Takeaways

* Terraform has powerful complex types
* list, map, set, tuple, object all serve different purposes
* object is the most important type for real infrastructure
* map(object) is a production standard pattern
* Strong typing improves module reliability
* Complex types enable scalable Terraform architectures

---

# Next Chapter

Next we move to:

```text id="nx01"
12-advanced-patterns.md
```

This is where everything comes together:

```text id="nx02"
import existing resources
moved blocks
refactoring infrastructure
provider aliases
dependency graphs
advanced module design
```

This is the final chapter of Terraform Language Deep Dive.
